import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

import 'utils/constants.dart';

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
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {
              'country': 'india',
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': 'india',
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&state=andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {
              'country': 'india',
              'state': 'andhra-pradesh',
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': 'india',
                'state': 'andhra-pradesh',
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&country=pakistan',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {
              'country': ['india', 'pakistan'],
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': ['india', 'pakistan'],
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {
              'country': ['india', 'pakistan'],
              'state': 'andhra-pradesh',
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': ['india', 'pakistan'],
                'state': 'andhra-pradesh',
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {
              'country': ['india', 'pakistan'],
              'state': ['andhra-pradesh', 'telangana'],
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': ['india', 'pakistan'],
                'state': ['andhra-pradesh', 'telangana'],
              },
              child: null,
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
            path: '/countries?country=india',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&state=andhra-pradesh',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&country=pakistan',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
          ),
          kEmptyResult,
        );
      });
    }
  });

  group('Combine Router QueryParameters Routes test', () {
    final sambaRouter = SambaRouter<String>();
    final otherRouter = SambaRouter<String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      sambaRouter.put(
        method: httpMethod,
        path: '/countries',
        value: '$httpMethodName countries',
      );

      otherRouter.put(
        method: httpMethod,
        path: '/',
        value: '$httpMethodName root',
      );
    }

    sambaRouter.combineWith(otherRouter);

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'country': 'india',
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': 'india',
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&state=andhra-pradesh',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'country': 'india',
              'state': 'andhra-pradesh',
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': 'india',
                'state': 'andhra-pradesh',
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&country=pakistan',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'country': ['india', 'pakistan'],
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': ['india', 'pakistan'],
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'country': ['india', 'pakistan'],
              'state': 'andhra-pradesh',
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': ['india', 'pakistan'],
                'state': 'andhra-pradesh',
              },
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {
              'country': ['india', 'pakistan'],
              'state': ['andhra-pradesh', 'telangana'],
            },
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {
                'country': ['india', 'pakistan'],
                'state': ['andhra-pradesh', 'telangana'],
              },
              child: null,
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
            path: '/countries?country=india',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&state=andhra-pradesh',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&country=pakistan',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
          ),
          kEmptyResult,
        );
      });
    }
  });
}
