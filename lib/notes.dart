class NotesMode {
  final int? id;
  final String title;
  final String discreption;
  final String email;

  NotesMode(
      {this.id,
      required this.title,
      required this.discreption,
      required this.email});

  NotesMode.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        discreption = res['discreption'],
        email = res['email'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discreption': discreption,
      'email': email
    };
  }
}
