class Commit {
  String body;
  String icon;
  String user_name;
  String created_at;
  int user_id;
  int id;
  int micropost_id;

  Commit(this.body, this.icon, this.user_name, this.created_at, this.user_id,
      this.id, this.micropost_id);

  Commit.fromJson(Map<String, dynamic> json)
      :
        body=json['body'],
        user_name=json['user_name'],
        icon=json['icon'],
        created_at=json['created_at'],
        user_id=json['user_id'],
        id=json['id'],
        micropost_id=json['micropost_id']

  ;

  Map<String, dynamic> toJson() =>
      {
        'body': body,
        'id': id,
        'user_id': user_id,
        'icon': icon,
        'created_at': created_at,
        'micropost_id': micropost_id,
        'user_name': user_name,
      };

  Map toMap() {
    Map map = {'body': body};
    map['id'] = id;
    map['user_id'] = user_id;
    map['icon'] = icon;
    map['micropost_id'] = micropost_id;
    map['user_name'] = user_name;
    map['created_at'] = created_at;

    return map;
  }


  Commit.fromMap(Map map) {
    id = map['id'];
    body = map['body'];
    user_id = map['user_id'];
    icon = map['icon'];
    micropost_id = map['micropost_id'];
    user_name = map['user_name'];
    created_at = map['created_at'];
  }

}