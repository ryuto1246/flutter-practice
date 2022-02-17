import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photoapp/models/photo.dart';

class PhotoRepository {
  PhotoRepository(this.user);

  final User user;

  Stream<List<Photo>> getPhotoList() {
    return FirebaseFirestore.instance
        .collection('users/${user.uid}/photos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_queryToPhotoList);
  }

  Future<void> addPhoto(File file) async {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final String name = file.path.split('/').last;
    final String path = '${timestamp}_$name';
    final TaskSnapshot task = await FirebaseStorage.instance
        .ref()
        .child('users/${user.uid}/photos')
        .child(path)
        .putFile(file);

    final Photo photo = Photo(
      imageUrl: await task.ref.getDownloadURL(),
      imagePath: task.ref.fullPath,
      isFavorite: false,
    );

    await FirebaseFirestore.instance
        .collection('users/${user.uid}/photos')
        .doc()
        .set(_photoToMap(photo));
  }

  Future<void> deletePhoto(Photo photo) async {
    await FirebaseFirestore.instance
        .collection('users/${user.uid}/photos')
        .doc(photo.id)
        .delete();
  }

  Future<void> updatePhoto(Photo photo) async {
    await FirebaseFirestore.instance
        .collection('users/${user.uid}/photos')
        .doc(photo.id)
        .update(_photoToMap(photo));
  }

  List<Photo> _queryToPhotoList(QuerySnapshot query) {
    return query.docs.map((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return Photo(
        id: doc.id,
        imageUrl: data['imageUrl'],
        imagePath: data['imagePath'],
        isFavorite: data['isFavorite'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Map<String, dynamic> _photoToMap(Photo photo) {
    return {
      'imageUrl': photo.imageUrl,
      'imagePath': photo.imagePath,
      'isFavorite': photo.isFavorite,
      'createdAt': photo.createdAt == null
          ? Timestamp.now()
          : Timestamp.fromDate(photo.createdAt!),
    };
  }
}
