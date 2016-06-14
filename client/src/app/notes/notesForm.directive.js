/**
 * @ngdoc directive
 * @name feNote
 * @description
 * Form for new note and editing note
 *
 * @example:
 <fe-notes-form></fe-notes-form>
 */


(function () {
  'use strict';

  angular
    .module('frontend')
    .directive('feNotesForm', directiveFunc);

  /** @ngInject */
  function directiveFunc() {
    var directive = {
      restrict: 'EA',
      templateUrl: 'app/notes/notesForm.html',
      scope: {
        form: '=',
        errors: '=',
        cancel: '&',
        submit: '&',
        entity: '=',
        statictitle: '=',
        ok: '@'
      }
    };

    return directive;
  }

})();
