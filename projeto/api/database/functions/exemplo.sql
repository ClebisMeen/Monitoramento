

CREATE OR REPLACE FUNCTION Comercial.InserirProprietario(
    pTipoProprietario CHAR,
    pIdusuario        VARCHAR(200),
    pIdCidade         VARCHAR(200),
    pCep              Comercial.Proprietario.cep%TYPE,
    pLogradouro       Comercial.Proprietario.logradouro%TYPE,
    pNumero           Comercial.Proprietario.numero%TYPE,
    pComplemento      Comercial.Proprietario.complemento%TYPE,
    pBairro           Comercial.Proprietario.bairro%TYPE,
    pEmail            Comercial.Proprietario.email%TYPE,
    pAtivo            Comercial.Proprietario.ativo%TYPE,
    pNome             Comercial.ProprietarioFisica.nome%TYPE,
    pSobrenome        Comercial.ProprietarioFisica.sobrenome%TYPE,
    pCpf              Comercial.ProprietarioFisica.cpf%TYPE,
    pRg               Comercial.ProprietarioFisica.rg%TYPE,
    pDataNascimento   Comercial.ProprietarioFisica.dataNascimento%TYPE,
    pSexo             Comercial.ProprietarioFisica.sexo%TYPE,
    pRazaoSocial      Comercial.ProprietarioJuridica.razaoSocial%TYPE,
    pNomeFantasia     Comercial.ProprietarioJuridica.nomeFantasia%TYPE,
    pCnpj             Comercial.ProprietarioJuridica.cnpj%TYPE,
    pTelefones        JSON
)
    RETURNS JSON AS $$
/*
Documentação
Arquivo Fonte.....: 
Objetivo..........: Inserir Proprietario
Autor.............: Cleber Spirlandeli
Data..............: 05/06/2017
Ex................:
    SELECT * FROM Comercial.InserirProprietario('F',
                                                '1',
                                                '1',
                                                '123456',
                                                'Rua das teste',
                                                '1234',
                                                'apto 00',
                                                'jd das flores',
                                                'teste@teste.com.br',
                                                true,
                                                'teste',
                                                'teste´s',
                                                '12346',
                                                '456789',
                                                '2010-10-10',
                                                'M',
                                                null,
                                                null,
                                                null,
                                                '[{"idTipoTelefone":"1",
                                                   "ddd":"16",
                                                   "numero":123456,
                                                   "contato":"teste1"}]' :: json);

   SELECT * FROM Comercial.InserirProprietario('J',
                                                '1',
                                                '1',
                                                '123456',
                                                'Rua das cove',
                                                '1234',
                                                'apto 42',
                                                'jd das flores',
                                                'teste@teste.com.br',
                                                true,
                                                null,
                                                null,
                                                null,
                                                null,
                                                null,
                                                null,
                                                'Empresa teste2',
                                                'teste´s Beer2',
                                                '123456',
                                                '[{"idTipoTelefone":"1",
                                                   "ddd":"16",
                                                   "numero":123456,
                                                   "contato":"teste2"}]' :: json);
*/

DECLARE vErrorProcedure    TEXT;
        vErrorMessage      TEXT;
        vReturningId       INTEGER;
        vIdCidadeDescripto INTEGER;

