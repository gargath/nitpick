'use strict';

angular.module('myApp.view1', ['ngRoute', 'ui.bootstrap', 'restangular'])
  .controller('View1Ctrl', function ($scope, Restangular) {
    Restangular.setBaseUrl('http://nitpick-6828.herokuapp.com/api/v1');

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