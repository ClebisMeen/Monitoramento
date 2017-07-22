/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */

const ReservadoRepository = require('./reservadoRepository.js');
const waterfall = require('async-waterfall');

module.exports = {
    inserirReservado,
    listarReservado,
    editarReservado,
    excluirReservado
};

function inserirReservado(req, res) {
    const params = {
        idProfessor: req.params.idProfessor,
        idLaboratorio: req.params.idLaboratorio,
        idHorario: req.params.idHorario,
        detalhe: req.body.detalhe
    };

    ReservadoRepository.inserirReservado(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function listarReservado(req, res) {
    const params = {
        idLaboratorio: req.params.idLaboratorio ? req.params.idLaboratorio : null
    };

    ReservadoRepository.listarReservado(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function editarReservado(req, res) {
    const params = {
        idLaboratorio: req.params.idLaboratorio,
        idProfessor: req.params.idProfessor,
        horaInicio: req.body.horaInicio,
        horaFim: req.body.horaFim
    };

    ReservadoRepository.editarReservado(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function excluirReservado(req, res) {
    const params = {
        idLaboratorio: req.params.idLaboratorio
    };

    ReservadoRepository.excluirReservado(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}
//