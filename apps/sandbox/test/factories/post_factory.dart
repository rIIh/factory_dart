import 'package:factory_annotation/factory_annotation.dart';
import 'package:sandbox/entity/post.dart';

export 'package:factory_annotation/factory_annotation.dart';
part 'post_factory.factory.dart';

@Factory(Post)
class PostFactory extends _$PostFactory with FakerProviderMixin {
  PostFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);

  @override
  Author getAuthor(FactoryContext context, ContextKey key) {
    return AuthorFactory(context, key).create();
  }

  @override
  Picture getImage(FactoryContext context, ContextKey key) {
    return PictureFactory(context, key).create();
  }
}

@Factory(Author)
class AuthorFactory extends _$AuthorFactory with FakerProviderMixin {
  AuthorFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}

@Factory(Picture)
class PictureFactory extends _$PictureFactory with FakerProviderMixin {
  PictureFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}
