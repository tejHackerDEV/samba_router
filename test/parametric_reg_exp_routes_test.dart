import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

import 'utils/constants.dart';

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
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod small country & state',
                pathParameters: {
                  'country': 'india',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod capital country & state',
                pathParameters: {
                  'country': 'INDIA',
                  'state': 'ANDHRA-PRADESH',
                },
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod small country & state',
                pathParameters: {
                  'country': 'india',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethod small country, state & city',
                  pathParameters: {
                    'country': 'india',
                    'state': 'andhra-pradesh',
                    'city': 'kadapa',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/INDIA/ANDHRA-PRADESH/KADAPA/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod capital country & state',
                pathParameters: {
                  'country': 'INDIA',
                  'state': 'ANDHRA-PRADESH',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethod capital country, state & city',
                  pathParameters: {
                    'country': 'INDIA',
                    'state': 'ANDHRA-PRADESH',
                    'city': 'KADAPA',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
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
            path: '/in-dia',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'IND-IA',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/in-dia/andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'IN-DIA/ANDHRA-PRADESH/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/cudd-apah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod small country & state',
                pathParameters: {
                  'country': 'india',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {
                    'country': 'india',
                    'state': 'andhra-pradesh',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/INDIA/ANDHRA-PRADESH/CUDDAP-AH/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod capital country & state',
                pathParameters: {
                  'country': 'INDIA',
                  'state': 'ANDHRA-PRADESH',
                },
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {
                    'country': 'INDIA',
                    'state': 'ANDHRA-PRADESH',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
          ),
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
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/KADAPA',
          ),
          kEmptyResult,
        );
      });
    }
  });

  group('Combine Router Parametric RegExp Routes test', () {
    final sambaRouter = SambaRouter<String>();
    final otherSambaRouter = SambaRouter<String>();

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
        );

      otherSambaRouter
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

    sambaRouter.combineWith(otherSambaRouter);

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod small country & state',
                pathParameters: {
                  'country': 'india',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod capital country & state',
                pathParameters: {
                  'country': 'INDIA',
                  'state': 'ANDHRA-PRADESH',
                },
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod small country & state',
                pathParameters: {
                  'country': 'india',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethod small country, state & city',
                  pathParameters: {
                    'country': 'india',
                    'state': 'andhra-pradesh',
                    'city': 'kadapa',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/INDIA/ANDHRA-PRADESH/KADAPA/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod capital country & state',
                pathParameters: {
                  'country': 'INDIA',
                  'state': 'ANDHRA-PRADESH',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethod capital country, state & city',
                  pathParameters: {
                    'country': 'INDIA',
                    'state': 'ANDHRA-PRADESH',
                    'city': 'KADAPA',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
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
            path: '/in-dia',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'IND-IA',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/in-dia/andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'IN-DIA/ANDHRA-PRADESH/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/cudd-apah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod small country',
              pathParameters: {
                'country': 'india',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod small country & state',
                pathParameters: {
                  'country': 'india',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {
                    'country': 'india',
                    'state': 'andhra-pradesh',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/INDIA/ANDHRA-PRADESH/CUDDAP-AH/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethod capital country',
              pathParameters: {
                'country': 'INDIA',
              },
              queryParameters: {},
              child: Result(
                value: '$httpMethod capital country & state',
                pathParameters: {
                  'country': 'INDIA',
                  'state': 'ANDHRA-PRADESH',
                },
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {
                    'country': 'INDIA',
                    'state': 'ANDHRA-PRADESH',
                  },
                  queryParameters: {},
                  child: null,
                ),
              ),
            ),
          ),
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
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/KADAPA',
          ),
          kEmptyResult,
        );
      });
    }
  });
}
