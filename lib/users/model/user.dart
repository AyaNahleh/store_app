class User {
  int userId;
  String userName;
  String userEmail;
  String userPassword;

  User(
      this.userId,
      this.userName,
      this.userEmail,
      this.userPassword
      );

  factory User.fromJson(Map<String,dynamic> json)=>User(
    int.parse(json["user_id"]),
    json["user_name"],
    json["user_email"],
    json["user_password"],
  );

  Map<String,dynamic> toJson()=>{
    'user_id':userId.toString(),
    'user_name':userName,
    'user_email':userEmail,
    'user_password':userPassword,
  };
}
