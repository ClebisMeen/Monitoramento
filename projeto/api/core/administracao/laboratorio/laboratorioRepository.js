/**
 * Created by Cleber Spirlandeli on 07/07/2017.
 */
/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */

const config = require('./../../../database/config.js');
let pg = require('pg-db')(config);

module.exports = {
    inserirLaboratorio,
    listarLaboratorio,
    editarLaboratorio,
    excluirLaboratorio
};

function inserirLaboratorio(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.INSERIRLABORATORIO($1, $2);",
        [
            params.idUsuarioInsercao,
            params.nomeLaboratorio
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 1,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `inserirLaboratorio: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].inserirlaboratorio.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 400,
                        errorTipoRepository: 2,
                        message: rows[0].inserirlaboratorio.message,
                        errorRepository: `inserirLaboratorio: ${rows[0].inserirlaboratorio}`
                    }
                };
            }
            if (!err) {
                row = rows[0].inserirlaboratorio;
            }
            callback(err, (err ? err.tipo.httpCode : 201), row);
        }
    );
}

function listarLaboratorio(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.LISTARLABORATORIO($1);",
        [
            params.idLaboratorio
        ],
        (err, rows) => {
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 3,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `listarLaboratorio: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows.length === 0) {
                err = {
                    tipo: {
                        httpCode: 204,
                        errorTipoRepository: 4,
                        message: `Nenhum horário cadastrado.`,
                        errorRepository: `listarLaboratorio`
                    }
                };
            }
            callback(err, (err ? err.tipo.httpCode : 200), rows);
        }
    );
}

function editarLaboratorio(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.EDITARLABORATORIO($1,$2,$3,$4);",
        [
            params.idLaboratorio,
            params.idProfessor,
            params.horaInicio,
            params.horaFim
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 5,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `editarLaboratorio: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].editarlaboratorio.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 404,
                        errorTipoRepository: 6,
                        message: rows[0].editarlaboratorio.message,
                        errorRepository: `editarLaboratorio: ${rows[0].editarlaboratorio}`
                    }
                };
            }
            if (!err) {
                row = rows[0].editarlaboratorio;
            }
            callback(err, (err ? err.tipo.httpCode : 200), row);
        }
    );
}

function excluirLaboratorio(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.EXCLUIRLABORATORIO($1);",
        [
            params.idLaboratorio
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 7,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `excluirLaboratorio: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].excluirlaboratorio.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 404,
                        errorTipoRepository: 8,
                        message: rows[0].excluirlaboratorio.message,
                        errorRepository: `excluirLaboratorio: ${rows[0].excluirlaboratorio.message}`
                    }
                };
            }
            if (!err) {
                row = rows[0].excluirlaboratorio;
            }
            callback(err, (err ? err.tipo.httpCode : 200), row);
        }
    );
}
//