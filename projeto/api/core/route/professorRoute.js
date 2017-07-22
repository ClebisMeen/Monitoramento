/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const ProfessorCtrl = require('./../seguranca/professor/professorController.js');

module.exports = function (app) {

    app.route('/api/professor/')
        .get(ProfessorCtrl.listarProfessor);


    app.route('/api/professor/:idProfessor')
        .post(ProfessorCtrl.inserirProfessor)
        .get(ProfessorCtrl.listarProfessor)
        .put(ProfessorCtrl.editarProfessor)
        .delete(ProfessorCtrl.excluirProfessor);
};