import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

import 'utils/constants.dart';

void main() {
  group('Static Routes test', () {
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
            path: '/countries',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
              value: '$httpMethodName countries',
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
            path: '/countries/pakistan/',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName pakistan',
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
            path: '/states',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName states',
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/states/andhra-pradesh',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName states',
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName andhra-pradesh',
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
            path: '/fruits/apple',
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
                value: '$httpMethodName apple',
                pathParameters: {},
                queryParameters: {},
                child: null,
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
            path: '/random',
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
            path: '/countries/in/dia',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
            path: '/countries/pak/stan',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
            path: '/countries/bangladesh',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
            path: '/states/telangana',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName states',
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
            path: '/fruits',
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
            path: '/fru-its',
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
            path: '/fruits/app/le',
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
            path: '/fru/its/pineapple',
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
            path: '/fru/its/ban/ana',
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
            path: '/fruits/straw-berry',
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
                value: null,
                pathParameters: {},
                queryParameters: {},
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
            path: '/countries',
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
            path: '/states',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/states/andhra-pradesh',
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
      });
    }
  });

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
            path: '/countries',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
              value: '$httpMethodName countries',
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
            path: '/countries/pakistan/',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName pakistan',
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
            path: '/states',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName states',
              pathParameters: {},
              queryParameters: {},
              child: null,
            ),
          ),
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/states/andhra-pradesh',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName states',
              pathParameters: {},
              queryParameters: {},
              child: Result(
                value: '$httpMethodName andhra-pradesh',
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
            path: '/fruits/apple',
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
                value: '$httpMethodName apple',
                pathParameters: {},
                queryParameters: {},
                child: null,
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
            path: '/random',
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
            path: '/countries/in/dia',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
            path: '/countries/pak/stan',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
            path: '/countries/bangladesh',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName countries',
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
            path: '/states/telangana',
          ),
          Result(
            value: '$httpMethodName root',
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName states',
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
            path: '/fruits',
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
            path: '/fru-its',
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
            path: '/fruits/app/le',
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
            path: '/fru/its/pineapple',
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
            path: '/fru/its/ban/ana',
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
            path: '/fruits/straw-berry',
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
                value: null,
                pathParameters: {},
                queryParameters: {},
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
            path: '/countries',
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
            path: '/states',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/states/andhra-pradesh',
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
      });
    }
  });
}
