import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

void main() {
  group('QueryParameters Routes test', () {
    final sambaRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      sambaRouter.put(
        method: httpMethod,
        path: '/countries',
        value: '$httpMethodName countries',
      );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries?country=india',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], 'india');
        expect(result?.queryParameters.length, 1);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries?country=india&state=andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], 'india');
        expect(result?.queryParameters['state'], 'andhra-pradesh');
        expect(result?.queryParameters.length, 2);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries?country=india&country=pakistan',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], ['india', 'pakistan']);
        expect(result?.queryParameters.length, 1);

        result = sambaRouter.lookup(
          method: httpMethod,
          path:
              '/countries?country=india&country=pakistan&state=andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], ['india', 'pakistan']);
        expect(result?.queryParameters['state'], 'andhra-pradesh');
        expect(result?.queryParameters.length, 2);

        result = sambaRouter.lookup(
          method: httpMethod,
          path:
              '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], ['india', 'pakistan']);
        expect(
            result?.queryParameters['state'], ['andhra-pradesh', 'telangana']);
        expect(result?.queryParameters.length, 2);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear $httpMethodName test', () {
        sambaRouter.clear();
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&state=andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&country=pakistan',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
          ),
          isNull,
        );
      });
    }
  });
}
