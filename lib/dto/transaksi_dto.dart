
class TransaksiDto {
    final int id;
    final String jamRequestAntar;
    final String tanggalRequestAntar;
    final String namaProduct;
    final String keterangan;
    final int idSeller;
    final int idCustomer;

    TransaksiDto(this.id, this.jamRequestAntar, this.tanggalRequestAntar, this.namaProduct, this.keterangan, this.idSeller, this.idCustomer);

    TransaksiDto.fromJson(Map jsonMap)
        : id = jsonMap['id'], 
        jamRequestAntar = jsonMap['jamRequestAntar'],
        tanggalRequestAntar = jsonMap['tanggalRequestAntar'],
        namaProduct = jsonMap['namaProduct'],
        keterangan = jsonMap['keterangan'],
        idSeller = jsonMap['idSeller'],
        idCustomer = jsonMap['idCustomer']
        ;

    Map toJson() => {
        'id': id,
        'jamRequestAntar': jamRequestAntar,
        'tanggalRequestAntar': tanggalRequestAntar,
        'namaProduct' : namaProduct,
        'keterangan': keterangan,
        'idSeller':idSeller,
        'idCustomer' : idCustomer
        };
}
