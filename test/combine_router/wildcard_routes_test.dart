import 'package:samba_router/samba_router.dart';
import 'package:samba_helpers/samba_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Combine Router Wildcard Routes test', () {
    final sambaRouter = SambaRouter<String>();
    final otherSambaRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      sambaRouter
        ..put(
          method: httpMethod,
          path: '/india/*',
          value: '$httpMethodName wildcard state',
        )
        ..put(
          method: httpMethod,
          path: '/india/andhra-pradesh/*',
          value: '$httpMethodName wildcard city',
        )
        ..put(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa/*/',
          value: '$httpMethodName wildcard street',
        );

      otherSambaRouter
        ..put(
          method: httpMethod,
          path: '/fruits/*',
          value: '$httpMethodName wildcard fruit',
        )
        ..put(
          method: httpMethod,
          path: '/*',
          value: '$httpMethodName wildcard',
        );
    }

    sambaRouter.combineWith(otherSambaRouter);

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/telangana',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard state',
        );
        expect(result?.pathParameters['*'], 'telangana');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/2424/',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard state',
        );
        expect(result?.pathParameters['*'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/cuddapah',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard city',
        );
        expect(result?.pathParameters['*'], 'cuddapah');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony/',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard street',
        );
        expect(result?.pathParameters['*'], 'bhagya-nagar-colony');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa/ngo-colony',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard street',
        );
        expect(result?.pathParameters['*'], 'ngo-colony');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/fruits/apple',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard fruit',
        );
        expect(result?.pathParameters['*'], 'apple');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/fruits/apple/1234',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard fruit',
        );
        expect(result?.pathParameters['*'], 'apple/1234');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/random',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['*'], 'random');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid lookupEachPathSection $httpMethodName test', () {
        Iterable<Result<String>>? results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/india/telangana',
        );
        expect(results?.length, 1);
        expect(
          results?.elementAt(0),
          Result(
            value: '$httpMethodName wildcard state',
            pathParameters: {'*': 'telangana'},
            queryParameters: {},
            nodeType: NodeType.wildcard,
          ),
        );

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/fruits/red/apples',
        );
        expect(results?.length, 1);
        expect(
          results?.elementAt(0),
          Result(
            value: '$httpMethodName wildcard fruit',
            pathParameters: {'*': 'red/apples'},
            queryParameters: {},
            nodeType: NodeType.wildcard,
          ),
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear $httpMethodName test', () {
        sambaRouter.clear();
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/telangana',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/2424',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/ngo-colony',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple/1234',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/random',
          ),
          isNull,
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear lookupEachPathSection $httpMethodName test', () {
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/india/telangana',
          ),
          isNull,
        );

        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/fruits/red/apples',
          ),
          isNull,
        );
      });
    }
  });
}
