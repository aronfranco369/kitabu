import 'package:hive_ce/hive_ce.dart';

part 'library_item.g.dart';

@HiveType(typeId: 0)
class WatchedItem {
  @HiveField(0)
  final String contentId;

  @HiveField(1)
  final String watchedAt;

  @HiveField(2)
  final double progress;

  @HiveField(3)
  final String context;

  WatchedItem({required this.contentId, required this.watchedAt, this.progress = 0.0, this.context = ''});
}

@HiveType(typeId: 1)
class DownloadItem {
  @HiveField(0)
  final String contentId;

  @HiveField(1)
  final String quality;

  @HiveField(2)
  final String size;

  @HiveField(3)
  final String at;

  @HiveField(4)
  final String context;

  DownloadItem({required this.contentId, this.quality = 'HD', this.size = '—', required this.at, this.context = ''});
}
