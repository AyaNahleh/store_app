import 'package:get/get.dart';

class OrderNowController extends GetxController{
  RxString _deliverySystem="FedEx".obs;
  RxString _paymentSystem="Apple Pay".obs;

  String get deliverySystem=>_deliverySystem.value;
  String get paymentSystem=>_paymentSystem.value;

  setDeliverySystem(String newDeliverySystem){
    _deliverySystem.value=newDeliverySystem;
  }

  setPaymentSystem(String newPaymentSystem){
    _paymentSystem.value=newPaymentSystem;
  }



}