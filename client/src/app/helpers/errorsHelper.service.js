/**
 * @ngdoc factory
 * @name errorsHelper
 * @description
 * Common functionality shared by CRUD controllers
 *
 */
(function () {
  'use strict';

  angular
    .module('frontend')
    .factory('errorsHelper', helperFunc);

  /** @ngInject */
  function helperFunc($log, feUtils) {
    var service = {
      activate: activateFunc
    };

    var vm = null;
    var errorCategories = {};

    return service;

    function activateFunc(_vm_, _errorCategories_) {
      errorCategories = _errorCategories_;

      // Initialize controller
      vm = _vm_;
      vm.errorsOfResponse = errorsOfResponse;
    }
    
     function errorsOfResponse(response) {
      var result;
      if (angular.isObject(response.data))
        result = categorizeErrors(response.data);
      else
        result = categorizeErrors({'other': response.statusText});
      return result;
    }

    function categorizeErrors(data) {
      var errors = feUtils.categorizeProperties(data, errorCategories);
      return errors;
    }
  }
})();




