class ReportBody {
  int payDate;
  String storeName;
  String invoice;
  String paymentMethod;
  String noGiro;
  int giroDate;
  String bankName;
  int amount;
  String note = "";

  ReportBody(this.payDate,this.storeName, this.invoice, this.paymentMethod, this.noGiro,
      this.giroDate, this.bankName, this.amount, this.note);

  Map<String, dynamic> toJson() => {
    'pay_date': payDate,
    'store_name': storeName,
    'invoice': invoice,
    'payment_method': paymentMethod,
    'no_giro': noGiro,
    'giro_date': giroDate,
    'bank_name': bankName,
    'amount': amount.toString(),
    'note': note
  };
}