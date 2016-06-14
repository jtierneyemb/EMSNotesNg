/**
 * @ngdoc controller
 * @name NoteController
 * @description
 * Controller for displaying and editing notes
 *
 */
(function () {
  'use strict';

  angular
    .module('frontend')
    .controller('NotesController', Controller);

  /** @ngInject */
  function Controller(notesResource, $log, $timeout, $scope, crudHelper, response) {


    var vm = this;

    activate();

    function activate() {
      crudHelper.activate(vm,
        {
          response: response,
          getResources: notesResource.getNotes,
          beforeSubmitNewEntity: beforeSubmitNewEntity,
          beforeSubmitEditEntity: beforeSubmitEditEntity,
          beforeShowNewEntityForm: beforeShowNewEntityForm,
          beforeShowEditEntityForm: beforeShowEditEntityForm,
          getEntityDisplayName: getEntityDisplayName,
          makeEntityBody: makeEntityBody,
          scope: $scope,
          keyName: 'title',
          errorCategories: {
            'text': null,
            'title': null
          }
        }
      );
    }

    function beforeSubmitNewEntity(entity) {
      return {
        title: entity.title,
        text: entity.text
      };
    }

    function beforeSubmitEditEntity(entity) {
      return {
        title: entity.title,
        text: entity.text
      };
    }

    function beforeShowNewEntityForm() {
      // Nothing to do.
    }

    function beforeShowEditEntityForm() {
      // Nothing to do.
    }

    function getEntityDisplayName(entity) {
      return entity.title;
    }

    function makeEntityBody(entity) {
      return entity;
    }


  }
})();




