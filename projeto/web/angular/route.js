/**
 * Created by Cleber Spirlandeli on 16/07/2017.
 */

angular.module("app").config(function ($routeProvider) {
    $routeProvider

        .when('/professor', {
           templateUrl: 'professor-cadastrar.html',
           controller: 'professorCtrl'
        })

        .when('/professor/cadastrar', {
            templateUrl: 'inicio-admin-listar.html',
            controller: 'professorCtrl'
        });


    /*
        .when('/professor/listar', {
            templateUrl: 'inicio-admin-listar.html',
            controller: 'professorCtrl'
        })

        .when('/professor/editar', {
            templateUrl: 'projeto/web/html/professor.html',
            controller: 'professorCtrl'
        });*/

        //$routeProvider.otherwise({redirectTo: '/professor'});
});





// angular.module('contatooh', ['ngRoute', 'ngResource'])
//     .config(function($routeProvider, $httpProvider) {
//
//         $httpProvider.interceptors.push('meuInterceptor');
//
//         $routeProvider.when('/contatos', {
//             templateUrl: 'partials/contatos.html',
//             controller: 'ContatosController'
//         });
//
//         $routeProvider.when('/contato/:contatoId', {
//             templateUrl: 'partials/contato.html',
//             controller: 'ContatoController'
//         });
//
//         $routeProvider.when('/contato', {
//             templateUrl: 'partials/contato.html',
//             controller: 'ContatoController'
//         });
//
//         $routeProvider.when('/auth', {
//             templateUrl: 'partials/auth.html'
//         });
//
//         $routeProvider.otherwise({redirectTo: '/contatos'});
//
//     });