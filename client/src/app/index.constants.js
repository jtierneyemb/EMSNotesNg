(function() {
  'use strict';

  angular
    .module('frontend')
    // The following baseURL is for testing
    // .constant("baseURL","/api/")
    // The following baseURL works if index.html is located in a subdirectory
    // of the directory that contains emsserver.dll
   .constant("baseURL","../emsserver.dll/")
  ;

})();
