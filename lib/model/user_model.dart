class User {
  String email;
  String name;
  String icon;
  int id;
  String sign_content;
  int followed;
  int follower;
  int relation; //0为 无关系，1是他关注了你，2是你关注了他，3是互相关注
  int micropost_num;
  int sex;


  User(this.email, this.name, this.icon, this.id, this.sign_content,
      this.followed, this.follower, this.relation, this.micropost_num);

  User.fromJson(Map<String, dynamic> json)
      :
        email=json['email'],
        name = json['name'],
        icon = json['icon'],
        id = json['id'],
        sex = json['sex'],
        sign_content = json['sign_content'],
        followed = json['followed'],
        follower = json['follower'],
        relation = json['relation'],
        micropost_num = json['micropost_num']
  ;

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'icon': icon,
        'id': id,
        'isign_contentd': sign_content,
        'followed': followed,
        'follower': follower,
        'relation': relation,
        'sex': sex,
        'micropost_num': micropost_num,
      };

}