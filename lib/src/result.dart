import 'package:samba_helpers/samba_helpers.dart';

class Result<T> {
  final T? value;
  final Map<String, String> pathParameters;
  final Map<String, dynamic> queryParameters;
  final Result<T>? child;

  const Result({
    required this.value,
    required this.pathParameters,
    required this.queryParameters,
    required this.child,
  });

  @override
  bool operator ==(Object other) {
    return other is Result &&
        other.value == value &&
        other.pathParameters.equalsTo(pathParameters) &&
        other.queryParameters.equalsTo(queryParameters) &&
        other.child == child;
  }

  @override
  int get hashCode => Object.hashAll(
        [value, pathParameters, queryParameters, child],
      );

  @override
  String toString() {
    return '{"value": $value, "pathParameters": $pathParameters, "queryParameters": $queryParameters, "child": $child}';
  }
}
