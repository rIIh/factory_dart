import 'package:sandbox/entity/post.dart';
import 'package:test/test.dart';

import '../factories/post_factory.dart';

void main() {
  test("compare", () {
    final postManualCreation = Post(
      id: 0,
      title: "title",
      description: "description",
      author: Author(
        firstName: "John",
        lastName: "Doe",
      ),
      image: Picture(
        small: "small.png",
        medium: "medium.png",
        large: "large.png",
      ),
    );

    final postFromFactory = PostFactory().create(
      title: (_, __) => 'title override',
    );

    // useless check, just to justify analyzer
    expect(postManualCreation, isNot(equals(postFromFactory)));
  });
}
