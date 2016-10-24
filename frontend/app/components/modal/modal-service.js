'use strict';

angular.module('myApp.modal.modal-service', ['ui.bootstrap'])
  .service("modalService", ['$uibModal', function ($uibModal) {
    this.open = function (ctrl, templateUrl) {
      return $uibModal.open(
        {
          animation: true,
          ariaLabelledBy: 'modal-title',
          ariaDescribedBy: 'modal-body',
          templateUrl: templateUrl,
          controller: ctrl,
          controllerAs: '$ctrl'
        }
      )
    }
  }]);