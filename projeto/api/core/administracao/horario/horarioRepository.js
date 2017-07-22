/**
 * Created by Cleber Spirlandeli on 07/07/2017.
 */
/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */
const config = require('./../../../database/config.js');
let pg = require('pg-db')(config);

module.exports = {
    inserirHorario,
    listarHorario,
    editarHorario,
    excluirHorario
};

function inserirHorario(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.INSERIRHORARIO($1, $2, $3);",
        [
            params.idHorario,
            params.horaInicio,
            params.horaFim
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 1,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `inserirHorario: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].inserirhorario.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 400,
                        errorTipoRepository: 2,
                        message: rows[0].inserirhorario.message,
                        errorRepository: `inserirHorario: ${rows[0].inserirhorario}`
                    }
                };
            }
            if (!err) {
                row = rows[0].inserirhorario;
            }
            callback(err, (err ? err.tipo.httpCode : 201), row);
        }
    );
}

function listarHorario(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.LISTARHORARIO($1);",
        [
            params.idHorario
        ],
        (err, rows) => {
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 3,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `listarHorario: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows.length === 0) {
                err = {
                    tipo: {
                        httpCode: 204,
                        errorTipoRepository: 4,
                        message: `Nenhum horário cadastrado.`,
                        errorRepository: `listarHorario`
                    }
                };
            }
            callback(err, (err ? err.tipo.httpCode : 200), rows);
        }
    );
}

function editarHorario(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.EDITARHORARIO($1,$2,$3,$4);",
        [
            params.idProfessor,
            params.idHorario,
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
                        errorRepository: `editarHorario: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].editarhorario.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 404,
                        errorTipoRepository: 6,
                        message: rows[0].editarhorario.message,
                        errorRepository: `editarHorario: ${rows[0].editarhorario}`
                    }
                };
            }
            if (!err) {
                row = rows[0].editarhorario;
            }
            callback(err, (err ? err.tipo.httpCode : 200), row);
        }
    );
}

function excluirHorario(params, callback) {
    pg.query("SELECT * FROM ADMINISTRACAO.EXCLUIRHORARIO($1);",
        [
            params.idHorario
        ],
        (err, rows) => {
            let row;
            if (err) {
                err = {
                    tipo: {
                        httpCode: 500,
                        errorTipoRepository: 7,
                        message: `Ocorreu um erro não esperado, tente novamente, se o erro persistir, entre em contato com o suporte`,
                        errorRepository: `excluirHorario: ERROR (' ${err.message} ')`
                    }
                };
            }
            else if (rows[0].excluirhorario.executionCode !== 1) {
                err = {
                    tipo: {
                        httpCode: 404,
                        errorTipoRepository: 8,
                        message: rows[0].excluirhorario.message,
                        errorRepository: `excluirHorario: ${rows[0].excluirhorario.message}`
                    }
                };
            }
            if (!err) {
                row = rows[0].excluirhorario;
            }
            callback(err, (err ? err.tipo.httpCode : 200), row);
        }
    );
}
//