/**
 * @ngdoc service
 * @name userResource
 * @description
 * Service to get the current user
 *
 */
(function() {
  'use strict';

  angular
    .module('frontend')
    .factory('userResource', resourceFunc);

  /** @ngInject */
  function resourceFunc($log, $resource, baseURL) {
    var path = baseURL + 'users/me';

    var service = {
      path: path,
      getUser: getUser
    };

    return service;

    function getUser() {
      return $resource(path, null);
    }
  }
})();
