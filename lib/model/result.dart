class Result {
  String _city;
  int _rating;
  int _population;
  String _country;

  static const List<String> listSelfKeys = ['city', 'rating', 'population', 'country'];


//  Result({this.city, this.rating, this.population, this.country, this.selected});

  Result({String city, int rating, int population, String country}) {
    _city = city;
    _rating = rating;
    _population = population;
    _country = country;
  }

  bool selected = false;

  List<String> listSelfValues() {
    return [_city, '$_rating', '$_population', _country];
  }

  Map<String, String> mapSelfKeyValues() {
    return {
      'city': _city,
      'rating': '$_rating',
      'population': '$_population',
      'country': _country,
    };
  }

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      city: json['city'] as String,
      rating: json['rating'] as int,
      population: json['population'] as int,
      country: json['country'] as String,
    );
  }
}