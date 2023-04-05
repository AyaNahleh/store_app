class Api{
  static const hostConnect="http://192.168.1.33/api_shop_app";
  static const hostConnectUsers="$hostConnect/user";
  static const hostConnectAdmins="$hostConnect/admin";
  static const hostItem="$hostConnect/items";
  static const hostClothes="$hostConnect/clothes";
  static const hostCart="$hostConnect/cart";
  static const hostFavorite="$hostConnect/favorite";
  static const hostOrder="$hostConnect/order";

  static const hostImages="$hostConnect/transaction_proof_images/";






  //signUp-login users
  static const signUp="$hostConnect/user/signup.php";
  static const validateEmail="$hostConnect/user/validate_email.php";
  static const login="$hostConnect/user/login.php";

  //login admin
  static const adminLogin="$hostConnectAdmins/login.php";
  static const adminGetAllOrders="$hostConnectAdmins/read_orders.php";

  //save new item
  static const uploadNewItem="$hostItem/upload.php";

  static const searchItem="$hostItem/search.php";



  static const getTrendingMostPopularClothes="$hostClothes/trending.php";
  static const getAllClothes="$hostClothes/all.php";
  static const addToCart="$hostCart/add.php";
  static const getCartList="$hostCart/read.php";
  static const deleteSelectedItem="$hostCart/delete.php";
  static const updateItemInCartList="$hostCart/update.php";

  static const addFavorite="$hostFavorite/add.php";
  static const deleteFavorite="$hostFavorite/delete.php";
  static const validateFavorite="$hostFavorite/validate_favorite.php";
  static const readFavorite="$hostFavorite/read.php";

  static const addOrder="$hostOrder/add.php";
  static const readOrder="$hostOrder/read.php";
  static const updateStatus="$hostOrder/update_status.php";
  static const readHistory="$hostOrder/read_history.php";
















}