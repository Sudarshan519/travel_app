import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gogotravel/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.ellipse2).existsSync(), isTrue);
    expect(File(Images.krasnyyKlyuch).existsSync(), isTrue);
    expect(File(Images.salavatYulaev).existsSync(), isTrue);
    expect(File(Images.shulgaTashcave).existsSync(), isTrue);
  });
}
