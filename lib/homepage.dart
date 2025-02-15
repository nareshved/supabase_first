import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_first/supabase_provider.dart';

class SupabaseHome extends StatefulWidget {
  const SupabaseHome({super.key});

  @override
  State<SupabaseHome> createState() => _SupabaseHomeState();
}

class _SupabaseHomeState extends State<SupabaseHome> {
  static File? myImage;
  late String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker Supabase"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SupabaseProvider().uploadImageToSupabase(mImage: myImage!);
        },
        child: Icon(Icons.upload),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: myImage != null ? FileImage(myImage!) : null,
              child: myImage == null
                  ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                  : null,
            ),
            ElevatedButton(
                onPressed: () {
                  imagePic(source: ImageSource.gallery);
                },
                child: Text("select image")),
            ElevatedButton(
                onPressed: () {
                  getImageFromSupabaseStorage(mImage: myImage!);
                  imgUrl == "" ? Text("wait") : Image.network(imgUrl);
                },
                child: Text("show image")),
          ],
        ),
      ),
    );
  }

  getImageFromSupabaseStorage({
    required File mImage,
  }) async {
    try {
      imgUrl = SupabaseProvider.supabase.storage
          .from(SupabaseProvider.collectionStorage)
          .getPublicUrl(mImage.path);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  imagePic({required ImageSource source, File? isImage}) async {
    final ImagePicker picker = ImagePicker();
    final mImage = await picker.pickImage(source: source);

    try {
      if (mImage != null) {
        setState(() {
          isImage = File(mImage.path);
          myImage = File(mImage.path);
          log("Image saved to IsImage");
          log("Image saved to $myImage global var");
        });
      } else {
        log("Image not picked or save please wait..");
        return Widget;
      }
    } catch (e) {
      log("error found in image picker ${e.toString()}");
    }
  }
}
