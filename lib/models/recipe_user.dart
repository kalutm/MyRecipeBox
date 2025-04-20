import 'package:my_recipe_box/utils/constants/databas_constants.dart';

class RecipeUser {
  final String id;
  final String email;

  RecipeUser({
    required this.id,
    required this.email
    });

  RecipeUser.fromRowMap(Map<String, Object?> dbRowMap):
  id = dbRowMap[userIdCoulmn] as String,
  email = dbRowMap[emailCoulmn] as String;

  Map<String, Object?> toMap(){
    return {
      userIdCoulmn: id,
      emailCoulmn: email,
    };
  }

  @override
  String toString() => "id: $id, email: $email";

  @override
  bool operator ==(covariant RecipeUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

