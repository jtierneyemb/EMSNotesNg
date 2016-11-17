/**
 * @ngdoc service
 * @name signupResource
 * @description
 * Service to signup a new user
 *
 */
(function() {
  'use strict';

  angular
    .module('frontend')
    .factory('signupResource', resourceFunc);

  /** @ngInject */
  function resourceFunc($log, $resource, baseURL) {
    var path = baseURL + 'users/signup';

    var service = {
      path: path,
      getSignup: getSignup
    };

    return service;

    function getSignup() {
      return $resource(path, null, {'signup': {method: 'POST', params: null}});
    }
  }
})();
