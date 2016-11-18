(function () {
  'use strict';

  /**
   * @todo Complete the test
   */
  describe('directive notes form', function () {
    var errors;
    var entity;
    var compiledDirective;
    var scope;
    var okText;

    beforeEach(module('frontend'));
    beforeEach(inject(function ($compile, $rootScope) {

      errors = {
        other: ['othererror'],
        name: ['nameerror']
      };
      entity = { name: 'namevalue'};
      okText = 'clickme';

      scope = $rootScope.$new();
      scope.aentity = entity;
      scope.aerrors = errors; // errors;
      scope.asubmit = jasmine.createSpy('onSubmit');
      scope.acancel = jasmine.createSpy('onCancel');

      // TODO test directive
      var html = ('<fe-notes-form>' +
      'form="formName" ' +
      'errors="aerrors" ' +
      'cancel="acancel" ' +
      'submit="asubmit" ' +
      'entity="aentity" ' +
      'ok="' + "{{'" + okText + "'}}" + '"' +
      '</fe-notes-form>');

      var el = angular.element(html);

      compiledDirective = $compile(el)(scope);
      // scope.$digest();  // Problem with form property
    }));

    it('should have isolate scope object with members', function () {
      // var isolatedScope = compiledDirective.isolateScope();

      // expect(isolatedScope).not.toEqual(null);
      // TODO: Get this working
      // expect(isolatedScope.entity).toBeDefined();
      // expect(isolatedScope.entity.name).toBeDefined();

    });
   });
})();
