class ResponseDto {
  final String errCode;
  final String errDesc;

  ResponseDto(this.errCode, this.errDesc);

  ResponseDto.fromJson(Map jsonMap)
      : errCode = jsonMap['errCode'],
        errDesc = jsonMap['errDesc'];

  Map toJson() => {
        'errCode': errCode,
        'errDesc': errDesc,
      };
}

class ResponseContentDto {
  final String errCode;
  final String errDesc;
  final dynamic contents;

  ResponseContentDto(this.errCode, this.errDesc, this.contents);

  ResponseContentDto.fromJson(Map jsonMap)
      : errCode = jsonMap['errCode'],
        errDesc = jsonMap['errDesc'],
        contents = jsonMap['contents'];

  Map toJson() => {
        'errCode': errCode,
        'errDesc': errDesc,
        'contents': contents,
      };
}
