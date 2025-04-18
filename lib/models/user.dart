import 'package:my_recipe_box/utils/constants/databas_constants.dart';

class User {
  final String id;
  final String email;

  User({
    required this.id,
    required this.email
    });

  User.fromDbr(Map<String, Object?> dbRow):
  id = dbRow[userIdCoulmn] as String,
  email = dbRow[emailCoulmn] as String;

  Map<String, Object?> toMap(){
    return {
      userIdCoulmn: id,
      emailCoulmn: email,
    };
  }

  @override
  String toString() => "id: $id, email: $email";

  @override
  bool operator ==(covariant User other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

