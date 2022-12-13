import 'dart:convert';

List<AccountModel> employeeFromJson(String str) => List<AccountModel>.from(
    json.decode(str).map((x) => AccountModel.fromJson(x)));

String employeeToJson(List<AccountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountModel {
  final String id;
  final double accountBalance;
  final String accountDateTime;

  AccountModel({
    required this.id,
    required this.accountBalance,
    required this.accountDateTime,
  });

  @override
  String toString() {
    String item = '$id-$accountBalance';
    return item;
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json['id'].toString(),
        accountBalance: double.parse(json['accountBalance'].toString()),
        accountDateTime: json['accountDateTime'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountBalance": accountBalance,
        "accountDateTime": accountDateTime,
      };
}
