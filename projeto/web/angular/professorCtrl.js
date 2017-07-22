/**
 * Created by Cleber Spirlandeli on 16/07/2017.
 */
angular.module("app")
    .controller("professorCtrl", function ($scope) {
        $scope.arrayProfessores = [
            {"nome":"Professor 1","email":"contato@email.com","telefone":"10932101"},
            {"nome":"Professor","email":"contato@email.com","telefone":"10932102"},
            {"nome":"Professor","email":"contato@email.com","telefone":"10932103"}
            ];


        $scope.adicionarProfessor = function (professor) {
            $scope.arrayProfessores.push(angular.copy(professor));
        };

    });