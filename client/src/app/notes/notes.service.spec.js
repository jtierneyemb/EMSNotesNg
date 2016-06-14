(function() {
  'use strict';

  describe('service Note', function() {
    var service;
    var $httpBackend;

    beforeEach(module('frontend'));
    beforeEach(inject(function(_notesResource_, _$httpBackend_) {
      service = _notesResource_;
      $httpBackend = _$httpBackend_;
    }));

    it('should be registered', function() {
      expect(service).not.toEqual(null);
    });

    describe('path variable', function() {
      it('should exist', function() {
        expect(service.path).not.toEqual(null);
      });
    });

    describe('getNotes function', function() {
      it('should exist', function() {
        expect(service.getNotes).not.toEqual(null);
      });

      it('should return data', function() {
        $httpBackend.when('GET',  service.path).respond(200, [{name: 'aname'}]);
        var data = null;
        service.getNotes().query(function(response) {
          data = response;
        },
        function() {

        });
        $httpBackend.flush();
        expect(data).toEqual(jasmine.any(Array));
        expect(data.length === 1).toBeTruthy();
        expect(data[0]).toEqual(jasmine.any(Object));
      });

      it('should log a error', function() {
        $httpBackend.when('GET',  service.path).respond(500);
        var error = false;
        service.getNotes().query(function() {
          },
          function() {
            error = true;

          });
        $httpBackend.flush();
        expect(error).toEqual(true);
      });
    });
  });
})();

