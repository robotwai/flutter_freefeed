
class Account{
  String token;
  String email;
  String name;
  String icon;
  int id;

  Account(this.token, this.email, this.name, this.icon, this.id);

  Account.fromJson(Map<String, dynamic> json)
      :
        token=json['token'],
        email=json['email'],
        name = json['name'],
        icon = json['icon'],
        id = json['id']
  ;

}