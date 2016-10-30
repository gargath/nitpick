'use strict';

angular.module('myApp.view1', ['myApp.modal', 'ngRoute', 'ui.bootstrap', 'restangular', 'myApp.alerts'])
  .controller('View1Ctrl', ['$scope', '$http', '$q', 'Restangular', 'modalService', 'alertsService', function ($scope, $http, $q, Restangular, modalService, alertsService) {
    var $ctrl = this;
    $ctrl.alerts = alertsService;

    var baseUsers = Restangular.all('users');
    $ctrl.signupModal = function () {
      var modalInstance = modalService.open('signupCtrl', 'view1/signupModal.html');
      modalInstance.result.then(function (data) {
          // User submitted data will be available in data.name and data.email
          baseUsers.post({name: data.name, email: data.email, password: data.password}).then(function () {
            console.log("New account created");
          }, function () {
            alertsService.addAlert("danger", "Sign-up failed. Please try again.");
            console.log("Error in creating user: " + data);
          });
        }, function () {
          // Modal dismissed without submit
        }
      );
    };
    baseUsers.getList().then(function (users) {
      $scope.allUsers = users;
    });
  }]).controller('signupCtrl', ['$scope', function ($scope) {
  var $ctrl = this;
  $ctrl.cancel = function () {
    $scope.$dismiss('user canceled');
  };
  $ctrl.ok = function () {
    $scope.$close({name: $scope.yourname, email: $scope.email, password: $scope.password});
  }
}]);