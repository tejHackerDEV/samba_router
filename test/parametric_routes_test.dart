import 'package:samba_router/samba_router.dart';
import 'package:samba_helpers/samba_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Parametric Routes test', () {
    final sambaRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      sambaRouter
        ..put(
          method: httpMethod,
          path: '/{country}',
          value: '$httpMethodName dynamic country',
        )
        ..put(
          method: httpMethod,
          path: '/india/{state}',
          value: '$httpMethodName dynamic state',
        )
        ..put(
          method: httpMethod,
          path: '/india/andhra-pradesh/{city}/',
          value: '$httpMethodName dynamic city',
        )
        ..put(
          method: httpMethod,
          path: '/india/{state}/{city}',
          value: '$httpMethodName dynamic state & city',
        )
        ..put(
          method: httpMethod,
          path: '/{country}/{state}/{city}',
          value: '$httpMethodName dynamic country, state & city',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/telangana',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic state',
        );
        expect(result?.pathParameters['state'], 'telangana');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic city',
        );
        expect(result?.pathParameters['city'], 'kadapa');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/india/telangana/hyderabad',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic state & city',
        );
        expect(result?.pathParameters['state'], 'telangana');
        expect(result?.pathParameters['city'], 'hyderabad');
        expect(result?.pathParameters.length, 2);
        expect(result?.queryParameters, isEmpty);

        result = sambaRouter.lookup(
          method: httpMethod,
          path: '/pakistan/punjab/lahore',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic country, state & city',
        );
        expect(result?.pathParameters['country'], 'pakistan');
        expect(result?.pathParameters['state'], 'punjab');
        expect(result?.pathParameters['city'], 'lahore');
        expect(result?.pathParameters.length, 3);
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
        expect(results, [
          Result(
            value: '$httpMethodName dynamic state',
            pathParameters: {'state': 'telangana'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/india/telangana/hyderabad',
        );
        expect(results, [
          Result(
            value: '$httpMethodName dynamic state',
            pathParameters: {'state': 'telangana'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethodName dynamic state & city',
            pathParameters: {'state': 'telangana', 'city': 'hyderabad'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/pakistan/punjab/lahore',
        );
        expect(results, [
          Result(
            value: '$httpMethodName dynamic country',
            pathParameters: {'country': 'pakistan'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethodName dynamic country, state & city',
            pathParameters: {
              'country': 'pakistan',
              'state': 'punjab',
              'city': 'lahore',
            },
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
        ]);

        results = sambaRouter.lookupEachPathSection(
          method: httpMethod,
          path: '/pakistan/punjab/lahore/random',
        );
        expect(results, [
          Result(
            value: '$httpMethodName dynamic country',
            pathParameters: {'country': 'pakistan'},
            queryParameters: {},
            nodeType: NodeType.parametric,
          ),
          Result(
            value: '$httpMethodName dynamic country, state & city',
            pathParameters: {
              'country': 'pakistan',
              'state': 'punjab',
              'city': 'lahore',
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
            path: '/india',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/kadapa/cuddapah',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/cuddapah/kadapa',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/states/kadapa/cuddapah',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cuddapah/kadapa',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/states/city/cuddapah',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/states/city/kadapa',
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
            path: '/india',
          ),
          isNull,
        );
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
            path: '/india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/telangana/hyderabad',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/pakistan/punjab/lahore',
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
            path: '/india/telangana/hyderabad',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/pakistan/punjab/lahore',
          ),
          isNull,
        );
        expect(
          sambaRouter.lookupEachPathSection(
            method: httpMethod,
            path: '/pakistan/punjab/lahore/random',
          ),
          isNull,
        );
      });
    }
  });
}
