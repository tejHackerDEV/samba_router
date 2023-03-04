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
  });
}
