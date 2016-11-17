/**
 * @ngdoc service
 * @name validateCredentials
 * @description
 * Service to login a user
 *
 */
(function () {
  'use strict';

  angular
    .module('frontend')
    .factory('validateCredentials', factory);

  /** @ngInject */
  function factory($http, $log, userResource, $q) {
    return validate;

    /**
     * @ngdoc function
     * @name validate
     * @methodOf frontend.validateCredentials
     * @description
     * Make a REST API request passing token
     * @param {Object} currentUser
     * username and token
     * @returns {Object} a promise
     * * The promise is resolved with a valid username and token
     * * The promise is rejected if the token is not valid
     */
    function validate(currentUser) {
      var deferred = $q.defer();
      if (currentUser) {
        $http.defaults.headers.common['X-Embarcadero-Session-Token'] = currentUser.token;
        // Credentials are valid when token identifies a user
        userResource.getUser().get(
          function (response) {
            deferred.resolve({
              username: response.username,
              token: currentUser.token
            });
          },
          function (response) {
            $log.error('validateCredentials getUser() ' + response.status);
            deferred.reject();
          });
      } else
        deferred.reject();
      return deferred.promise;
    }
  }
})();
