/**
 * Created by Cleber Spirlandeli on 16/07/2017.
 */

angular.module("app").config(function ($routeProvider) {
    $routeProvider

        .when('/horario', {
            templateUrl: 'horario-listar.html',
            controller: 'horarioCtrl'
        })

        .when('/horario/cadastrar', {
            templateUrl: 'horario-cadastrar.html',
            controller: 'horarioCtrl'
        });

    $routeProvider.otherwise({redirectTo: '/horario'});
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