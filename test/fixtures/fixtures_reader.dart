import 'dart:io';

String fixture({required String filename}) =>
    File('test/fixtures/$filename').readAsStringSync();
