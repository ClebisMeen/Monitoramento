/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const HorarioRepository = require('./horarioRepository.js');
const waterfall = require('async-waterfall');

module.exports = {
    inserirHorario,
    listarHorario,
    editarHorario,
    excluirHorario
};

function inserirHorario(req, res) {
    const params = {
        idHorario: req.params.idHorario,
        horaInicio: req.body.horaInicio,
        horaFim: req.body.horaFim
    };

    HorarioRepository.inserirHorario(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function listarHorario(req, res) {
    const params = {
        idHorario: req.params.idHorario ? req.params.idHorario : null
    };

    HorarioRepository.listarHorario(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function editarHorario(req, res) {
    const params = {
        idHorario: req.params.idHorario,
        idProfessor: req.params.idProfessor,
        horaInicio: req.body.horaInicio,
        horaFim: req.body.horaFim
    };

    HorarioRepository.editarHorario(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function excluirHorario(req, res) {
    const params = {
        idHorario: req.params.idHorario
    };

    HorarioRepository.excluirHorario(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}
