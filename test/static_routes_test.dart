import 'package:samba_router/samba_router.dart';
import 'package:samba_helpers/samba_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Static Routes test', () {
    final sambaRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      sambaRouter
        ..put(
          method: httpMethod,
          path: '/',
          value: '$httpMethodName root',
        )
        ..put(
          method: httpMethod,
          path: '/countries',
          value: '$httpMethodName countries',
        )
        ..put(
          method: httpMethod,
          path: '/countries/india/',
          value: '$httpMethodName india',
        )
        ..put(
          method: httpMethod,
          path: '/countries/pakistan',
          value: '$httpMethodName pakistan',
        )
        ..put(
          method: httpMethod,
          path: '/countries/afghanistan',
          value: '$httpMethodName afghanistan',
        )
        ..put(
          method: httpMethod,
          path: '/states',
          value: '$httpMethodName states',
        )
        ..put(
          method: httpMethod,
          path: '/states/andhra-pradesh',
          value: '$httpMethodName andhra-pradesh',
        )
        ..put(
          method: httpMethod,
          path: '/fruits/apple',
          value: '$httpMethodName apple',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = sambaRouter.lookup(
          method: httpMethod,
          path: '/',
        );
        expect(
          result?.value,
          '$httpMethodName root',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/india',
        );
        expect(
          result?.value,
          '$httpMethodName india',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/pakistan/',
        );
        expect(
          result?.value,
          '$httpMethodName pakistan',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/states',
        );
        expect(
          result?.value,
          '$httpMethodName states',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/states/andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethodName andhra-pradesh',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/fruits/apple',
        );
        expect(
          result?.value,
          '$httpMethodName apple',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/random',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/countries/in/dia',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/countries/pak/stan',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/countries/bangladesh',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/states/telangana',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fruits',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fru-its',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fruits/app/le',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fru/its/pineapple',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fru/its/ban/ana',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fruits/straw-berry',
              )
              ?.value,
          isNull,
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear $httpMethodName test', () {
        sambaRouter.clear();
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/countries',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/countries/india',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/countries/pakistan',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/states',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/states/andhra-pradesh',
              )
              ?.value,
          isNull,
        );
        expect(
          sambaRouter
              .lookup(
                method: httpMethod,
                path: '/fruits/apple',
              )
              ?.value,
          isNull,
        );
      });
    }
  });
}
