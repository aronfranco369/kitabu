import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_filter.freezed.dart';

@freezed
abstract class DiscoverFilter with _$DiscoverFilter {
  const factory DiscoverFilter({@Default('All') String year, @Default('All') String dj, @Default('All') String country, @Default('All') String type}) = _DiscoverFilter;
}

extension DiscoverFilterX on DiscoverFilter {
  bool get isDefault => year == 'All' && dj == 'All' && country == 'All' && type == 'All';
}
