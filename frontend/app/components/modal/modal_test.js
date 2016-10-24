'use strict';

describe('myApp.modal module', function () {
  var modalService;

  beforeEach(module('myApp.modal'));

  beforeEach(inject(function (_modalService_) {
    modalService = _modalService_;
  }));

  describe('modalService', function () {
    it('should be defined', function () {
      expect(modalService).toBeDefined();
    });
    it('should return a modal instance when invoked', function () {
      var instance = modalService.open('TestCtrl', 'FakeTemplate.html');
      expect(instance).toBeDefined();
    })
  });
});