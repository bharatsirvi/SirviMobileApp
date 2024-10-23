class Gotra {
  final String name;

  Gotra({required this.name});

  factory Gotra.fromJson(Map<String, dynamic> json) {
    return Gotra(
      name: json['name'],
    );
  }
}
