import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/rituals_repository.dart';
import '../domain/ritual.dart';

part 'rituals_notifier.freezed.dart';
part 'rituals_notifier.g.dart';

@freezed
class RitualsState with _$RitualsState {
  const factory RitualsState({
    @Default([]) List<Ritual> rituals,
    @Default(true) bool isLoading,
    String? error,
    @Default(RitualCategory.festival) RitualCategory selectedCategory,
    RitualTradition? selectedTradition,
    @Default('') String searchQuery,
  }) = _RitualsState;
}

@riverpod
class RitualsNotifier extends _$RitualsNotifier {
  @override
  RitualsState build() {
    _load();
    return const RitualsState();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rituals = await ref.read(ritualsRepositoryProvider).fetchRituals(
            category: state.selectedCategory,
            tradition: state.selectedTradition,
            query: state.searchQuery.isEmpty ? null : state.searchQuery,
          );
      state = state.copyWith(rituals: rituals, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setCategory(RitualCategory category) async {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    await _load();
  }

  Future<void> setTradition(RitualTradition? tradition) async {
    if (state.selectedTradition == tradition) return;
    state = state.copyWith(selectedTradition: tradition);
    await _load();
  }

  Future<void> setSearchQuery(String query) async {
    state = state.copyWith(searchQuery: query);
    await _load();
  }

  Future<void> refresh() async => _load();
}
