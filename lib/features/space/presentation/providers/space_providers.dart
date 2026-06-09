import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/space_entity.dart';
import '../../domain/usecases/observe_spaces_use_case.dart';
import '../notifiers/space_notifier.dart';

final allSpacesProvider = StreamProvider<List<SpaceEntity>>((ref) {
  final useCase = ref.watch(observeSpacesUseCaseProvider);
  return useCase.allSpaces();
});

final mySpacesProvider =
    StreamProvider.family<List<SpaceEntity>, String>((ref, userId) {
  final useCase = ref.watch(observeSpacesUseCaseProvider);
  return useCase.mySpaces(userId);
});

final spaceProvider =
    StreamProvider.family<SpaceEntity?, String>((ref, spaceId) {
  final useCase = ref.watch(observeSpacesUseCaseProvider);
  return useCase.singleSpace(spaceId);
});
