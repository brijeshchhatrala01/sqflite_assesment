// ignore_for_file: non_constant_identifier_names

class UserModel {
  final String first_name;
  final String last_name;
  final String email;
  final String username;
  final String password;
  final String confirm_password;

  const UserModel({required this.first_name,required this.last_name,required this.email,required this.username,required this.password,required this.confirm_password});


  Map<String,Object?> toMap() {
    return {
      'first_name' : first_name,
      'last_name' : last_name,
      'email' : email,
      'username' : username,
      'password' : password,
      'confirm_password' : confirm_password,
    };
  }
}