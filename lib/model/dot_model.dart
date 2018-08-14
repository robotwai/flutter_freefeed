class Dot {
  String icon;
  String user_name;
  String created_at;
  int user_id;
  int id;

  Dot(this.icon, this.user_name, this.created_at, this.user_id,
      this.id,);

  Dot.fromJson(Map<String, dynamic> json)
      :

        user_name=json['user_name'],
        icon=json['icon'],
        created_at=json['created_at'],
        user_id=json['user_id'],
        id=json['id']


  ;

  Map<String, dynamic> toJson() =>
      {

        'id': id,
        'user_id': user_id,
        'icon': icon,
        'created_at': created_at,
        'user_name': user_name,
      };

  Map toMap() {
    Map map = {};
    map['id'] = id;
    map['user_id'] = user_id;
    map['icon'] = icon;
    map['user_name'] = user_name;
    map['created_at'] = created_at;

    return map;
  }


  Dot.fromMap(Map map) {
    id = map['id'];
    user_id = map['user_id'];
    icon = map['icon'];
    user_name = map['user_name'];
    created_at = map['created_at'];
  }

}