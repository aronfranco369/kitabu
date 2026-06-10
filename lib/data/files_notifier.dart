import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/media.dart';

part 'files_notifier.g.dart';

SupabaseClient get _db => Supabase.instance.client;

@riverpod
class FilesNotifier extends _$FilesNotifier {
  Box<MediaFile> get _box => Hive.box<MediaFile>('files_cache');
  Box<bool> get _fetched => Hive.box<bool>('files_fetched');
  RealtimeChannel? _channel;
  StreamSubscription<BoxEvent>? _hiveSub;

  @override
  Future<List<MediaFile>> build() async {
    ref.onDispose(() {
      _hiveSub?.cancel();
      _channel?.unsubscribe();
    });

    // Set up Hive watcher — fires when any file is added/updated/deleted
    _hiveSub = _box.watch().listen((_) {
      state = AsyncData(_box.values.toList());
    });

    _setupRealtime();
    return _box.values.toList();
  }

  /// Fetches files for [mediaId] from Supabase if not already cached.
  Future<void> ensureLoaded(String mediaId) async {
    if (_fetched.get(mediaId) == true) return;
    final data = await _db
        .from('files')
        .select()
        .eq('media_id', mediaId)
        .order('episode_number', ascending: true, nullsFirst: false)
        .order('label', ascending: true, nullsFirst: false);
    final files = (data as List)
        .map((r) => MediaFile.fromJson(r as Map<String, dynamic>))
        .toList();
    await _box.putAll({for (final f in files) f.id: f});
    await _fetched.put(mediaId, true);
  }

  void _setupRealtime() {
    _channel?.unsubscribe();
    _channel = _db
        .channel('files_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'files',
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.delete) {
              final id = payload.oldRecord['id'] as String?;
              if (id != null) _box.delete(id);
            } else {
              final f = MediaFile.fromJson(payload.newRecord);
              _box.put(f.id, f);
            }
          },
        )
        .subscribe();
  }
}
