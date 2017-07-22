/**
 * Created by Cleber Spirlandeli on 15/07/2017.
 */
$(document).ready(function () {
    $('.parallax').parallax();
    $('.modal').modal();
});

$(window).on("scroll", function () {
    if ($(window).scrollTop() > 135) {
        $('#botao-voltar-topo').show();
    } else {
        $('#botao-voltar-topo').hide();
    }
});

$("#ads,#ge,#gpi,#contato")
    .mouseenter(function () {
        $(this).removeClass("z-depth-3").addClass("z-depth-5");
    })
    .mouseleave(function () {
            $(this).removeClass("z-depth-5").addClass("z-depth-3");
        }
    );

$("#botao-voltar-topo").click(function () {
    $("html, body").animate({scrollTop: 0}, "slow");
    return false;
});



/*$("#bnt-entrar").click(function () {

    var users = [
        {name: "admin", password: "key112233"},
        {name: "neto", password: "neto1fatec"}
    ];
    localStorage.setItem('users', JSON.stringify(users));

    var user = localStorage.getItem('users');

    var confirmaUsuario = false;
    var us = JSON.parse(user);
    var userName = $("#name-user").val();
    var userPassword = $("#password").val();

    for (var x = 0; x < us.length; x++) {
        if (us[x].name === userName && us[x].password === userPassword) {
            confirmaUsuario = true;
            var authorized = {name: userName, password: userPassword};
            sessionStorage.setItem('authorized_entry', JSON.stringify(authorized));
            window.location.href = "menu.html";
        }
    }

    if (confirmaUsuario === false) {
        Materialize.toast('Usuário ou senha incorreto!', 3000);
    }

});*/

/*
$scope.teste = function (usuario) {
    $http({
        method: 'POST',
        url: 'http://localhost:3000/api/usuario/',
        data: {
            cpf: usuario.cpf,
            senha: usuario.senha
        }
    }).then(function (response) {
        //console.log('DEU CERTO');
        //console.log(response);
        window.location.href = "procurar.html";
    }, function (response) {
        //console.log('DEU ERRADO ');
        //console.log(response);
        Materialize.toast('Usuário ou senha incorreto!', 3000);
    });
};*/
