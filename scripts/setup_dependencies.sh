BASEDIR=$(dirname "$0")

cd $BASEDIR/../factory_annotation

echo "Installing factory_annotation"
dart pub get

cd ../factory

echo "overriding factory dependencies"
echo "
dependency_overrides:
  factory_annotation:
    path: ../factory_annotation" >> pubspec.yaml

echo "Installing freezed"
dart pub get