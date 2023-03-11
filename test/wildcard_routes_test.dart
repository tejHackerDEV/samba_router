import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

import 'utils/constants.dart';

void main() {
  group('Wildcard Routes test', () {
    final sambaRouter = SambaRouter<String>();

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
        )
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

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/telangana',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard state',
                pathParameters: {'*': 'telangana'},
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/2424',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard state',
                pathParameters: {'*': '2424'},
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {},
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName wildcard city',
                  pathParameters: {'*': 'cuddapah'},
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
            path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {},
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {},
                  queryParameters: {},
                  child: Result(
                    value: '$httpMethodName wildcard street',
                    pathParameters: {
                      '*': 'bhagya-nagar-colony',
                    },
                    queryParameters: {},
                    child: null,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/ngo-colony',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {},
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {},
                  queryParameters: {},
                  child: Result(
                    value: '$httpMethodName wildcard street',
                    pathParameters: {
                      '*': 'ngo-colony',
                    },
                    queryParameters: {},
                    child: null,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard fruit',
                pathParameters: {
                  '*': 'apple',
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
            path: '/fruits/apple/1234',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard fruit',
                pathParameters: {
                  '*': 'apple/1234',
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
            path: '/random',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName wildcard',
              pathParameters: {
                '*': 'random',
              },
              queryParameters: {},
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
            path: '/fruits',
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
            path: '/india/andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
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
          ),
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
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
            path: '/india/telangana',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/2424',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          kEmptyResult,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/ngo-colony',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple/1234',
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
            path: '/random',
          ),
          kEmptyResult,
        );
      });
    }
  });

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
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/telangana',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard state',
                pathParameters: {'*': 'telangana'},
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/2424',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard state',
                pathParameters: {'*': '2424'},
                queryParameters: {},
                child: null,
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {},
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName wildcard city',
                  pathParameters: {'*': 'cuddapah'},
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
            path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony/',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {},
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {},
                  queryParameters: {},
                  child: Result(
                    value: '$httpMethodName wildcard street',
                    pathParameters: {
                      '*': 'bhagya-nagar-colony',
                    },
                    queryParameters: {},
                    child: null,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/ngo-colony',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {},
                queryParameters: {},
                child: Result(
                  value: null,
                  pathParameters: {},
                  queryParameters: {},
                  child: Result(
                    value: '$httpMethodName wildcard street',
                    pathParameters: {
                      '*': 'ngo-colony',
                    },
                    queryParameters: {},
                    child: null,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard fruit',
                pathParameters: {
                  '*': 'apple',
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
            path: '/fruits/apple/1234',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName wildcard fruit',
                pathParameters: {
                  '*': 'apple/1234',
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
            path: '/random',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName wildcard',
              pathParameters: {
                '*': 'random',
              },
              queryParameters: {},
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
            path: '/fruits',
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
            path: '/india/andhra-pradesh',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
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
          ),
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: null,
              pathParameters: {},
              queryParameters: {},
              child: Result(
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
            path: '/india/telangana',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/2424',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          kEmptyResult,
        );
        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/ngo-colony',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple/1234',
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
            path: '/random',
          ),
          kEmptyResult,
        );
      });
    }
  });
}
