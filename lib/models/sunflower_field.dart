import 'package:flutter/material.dart';
import 'package:innopolis_hack/models/sunflower_sample.dart';

class SunflowerField {
  final String sunflowerFieldName;
  final String fieldArea;
  final String date;
  final List<SunflowerSample> samples;

  SunflowerField({
    required this.sunflowerFieldName,
    required this.fieldArea,
    required this.date,
    required this.samples,
  });
}
