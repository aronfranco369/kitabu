import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/media.dart';

part 'media_notifier.g.dart';

SupabaseClient get _db => Supabase.instance.client;

@riverpod
class MediaNotifier extends _$MediaNotifier {
  Box<Media> get _box => Hive.box<Media>('media_cache');
  Box<String> get _meta => Hive.box<String>('metadata');
  RealtimeChannel? _channel;
  StreamSubscription<BoxEvent>? _hiveSub;

  static const _kLastSynced = 'media_last_synced';
  static const _kSyncInterval = Duration(hours: 24);

  @override
  Future<List<Media>> build() async {
    ref.onDispose(() {
      _hiveSub?.cancel();
      _channel?.unsubscribe();
    });

    if (_box.isEmpty) {
      // First launch: block until initial fetch is complete
      await _fullFetch();
    } else if (_needsRefresh) {
      // Stale cache: refresh silently in background
      Future.microtask(_fullFetch);
    }

    // Set up Hive watcher — fires on any box mutation (Realtime-driven updates)
    _hiveSub = _box.watch().listen((_) {
      state = AsyncData(_sorted(_box.values.toList()));
    });

    _setupRealtime();
    return _sorted(_box.values.toList());
  }

  bool get _needsRefresh {
    final ts = _meta.get(_kLastSynced);
    if (ts == null) return true;
    final last = DateTime.tryParse(ts);
    if (last == null) return true;
    return DateTime.now().difference(last) > _kSyncInterval;
  }

  Future<void> _fullFetch() async {
    final data = await _db.from('media').select().order('title');
    final list = (data as List).map((r) => Media.fromJson(r as Map<String, dynamic>)).toList();
    await _box.putAll({for (final m in list) m.id: m});
    await _meta.put(_kLastSynced, DateTime.now().toIso8601String());
  }

  void _setupRealtime() {
    _channel?.unsubscribe();
    _channel = _db
        .channel('media_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'media',
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.delete) {
              final id = payload.oldRecord['id'] as String?;
              if (id != null) _box.delete(id);
            } else {
              final m = Media.fromJson(payload.newRecord);
              _box.put(m.id, m);
            }
          },
        )
        .subscribe();
  }

  List<Media> _sorted(List<Media> list) =>
      list..sort((a, b) => a.title.compareTo(b.title));
}
