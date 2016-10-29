'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'ngAnimate',
  'ngSanitize',
  'myApp.view1',
  'myApp.view2',
  'myApp.version',
  'myApp.modal',
  'myApp.users',
  'ui.bootstrap',
  'restangular'
]).config(['$locationProvider', '$routeProvider', 'RestangularProvider', function ($locationProvider, $routeProvider, RestangularProvider) {
  $locationProvider.hashPrefix('!');

  $routeProvider.otherwise({redirectTo: '/view1'});

  RestangularProvider.setBaseUrl('/api/v1');

  var refreshAccessToken = function () {
    var deferred = $q.defer();

    deferred.reject("Unauthorized!");
    return deferred.promise;
  };

  RestangularProvider.setErrorInterceptor(function (response, deferred, responseHandler) {
    if (response.status === 404) {
      refreshAccessToken().then(function () {
        $http(response.config).then(responseHandler, deferred.reject);
      });

      return false; // error handled
    }

    return true; // error not handled
  });
}]);
