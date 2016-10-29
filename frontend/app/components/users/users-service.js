'use strict';

angular.module('myApp.users.users-service', ['restangular'])
  .service("usersService", ['Restangular', function (Restangular) {
    var baseUsers = Restangular.all('users');

    // Each of these functions return a promise

    this.newUser = function (name, email, password) {
      return baseUsers.post({name: name, email: email, password: password});
    };

    this.getUsers = function () {
      return baseUsers.getList();
    }
  }]);