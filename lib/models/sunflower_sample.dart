class SunflowerSample {
  String title;
  DateTime dateTime;

  SunflowerSample({
    required this.title,
    required this.dateTime,
  });
}

List<SunflowerSample> samples = [
  SunflowerSample(title: 'Проба 1', dateTime: DateTime.now()),
  SunflowerSample(title: 'Проба 2', dateTime: DateTime.now()),
  SunflowerSample(title: 'Проба 3', dateTime: DateTime.now()),
];
