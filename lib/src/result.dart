import 'package:samba_helpers/samba_helpers.dart';

import 'enum/node_type.dart';

class Result<T> {
  final T value;
  final Map<String, String> pathParameters;
  final Map<String, dynamic> queryParameters;

  /// Indicates the type of the last node that has been found
  /// while looking up.
  final NodeType nodeType;

  Result({
    required this.value,
    required this.pathParameters,
    required this.queryParameters,
    required this.nodeType,
  });

  @override
  bool operator ==(Object other) =>
      other is Result &&
      other.runtimeType == runtimeType &&
      other.value == value &&
      other.pathParameters.equalsTo(pathParameters) &&
      other.queryParameters.equalsTo(queryParameters) &&
      other.nodeType == nodeType;

  @override
  int get hashCode => Object.hashAll(
        [value, pathParameters, queryParameters, nodeType],
      );

  @override
  String toString() {
    return '{"value": $value, "pathParameters": $pathParameters, "queryParameters": $queryParameters}';
  }
}
