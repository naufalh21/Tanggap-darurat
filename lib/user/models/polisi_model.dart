class Polisi {
  final String idPolisi;
  final String namaPolisi;
  final String noHp;
  final String alamat;
  final String linkMaps;
  final String logo;
  final String catatan;

  Polisi({
    required this.idPolisi,
    required this.namaPolisi,
    required this.noHp,
    required this.alamat,
    required this.linkMaps,
    required this.logo,
    required this.catatan,
  });

  factory Polisi.fromJson(Map<String, dynamic> json) {
    return Polisi(
      idPolisi: json['id_polisi'] ?? 'Unknown',
      namaPolisi: json['nama_polisi'] ?? 'Unknown',
      noHp: json['no_hp'] ?? 'Unknown',
      alamat: json['alamat'] ?? 'Unknown',
      linkMaps: json['link_maps'] ?? 'Unknown',
      logo: json['logo'] ?? 'Unknown',
      catatan: json['catatan'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_polisi': idPolisi,
      'nama_polisi': namaPolisi,
      'no_hp': noHp,
      'alamat': alamat,
      'link_maps': linkMaps,
      'logo': logo,
      'catatan': catatan,
    };
  }
}
