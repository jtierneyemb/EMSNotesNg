/**
 * @ngdoc factory
 * @name toastrHelper
 * @description
 * Common controller functionality shared controllers
 *
 */
(function () {
  'use strict';

  angular
    .module('frontend')
    .factory('toastrHelper', helperFunc);

  /** @ngInject */
  function helperFunc($log, toastr, feUtils) {
    var service = {
      activate: activateFunc
    };

    var vm = null;
    return service;

    function activateFunc(_vm_, _scope_) {
      vm = _vm_;
      vm.showToastrError = showToastrError;
      vm.lastToast = null;

      _scope_.$on('$destroy', function () {
        // Remove current toasts when switch views
        toastr.clear();
      });
    }
    
    function showToastrError(message, caption) {
      if (angular.isUndefined(caption))
        caption = 'Error';

      toastr.clear();
      vm.lastToast = toastr.error(feUtils.escapeHtml(message), caption);
    }


  }
})();




