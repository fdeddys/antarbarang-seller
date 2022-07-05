class LoginDto {
  final String kode;
  final String password;

  LoginDto(this.kode, this.password);

  LoginDto.fromJson(Map jsonMap)
      : kode = jsonMap['kode'],
        password = jsonMap['password'];

  Map toJson() => {
        'kode': kode,
        'password': password,
      };
}
