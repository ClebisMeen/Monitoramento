// Cleber Spirlandeli
// Banco de dados SQL Server
// Controller ~> Async-Waterfall - Promise

module.exports = {
    criarOpcional,
    editarOpcional
};

function criarOpcional(req, res) {
    const params = {
        idUsuario: req.params.idUsuario
    };

    var transaction;
    var conn = sql.connect(config).then(
        transaction = new sql.Transaction(conn));

    waterfall([
        function (callback) {
            transaction.begin(function (err) {
                if (err)
                    callback(err);
                else
                    callback(null);
            });
        },

        function (callback) {
            Repository.criarCargo(transaction, params, req.body, function (err, dados, idCargo) {
                if (err)
                    callback(err, dados);
                else
                    callback(null, idCargo);
            });
        },

        function (idCargo, callback) {
            let promises = req.body.opcionais.map(opcional => new Promise((resolve, reject) => {
                Repository.criarOpcionalCargo(transaction, opcional.opcional, idCargo, (err, dados) => {
                    if (err)
                        reject(dados);
                    else
                        resolve(null);

                });
            }));

            Promise.all(promises).then(() => {
                    callback(null, null, idCargo);
                }, (err) => {
                    callback(500, dados);
                }
            );
        } 
    ], function (err, dados, idCargo) {
        if (err) {
            transaction.rollback(function (erro) {
                if (erro)
                    console.log('Erro Rollback: ' + erro);
                else
                    res.status(err).json(dados);
            });
        }
        else {
            transaction.commit(function (erro) {
                if (erro)
                    console.log('Erro Commited: ' + erro);
                else
                    res.status(200).json({id: idCargo});
            });
        }
    });
}


function editarOpcional(req, res) {
    const params = {
        idUsuario: req.params.idUsuario,
        idCargo: req.params.idCargo
    };

    var transaction;
    var conn = sql.connect(config).then(
        transaction = new sql.Transaction(conn));

    waterfall([
            function (callback) {
                transaction.begin(function (err) {
                    if (err)
                        callback(err);
                    else
                        callback(null);
                });
            },

            function (callback) {
                Repository.editarOpcional(transaction, params, req.body, (err, dados) => {
                    if (err)
                        callback(err, dados);
                    else
                        callback(null, dados);
                });
            },

            function (dados, callback) {
                Repository.deletarOpcionalTipo(transaction, params, function (err, dados) {
                    if (err)
                        callback(err, dados);
                    else
                        callback(null, dados);
                });
            },

            function (dados, callback) {
                let promises = req.body.opcionais.map(opcional => new Promise((resolve, reject) => {
                    Repository.editarOpcionalTipo(transaction, req, opcional.opcional, function (err, dados) {
                        if (err)
                            reject(dados);
                        else
                            resolve(null);
                    });
                }));

                Promise.all(promises).then(() => {
                        callback(null);
                    }, (err) => {
                        callback(500, dados);
                    }
                );

            }

        ], function (err, dados) {
            if (err) {
                transaction.rollback(function (erro) {
                    if (erro)
                        console.log('Erro Rollback: ' + erro);
                    else
                        res.status(err).json(dados);
                });
            }
            else {
                transaction.commit(function (erro) {
                    if (erro)
                        console.log('Erro Commited: ' + erro);
                    else
                        res.status(200).json(dados);
                });
            }
        }
    );
}