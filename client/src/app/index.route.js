(function () {
  'use strict';

  angular
    .module('frontend')
    .config(routerConfig);

  /** @ngInject */
  function routerConfig($stateProvider, $urlRouterProvider) {

    var header = {
      templateUrl: 'app/header/header.html',
      controller: 'HeaderController',
      controllerAs: 'vm'
    };

    $stateProvider
      .state('home', {
        url: '/',
        views: {
          'header': header,
          'content': {
            templateUrl: 'app/main/main.html'
          }
        }
      })
      .state('notes', {
        url: '/notes',
        views: {
          'header': header,
          'content': {
            templateUrl: 'app/notes/notes.html',
            controller: 'NotesController',
            controllerAs: 'main',
            resolve: {
              response: resolveNotes()
            }
          }
        }
      })

      .state('login', {
        url: '/login',
        views: {
          'header': header,
          'content': {
            templateUrl: 'app/auth/login.view.html',
            controller: 'LoginController',
            controllerAs: 'vm'
          }
        }
      })
      
      .state('register', {
        url: '/register',
        views: {
          'header': header,
          'content': {
            templateUrl: 'app/auth/signup.view.html',
            controller: 'SignupController',
            controllerAs: 'vm'
          }
        }
      })
    ;

    $urlRouterProvider.otherwise('/');

    function resolveNotes() {
      /** @ngInject */
      function resolve(notesResource, $q, $log, waitIndicator) {
        return resolveResourceQuery(notesResource.getNotes(), $q, waitIndicator, $log);
      }

      return resolve;
    }

    function resolveResourceQuery(resource, $q, waitIndicator, $log) {
      var deferred = $q.defer();
      var endWait = waitIndicator.beginWait();
      resource.query(
        function (response) {
          $log.info('received data');
          endWait();
          deferred.resolve(response);
        },
        function (response) {
          $log.error('data error ' + response.status + " " + response.statusText);
          endWait();
          deferred.resolve(response);
        }
      );
      return deferred.promise;
    }

    function resolveResourceGet(resource, id, $q, waitIndicator, $log) {
      var deferred = $q.defer();
      var endWait = waitIndicator.beginWait();
      resource.get({id: id},
        function (response) {
          $log.info('received data');
          endWait();
          deferred.resolve(response);
        },
        function (response) {
          $log.error('data error ' + response.status + " " + response.statusText);
          endWait();
          deferred.resolve(response);
        }
      );
      return deferred.promise;
    }


  }

})();
