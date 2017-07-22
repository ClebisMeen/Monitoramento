/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const HorarioCtrl = require('./../administracao/horario/horarioController.js');

module.exports = function (app) {

    app.route('/api/horario/')
        .get(HorarioCtrl.listarHorario);

    app.route('/api/horario/:idHorario')
        .get(HorarioCtrl.listarHorario)
        .delete(HorarioCtrl.excluirHorario);

    app.route('/api/horario/:idProfessor')
        .post(HorarioCtrl.inserirHorario);

    app.route('/api/horario/:idHorario/:idProfessor')
        .put(HorarioCtrl.editarHorario);
};
