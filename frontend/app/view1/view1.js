'use strict';

angular.module('myApp.view1', ['ngRoute', 'ui.bootstrap', 'restangular'])
  .controller('View1Ctrl', function ($scope, Restangular) {
    var baseUsers = Restangular.all('users');
    $scope.foo = 'bar';
    baseUsers.getList().then(function (users) {
      $scope.allUsers = users;
    });

  }).config(['$routeProvider', function ($routeProvider) {
  $routeProvider.when('/view1', {
    templateUrl: 'view1/view1.html',
    controller: 'View1Ctrl'
  });
}]);