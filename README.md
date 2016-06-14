## EMS/AngularJS Sample

### Summary

An EMS (RAD Server) resource package with AngularJS application, to list, add, edit and delete notes.

### Two Projects

The resource directory contains an EMS resource project called NotesResourcePackage.dpk.

The client directory contains an AngularJS/Gulp project.  This application communicates with the EMS server
using conventional Angular $resource calls.

The two projects are built independently.    

### Download

* `git clone https://github.com/jtierneyemb/EMSNotesNg.git`

### EMS Build
* Build resource package
  * Open NotesResourcePackage in RAD Studio
  * Build Win64 target

### Angular Build
* Package manager installation
  * Install npm
  * Install bower
* Package setup
    * `cd client`
    * `npm install`
    * `bower install`
* Build 
    * `cd client`
    * `gulp build`
* Test
    * `cd client`
    * `gulp test`
    
### IIS Configuration
* Virtual directory
  * Create a new virtual directory using IIS Manager
  * Create a subdirectory called client
* Copy EMS files
  * Copy the following files to the virtual directory
    * bin64/emsserver.dll
    * bin64/rtl240.bpl
    * bin64/emsserverapi.dll
    * NotesResourcePackage.bpl
* emsserver.ini
   * copy emsserver.ini to virtual directory
   * modify emsserver.ini
     * Under [Server.Packages] specify the full path of NotesResourcePackage.
     * For example: `c:\ems\NotesResourcePackage.bpl=notes resource`
* Copy Angular project dist files
  * Copy all files from EMSNotesNg/client/dist to the virtual client directory
  
### Run
* Browse to the virtual client directory to see the Home page
* Click the login link on the right
* Login and existing user or signup a new user

### Trouble shooting
* Do not see home page
  * Check that dist files have been copied to the virtual directory.
  * client\index.html must exist
* Can't login
  * Check that emsserver is available
    * From login page show the Chrome debugger
    * Use network tab to see the URL of the login request
    * Verify that the EMS server is available at this address
      * Browser to <virtualdir>/emsserver.dll/version
* Can't list notes
  * Check that notes resource is available
    * Browse to <virtualdir>/emsserver.dll/notes
      * Expect error message about logging in
    * Be sure that emsserver.ini is in the same directory as emsserver.dll
    * Be sure that emsserver.ini identifies full path of NotesResourcePackage.bpl
    
  

    