BEGIN
    vIdCidadeDescripto = seguranca.descriptografar(pIdCidade) :: INTEGER;

        IF EXISTS(SELECT 1
                  FROM Comercial.ProprietarioFisica
                  WHERE cpf = pCpf)
        THEN
            RETURN
            json_build_object(
                'executionCode', 1,
                'message', 'CPF já cadastrado.'
            );
        END IF;

        IF EXISTS(SELECT 1
                  FROM Comercial.ProprietarioJuridica
                  WHERE cnpj = pCnpj)
        THEN
            RETURN
            json_build_object(
                'executionCode', 2,
                'message', 'CNPJ já cadastrado.'
            );
        END IF;

    INSERT INTO Comercial.Proprietario (
        idcidade,
        cep,
        logradouro,
        numero,
        complemento,
        bairro,
        email,
        ativo,
        idusuariocadastro,
        datacadastro
    ) VALUES (
        vIdCidadeDescripto,
        pCep,
        pLogradouro,
        pNumero,
        pComplemento,
        pBairro,
        pEmail,
        pAtivo,
        pIdusuario,
        CURRENT_TIMESTAMP
    )
    RETURNING id
        INTO vReturningId;

    CASE
        WHEN pTipoProprietario = 'F'
        THEN
            INSERT INTO Comercial.ProprietarioFisica (
                idproprietario,
                nome,
                sobrenome,
                cpf,
                rg,
                datanascimento,
                sexo
            ) VALUES (
                vReturningId,
                pNome,
                pSobrenome,
                pCpf,
                pRg,
                pDataNascimento,
                pSexo);

        WHEN pTipoProprietario = 'J'
        THEN
            INSERT INTO Comercial.ProprietarioJuridica (
                idproprietario,
                razaosocial,
                nomefantasia,
                cnpj
            ) VALUES (
                vReturningId,
                pRazaoSocial,
                pNomeFantasia,
                pCnpj);
    END CASE;

    INSERT INTO Comercial.TelefoneProprietario (
        idproprietario,
        idtipotelefone,
        ddd,
        numero,
        contato
    ) SELECT
          vReturningId,
          "idTipoTelefone",
          "ddd",
          "numero",
          "contato"
      FROM json_to_recordset(pTelefones)
          AS x(
           "idTipoTelefone" SMALLINT,
           "ddd" SMALLINT,
           "numero" INTEGER,
           "ramal" SMALLINT,
           "contato" VARCHAR(50));

    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'OK',
        'content', json_build_object(
            'id', Seguranca.criptografar(vReturningId)
        )
    );
    EXCEPTION WHEN OTHERS
    THEN
        GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
        GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;
END;
$$
LANGUAGE plpgsql;


SELECT seguranca.excluirFuncao('RecursosHumanos', 'ListarCargo');
CREATE OR REPLACE FUNCTION RecursosHumanos.ListarCargo(pStatus   CHAR,
                                                       pPesquisa VARCHAR(200),
                                                       pPagina   INTEGER,
                                                       pLinhas   INTEGER

)
    RETURNS TABLE(
        "id"   VARCHAR(200),
        "nome" RECURSOSHUMANOS.CARGO.NOME%TYPE
    ) AS $$
/*
Documentation
Source............: 
Objective.........: Listar cargo.
Autor.............: Cleber Spirlandeli
Data..............: 18/05/2017
Ex................:
                        SELECT * FROM RecursosHumanos.ListarCargo(null, null, null, null)
*/
BEGIN
    RETURN QUERY
    SELECT
        seguranca.criptografahash(c.id, TRUE) AS idCargo,
        c.nome
    FROM RecursosHumanos.cargo c
    WHERE
        CASE
        WHEN pStatus IS NOT NULL
            THEN
                CASE
                WHEN pStatus = 'I'
                    THEN
                        c.ativo IS FALSE
                WHEN pStatus = 'A'
                    THEN
                        c.ativo IS TRUE
                END
        ELSE TRUE END

        AND

        CASE WHEN pPesquisa IS NOT NULL
            THEN unaccent(c.nome) ILIKE '%' || pPesquisa || '%'
        ELSE
            TRUE
        END
    ORDER BY c.nome
    LIMIT
        CASE WHEN pLinhas > 0 AND pPagina > 0
            THEN pLinhas
        ELSE NULL END
    OFFSET
        CASE WHEN pLinhas > 0 AND pPagina > 0
            THEN (pPagina - 1) * pLinhas
        ELSE NULL END;
END;
$$
LANGUAGE plpgsql;