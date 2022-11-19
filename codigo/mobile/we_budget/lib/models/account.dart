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
}
