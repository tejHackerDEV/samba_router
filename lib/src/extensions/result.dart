import 'package:samba_router/samba_router.dart';

extension ResultExtension<T> on Result<T> {
  Result<T>? get endResult {
    Result<T>? tempResult = this;
    while (tempResult?.child != null) {
      tempResult = tempResult?.child;
    }
    return tempResult;
  }
}
