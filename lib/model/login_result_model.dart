class LoginResultDto {
    final String token;
    final String errCode;
    final String errDesc;

    LoginResultDto( this.token, this.errCode, this.errDesc);

    LoginResultDto.fromJson(Map jsonMap)
        : token = jsonMap['token'],
            errCode = jsonMap['errCode'],
            errDesc = jsonMap['errDesc'];

    Map toJson() => {
            'token': token,
            'errCode': errCode,
            'errDesc': errDesc,
        };
}
