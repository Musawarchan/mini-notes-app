import 'package:flutter/material.dart';
import 'core/utils/storage_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const NotesMiniApp());
//initialize storage service
  Future.microtask(() async {
    await StorageService.init();
  });
}
