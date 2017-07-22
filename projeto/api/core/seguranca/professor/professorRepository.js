/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const config = require('./../../../database/config.js');
let pg = require('pg-db')(config);

module.exports = {
    listarProfessor,
    inserirProfessor,
    editarProfessor,
    excluirProfessor
};

function inserirProfessor(params, callback) {
    pg.query("SELECT * FROM SEGURANCA.INSERIRPROFESSOR($1, $2, $3, $4, $5);",
        [
            params.idUsuarioCadastro,
            params.nome,
            params.email,
            params.senha,
            params.telefone
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 1,
                        message: `Ocorreu um erro nao esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `inserirProfessor: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].inserirprofessor.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 400,
                        errorTipoRepository: 2,
                        message: rows[0].inserirprofessor.message,
                        errorRepository: `inserirProfessor: ${rows[0].inserirprofessor}`
                    }
                };
            }
            if (!err) {
                row = rows[0].inserirprofessor;
            }
            callback(err, (err ? err.tipo.httpCode : 201), row);
        }
    );
}

function listarProfessor(params, callback) {
    pg.query("SELECT * FROM SEGURANCA.LISTARPROFESSOR($1);",
        [
            params.idProfessor
        ],
        (err, rows) => {
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 3,
                        message: `Ocorreu um erro nao esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `listarProfessor: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows.length === 0) {
                err = {
                    tipo: {
                        httpCode: 204,
                        errorTipoRepository: 4,
                        message: `Nenhum professor cadastrado.`,
                        errorRepository: `listarProfessor`
                    }
                };
            }
            callback(err, (err ? err.tipo.httpCode : 200), rows);
        }
    );
}

function editarProfessor(params, callback) {
    pg.query("SELECT * FROM SEGURANCA.EDITARPROFESSOR($1,$2,$3,$4,$5);",
        [
            params.idProfessor,
            params.nome,
            params.email,
            params.senha,
            params.telefone
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 5,
                        message: `Ocorreu um erro nao esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `editarProfessor: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].editarprofessor.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 404,
                        errorTipoRepository: 6,
                        message: rows[0].editarprofessor.message,
                        errorRepository: `editarProfessor: ${rows[0].editarprofessor}`
                    }
                };
            }
            if (!err) {
                row = rows[0].editarprofessor;
            }
            callback(err, (err ? err.tipo.httpCode : 200), row);
        }
    );
}

function excluirProfessor(params, callback) {
    pg.query("SELECT * FROM SEGURANCA.EXCLUIRPROFESSOR($1);",
        [
            params.idProfessor
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 7,
                        message: `Ocorreu um erro nao esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `excluirProfessor: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].excluirprofessor.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 404,
                        errorTipoRepository: 8,
                        message: rows[0].excluirprofessor.message,
                        errorRepository: `excluirProfessor: ${rows[0].excluirprofessor}`
                    }
                };
            }
            if (!err) {
                row = rows[0].excluirprofessor;
            }
            callback(err, (err ? err.tipo.httpCode : 200), row);
        }
    );
}
