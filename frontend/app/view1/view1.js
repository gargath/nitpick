'use strict';

angular.module('myApp.view1', ['ngRoute', 'ui.bootstrap', 'restangular'])
  .controller('View1Ctrl', ['$scope', '$http', '$q', 'Restangular', 'loginModal', function ($scope, $http, $q, Restangular, loginModal) {
    var baseUsers = Restangular.all('users');
    baseUsers.getList().then(function (users) {
      $scope.allUsers = users;
    });
  }]).config(['$routeProvider', function ($routeProvider) {
  $routeProvider.when('/view1', {
    templateUrl: 'view1/view1.html',
    controller: 'View1Ctrl'
  });
}]);