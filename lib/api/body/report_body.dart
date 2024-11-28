class ReportBody {
  String storeName;
  String invoice;
  String paymentMethod;
  String noGiro;
  String giroDate;
  String bankName;
  int amount;

  ReportBody(this.storeName, this.invoice, this.paymentMethod, this.noGiro,
      this.giroDate, this.bankName, this.amount);

  Map<String, dynamic> toJson() => {
    'store_name': storeName,
    'invoice': invoice,
    'payment_method': paymentMethod,
    'no_giro': noGiro,
    'giro_date': giroDate,
    'bank_name': bankName,
    'amount': amount.toString()
  };
}