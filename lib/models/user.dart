class User {
  User({
    this.uid,
    this.name,
    this.money,
    this.allowedCredit,
    this.email,
    this.disabled,
    this.roles,
    this.discount,
  });

  String uid;
  String name;
  double money;
  double allowedCredit;
  String email;
  bool disabled;
  List<String> roles;
  Map<String,dynamic> discount;


  factory User.fromMap(Map<String, dynamic> json) => User(
        uid: json['uid'] ?? User.defaultUser().uid,
        name: json['name'] ?? User.defaultUser().name,
        money: double.tryParse(json['money'].toString()) ?? User.defaultUser().money,
        allowedCredit: double.tryParse(json['allowedCredit'].toString()) ?? User.defaultUser().allowedCredit,
        email: json['email'] ?? User.defaultUser().email,
        disabled: json['disabled'] ?? User.defaultUser().disabled,
        roles: (json['roles'] ?? User.defaultUser().roles).cast<String>(),
        discount: (json['discount'] ?? User.defaultUser().discount).cast<String,dynamic>(),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'money': money,
        'allowedCredit': allowedCredit,
        'email': email,
        'disabled': disabled,
        'roles': roles,
        'discount': discount
      };

  factory User.defaultUser() => User(
        uid: "",
        name: "",
        money: 0,
        allowedCredit: 0,
        email: "",
        disabled: false,
        roles: ["customer"],
        discount: {},
      );
}
