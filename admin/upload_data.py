"""
Uploads the sample.xlsx catalogue into Supabase:

  1. uploads each cover image to the COVERS_BUCKET storage bucket
  2. uploads the book PDF to the BOOKS_BUCKET storage bucket
  3. upserts one row per book into the public.books table

Run schema.sql in the Supabase SQL Editor first, then:

    venv/Scripts/python.exe upload_data.py
"""

import os
import re
import sys
from pathlib import Path

import openpyxl
from dotenv import load_dotenv
from pypdf import PdfReader
from supabase import create_client

# --------------------------------------------------------------------------- #
# Config
# --------------------------------------------------------------------------- #
load_dotenv()

ROOT = Path(__file__).resolve().parent
EXCEL = ROOT / "sample.xlsx"
COVERS_DIR = ROOT / "assets" / "covers"
BOOKS_DIR = ROOT / "assets" / "books"

SUPABASE_URL = os.getenv("SUPABASE_URL", "").strip()
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "").strip()
COVERS_BUCKET = os.getenv("COVERS_BUCKET", "book-covers").strip()
BOOKS_BUCKET = os.getenv("BOOKS_BUCKET", "book-files").strip()

if not SUPABASE_URL or "YOUR-PROJECT-REF" in SUPABASE_URL or not SUPABASE_KEY:
    sys.exit("ERROR: set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in .env first.")

CONTENT_TYPES = {
    ".pdf":  "application/pdf",
    ".epub": "application/epub+zip",
    ".jpg":  "image/jpeg",
    ".jpeg": "image/jpeg",
    ".png":  "image/png",
    ".webp": "image/webp",
}

sb = create_client(SUPABASE_URL, SUPABASE_KEY)


# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #
def content_type(path: Path) -> str:
    return CONTENT_TYPES.get(path.suffix.lower(), "application/octet-stream")


def slug(name: str) -> str:
    name = name.lower()
    name = re.sub(r"[^a-z0-9.]+", "-", name).strip("-")
    return name or "file"


def ensure_bucket(name: str) -> None:
    existing = {getattr(b, "name", None) for b in sb.storage.list_buckets()}
    if name in existing:
        return
    sb.storage.create_bucket(name, options={"public": True})
    print(f"  created storage bucket: {name}")


_url_cache: dict[tuple[str, str], str] = {}


def upload(bucket: str, local: Path, dest: str) -> str:
    """Upload a file (idempotent via upsert) and return its public URL."""
    cache_key = (bucket, dest)
    if cache_key in _url_cache:
        return _url_cache[cache_key]

    sb.storage.from_(bucket).upload(
        path=dest,
        file=local.read_bytes(),
        file_options={"content-type": content_type(local), "upsert": "true"},
    )
    url = sb.storage.from_(bucket).get_public_url(dest)
    _url_cache[cache_key] = url
    return url


def parse_tags(raw: str | None) -> list[str]:
    """Split a comma-separated tags string into a clean list."""
    if not raw:
        return []
    return [t.strip() for t in str(raw).split(",") if t.strip()]


# --------------------------------------------------------------------------- #
# Resolve local assets
# --------------------------------------------------------------------------- #
cover_index = {
    f.stem.lower(): f for f in COVERS_DIR.iterdir() if f.is_file()
}
if not cover_index:
    sys.exit(f"ERROR: no cover images found in {COVERS_DIR}")
fallback_cover = sorted(cover_index.values())[0]

pdfs = sorted(f for f in BOOKS_DIR.iterdir() if f.suffix.lower() == ".pdf")
if not pdfs:
    sys.exit(f"ERROR: no .pdf file found in {BOOKS_DIR}")
the_book = pdfs[0]


def resolve_cover(cover_path: str) -> Path:
    # Excel stores paths like './covers/img6.jpg' — only the stem matters
    # Handles truncated extensions like 'img1.web' → stem 'img1' → img1.webp
    stem = Path(str(cover_path)).stem.lower()
    return cover_index.get(stem, fallback_cover)


# --------------------------------------------------------------------------- #
# Run
# --------------------------------------------------------------------------- #
def main() -> None:
    print("Ensuring storage buckets...")
    ensure_bucket(COVERS_BUCKET)
    ensure_bucket(BOOKS_BUCKET)

    print(f"Uploading book file: {the_book.name} ...")
    book_dest = slug(the_book.stem) + the_book.suffix.lower()
    book_url = upload(BOOKS_BUCKET, the_book, book_dest)
    file_format = the_book.suffix.lstrip(".").upper()          # "PDF"
    file_size = the_book.stat().st_size                        # bytes
    page_count = len(PdfReader(the_book).pages)
    print(f"  {page_count} pages detected")

    wb = openpyxl.load_workbook(EXCEL, data_only=True, read_only=True)
    ws = wb.active
    rows = list(ws.iter_rows(values_only=True))
    headers = [str(h).strip() for h in rows[0]]

    records = []
    for raw in rows[1:]:
        if raw is None or all(v is None for v in raw):
            continue
        d = dict(zip(headers, raw))

        is_free = bool(d.get("is_free"))

        cover_file = resolve_cover(d.get("cover_url") or "")
        cover_url = upload(COVERS_BUCKET, cover_file, cover_file.name)
        print(f"  {d['title']!r}  cover={cover_file.name}")

        records.append(
            {
                # id is omitted — Supabase generates it via gen_random_uuid()
                "title":           d["title"],
                "author":          d.get("author"),
                "description":     d.get("description"),
                "year":            int(d["year"]) if d.get("year") is not None else None,
                "category":        d.get("category"),
                "tags":            parse_tags(d.get("tags")),
                "is_free":         is_free,
                # free books carry null prices, not 0
                "price":           None if is_free else float(d.get("price") or 0),
                "discount_price":  None if is_free else float(d.get("discount_price") or 0),
                "file_url":        book_url,
                "file_format":     file_format,
                "is_downloadable": bool(d.get("is_downloadable")),
                "file_size":       file_size,
                "cover_url":       cover_url,
                "page_count":      page_count,
                "view_count":      0,
                "download_count":  0,
            }
        )

    print(f"Upserting {len(records)} books into public.books...")
    resp = sb.table("books").upsert(records, on_conflict="title,author").execute()
    print(f"Done. {len(resp.data)} rows written.")


if __name__ == "__main__":
    main()
