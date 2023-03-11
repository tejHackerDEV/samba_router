import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

void main() {
  group('Combined Routes test', () {
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
          path: '/*',
          value: '$httpMethodName wildcard',
        )
        ..put(
          method: httpMethod,
          path: '/fruits',
          value: '$httpMethodName fruits',
        )
        ..put(
          method: httpMethod,
          path: '/countries/india',
          value: '$httpMethodName india',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country}/',
          value: '$httpMethodName dynamic country',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country}/*',
          value: '$httpMethodName dynamic wildcard state',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country:\\d+\$}',
          value: '$httpMethodName dynamic number country',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country:\\d+\$}/states',
          value: '$httpMethodName dynamic number country & state',
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
        expect(result?.pathParameters, isEmpty);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '?language=telugu&religion=hindu&religion=muslim',
        );
        expect(
          result?.value,
          '$httpMethodName root',
        );
        expect(result?.pathParameters, isEmpty);
        expect(result?.queryParameters['language'], 'telugu');
        expect(result?.queryParameters['religion'], ['hindu', 'muslim']);
        expect(result?.queryParameters.length, 2);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/fruits',
        );
        expect(
          result?.value,
          '$httpMethodName fruits',
        );
        expect(result?.pathParameters, isEmpty);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/india',
        );
        expect(
          result?.value,
          '$httpMethodName india',
        );
        expect(result?.pathParameters, isEmpty);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/pakistan',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic country',
        );
        expect(result?.pathParameters['country'], 'pakistan');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/2424',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/2424/states',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country & state',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/countries/bangladesh/random',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic wildcard state',
        );
        expect(result?.pathParameters['country'], 'bangladesh');
        expect(result?.pathParameters['*'], 'random');
        expect(result?.pathParameters.length, 2);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/random/2424/random',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['*'], 'random/2424/random');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path:
              '/random/2424/random?language=telugu&religion=hindu&religion=muslim',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['*'], 'random/2424/random');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters['language'], 'telugu');
        expect(result?.queryParameters['religion'], ['hindu', 'muslim']);
        expect(result?.queryParameters.length, 2);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid lookupEachPathSection $httpMethodName test', () {
        Iterable<Result<String>>? results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '?language=telugu&religion=hindu&religion=muslim',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            nodeType: NodeType.static,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/fruits',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName fruits',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/india',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName india',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/pakistan',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName dynamic country',
            pathParameters: {
              'country': 'pakistan',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/2424',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName dynamic number country',
            pathParameters: {
              'country': '2424',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/2424/states',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName dynamic number country',
            pathParameters: {
              'country': '2424',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethodName dynamic number country & state',
            pathParameters: {
              'country': '2424',
            },
            queryParameters: {},
            nodeType: NodeType.static,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/bangladesh/random',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName dynamic country',
            pathParameters: {
              'country': 'bangladesh',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethodName dynamic wildcard state',
            pathParameters: {
              'country': 'bangladesh',
              '*': 'random',
            },
            queryParameters: {},
            nodeType: NodeType.wildcard,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/countries/2424/random',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName dynamic number country',
            pathParameters: {
              'country': '2424',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/random/2424/random',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName wildcard',
            pathParameters: {
              '*': 'random/2424/random',
            },
            queryParameters: {},
            nodeType: NodeType.wildcard,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path:
              '/random/2424/random?language=telugu&religion=hindu&religion=muslim',
        );
        expect(results, [
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            nodeType: NodeType.static,
          ),
          Result(
            value: '$httpMethodName wildcard',
            pathParameters: {
              '*': 'random/2424/random',
            },
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            nodeType: NodeType.wildcard,
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
            path: '/countries',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
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
            path: '/',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries',
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
            path: '/countries/india',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/bangladesh/random',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
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
            path: '/',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '',
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
            path: '/fruits',
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
            path: '/countries/pakistan',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/countries/2424',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/countries/bangladesh/random',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          isNull,
        );
      });
    }
  });
}
