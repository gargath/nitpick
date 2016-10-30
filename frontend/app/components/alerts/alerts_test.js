'use strict';

describe('myApp.alerts module', function () {
  var alertsService;

  beforeEach(module('myApp.alerts'));

  beforeEach(inject(function (_alertsService_) {
    alertsService = _alertsService_;
  }));

  describe('alertsService', function () {
    it('should be defined', function () {
      expect(alertsService).toBeDefined();
    });
    it('should have zero alerts', function () {
      expect(alertsService.getAlerts()).toEqual([]);
    });
    it('after adding an alert, it should be there', function () {
      alertsService.addAlert('warning', 'warnings!');
      expect(alertsService.getAlerts()).toEqual([{type: 'warning', msg: 'warnings!'}]);
    });
    it('after removing an alert, it should be gone', function () {
      alertsService.addAlert('warning', 'first');
      alertsService.addAlert('warning', 'second');
      alertsService.closeAlert(0);
      expect(alertsService.getAlerts()).toEqual([{type: 'warning', msg: 'second'}]);
    })
  });
});