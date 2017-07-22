/**
 * Created by Cleber Spirlandeli on 04/07/2017.
 */

module.exports = function () {

    let express = require('express');
    let path = require('path');
    let favicon = require('serve-favicon');
    let logger = require('morgan');
    let cookieParser = require('cookie-parser');
    let bodyParser = require('body-parser');

    let app = express();

    app.set('views', path.join(__dirname, 'views'));
    app.set('view engine', 'jade');

    app.use(logger('dev'));
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({extended: false}));
    app.use(cookieParser());
    app.use(express.static(path.join(__dirname, 'public')));

    app.all('*', function (req, res, next) {
        res.header('Access-Control-Allow-Origin', '*');
        res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS');
        res.header('Access-Control-Allow-Headers', 'Content-Type');
        next();
    });

    require('./core/route/professorRoute.js')(app);
    require('./core/route/horarioRoute.js')(app);
    require('./core/route/laboratorioRoute.js')(app);

    app.listen(3000, () => {
        console.log('    Server Localhost:3000 server.js');
    });
};