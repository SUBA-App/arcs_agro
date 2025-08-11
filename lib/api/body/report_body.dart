import 'package:sales_app/api/response/invoice_response.dart';

class ReportBody {
  int payDate;
  String storeName;
  List<InvoiceData> invoice;
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
    'invoice': invoice.map((i) => i.toJson()).toList(),
    'payment_method': paymentMethod,
    'no_giro': noGiro,
    'giro_date': giroDate,
    'bank_name': bankName,
    'amount': amount.toString(),
    'note': note
  };
}