class Book {
  const Book({
    required this.id,
    required this.slug,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.pageCount,
    required this.isFree,
    required this.digitalPrice,
    this.physicalPrice,
    this.coverUrl,
    this.language = 'English',
    this.publishedYear,
    this.publisher,
    this.tags = const [],
    this.readProgress = 0.0,
  });

  final int id;
  final String slug;
  final String title;
  final String author;
  final String description;
  final String category;
  final double rating;
  final int reviewCount;
  final int pageCount;
  final bool isFree;
  final double digitalPrice;
  final double? physicalPrice;
  final String? coverUrl;
  final String language;
  final int? publishedYear;
  final String? publisher;
  final List<String> tags;
  final double readProgress;

  factory Book.fromMap(Map<String, dynamic> m) => Book(
        id: m['id'] as int,
        slug: m['slug'] as String,
        title: m['title'] as String,
        author: m['author'] as String,
        description: m['description'] as String,
        category: m['category'] as String,
        rating: (m['rating'] as num).toDouble(),
        reviewCount: m['review_count'] as int,
        pageCount: m['page_count'] as int,
        isFree: m['is_free'] as bool,
        digitalPrice: (m['digital_price'] as num).toDouble(),
        physicalPrice: m['physical_price'] != null
            ? (m['physical_price'] as num).toDouble()
            : null,
        coverUrl: m['cover_url'] as String?,
        language: m['language'] as String? ?? 'English',
        publishedYear: m['published_year'] as int?,
        publisher: m['publisher'] as String?,
        tags: m['tags'] != null
            ? List<String>.from(m['tags'] as List)
            : const [],
        readProgress: m['read_progress'] != null
            ? (m['read_progress'] as num).toDouble()
            : 0.0,
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

  factory Category.fromMap(Map<String, dynamic> m) => Category(
        id: m['id'] as int,
        slug: m['slug'] as String,
        name: m['name'] as String,
        icon: m['icon'] as String,
        color: m['color'] is String
            ? int.parse((m['color'] as String).replaceAll('#', '0xFF'))
            : m['color'] as int,
        bookCount: m['book_count'] as int? ?? 0,
      );
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

  final int id;
  final RequestStatus status;
  final String note;
  final DateTime createdAt;

  factory RequestEvent.fromMap(Map<String, dynamic> m) => RequestEvent(
        id: m['id'] as int,
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
        events: m['events'] != null
            ? (m['events'] as List)
                .map((e) => RequestEvent.fromMap(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}

class OrderStep {
  const OrderStep({
    required this.id,
    required this.label,
    required this.completedAt,
  });

  final int id;
  final String label;
  final DateTime? completedAt;

  bool get isComplete => completedAt != null;

  factory OrderStep.fromMap(Map<String, dynamic> m) => OrderStep(
        id: m['id'] as int,
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
        steps: m['steps'] != null
            ? (m['steps'] as List)
                .map((e) => OrderStep.fromMap(e as Map<String, dynamic>))
                .toList()
            : [],
        trackingNumber: m['tracking_number'] as String?,
        estimatedDelivery: m['estimated_delivery'] != null
            ? DateTime.parse(m['estimated_delivery'] as String)
            : null,
        shippingAddress: m['shipping_address'] as String?,
      );
}
