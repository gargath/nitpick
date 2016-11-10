'use strict';

angular.module('myApp.users.users-service', ['restangular'])
  .service("usersService", ['Restangular', '$http', function (Restangular, $http) {
    var baseUsers = Restangular.all('users');

    // Each of these functions return a promise

    this.newUser = function (name, email, password) {
      return baseUsers.post({name: name, email: email, password: password});
    };

    this.getUsers = function () {
      return baseUsers.getList();
    };

    // Returns a promise
    this.validateUser = function (user) {
      return $http.put('/api/users/v1/'+user.id+'/validationtoken', {validation_token: user.token});
    };
  }]);