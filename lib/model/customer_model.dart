
class Customer {
    final int id;
    final int sellerId;
    final String nama;
    final String hp;
    final String alamat;
    final String coordinate;
    final int status;
    final String lastUpdate;

    Customer(this.id, this.sellerId, this.nama, this.hp, this.alamat, this.coordinate, this.status, this.lastUpdate);

    Customer.fromJson(Map jsonMap)
        : id = jsonMap['id'], 
        sellerId = jsonMap['sellerId'],
        nama = jsonMap['nama'],
        hp = jsonMap['hp'],
        alamat = jsonMap['alamat'],
        coordinate = jsonMap['coordinate'],
        status = jsonMap['status'],
        lastUpdate = jsonMap['lastUpdate']
        ;

    Map toJson() => {
        'id': id,
        'sellerId': sellerId,
        'nama': nama,
        'hp' : hp,
        'alamat': alamat,
        'coordinate': coordinate,
        'status':status,
        'lastUpdate' : lastUpdate
        };
}
