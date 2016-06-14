(function () {
  'use strict';

  describe('notes controller', function () {
    var $httpBackend;
    var $controller;
    var $scope;
    var resourceService;

    var sampleNotes = [
      {
        title:'sometitle',
        text: "sometext"
      }
    ];

    var samplePost = [
      {
        text: "different text"
      }
    ];

    beforeEach(module('frontend'));
    beforeEach(inject(function (_$controller_, $rootScope, _$httpBackend_, _notesResource_) {
      $httpBackend = _$httpBackend_;
      $controller = _$controller_;
      $scope = $rootScope.$new();
      resourceService = _notesResource_;
    }));


    describe('loading', function () {

      it('should load', function () {
        var vm;
        $httpBackend.when('GET', resourceService.path).respond(
          function () {
            return [200, sampleNotes]
          });
        vm = $controller('NotesController', {
          $scope: $scope,
          response: null
        });
        expect(vm.loading).toBe(true);
        $httpBackend.flush();

        expect(vm.loading).toBe(false);
        expect(vm.loadingFailed).toBe(false);
        expect(vm.loadingFailedMessage).toBe(null);
      });

      it('should fail', function () {
        var vm;
        $httpBackend.when('GET', resourceService.path).respond(500, {'error': 'something went wrong'});
        vm = $controller('NotesController', {
          $scope: $scope,
          response: null
        });
        $httpBackend.flush();

        expect(vm.loading).toBe(false);
        expect(vm.loadingFailed).toBe(true);
        expect(vm.loadingFailedMessage).toEqual(jasmine.any(String));
      });
    });

    describe('crud', function () {
        var vm;

        beforeEach(function () {
          $httpBackend.when('GET', resourceService.path).respond(200, sampleNotes);
          vm = $controller('NotesController', {
            $scope: $scope,
            response: null
          });
          $httpBackend.flush();

        });

        it('should get', function () {
          expect(vm.entitys).toEqual(jasmine.any(Array));
          //expect(angular.isArray(vm.entitys)).toBeTruthy();
          expect(vm.entitys.length).toBe(sampleNotes.length);
          expect(angular.equals(vm.entitys[0], sampleNotes[0])).toBeTruthy;
        });

        it('should add 1', function () {
          $httpBackend.when('POST', resourceService.path).respond(201, {mergeKey: "mergeValue"});
          vm.newEntity = {title: "newname"};
          vm.submitNewEntityForm();
          $httpBackend.flush();

          expect(angular.isArray(vm.entitys)).toBeTruthy();
          expect(vm.entitys.length).toBe(sampleNotes.length + 1);
          expect(vm.entitys[0].mergeKey).toBe("mergeValue");
          expect(vm.entitys[0].title).toBe("newname");
        });

        it('should delete 1', function () {
          var toRemove = vm.entitys[0];
          $httpBackend.when('DELETE', resourceService.path + '/' + toRemove.title).respond(200, {});
          vm.trashEntity(toRemove, false);  // do not confirm: false
          $httpBackend.flush();
          expect(angular.isArray(vm.entitys)).toBeTruthy();
          expect(vm.entitys.length).toBe(sampleNotes.length - 1);
        });

        it('should format body', function () {
          $httpBackend.expect('POST', resourceService.path, samplePost[0]).respond(200, {});
          vm.newEntity = samplePost[0];
          vm.submitNewEntityForm();
          $httpBackend.flush();
        });

        it('should capture create error', function () {
          $httpBackend.when('POST', resourceService.path).respond(422, {"title": ["has already been taken"]});
          vm.newEntity = samplePost[0];
          vm.submitNewEntityForm();
          $httpBackend.flush();

          expect(vm.entitys.length).toBe(sampleNotes.length);
          expect(vm.entityCreateErrors).toEqual(jasmine.any(Object));
          expect(vm.entityCreateErrors.title).toEqual(jasmine.any(Array));
          expect(vm.entityCreateErrors.title.length).toBe(1);
          expect(vm.entityCreateErrors.title[0]).toEqual(jasmine.stringMatching('has already been taken'));
        });

        it('should capture delete error', function () {
          $httpBackend.when('DELETE', resourceService.path + '/999').respond(404, {"error": "not found"});
          vm.trashEntity({title: 999}, false);  // do not confirm: false
          $httpBackend.flush();
          expect(vm.entitys.length).toBe(sampleNotes.length);
          expect(vm.lastToast).toEqual(jasmine.any(Object));
          expect(vm.lastToast.iconClass).toEqual('toast-error')
        });

      }
    )
  });
})();
