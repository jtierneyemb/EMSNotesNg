(function() {
  'use strict';

  angular
    .module('frontend')
    // The following baseURL works if index.html is located in a subdirectory
    // of the directory that contains emsserver.dll

    .constant("baseURL","../emsserver.dll/")

    // The following baseURL works againt the EMSDevServer.
    // Cross posting must be enabled by modifying the emsserver.ini file:
    // [Server.APICrossDomain]
    // CrossDomain=*

   //.constant("baseURL","http://172.16.118.143:8080/")
  ;

})();
