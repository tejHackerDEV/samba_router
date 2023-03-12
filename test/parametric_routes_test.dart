import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/samba_router.dart';
import 'package:test/test.dart';

import 'utils/constants.dart';

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
                value: '$httpMethodName dynamic state',
                pathParameters: {
                  'state': 'telangana',
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
                  value: '$httpMethodName dynamic city',
                  pathParameters: {
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
            path: '/india/telangana/hyderabad',
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
                value: '$httpMethodName dynamic state',
                pathParameters: {
                  'state': 'telangana',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic state & city',
                  pathParameters: {
                    'state': 'telangana',
                    'city': 'hyderabad',
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
            path: '/pakistan/punjab/lahore',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'pakistan',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'pakistan',
                  'state': 'punjab',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'pakistan',
                    'state': 'punjab',
                    'city': 'lahore',
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
            path: '/india',
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
            path: '/countries/andhra-pradesh/kadapa/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'andhra-pradesh',
                    'city': 'kadapa',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'andhra-pradesh',
                      'city': 'kadapa',
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
            path: '/countries/andhra-pradesh/cuddapah/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'andhra-pradesh',
                    'city': 'cuddapah',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'andhra-pradesh',
                      'city': 'cuddapah',
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
            path: '/countries/states/kadapa/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'kadapa',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'kadapa',
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
            path: '/countries/states/cuddapah/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'cuddapah',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'cuddapah',
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
            path: '/countries/states/city/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'city',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'city',
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
            path: '/countries/states/city/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'city',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'city',
                    },
                    queryParameters: {},
                    child: null,
                  ),
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
            path: '/india',
          ),
          kEmptyResult,
        );

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
            path: '/india/andhra-pradesh/kadapa',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/telangana/hyderabad',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/pakistan/punjab/lahore',
          ),
          kEmptyResult,
        );
      });
    }
  });

  group('Combine Router Parametric Routes test', () {
    final sambaRouter = SambaRouter<String>();
    final otherSambaRouter = SambaRouter<String>();

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
          path: '/india/andhra-pradesh/{city}/',
          value: '$httpMethodName dynamic city',
        )
        ..put(
          method: httpMethod,
          path: '/india/{state}/{city}',
          value: '$httpMethodName dynamic state & city',
        );

      otherSambaRouter
        ..put(
          method: httpMethod,
          path: '/india/{state}',
          value: '$httpMethodName dynamic state',
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
                value: '$httpMethodName dynamic state',
                pathParameters: {
                  'state': 'telangana',
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
                  value: '$httpMethodName dynamic city',
                  pathParameters: {
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
            path: '/india/telangana/hyderabad',
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
                value: '$httpMethodName dynamic state',
                pathParameters: {
                  'state': 'telangana',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic state & city',
                  pathParameters: {
                    'state': 'telangana',
                    'city': 'hyderabad',
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
            path: '/pakistan/punjab/lahore',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'pakistan',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'pakistan',
                  'state': 'punjab',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'pakistan',
                    'state': 'punjab',
                    'city': 'lahore',
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

    sambaRouter.combineWith(otherSambaRouter);

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
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
            path: '/countries/andhra-pradesh/kadapa/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'andhra-pradesh',
                    'city': 'kadapa',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'andhra-pradesh',
                      'city': 'kadapa',
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
            path: '/countries/andhra-pradesh/cuddapah/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'andhra-pradesh',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'andhra-pradesh',
                    'city': 'cuddapah',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'andhra-pradesh',
                      'city': 'cuddapah',
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
            path: '/countries/states/kadapa/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'kadapa',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'kadapa',
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
            path: '/countries/states/cuddapah/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'cuddapah',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'cuddapah',
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
            path: '/countries/states/city/cuddapah',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'city',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'city',
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
            path: '/countries/states/city/kadapa',
          ),
          Result(
            value: null,
            pathParameters: {},
            queryParameters: {},
            child: Result(
              value: '$httpMethodName dynamic country',
              pathParameters: {
                'country': 'countries',
              },
              queryParameters: {},
              child: Result(
                value: null,
                pathParameters: {
                  'country': 'countries',
                  'state': 'states',
                },
                queryParameters: {},
                child: Result(
                  value: '$httpMethodName dynamic country, state & city',
                  pathParameters: {
                    'country': 'countries',
                    'state': 'states',
                    'city': 'city',
                  },
                  queryParameters: {},
                  child: Result(
                    value: null,
                    pathParameters: {
                      'country': 'countries',
                      'state': 'states',
                      'city': 'city',
                    },
                    queryParameters: {},
                    child: null,
                  ),
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
            path: '/india',
          ),
          kEmptyResult,
        );

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
            path: '/india/andhra-pradesh/kadapa',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/india/telangana/hyderabad',
          ),
          kEmptyResult,
        );

        expect(
          sambaRouter.lookup(
            method: httpMethod,
            path: '/pakistan/punjab/lahore',
          ),
          kEmptyResult,
        );
      });
    }
  });
}
