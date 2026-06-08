// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchedItemAdapter extends TypeAdapter<WatchedItem> {
  @override
  final typeId = 0;

  @override
  WatchedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchedItem(
      contentId: fields[0] as String,
      watchedAt: fields[1] as String,
      progress: fields[2] == null ? 0.0 : (fields[2] as num).toDouble(),
      context: fields[3] == null ? '' : fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WatchedItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.contentId)
      ..writeByte(1)
      ..write(obj.watchedAt)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.context);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadItemAdapter extends TypeAdapter<DownloadItem> {
  @override
  final typeId = 1;

  @override
  DownloadItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadItem(
      contentId: fields[0] as String,
      quality: fields[1] == null ? 'HD' : fields[1] as String,
      size: fields[2] == null ? '—' : fields[2] as String,
      at: fields[3] as String,
      context: fields[4] == null ? '' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.contentId)
      ..writeByte(1)
      ..write(obj.quality)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.at)
      ..writeByte(4)
      ..write(obj.context);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
