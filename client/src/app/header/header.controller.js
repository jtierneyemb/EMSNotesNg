/**
 * @ngdoc controller
 * @name HeaderController
 * @description
 * Manage data required by nav bar
 *
 */
(function() {
  'use strict';

  angular
    .module('frontend')
    .controller('HeaderController', Controller);

  /** @ngInject */
  function Controller(AuthenticationService, $scope, $state) {
    var vm = this;
    vm.isCollapsed = true;
    
    vm.loggedIn = false;
    vm.userName = "";
    vm.loggingIn = loggingIn;
    
    activate();

    function activate() {
      AuthenticationService.subscribeChanged($scope, changed);
      vm.loggedIn = AuthenticationService.loggedIn;
      vm.userName = AuthenticationService.userName;
    }

    function changed() {
      vm.loggedIn = AuthenticationService.loggedIn;
      vm.userName = AuthenticationService.userName;
    }
    
    function loggingIn() {
      return  (['login', 'register'].indexOf($state.current.name) >= 0)
    }
    
  }
})();
