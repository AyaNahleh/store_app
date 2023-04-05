import 'package:get/get.dart';

import '../model/cart.dart';

class CartListController extends GetxController{

   final RxList<Cart> _cartList=<Cart>[].obs;
   final RxList<int> _selectedItemList=<int>[].obs;
   final RxBool _isSelectedAll=false.obs;
   final RxDouble _total=0.0.obs;

   List<Cart> get cartList =>_cartList.value;
   List<int> get selectedItem =>_selectedItemList.value;
   bool get isSelectedAll =>_isSelectedAll.value;
   double get total =>_total.value;


   setList(List<Cart> list){
     _cartList.value=list;
   }
   addSelectedItem(int itemSelectedID){
     _selectedItemList.value.add(itemSelectedID);
     update();
   }
   deleteSelectedItem(int  itemSelectedID){
     _selectedItemList.value.remove(itemSelectedID);
     update();

   }
   setIsSelectedAllItem(){
     _isSelectedAll.value=!_isSelectedAll.value;
   }

   clearAllSelectedItem(){
     _selectedItemList.value.clear();
     update();
   }
   setTotal(double overallTotal){
     _total.value=overallTotal;
   }




}