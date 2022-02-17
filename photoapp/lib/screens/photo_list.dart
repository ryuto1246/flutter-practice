import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/models/photo.dart';
import 'package:photoapp/repositories/photo_repository.dart';
import 'package:photoapp/screens/photo_view.dart';
import 'package:photoapp/screens/sign_in.dart';
import 'package:photoapp/widgets/grid_view.dart';
import 'package:photoapp/providers.dart';

class PhotoListScreen extends ConsumerStatefulWidget {
  const PhotoListScreen({Key? key}) : super(key: key);

  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends ConsumerState<PhotoListScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: ref.read(photoListIndexProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      floatingActionButton: floatingActionButton(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('PhotoApp'),
      actions: [
        IconButton(
          onPressed: () => onSignOut(),
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  Widget body() {
    return PageView(
      controller: _controller,
      onPageChanged: (int index) => onPageChanged(index),
      children: [
        //全ての画像
        Consumer(
          builder: (context, ref, child) {
            final asyncPhotoList = ref.watch(photoListProvider);
            return asyncPhotoList.when(
              data: (List<Photo> photoList) {
                return PhotoGridView(
                  photoList: photoList,
                  onTap: (photo) => onTapPhoto(photo, photoList),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (e, stackTrace) {
                return Center(
                  child: Text(e.toString()),
                );
              },
            );
          },
        ),
        //お気に入り画像
        Consumer(
          builder: (context, ref, child) {
            final asyncPhotoList = ref.watch(favoritePhotoListProvider);
            return asyncPhotoList.when(
              data: (List<Photo> photoList) {
                return PhotoGridView(
                  photoList: photoList,
                  onTap: (photo) => onTapPhoto(photo, photoList),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (e, stackTrace) {
                return Center(
                  child: Text(e.toString()),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget bottomNavigationBar() {
    // 0: フォト
    // 1: お気に入り
    return Consumer(builder: (context, ref, child) {
      final photoIndex = ref.watch(photoListIndexProvider);

      return BottomNavigationBar(
        onTap: (int index) => onTapBottomNavigationItem(photoIndex),
        currentIndex: photoIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'フォト'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'お気に入り')
        ],
      );
    });
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      onPressed: () => onAddPhoto(),
      child: const Icon(Icons.add),
    );
  }

  void onPageChanged(int index) {
    ref.read(photoListIndexProvider.notifier).state = index;
  }

  void onTapPhoto(Photo photo, List<Photo> photoList) {
    final initialIndex = photoList.indexOf(photo);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProviderScope(
          overrides: [
            photoViewInitialIndexProvider.overrideWithValue(initialIndex)
          ],
          child: const PhotoViewScreen(),
        ),
      ),
    );
  }

  void onTapBottomNavigationItem(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    ref.read(photoListIndexProvider.notifier).state = index;
  }

  Future<void> onSignOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const SignInScreen(),
      ),
    );
  }

  Future<void> onAddPhoto() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      final User user = FirebaseAuth.instance.currentUser!;
      final PhotoRepository repository = PhotoRepository(user);
      final File file = File(result.files.single.path!);

      await repository.addPhoto(file);
    }
  }
}
