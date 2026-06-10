// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaById)
final mediaByIdProvider = MediaByIdFamily._();

final class MediaByIdProvider
    extends $FunctionalProvider<AsyncValue<Media?>, Media?, FutureOr<Media?>>
    with $FutureModifier<Media?>, $FutureProvider<Media?> {
  MediaByIdProvider._({
    required MediaByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaByIdHash();

  @override
  String toString() {
    return r'mediaByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Media?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Media?> create(Ref ref) {
    final argument = this.argument as String;
    return mediaById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaByIdHash() => r'f4f6f795ecddf4f4911e90958c2bf1db50fc54b7';

final class MediaByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Media?>, String> {
  MediaByIdFamily._()
    : super(
        retry: null,
        name: r'mediaByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaByIdProvider call(String id) =>
      MediaByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'mediaByIdProvider';
}

@ProviderFor(homeRows)
final homeRowsProvider = HomeRowsProvider._();

final class HomeRowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeRow>>,
          List<HomeRow>,
          FutureOr<List<HomeRow>>
        >
    with $FutureModifier<List<HomeRow>>, $FutureProvider<List<HomeRow>> {
  HomeRowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRowsHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeRow>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeRow>> create(Ref ref) {
    return homeRows(ref);
  }
}

String _$homeRowsHash() => r'3951d2ef782d64ab2b9847d4a411c0d4a7bf69b1';

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.

@ProviderFor(mediaFiles)
final mediaFilesProvider = MediaFilesFamily._();

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.

final class MediaFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFile>>,
          List<MediaFile>,
          FutureOr<List<MediaFile>>
        >
    with $FutureModifier<List<MediaFile>>, $FutureProvider<List<MediaFile>> {
  /// Files for a specific media — reads from Hive via FilesNotifier.
  /// Triggers a background Supabase fetch on first access for this mediaId.
  MediaFilesProvider._({
    required MediaFilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaFilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaFilesHash();

  @override
  String toString() {
    return r'mediaFilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MediaFile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MediaFile>> create(Ref ref) {
    final argument = this.argument as String;
    return mediaFiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaFilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaFilesHash() => r'bdcb9d0a29dc670e1bcfab8abf0c44e0302a30da';

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.

final class MediaFilesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MediaFile>>, String> {
  MediaFilesFamily._()
    : super(
        retry: null,
        name: r'mediaFilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Files for a specific media — reads from Hive via FilesNotifier.
  /// Triggers a background Supabase fetch on first access for this mediaId.

  MediaFilesProvider call(String mediaId) =>
      MediaFilesProvider._(argument: mediaId, from: this);

  @override
  String toString() => r'mediaFilesProvider';
}

@ProviderFor(relatedMedia)
final relatedMediaProvider = RelatedMediaFamily._();

final class RelatedMediaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  RelatedMediaProvider._({
    required RelatedMediaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'relatedMediaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$relatedMediaHash();

  @override
  String toString() {
    return r'relatedMediaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    final argument = this.argument as String;
    return relatedMedia(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RelatedMediaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$relatedMediaHash() => r'c8693c66220808594197234e4ec66e1c93ea71cf';

final class RelatedMediaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Media>>, String> {
  RelatedMediaFamily._()
    : super(
        retry: null,
        name: r'relatedMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RelatedMediaProvider call(String mediaId) =>
      RelatedMediaProvider._(argument: mediaId, from: this);

  @override
  String toString() => r'relatedMediaProvider';
}

@ProviderFor(filterYears)
final filterYearsProvider = FilterYearsProvider._();

final class FilterYearsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FilterYearsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterYearsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterYearsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterYears(ref);
  }
}

String _$filterYearsHash() => r'069fd4f40602b7fa8cb1fc2194c3e9fb6b4670ad';

@ProviderFor(filterDjs)
final filterDjsProvider = FilterDjsProvider._();

final class FilterDjsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FilterDjsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterDjsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterDjsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterDjs(ref);
  }
}

String _$filterDjsHash() => r'8181b3209bf9e65833bc649a197975879ed58d5f';

@ProviderFor(filterCountries)
final filterCountriesProvider = FilterCountriesProvider._();

final class FilterCountriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FilterCountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterCountriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterCountriesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterCountries(ref);
  }
}

String _$filterCountriesHash() => r'36d5c29170b4d9bbe96f84e50d77cd3f3e69eb2d';

@ProviderFor(DiscoverFilters)
final discoverFiltersProvider = DiscoverFiltersProvider._();

final class DiscoverFiltersProvider
    extends $NotifierProvider<DiscoverFilters, DiscoverFilter> {
  DiscoverFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverFiltersHash();

  @$internal
  @override
  DiscoverFilters create() => DiscoverFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverFilter>(value),
    );
  }
}

String _$discoverFiltersHash() => r'0e0b5e9ef40f23f535f50ca8efcdd88378360463';

abstract class _$DiscoverFilters extends $Notifier<DiscoverFilter> {
  DiscoverFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoverFilter, DiscoverFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverFilter, DiscoverFilter>,
              DiscoverFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(discoverResults)
final discoverResultsProvider = DiscoverResultsProvider._();

final class DiscoverResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  DiscoverResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return discoverResults(ref);
  }
}

String _$discoverResultsHash() => r'7e81b8077c926ccdfa83cdd65a4999e51954a6e4';

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'eade1e6597edd69e5cbf599d41b96561f4759074';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'0055a8ec593a45932df0b47e1bbf3bd89fa52eeb';

@ProviderFor(Saved)
final savedProvider = SavedProvider._();

final class SavedProvider extends $NotifierProvider<Saved, Set<String>> {
  SavedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedHash();

  @$internal
  @override
  Saved create() => Saved();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$savedHash() => r'ea395a36fc3dcaa2403698136ec22af63e09b028';

abstract class _$Saved extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(savedContent)
final savedContentProvider = SavedContentProvider._();

final class SavedContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  SavedContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedContentHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return savedContent(ref);
  }
}

String _$savedContentHash() => r'ed2dd00d30e96b614e3b4e5142468a92377ddd50';

@ProviderFor(Recent)
final recentProvider = RecentProvider._();

final class RecentProvider
    extends $NotifierProvider<Recent, List<WatchedItem>> {
  RecentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentHash();

  @$internal
  @override
  Recent create() => Recent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WatchedItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WatchedItem>>(value),
    );
  }
}

String _$recentHash() => r'56d8f5b8013bd7a0794dc398891a2f012cdbea42';

abstract class _$Recent extends $Notifier<List<WatchedItem>> {
  List<WatchedItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<WatchedItem>, List<WatchedItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<WatchedItem>, List<WatchedItem>>,
              List<WatchedItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(recentContent)
final recentContentProvider = RecentContentProvider._();

final class RecentContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<(WatchedItem, Media)>>,
          List<(WatchedItem, Media)>,
          FutureOr<List<(WatchedItem, Media)>>
        >
    with
        $FutureModifier<List<(WatchedItem, Media)>>,
        $FutureProvider<List<(WatchedItem, Media)>> {
  RecentContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentContentHash();

  @$internal
  @override
  $FutureProviderElement<List<(WatchedItem, Media)>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<(WatchedItem, Media)>> create(Ref ref) {
    return recentContent(ref);
  }
}

String _$recentContentHash() => r'98ee8eaaa5e9f9bacb83f5bf482440a504d3e716';

@ProviderFor(Downloads)
final downloadsProvider = DownloadsProvider._();

final class DownloadsProvider
    extends $NotifierProvider<Downloads, List<DownloadItem>> {
  DownloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsHash();

  @$internal
  @override
  Downloads create() => Downloads();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DownloadItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DownloadItem>>(value),
    );
  }
}

String _$downloadsHash() => r'8d07a15c9e3ee9d96ea219a9296740af4e2c2c1e';

abstract class _$Downloads extends $Notifier<List<DownloadItem>> {
  List<DownloadItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<DownloadItem>, List<DownloadItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DownloadItem>, List<DownloadItem>>,
              List<DownloadItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(downloadsContent)
final downloadsContentProvider = DownloadsContentProvider._();

final class DownloadsContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<(DownloadItem, Media)>>,
          List<(DownloadItem, Media)>,
          FutureOr<List<(DownloadItem, Media)>>
        >
    with
        $FutureModifier<List<(DownloadItem, Media)>>,
        $FutureProvider<List<(DownloadItem, Media)>> {
  DownloadsContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsContentHash();

  @$internal
  @override
  $FutureProviderElement<List<(DownloadItem, Media)>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<(DownloadItem, Media)>> create(Ref ref) {
    return downloadsContent(ref);
  }
}

String _$downloadsContentHash() => r'1f6c513eee5039ac3f03f5bb8a90089f7ce102b0';

@ProviderFor(Requests)
final requestsProvider = RequestsProvider._();

final class RequestsProvider
    extends $NotifierProvider<Requests, List<ContentRequest>> {
  RequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestsHash();

  @$internal
  @override
  Requests create() => Requests();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ContentRequest> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ContentRequest>>(value),
    );
  }
}

String _$requestsHash() => r'6372b4f4888abdd5ebdf91ac84a1ad7a2c8864cc';

abstract class _$Requests extends $Notifier<List<ContentRequest>> {
  List<ContentRequest> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ContentRequest>, List<ContentRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ContentRequest>, List<ContentRequest>>,
              List<ContentRequest>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
