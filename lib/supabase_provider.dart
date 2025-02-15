import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  static final supabase = Supabase.instance.client;

  static final String collectionStorage = "images";

  // already saved image url in supabase
  Future uploadImageToSupabase({required File mImage}) async {
    try {
      await supabase.storage
          .createBucket(collectionStorage, BucketOptions(public: true))
          .then(
            (value) => log("storage collection created"),
          );

      await supabase.storage
          .from(collectionStorage)
          .upload(mImage.path, mImage, fileOptions: FileOptions(upsert: true))
          .then(
            (value) => log("image uploaded"),
          );
    } catch (e) {
      log(e.toString());
    }
  }
}
