class Admin {
  final String username;
  final String password;

  Admin({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": this.username,
      "password": this.password,
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      username: json["username"],
      password: json["password"],
    );
  }

//

}