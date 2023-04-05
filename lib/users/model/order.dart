class Order {
  int? orderId;
  int? userId;
  String? selectedItem;
  String? deliverySystem;
  String? paymentSystem;
  String? note;
  double? totalAmount;
  String? image;
  String? status;
  DateTime? dateTime;
  String? shipmentAddress;
  String? phoneNumber;

  Order(
      {this.orderId,
      this.userId,
      this.selectedItem,
      this.deliverySystem,
      this.paymentSystem,
      this.note,
      this.totalAmount,
      this.image,
      this.status,
      this.dateTime,
      this.shipmentAddress,
      this.phoneNumber});

  factory Order.fromJson(Map<String,dynamic> json)=>Order(
    orderId: int.parse(json['order_id']),
    paymentSystem: json['paymentSystem'],
    userId: int.parse(json['user_id']),
    selectedItem: json['selectedItem'],
    deliverySystem: json['deliverySystem'],
    note: json['note'],
    totalAmount:double.parse(json['totalAmount']),
    status: json['status'],
    dateTime: DateTime.parse(json['dateTime']),
    shipmentAddress: json['shipmentAddress'],
    phoneNumber: json['phoneNumber'],
    image: json['image'],
  );

  Map<String, dynamic> toJson(String imageSelected) => {
        "order_id": orderId.toString(),
        "user_id": userId.toString(),
        "selectedItem": selectedItem,
        "deliverySystem": deliverySystem,
        "paymentSystem": paymentSystem,
        "note": note,
        "totalAmount": totalAmount!.toStringAsFixed(2),
        "image": image,
        "status": status,
        "shipmentAddress": shipmentAddress,
        "phoneNumber": phoneNumber,
    "imageFile":imageSelected,
      };
}
