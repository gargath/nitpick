'use strict';

angular.module('myApp.validate', ['angular-jwt', 'ngRoute', 'restangular'])
  .controller('ValidateCtrl', ['$scope', '$http', 'Restangular', '$routeParams', 'jwtHelper', function ($scope, $http, Restangular, $routeParams, jwtHelper) {
    var $ctrl = this;
    $ctrl.validated = false;
    $ctrl.autosubmit = angular.isDefined($routeParams.token);

    $ctrl.submit = function submit() {
      $ctrl.submitted = true;

      var tokenPayload = jwtHelper.decodeToken($ctrl.token)
      $http.put('/api/users/v1/'+tokenPayload.user_id+'/validationtoken', {validation_token: $ctrl.token}).then(function () {
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