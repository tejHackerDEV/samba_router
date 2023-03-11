import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

import 'utils/constants.dart';

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
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: null,
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '?language=telugu&religion=hindu&religion=muslim',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            child: null,
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName fruits',
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName india',
                pathParameters: {},
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic country',
                pathParameters: {
                  'country': 'pakistan',
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
            path: '/countries/2424',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
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
            path: '/countries/2424/states',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic number country & state',
                  pathParameters: {
                    'country': '2424',
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
            path: '/countries/bangladesh/random',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic country',
                pathParameters: {
                  'country': 'bangladesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic wildcard state',
                  pathParameters: {
                    'country': 'bangladesh',
                    '*': 'random',
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
            path: '/random/2424/random',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName wildcard',
              pathParameters: {
                '*': 'random/2424/random',
              },
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/random/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            child: Result(
              value: '$httpMethodName wildcard',
              pathParameters: {
                '*': 'random/2424/random',
              },
              queryParameters: {
                'language': 'telugu',
                'religion': ['hindu', 'muslim'],
              },
              child: null,
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
            path: '/countries',
          ),
          Result(
            value: '$httpMethodName root',
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
            path: '/countries/2424/random',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
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
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {
                'language': 'telugu',
                'religion': ['hindu', 'muslim'],
              },
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
                },
                queryParameters: {
                  'language': 'telugu',
                  'religion': ['hindu', 'muslim'],
                },
                child: null,
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
            path: '/',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/bangladesh/random',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          kEmptyResult,
        );
      });
    }
  });

  group('Combine Router Combined Routes test', () {
    final sambaRouter = SambaRouter<String>();
    final otherSambaRouter = SambaRouter<String>();
    final oneMoreSambaRouter = SambaRouter<String>();

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
        );

      otherSambaRouter
        ..put(
          method: httpMethod,
          path: '/countries/{country}/*',
          value: '$httpMethodName dynamic wildcard state',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country:\\d+\$}',
          value: '$httpMethodName dynamic number country',
        );

      oneMoreSambaRouter.put(
        method: httpMethod,
        path: '/states',
        value: '$httpMethodName dynamic number country & state',
      );
    }

    otherSambaRouter.combineWith(
      oneMoreSambaRouter,
      prefixPath: '/countries/{country:\\d+\$}',
    );
    sambaRouter.combineWith(
      otherSambaRouter,
    );

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: null,
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '?language=telugu&religion=hindu&religion=muslim',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            child: null,
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName fruits',
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName india',
                pathParameters: {},
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic country',
                pathParameters: {
                  'country': 'pakistan',
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
            path: '/countries/2424',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
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
            path: '/countries/2424/states',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic number country & state',
                  pathParameters: {
                    'country': '2424',
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
            path: '/countries/bangladesh/random',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic country',
                pathParameters: {
                  'country': 'bangladesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic wildcard state',
                  pathParameters: {
                    'country': 'bangladesh',
                    '*': 'random',
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
            path: '/random/2424/random',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName wildcard',
              pathParameters: {
                '*': 'random/2424/random',
              },
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/random/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            child: Result(
              value: '$httpMethodName wildcard',
              pathParameters: {
                '*': 'random/2424/random',
              },
              queryParameters: {
                'language': 'telugu',
                'religion': ['hindu', 'muslim'],
              },
              child: null,
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
            path: '/countries',
          ),
          Result(
            value: '$httpMethodName root',
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
            path: '/countries/2424/random',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
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
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'language': 'telugu',
              'religion': ['hindu', 'muslim'],
            },
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {
                'language': 'telugu',
                'religion': ['hindu', 'muslim'],
              },
              child: Result(
                value: '$httpMethodName dynamic number country',
                pathParameters: {
                  'country': '2424',
                },
                queryParameters: {
                  'language': 'telugu',
                  'religion': ['hindu', 'muslim'],
                },
                child: null,
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
            path: '/',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries/bangladesh/random',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          kEmptyResult,
        );
      });
    }
  });
}
