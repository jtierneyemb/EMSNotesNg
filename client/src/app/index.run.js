(function () {
  'use strict';

  angular
    .module('frontend')
    .run(runBlock);

  /** @ngInject */
  function runBlock($rootScope, $state, $http, $log, AuthenticationService) {
    // keep user logged in after page refresh
    AuthenticationService.loadCredentials();

    var deregister = $rootScope
      .$on('$stateChangeStart',
        function (event, toState, toParams, fromState /*, fromParams*/) {
          var restrictedPage = ['login', 'register', 'home'].indexOf(toState.name) === -1;
          if (restrictedPage && AuthenticationService.validatingCredentials) {
            event.preventDefault();
            return $state.go('home');
          }
          var loggedIn = $rootScope.currentUser;
          if (restrictedPage && !loggedIn) {
            event.preventDefault();
            if (['login', 'register'].indexOf(fromState.name) === -1)
              return $state.go('login');
          }
        });
    $rootScope.$on('$destroy', deregister)
  }

})();
