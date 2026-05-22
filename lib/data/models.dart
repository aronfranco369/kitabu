class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.isFree,
    required this.price,
    this.discountPrice,
    this.coverUrl,
    this.year,
    this.tags = const [],
    this.fileUrl,
    this.fileFormat,
    this.isDownloadable = false,
    this.fileSize = 0,
    this.pageCount = 0,
    this.viewCount = 0,
    this.downloadCount = 0,
  });

  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final bool isFree;
  final double price;
  final double? discountPrice;
  final String? coverUrl;
  final int? year;
  final List<String> tags;
  final String? fileUrl;
  final String? fileFormat;
  final bool isDownloadable;
  final int fileSize;
  final int pageCount;
  final int viewCount;
  final int downloadCount;

  factory Book.fromMap(Map<String, dynamic> m) => Book(
        id: m['id'] as String,
        title: m['title'] as String? ?? '',
        author: m['author'] as String? ?? '',
        description: m['description'] as String? ?? '',
        category: m['category'] as String? ?? '',
        isFree: m['is_free'] as bool? ?? false,
        price: m['price'] != null ? (m['price'] as num).toDouble() : 0.0,
        discountPrice: m['discount_price'] != null
            ? (m['discount_price'] as num).toDouble()
            : null,
        coverUrl: m['cover_url'] as String?,
        year: m['year'] as int?,
        tags: m['tags'] != null
            ? List<String>.from(m['tags'] as List)
            : const [],
        fileUrl: m['file_url'] as String?,
        fileFormat: m['file_format'] as String?,
        isDownloadable: m['is_downloadable'] as bool? ?? false,
        fileSize: (m['file_size'] as num?)?.toInt() ?? 0,
        pageCount: m['page_count'] as int? ?? 0,
        viewCount: m['view_count'] as int? ?? 0,
        downloadCount: m['download_count'] as int? ?? 0,
      );
}

class Category {
  const Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.icon,
    required this.color,
    this.bookCount = 0,
  });

  final int id;
  final String slug;
  final String name;
  final String icon;
  final int color;
  final int bookCount;
}

class LibraryEntry {
  const LibraryEntry({
    required this.book,
    required this.addedAt,
    this.readProgress = 0.0,
    this.lastReadAt,
  });

  final Book book;
  final DateTime addedAt;
  final double readProgress;
  final DateTime? lastReadAt;

  factory LibraryEntry.fromMap(Map<String, dynamic> m, Book book) =>
      LibraryEntry(
        book: book,
        addedAt: DateTime.parse(m['added_at'] as String),
        readProgress: m['read_progress'] != null
            ? (m['read_progress'] as num).toDouble()
            : 0.0,
        lastReadAt: m['last_read_at'] != null
            ? DateTime.parse(m['last_read_at'] as String)
            : null,
      );
}

enum RequestStatus { pending, inReview, sourcing, available, unavailable }

extension RequestStatusX on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.inReview:
        return 'In Review';
      case RequestStatus.sourcing:
        return 'Sourcing';
      case RequestStatus.available:
        return 'Available';
      case RequestStatus.unavailable:
        return 'Unavailable';
    }
  }
}

RequestStatus requestStatusFromString(String s) {
  switch (s) {
    case 'in_review':
      return RequestStatus.inReview;
    case 'sourcing':
      return RequestStatus.sourcing;
    case 'available':
      return RequestStatus.available;
    case 'unavailable':
      return RequestStatus.unavailable;
    default:
      return RequestStatus.pending;
  }
}

class RequestEvent {
  const RequestEvent({
    required this.id,
    required this.status,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final RequestStatus status;
  final String note;
  final DateTime createdAt;

  factory RequestEvent.fromMap(Map<String, dynamic> m) => RequestEvent(
        id: m['id'].toString(),
        status: requestStatusFromString(m['status'] as String),
        note: m['note'] as String? ?? '',
        createdAt: DateTime.parse(m['created_at'] as String),
      );
}

class BookRequest {
  const BookRequest({
    required this.id,
    required this.title,
    required this.author,
    required this.note,
    required this.status,
    required this.createdAt,
    this.events = const [],
  });

  final String id;
  final String title;
  final String author;
  final String note;
  final RequestStatus status;
  final DateTime createdAt;
  final List<RequestEvent> events;

  factory BookRequest.fromMap(Map<String, dynamic> m) => BookRequest(
        id: m['id'].toString(),
        title: m['title'] as String,
        author: m['author'] as String? ?? '',
        note: m['note'] as String? ?? '',
        status: requestStatusFromString(m['status'] as String? ?? 'pending'),
        createdAt: DateTime.parse(m['created_at'] as String),
        events: (m['request_events'] as List?)
                ?.map((e) => RequestEvent.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class OrderStep {
  const OrderStep({
    required this.id,
    required this.label,
    required this.completedAt,
  });

  final String id;
  final String label;
  final DateTime? completedAt;

  bool get isComplete => completedAt != null;

  factory OrderStep.fromMap(Map<String, dynamic> m) => OrderStep(
        id: m['id'].toString(),
        label: m['label'] as String,
        completedAt: m['completed_at'] != null
            ? DateTime.parse(m['completed_at'] as String)
            : null,
      );
}

class PhysicalOrder {
  const PhysicalOrder({
    required this.id,
    required this.book,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.steps = const [],
    this.trackingNumber,
    this.estimatedDelivery,
    this.shippingAddress,
  });

  final String id;
  final Book book;
  final int quantity;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final List<OrderStep> steps;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final String? shippingAddress;

  factory PhysicalOrder.fromMap(Map<String, dynamic> m, Book book) =>
      PhysicalOrder(
        id: m['id'].toString(),
        book: book,
        quantity: m['quantity'] as int,
        totalPrice: (m['total_price'] as num).toDouble(),
        status: m['status'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
        steps: (m['order_steps'] as List?)
                ?.map((e) => OrderStep.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        trackingNumber: m['tracking_number'] as String?,
        estimatedDelivery: m['estimated_delivery'] != null
            ? DateTime.parse(m['estimated_delivery'] as String)
            : null,
        shippingAddress: m['shipping_address'] as String?,
      );
}
