import 'package:flutter/material.dart';
import 'package:photoapp/models/photo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/providers.dart';
import 'package:share/share.dart';

class PhotoViewScreen extends ConsumerStatefulWidget {
  const PhotoViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends ConsumerState<PhotoViewScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: ref.read(photoViewInitialIndexProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget body() {
    return Stack(
      children: [
        Consumer(builder: (context, ref, child) {
          final asyncPhotoList = ref.watch(photoListProvider);

          return asyncPhotoList.when(
            data: (List<Photo> photoList) {
              return PageView(
                controller: _controller,
                onPageChanged: (int index) => {},
                children: photoList
                    .map(
                      (Photo photo) => Image.network(
                        photo.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
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
        }),
        bottomMenu(),
      ],
    );
  }

  Widget bottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            shareButton(),
            deleteButton(),
          ],
        ),
      ),
    );
  }

  IconButton shareButton() {
    return IconButton(
      onPressed: () => onTapShare(),
      color: Colors.white,
      icon: const Icon(Icons.ios_share),
    );
  }

  IconButton deleteButton() {
    return IconButton(
      onPressed: () => onTapDelete(),
      color: Colors.white,
      icon: const Icon(Icons.delete),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.bottomCenter,
        end: FractionalOffset.topCenter,
        colors: [Colors.black.withOpacity(.5), Colors.transparent],
      ),
    );
  }

  Future<void> onTapDelete() async {
    final photoRepository = ref.read(photoRepositoryProvider);
    final photoList = ref.read(photoListProvider).value;
    final photo = photoList![_controller.page!.toInt()];

    if (photoList.length <= 1) {
      Navigator.of(context).pop();
    } else if (photoList.last == photo) {
      await _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    await photoRepository!.deletePhoto(photo);
  }

  Future<void> onTapShare() async {
    final photoList = ref.read(photoListProvider).value;
    final photo = photoList![_controller.page!.toInt()];

    await Share.share(photo.imageUrl);
  }
}
