@app = angular.module('app', [   # additional dependencies here, such as restangular   'templates' ])
@app.config([   '$httpProvider', ($httpProvider)->     $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content') ])  
@app.run(->   console.log 'angular app running' )
