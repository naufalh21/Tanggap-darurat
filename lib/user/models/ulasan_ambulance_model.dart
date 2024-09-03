class UlasanAmbulance {
  String idUlasan;
  String namaAmbulance;
  String ulasan;
  String rating;
  String tglUlasan;
  String username;

  UlasanAmbulance({
    required this.idUlasan,
    required this.namaAmbulance,
    required this.ulasan,
    required this.rating,
    required this.tglUlasan,
    required this.username,
  });

  factory UlasanAmbulance.fromJson(Map<String, dynamic> json) {
    return UlasanAmbulance(
      idUlasan: json['id_ulasan'] ?? 'Unknown',
      namaAmbulance: json['nama_ambulance'] ?? 'Unknown',
      ulasan: json['ulasan'] ?? 'Unknown',
      rating: json['rating'] ?? '0',  // default to '0' if null
      tglUlasan: json['tgl_ulasan'] ?? 'Unknown',
      username: json['username'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id_ulasan' : idUlasan,
      'nama_ambulance' : namaAmbulance,
      'ulasan' : ulasan,
      'rating': rating,
      'tgl_ulasan':tglUlasan,
      'username':username,
    };
  }
}
