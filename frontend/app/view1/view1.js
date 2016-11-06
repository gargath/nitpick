'use strict';

angular.module('myApp.view1', ['myApp.modal', 'ngRoute', 'ui.bootstrap', 'restangular', 'myApp.alerts'])
  .controller('View1Ctrl', ['$scope', '$http', '$q', 'Restangular', 'modalService', 'alertsService', function ($scope, $http, $q, Restangular, modalService, alertsService) {
    var $ctrl = this;
    $ctrl.alerts = alertsService;

    var baseUsers = Restangular.all('users/v1');

    this.login = function (data) {
      $http.post('/api/auth/v1/login', {username: data.name, password: data.password})
        .then(function (response) {
          console.log("Login successful");
          console.log("The JWT is " + response.data.authtoken);
        }, function (response) {
          alertsService.addAlert("danger", "Login failed!");
          console.log("Error during login: " + response.data.error);
        });
    };

    this.signUp = function (data) {
      // User submitted data will be available in data.name, etc
      baseUsers.post({user: {username: data.name, email: data.email, password: data.password}}).then(function () {
        console.log("New account created");
      }, function (data) {
        alertsService.addAlert("danger", "Sign-up failed. Please try again.");
        console.log("Error in creating user:");
        console.log(data);
      });
    };

    $ctrl.signupModal = function () {
      var modalInstance = modalService.open('signupCtrl', 'view1/signupModal.html');
      modalInstance.result.then($ctrl.signUp, function () {
          // Modal dismissed without submit
        }
      );
    };

    $ctrl.loginModal = function () {
      var modalInstance = modalService.open('signupCtrl', 'view1/loginModal.html');
      modalInstance.result.then($ctrl.login,
        function () {
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