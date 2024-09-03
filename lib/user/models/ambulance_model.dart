class Ambulance {
  final String idAmbulance;
  final String namaAmbulance;
  final String noHp;
  final String alamat;
  final String linkMaps;
  final String logo;
  final String catatan;

  Ambulance({
    required this.idAmbulance,
    required this.namaAmbulance,
    required this.noHp,
    required this.alamat,
    required this.linkMaps,
    required this.logo,
    required this.catatan,
  });

  factory Ambulance.fromJson(Map<String, dynamic> json) {
    return Ambulance(
      idAmbulance: json['id_ambulance'] ?? 'Unknown',
      namaAmbulance: json['nama_ambulance'] ?? 'Unknown',
      noHp: json['no_hp'] ?? 'Unknown',
      alamat: json['alamat'] ?? 'Unknown',
      linkMaps: json['link_maps'] ?? 'Unknown',
      logo: json['logo'] ?? 'Unknown',
      catatan: json['catatan'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ambulance': idAmbulance,
      'nama_ambulance': namaAmbulance,
      'no_hp': noHp,
      'alamat': alamat,
      'link_maps': linkMaps,
      'logo': logo,
      'catatan': catatan,
    };
  }
}
