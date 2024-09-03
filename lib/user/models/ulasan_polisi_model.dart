class UlasanPolisi {
  String idUlasan;
  String namaPolisi;
  String ulasan;
  String rating;
  String tglUlasan;
  String username;

  UlasanPolisi({
    required this.idUlasan,
    required this.namaPolisi,
    required this.ulasan,
    required this.rating,
    required this.tglUlasan,
    required this.username,
  });

  factory UlasanPolisi.fromJson(Map<String, dynamic> json) {
    return UlasanPolisi(
      idUlasan: json['id_ulasan'] ?? 'Unknown',
      namaPolisi: json['nama_polisi'] ?? 'Unknown',
      ulasan: json['ulasan'] ?? 'Unknown',
      rating: json['rating'] ?? '0',  // default to '0' if null
      tglUlasan: json['tgl_ulasan'] ?? 'Unknown',
      username: json['username'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ulasan': idUlasan,
      'nama_polisi': namaPolisi,
      'ulasan': ulasan,
      'rating': rating,
      'tgl_ulasan':tglUlasan,
      'username':username
    };
  }
}
