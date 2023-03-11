import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

void main() {
  group('Parametric RegExp Routes test', () {
    final sambaRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;

    for (final httpMethod in httpMethods) {
      sambaRouter
        ..put(
          method: httpMethod,
          path: '/{country:^[a-z]+\$}',
          value: '$httpMethod small country',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[A-Z]+\$}',
          value: '$httpMethod capital country',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[a-z]+\$}/{state:^[a-z-]+\$}/',
          value: '$httpMethod small country & state',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[A-Z]+\$}/{state:^[A-Z-]+\$}',
          value: '$httpMethod capital country & state',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[a-z]+\$}/{state:^[a-z-]+\$}/{city:^[a-z]+\$}',
          value: '$httpMethod small country, state & city',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[A-Z]+\$}/{state:^[A-Z-]+\$}/{city:^[A-Z]+\$}',
          value: '$httpMethod capital country, state & city',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = sambaRouter.lookup(
          method: httpMethod,
          path: 'india',
        );
        expect(
          result?.value,
          '$httpMethod small country',
        );
        expect(result?.pathParameters['country'], 'india');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: 'INDIA',
        );
        expect(
          result?.value,
          '$httpMethod capital country',
        );
        expect(result?.pathParameters['country'], 'INDIA');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: 'india/andhra-pradesh/',
        );
        expect(
          result?.value,
          '$httpMethod small country & state',
        );
        expect(result?.pathParameters['country'], 'india');
        expect(result?.pathParameters['state'], 'andhra-pradesh');
        expect(result?.pathParameters.length, 2);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: 'INDIA/ANDHRA-PRADESH',
        );
        expect(
          result?.value,
          '$httpMethod capital country & state',
        );
        expect(result?.pathParameters['country'], 'INDIA');
        expect(result?.pathParameters['state'], 'ANDHRA-PRADESH');
        expect(result?.pathParameters.length, 2);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: 'india/andhra-pradesh/kadapa/',
        );
        expect(
          result?.value,
          '$httpMethod small country, state & city',
        );
        expect(result?.pathParameters['country'], 'india');
        expect(result?.pathParameters['state'], 'andhra-pradesh');
        expect(result?.pathParameters['city'], 'kadapa');
        expect(result?.pathParameters.length, 3);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: 'INDIA/ANDHRA-PRADESH/KADAPA',
        );
        expect(
          result?.value,
          '$httpMethod capital country, state & city',
        );
        expect(result?.pathParameters['country'], 'INDIA');
        expect(result?.pathParameters['state'], 'ANDHRA-PRADESH');
        expect(result?.pathParameters['city'], 'KADAPA');
        expect(result?.pathParameters.length, 3);
        expect(result?.queryParameters, isEmpty);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid lookupEachPathSection $httpMethodName test', () {
        Iterable<Result<String>>? results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: 'india',
        );
        expect(results, [
          Result(
            value: '$httpMethod small country',
            pathParameters: {'country': 'india'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: 'INDIA',
        );
        expect(results, [
          Result(
            value: '$httpMethod capital country',
            pathParameters: {'country': 'INDIA'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: 'india/andhra-pradesh',
        );
        expect(results, [
          Result(
            value: '$httpMethod small country',
            pathParameters: {'country': 'india'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethod small country & state',
            pathParameters: {
              'country': 'india',
              'state': 'andhra-pradesh',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: 'INDIA/ANDHRA-PRADESH',
        );
        expect(results, [
          Result(
            value: '$httpMethod capital country',
            pathParameters: {'country': 'INDIA'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethod capital country & state',
            pathParameters: {'country': 'INDIA', 'state': 'ANDHRA-PRADESH'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: 'india/andhra-pradesh/kadapa/',
        );
        expect(results, [
          Result(
            value: '$httpMethod small country',
            pathParameters: {'country': 'india'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethod small country & state',
            pathParameters: {
              'country': 'india',
              'state': 'andhra-pradesh',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethod small country, state & city',
            pathParameters: {
              'country': 'india',
              'state': 'andhra-pradesh',
              'city': 'kadapa',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: 'INDIA/ANDHRA-PRADESH/KADAPA/',
        );
        expect(results, [
          Result(
            value: '$httpMethod capital country',
            pathParameters: {'country': 'INDIA'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethod capital country & state',
            pathParameters: {'country': 'INDIA', 'state': 'ANDHRA-PRADESH'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethod capital country, state & city',
            pathParameters: {
              'country': 'INDIA',
              'state': 'ANDHRA-PRADESH',
              'city': 'KADAPA',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'in-dia',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'IND-IA',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'in-dia/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'IN-DIA/ANDHRA-PRADESH',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/cudd-apah',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/CUDDAP-AH',
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
            path: 'india',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/KADAPA',
          ),
          isNull,
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear lookupEachPathSection $httpMethodName test', () {
        sambaRouter.clear();
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: 'india',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: 'INDIA',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: 'india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/KADAPA',
          ),
          isNull,
        );
      });
    }
  });
}
