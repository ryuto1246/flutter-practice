import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:photoapp/models/photo.dart";
import 'package:photoapp/providers.dart';

class PhotoGridView extends ConsumerWidget {
  const PhotoGridView({
    Key? key,
    required this.photoList,
    required this.onTap,
  }) : super(key: key);

  final List<Photo> photoList;
  final void Function(Photo photo) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: photoList.map((Photo photo) {
        return photoGridItem(photo, ref);
      }).toList(),
    );
  }

  Stack photoGridItem(Photo photo, WidgetRef ref) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: InkWell(
            onTap: () => onTap(photo),
            child: Image.network(
              photo.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => onTapFav(photo, ref),
            color: Colors.white,
            icon: Icon(
              photo.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        )
      ],
    );
  }

  void onTapFav(Photo photo, WidgetRef ref) async {
    final photoRepository = ref.read(photoRepositoryProvider);
    final toggledPhoto = photo.toggleIsFavorite();

    await photoRepository!.updatePhoto(toggledPhoto);
  }
}
