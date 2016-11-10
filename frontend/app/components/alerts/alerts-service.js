'use strict';
angular.module('myApp.alerts.alerts-service', [])
  .service("alertsService", function () {
    var alerts = [];

    this.getAlerts = function () {
      return alerts;
    };

    this.addAlert = function (type, msg) {
      alerts.push({type: type, msg: msg});
    };

    this.closeAlert = function (index) {
      alerts.splice(index, 1);
    };
  });