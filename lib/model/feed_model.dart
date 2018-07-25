
class Micropost{
  String content;
  int id;

  Micropost(this.content, this.id);

  Micropost.fromJson(Map<String, dynamic> json)
      :
        content=json['content'],

        id = json['id']
  ;

  Map<String, dynamic> toJson() =>
      {
        'content': content,
        'id': id,
      };

}