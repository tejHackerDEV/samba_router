import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

void main() {
  group('Combine Router Static Routes test', () {
    final sambaRouter = SambaRouter<String>();
    final otherSambaRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      sambaRouter
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
        );

      otherSambaRouter
        ..put(
          method: httpMethod,
          path: '/',
          value: '$httpMethodName root',
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

    sambaRouter.combineWith(otherSambaRouter);

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
      test('Valid lookupEachPathSection $httpMethodName test', () {
        Iterable<Result<String>>? results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/',
        );
        expect(results?.length, 1);
        expect(
          results?.elementAt(0),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries',
        );
        expect(results?.length, 2);
        expect(
          results?.elementAt(0),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );
        expect(
          results?.elementAt(1),
          Result(
            value: '$httpMethodName countries',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/india',
        );
        expect(results?.length, 3);
        expect(
          results?.elementAt(0),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );
        expect(
          results?.elementAt(1),
          Result(
            value: '$httpMethodName countries',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );
        expect(
          results?.elementAt(2),
          Result(
            value: '$httpMethodName india',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/india/random',
        );
        expect(results?.length, 3);
        expect(
          results?.elementAt(0),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );
        expect(
          results?.elementAt(1),
          Result(
            value: '$httpMethodName countries',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );
        expect(
          results?.elementAt(2),
          Result(
            value: '$httpMethodName india',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        );
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

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear lookupEachPathSection $httpMethodName test', () {
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/countries',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/countries/india',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/countries/random',
          ),
          isNull,
        );
      });
    }
  });
}
