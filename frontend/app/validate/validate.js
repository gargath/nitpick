'use strict';

angular.module('myApp.validate', ['ngRoute', 'restangular'])
  .controller('ValidateCtrl', ['$scope', '$http', 'Restangular', '$routeParams', function ($scope, $http, Restangular, $routeParams) {
    var $ctrl = this;
    $ctrl.validated = false;
    $ctrl.autosubmit = angular.isDefined($routeParams.token);

    $ctrl.submit = function submit() {
      $ctrl.submitted = true;
      console.log("Look here is the scope");
      console.log($scope);
      $http.put('/api/users/v1/1/validationtoken', {validation_token: $ctrl.token}).then(function () {
        console.log("Validation accepted.");
        $ctrl.validated = true;
      }, function (response) {
        console.log("Validation rejected:");
        console.log(response);
        $ctrl.validated = false;
      });
    };

    if (angular.isDefined($routeParams.token)) {
      $ctrl.token = $routeParams.token;
      $ctrl.submit();
    }
  }]);