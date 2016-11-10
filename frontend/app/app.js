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
]).config(['$locationProvider', '$routeProvider', 'RestangularProvider', 'jwtOptionsProvider', '$httpProvider', function ($locationProvider, $routeProvider, RestangularProvider, jwtOptionsProvider, $httpProvider) {
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

  jwtOptionsProvider.config({
    tokenGetter: function () {
      return localStorage.getItem('id_token');
    }
  });

  $httpProvider.interceptors.push('jwtInterceptor');
}]).run(['authManager', function (authManager) {
  authManager.checkAuthOnRefresh();
}])
