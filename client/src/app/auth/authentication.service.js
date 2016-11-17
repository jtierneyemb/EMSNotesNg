(function () {
  'use strict';

  angular
    .module('frontend')
    .service('AuthenticationService', AuthenticationService);

  /** @ngInject */
  function AuthenticationService($http, $localStorage, validateCredentials, $rootScope, $log) {
    var service = this;

    // service.Login = Login;
    service.setCredentials = setCredentials;
    service.clearCredentials = clearCredentials;
    service.loadCredentials = loadCredentials;
    service.subscribeChanged = subscribeChanged;
    service.validatingCredentials = false;
    service.loggedIn = false;
    service.userName = "";

    function setCredentials(username, token) {

      var currentUser = {
        username: username,
        token: token
      };
      $rootScope.currentUser = currentUser;

      $http.defaults.headers.common['X-Embarcadero-Session-Token'] = token; // jshint ignore:line
      // $cookieStore.put('globals', $rootScope.globals);
      // $localStorage.currentUser = angular.copy(currentUser);
      $localStorage.lastUser = currentUser;
      //$localStorage.$save();
      changed();
    }

    function clearCredentials() {
      clearData();
      changed();
    }

    function clearData() {
      $rootScope.currentUser = null;
      // $cookieStore.remove('globals');
      delete $localStorage.lastUser;
      delete $http.defaults.headers.common['X-Embarcadero-Session-Token'];
    }

    function loadCredentials() {
      var currentUser = $localStorage.lastUser;
      $rootScope.currentUser = currentUser;
      if (currentUser) {
        service.validatingCredentials = true;
        validateCredentials($rootScope.currentUser).then(
          function (credentials) {
            $rootScope.currentUser = credentials;
            $localStorage.lastUser = credentials;
            changed();
            service.validatingCredentials = false;
          },
          function () {
            clearData();
            changed()
            service.validatingCredentials = false;
          }
        );
      }
      else
        changed();

    }

    var EVENT_NAME = 'auth-service:change';
    function subscribeChanged(scope, callback) {
      var handler = $rootScope.$on(EVENT_NAME, callback);
      scope.$on('$destroy', handler);
    }

    function changed() {
      service.loggedIn = $rootScope.currentUser;
      if (service.loggedIn) {
        service.userName = $rootScope.currentUser.username;
      }
      else
        service.userName = "";

      $rootScope.$emit(EVENT_NAME);
    }

  }

})();
