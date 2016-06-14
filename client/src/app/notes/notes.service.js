/**
 * @ngdoc service
 * @name notesResource
 * @description
 * Service to transfer note JSON between frontend and backend
 *
 */
(function() {
  'use strict';

  angular
    .module('frontend')
    .factory('notesResource', notesFunc);

  /** @ngInject */
  function notesFunc($log, $resource, baseURL) {
    var path = baseURL + 'notes';

    var service = {
      path: path,
      getNotes: getNotes
    };

    return service;

    function getNotes() {
      $log.info("getNotes()");
      return $resource(path + '/:id', null, {'update': {method: 'PUT'}});
    }
  }
})();
