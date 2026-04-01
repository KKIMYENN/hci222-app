import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();
  @override
  List<Object?> get props => [];
}

class ScanImageCaptured extends ScanEvent {
  final File image;
  const ScanImageCaptured(this.image);
  @override
  List<Object?> get props => [image.path];
}

class ScanReset extends ScanEvent {
  const ScanReset();
}
