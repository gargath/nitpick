'use strict';

angular.module('myApp.view1', ['myApp.modal', 'ngRoute', 'ui.bootstrap', 'restangular'])
  .controller('View1Ctrl', ['$scope', '$http', '$q', 'Restangular', 'modalService', function ($scope, $http, $q, Restangular, modalService) {
    var $ctrl = this;

    $ctrl.signupModal = function () {
      var modalInstance = modalService.open('signupCtrl', 'view1/signupModal.html');
      modalInstance.result.then(function (data) {
          // User submitted data will be available in data.name and data.email
        }, function () {
          // Modal dismissed without submit
        }
      );
    };

    var baseUsers = Restangular.all('users');
    baseUsers.getList().then(function (users) {
      $scope.allUsers = users;
    });
  }]).config(['$routeProvider', function ($routeProvider) {
  $routeProvider.when('/view1', {
    templateUrl: 'view1/view1.html',
    controller: 'View1Ctrl'
  });
}]).controller('signupCtrl', ['$scope', function ($scope) {
  var $ctrl = this;
  $ctrl.cancel = function () {
    $scope.$dismiss('user canceled');
  };
  $ctrl.ok = function () {
    $scope.$close({name: $scope.yourname, email: $scope.email});
  }
}]);