
class Micropost{
  String content;
  int id;
  final String columnId = "id";
  final String columnContent = "content";
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

  Map toMap() {
    Map map = {columnContent: content};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }


  Micropost.fromMap(Map map) {
    id = map[columnId];
    content = map[columnContent];
  }

}