class PaymentReciptData {
  final bool purchesSucess;
  final int payablePrice;
  final String paymentStatus;

  PaymentReciptData.fromjson(Map<String,dynamic> json):
  purchesSucess=json['purchase_success'],
  payablePrice = json['payable_price'],
  paymentStatus=json['payment_status'];
}