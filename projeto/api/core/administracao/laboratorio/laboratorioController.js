/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */

const LaboratorioRepository = require('./laboratorioRepository.js');
const waterfall = require('async-waterfall');

module.exports = {
    inserirLaboratorio,
    listarLaboratorio,
    editarLaboratorio,
    excluirLaboratorio
};

function inserirLaboratorio(req, res) {
    const params = {
        idUsuarioInsercao: req.params.idUsuarioInsercao,
        nomeLaboratorio: req.body.nomeLaboratorio
    };

    LaboratorioRepository.inserirLaboratorio(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function listarLaboratorio(req, res) {
    const params = {
        idLaboratorio: req.params.idLaboratorio ? req.params.idLaboratorio : null
    };

    LaboratorioRepository.listarLaboratorio(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function editarLaboratorio(req, res) {
    const params = {
        idLaboratorio: req.params.idLaboratorio,
        idProfessor: req.params.idProfessor,
        horaInicio: req.body.horaInicio,
        horaFim: req.body.horaFim
    };

    LaboratorioRepository.editarLaboratorio(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function excluirLaboratorio(req, res) {
    const params = {
        idLaboratorio: req.params.idLaboratorio
    };

    LaboratorioRepository.excluirLaboratorio(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}
//