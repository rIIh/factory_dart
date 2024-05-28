import 'package:factory_annotation/factory_annotation.dart';

class Post {
  final int id;
  final String title;
  final String description;
  final Picture image;
  final Author author;

  @factoryConstructor
  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.author,
  });
}

class Picture {
  final String small;
  final String medium;
  final String large;

  const Picture({
    required this.small,
    required this.medium,
    required this.large,
  });
}

class Author {
  final String firstName;
  final String lastName;

  Author({
    required this.firstName,
    required this.lastName,
  });
}
