(function () {
  'use strict';

  angular
    .module('frontend')
    .run(runBlock);
  
  /** @ngInject */
  function runBlock($rootScope, $state, $cookieStore, $http, $log, AuthenticationService) {
    // keep user logged in after page refresh
    AuthenticationService.loadCredentials();

    $rootScope
      .$on('$stateChangeStart',
        function (event, toState, toParams, fromState, fromParams) {
          $log.info('$stateChangeStart');
          // redirect to auth page if not logged in and trying to access a restricted page
          // var restrictedPage = $.inArray($location.path(), ['/auth', '/register']) === -1;
          var restrictedPage = ['login', 'register', 'home'].indexOf(toState.name) === -1;
          var loggedIn = $rootScope.globals.currentUser;
          if (restrictedPage && !loggedIn) {
            event.preventDefault();
            if (['login', 'register'].indexOf(fromState.name) === -1)
              return $state.go('login');
          }
        });
  }

})();
