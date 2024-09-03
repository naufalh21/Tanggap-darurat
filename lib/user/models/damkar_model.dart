class Damkar {
  final String idDamkar;
  final String namaDamkar;
  final String noHp;
  final String alamat;
  final String linkMaps;
  final String logo;
  final String catatan;

  Damkar({
    required this.idDamkar,
    required this.namaDamkar,
    required this.noHp,
    required this.alamat,
    required this.linkMaps,
    required this.logo,
    required this.catatan,
  });

  factory Damkar.fromJson(Map<String, dynamic> json) {
    return Damkar(
      idDamkar: json['id_damkar'] ?? 'Unknown',
      namaDamkar: json['nama_damkar'] ?? 'Unknown',
      noHp: json['no_hp'] ?? 'Unknown',
      alamat: json['alamat'] ?? 'Unknown',
      linkMaps: json['link_maps'] ?? 'Unknown',
      logo: json['logo'] ?? 'Unknown',
      catatan: json['catatan'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_damkar': idDamkar,
      'nama_damkar': namaDamkar,
      'no_hp': noHp,
      'alamat': alamat,
      'link_maps': linkMaps,
      'logo': logo,
      'catatan': catatan,
    };
  }
}
