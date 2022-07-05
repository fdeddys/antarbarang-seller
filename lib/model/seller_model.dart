class Seller {
    final int id;
    final String kode;
    final String nama;
    final String hp;
    final String alamat;
    final int status;
    final String lastUpdate;

    Seller(this.id, this.kode, this.nama, this.hp, this.alamat, this.status, this.lastUpdate);

    Seller.fromJson(Map jsonMap)
        : id = jsonMap['id'], 
        kode = jsonMap['kode'],
        nama = jsonMap['nama'],
        hp = jsonMap['hp'],
        alamat = jsonMap['alamat'],
        status = jsonMap['status'],
        lastUpdate = jsonMap['lastUpdate']
        ;

    Map toJson() => {
        'id': id,
        'kode': kode,
        'nama': nama,
        'hp' : hp,
        'alamat': alamat,
        'status':status,
        'lastUpdate' : lastUpdate
        };
}
