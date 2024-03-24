import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gogotravel/resources/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.vector).existsSync(), isTrue);
    expect(File(AppIcons.arrow).existsSync(), isTrue);
    expect(File(AppIcons.back).existsSync(), isTrue);
    expect(File(AppIcons.breakfast).existsSync(), isTrue);
    expect(File(AppIcons.chat).existsSync(), isTrue);
    expect(File(AppIcons.distance).existsSync(), isTrue);
    expect(File(AppIcons.ensurance).existsSync(), isTrue);
    expect(File(AppIcons.food).existsSync(), isTrue);
    expect(File(AppIcons.liked).existsSync(), isTrue);
    expect(File(AppIcons.main).existsSync(), isTrue);
    expect(File(AppIcons.map).existsSync(), isTrue);
    expect(File(AppIcons.nature).existsSync(), isTrue);
    expect(File(AppIcons.price).existsSync(), isTrue);
    expect(File(AppIcons.rate).existsSync(), isTrue);
    expect(File(AppIcons.search).existsSync(), isTrue);
    expect(File(AppIcons.settings).existsSync(), isTrue);
    expect(File(AppIcons.top30).existsSync(), isTrue);
  });
}
