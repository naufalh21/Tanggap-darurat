class UlasanDamkar {
  String idUlasan;
  String namaDamkar;
  String ulasan;
  String rating;
  String tglUlasan;
  String username;

  UlasanDamkar({
    required this.idUlasan,
    required this.namaDamkar,
    required this.ulasan,
    required this.rating,
    required this.tglUlasan,
    required this.username,
  });

  factory UlasanDamkar.fromJson(Map<String, dynamic> json) {
    return UlasanDamkar(
      idUlasan: json['id_ulasan'] ?? 'Unknown',
      namaDamkar: json['nama_damkar'] ?? 'Unknown',
      ulasan: json['ulasan'] ?? 'Unknown',
      rating: json['rating'] ?? '0',  // default to '0' if null
      tglUlasan: json['tgl_ulasan'] ?? 'Unknown',
      username: json['username'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ulasan': idUlasan,
      'nama_damkar': namaDamkar,
      'ulasan': ulasan,
      'rating': rating,
      'tgl_ulasan':tglUlasan,
      'username':username
    };
  }
}
