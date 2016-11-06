'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'ngAnimate',
  'ngSanitize',
  'myApp.view1',
  'myApp.view2',
  'myApp.validate',
  'myApp.version',
  'myApp.modal',
  'myApp.users',
  'myApp.alerts',
  'ui.bootstrap',
  'restangular'
]).config(['$locationProvider', '$routeProvider', 'RestangularProvider', function ($locationProvider, $routeProvider, RestangularProvider) {
  $locationProvider.hashPrefix('!');

  $routeProvider
    .when('/view1', {
      templateUrl: 'view1/view1.html',
      controller: 'View1Ctrl',
      controllerAs: '$ctrl'
    })
    .when('/validate', {
      templateUrl: 'validate/validate.html',
      controller: 'ValidateCtrl',
      controllerAs: '$ctrl'
    }).otherwise({redirectTo: '/view1'});

  RestangularProvider.setBaseUrl('/api');
}]);
