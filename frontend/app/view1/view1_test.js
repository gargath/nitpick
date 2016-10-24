'use strict';

describe('myApp.view1 module', function () {
  beforeEach(module('myApp'));
  beforeEach(module('myApp.view1'));
  beforeEach(module('restangular'));
  var $rootScope, $httpBackend, Restangular, View1Ctrl, createController;
  var allUsers = [{firstname: "Piter", lastname: "Raccoon"}];

  beforeEach(inject(function ($injector) {
    var $controller = $injector.get('$controller');
    $rootScope = $injector.get('$rootScope');
    Restangular = $injector.get('Restangular');
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.when('GET', '/api/v1/users')
      .respond(
        allUsers
      );

    createController = function () {
      return $controller('View1Ctrl', {'$scope': $rootScope, 'Restangular': Restangular});
    };
  }));

  afterEach(inject(function ($httpBackend, $rootScope) {
    // Check that we don't have anything else hanging.
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  }));

  it('should have users', function () {
    var View1Ctrl = createController();
    expect(View1Ctrl).toBeDefined();

    $httpBackend.flush();
    expect(Restangular.stripRestangular($rootScope.allUsers)).toEqual(allUsers);
  });

  it('should op')

});