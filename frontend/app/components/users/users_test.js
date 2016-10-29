'use strict';

describe('myApp.users module', function () {
  var usersService, httpBackend, Restangular;

  var allUsers = [{firstname: "Piter", lastname: "Raccoon"}];


  beforeEach(module('restangular'));
  beforeEach(module('myApp.users'));

  beforeEach(inject(function (_usersService_) {
    usersService = _usersService_;
  }));

  beforeEach(inject(function (_$httpBackend_) {
    httpBackend = _$httpBackend_;
  }));


  beforeEach(inject(function (_Restangular_) {
    Restangular = _Restangular_;
  }));

  describe('usersService', function () {
    it('should be defined', function () {
      expect(usersService).toBeDefined();
    });
    describe('getUsers', function () {
      it('should be defined', function () {
        expect(usersService.getUsers).toBeDefined();
      });
      it('should return a promise', function () {
        httpBackend.expectGET('/users').respond(allUsers);
        var promise = usersService.getUsers();
        expect(promise.then).toBeDefined();
        httpBackend.flush();
      });
      it('which returns the user list', function () {
        httpBackend.expectGET('/users').respond(allUsers);
        usersService.getUsers().then(function (data) {
          expect(Restangular.stripRestangular(data)).toEqual(allUsers);
        });
        httpBackend.flush();
      });
    });
    describe('newUser', function () {
      it('should be defined', function () {
        expect(usersService.newUser).toBeDefined();
      });
      it('should return a promise', function () {
        httpBackend.expectPOST('/users').respond(function () {
          return [201, "User created", {Location: "/users/123"}];
        });
        var promise = usersService.newUser({name: "Someone", email: "mail@example.com", password: "1234invalid"});
        expect(promise.then).toBeDefined();
        promise.then(function (data) {
          expect(data).toEqual("User created");
        });
        httpBackend.flush();
      });
    });
  });
});