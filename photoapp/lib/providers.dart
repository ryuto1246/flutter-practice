import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/models/photo.dart';
import 'package:photoapp/repositories/photo_repository.dart';

final userProvider = StreamProvider.autoDispose((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final photoRepositoryProvider = Provider.autoDispose((ref) {
  final user = ref.watch(userProvider).value;
  return user == null ? null : PhotoRepository(user);
});

final photoListProvider = StreamProvider.autoDispose((ref) {
  final photoRepository = ref.watch(photoRepositoryProvider);
  return photoRepository == null
      ? Stream.value(<Photo>[])
      : photoRepository.getPhotoList();
});

final favoritePhotoListProvider = Provider.autoDispose((ref) {
  return ref.watch(photoListProvider).whenData((List<Photo> data) {
    return data.where((photo) => photo.isFavorite).toList();
  });
});

final photoListIndexProvider = StateProvider.autoDispose((ref) {
  return 0;
});

final photoViewInitialIndexProvider =
    Provider<int>((_) => throw UnimplementedError());
