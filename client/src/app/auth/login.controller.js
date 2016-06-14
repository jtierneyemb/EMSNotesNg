(function () {
  'use strict';

  angular
    .module('frontend')
    .controller('LoginController', LoginController);

  /** @ngInject */
  function LoginController($state, $location, loginResource, AuthenticationService, errorsHelper, waitIndicator, $log) {
    var vm = this;

    vm.entity = {username: "", password: ""};
    vm.errors = {};
    vm.submit = submit;
    vm.loginForm = null;

    activate();

    function activate() {
      // reset auth status
      AuthenticationService.ClearCredentials();
      errorsHelper.activate(vm,
        {
          'username': null,
          'password': null
        });
    }

    function submit() {
      updateEntity(vm.entity);
    }

    function updateEntity(entity) {
      var body = {
        username: vm.entity.username,
        password: vm.entity.password
      };
      var endWait = waitIndicator.beginWait();
      loginResource.getLogin().login(body,
        function (response) {
          $log.info('login');
          $log.info(response);
          endWait();
          var updatedEntity = angular.copy(entity);
          angular.merge(updatedEntity, response);
          entityUpdated(updatedEntity);
        },
        function (response) {
          $log.error('auth error ' + response.status + " " + response.statusText);
          endWait();
          entityUpdateError(entity, response);
        }
      );
    }

    function entityUpdateError(entity, response) {
      vm.errors = vm.errorsOfResponse(response);
    }

    function entityUpdated(entity) {
      // TODO: Go to page
      var sessionToken = entity.sessionToken;
      AuthenticationService.SetCredentials(entity.username, entity.sessionToken);
      $state.go('notes');
    }

  }

})();
