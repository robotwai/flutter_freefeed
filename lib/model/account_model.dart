
class Account{
  String token;
  String email;
  String name;
  String icon;
  int id;
  String sign_content;
  int followed;
  int follower;
  int sex;


  Account(this.token, this.email, this.name, this.icon, this.id,
      this.sign_content, this.followed, this.follower, this.sex);

  Account.fromJson(Map<String, dynamic> json)
      :
        token=json['token'],
        email=json['email'],
        name = json['name'],
        icon = json['icon'],
        id = json['id'],
        sex = json['sex'],
        sign_content = json['sign_content'],
        followed = json['followed'],
        follower = json['follower']
  ;

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'token': token,
        'icon': icon,
        'id': id,
        'isign_contentd': sign_content,
        'followed': followed,
        'follower': follower,
        'sex': sex,
      };

}