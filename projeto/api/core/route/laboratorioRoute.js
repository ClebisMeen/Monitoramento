/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const LaboratorioCtrl = require('./../administracao/laboratorio/laboratorioController.js');

module.exports = function (app) {

    app.route('/api/laboratorio/:idUsuarioInsercao')
        .post(LaboratorioCtrl.inserirLaboratorio);

   /* app.route('/api/laboratorio/')
        .get(LaboratorioCtrl.listarLaboratorio);

    app.route('/api/laboratorio/:idHorario')
        .get(LaboratorioCtrl.listarLaboratorio)
        .delete(LaboratorioCtrl.excluirLaboratorio);

    app.route('/api/laboratorio/:idHorario/:idProfessor')
        .put(LaboratorioCtrl.editarLaboratorio);*/
};