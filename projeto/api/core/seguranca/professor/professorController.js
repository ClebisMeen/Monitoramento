/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const ProfessorRepository = require('./professorRepository.js');
const waterfall = require('async-waterfall');

module.exports = {
    listarProfessor,
    inserirProfessor,
    editarProfessor,
    excluirProfessor
};

function inserirProfessor(req, res) {
    const params = {
        idUsuarioCadastro: req.params.idUsuarioCadastro,
        nome: req.body.nome,
        email: req.body.email,
        senha: req.body.senha,
        telefone: req.body.telefone ? req.body.telefone : null
    };

    ProfessorRepository.inserirProfessor(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function listarProfessor(req, res) {
    const params = {
        idProfessor: req.params.idProfessor ? req.params.idProfessor : null
    };

    ProfessorRepository.listarProfessor(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function editarProfessor(req, res) {
    const params = {
        idProfessor: req.params.idProfessor,
        nome: req.body.nome,
        email: req.body.email,
        senha: req.body.senha,
        telefone: req.body.telefone ? req.body.telefone : null
    };

    ProfessorRepository.editarProfessor(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}

function excluirProfessor(req, res) {
    const params = {
        idProfessor: req.params.idProfessor
    };

    ProfessorRepository.excluirProfessor(params, (err, httpCode, rows) => {
        let result = err ? err.tipo : rows;
        res.status(httpCode).json(result);
    });
}