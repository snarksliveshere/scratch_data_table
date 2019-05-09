class Result {
  final String sex;
  final String region;
  final int year;
  final String statistic;
  final String value;

  Result({this.sex, this.region, this.year, this.statistic, this.value});

  bool selected = false;

  List<String> listSelfValues() {
    return [this.sex, this.region, '${this.year}', this.statistic, this.value];
  }

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      sex: json['sex'] as String,
      region: json['region'] as String,
      year: json['year'] as int,
      statistic: json['statistic'] as String,
      value: json['value'] as String,
    );
  }
}