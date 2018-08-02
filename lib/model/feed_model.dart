
class Micropost{
  String content;
  int id;
  int user_id;
  String picture;
  String icon;
  String user_name;
  String created_at;
  int dotId;
  int dots_num;
  int comment_num;


  Micropost(this.content, this.id, this.user_id, this.picture, this.icon,
      this.user_name, this.created_at, this.dotId, this.dots_num,
      this.comment_num);

  Micropost.fromJson(Map<String, dynamic> json)
      :
        content=json['content'],
        user_id=json['user_id'],
        icon=json['icon'],
        picture=json['picture'],
        user_name=json['user_name'],
        created_at=json['created_at'],
        dotId=json['dotId'],
        dots_num=json['dots_num'],
        comment_num=json['comment_num'],
        id = json['id']
  ;

  Map<String, dynamic> toJson() =>
      {
        'content': content,
        'id': id,
        'user_id': user_id,
        'icon': icon,
        'picture': picture,
        'user_name': user_name,
        'created_at': created_at,
        'dotId': dotId,
        'dots_num': dots_num,
        'comment_num': comment_num,
      };

  Map toMap() {
    Map map = {'content': content};
    map['id'] = id;
    map['user_id'] = user_id;
    map['icon'] = icon;
    map['picture'] = picture;
    map['user_name'] = user_name;
    map['created_at'] = created_at;
    map['dotId'] = dotId;
    map['dots_num'] = dots_num;
    map['comment_num'] = comment_num;


    return map;
  }


  Micropost.fromMap(Map map) {
    id = map['id'];
    content = map['content'];
    user_id = map['user_id'];
    icon = map['icon'];
    picture = map['picture'];
    user_name = map['user_name'];
    created_at = map['created_at'];
    dotId = map['dotId'];
    dots_num = map['dots_num'];
    comment_num = map['comment_num'];
  }

  @override
  int get hashCode {
    return id;
  }


}