

-- region SEGURANCA.INSERIRPROFESSOR
CREATE OR REPLACE FUNCTION SEGURANCA.INSERIRPROFESSOR(
  pIdUsuario VARCHAR,
  pNome      SEGURANCA.PROFESSOR.NOME%TYPE,
  pEmail     SEGURANCA.PROFESSOR.EMAIL%TYPE,
  pSenha     SEGURANCA.PROFESSOR.SENHA%TYPE,
  pTelefone  SEGURANCA.PROFESSOR.TELEFONE%TYPE
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: professor.sql
Objetivo..........: Inserir um novo professor
Autor.............: Cleber Spirlandeli
Data..............: 04/07/2017
Ex................: SELECT * FROM Seguranca.InserirProfessor(
                                                            'MjAxNy0wNy0wOCAxOV9eKkMuXzVfUzs3',
                                                            'apagar',
                                                            'apagar@ste.com',
                                                            '123',
                                                            '123-000'
                                                            );

*/

DECLARE vErrorProcedure TEXT;
        vErrorMessage   TEXT;
        vReturningId    INTEGER;
        vIdUsuarioDescripto INTEGER = public.dekryptosgraphein(pIdUsuario);

BEGIN

  RAISE NOTICE 'vIdUsuarioDescripto: %', vIdUsuarioDescripto;

  IF EXISTS(SELECT 1
            FROM Seguranca.Professor
            WHERE email = pEmail)
  THEN
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Email já cadastrado.'
    );
  END IF;

  INSERT INTO SEGURANCA.professor (
    nome,
    email,
    senha,
    telefone,
    datainsercao,
    usuarioinsercao
  )
  VALUES (
    pNome,
    pEmail,
    pSenha,
    pTelefone,
    CURRENT_TIMESTAMP,
    vIdUsuarioDescripto
  )
  RETURNING idprofessor
    INTO vReturningId;

  RETURN
  json_build_object(
      'executionCode', 1,
      'message', 'Professor cadastrado com sucesso.',
      'content', json_build_object(
          'id', public.kryptosgraphein(vReturningId)
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
--endregion

-- region SEGURANCA.LISTARPROFESSOR
-- DROP FUNCTION seguranca.listarprofessor();
CREATE OR REPLACE FUNCTION SEGURANCA.LISTARPROFESSOR(pIdProfessor VARCHAR)
  RETURNS TABLE(
    idprof            VARCHAR,
    nomeProfessor     VARCHAR,
    emailProfessor    VARCHAR,
    telefoneProfessor VARCHAR
  ) AS $$

/*
Documentação
Arquivo Fonte.....: professor.sql
Objetivo..........: Listar todos os professores
Autor.............: Cleber Spirlandeli
Data..............: 06/07/2017
Ex................:
                    SELECT * FROM Seguranca.ListarProfessor(null);
                    SELECT * FROM Seguranca.ListarProfessor('MjAxNy0wNy0wOCAyMl9eKkMuXzZfUzs3');
*/

DECLARE vErrorProcedure TEXT;
        vErrorMessage   TEXT;
        vIdProfessorDescripto INTEGER;

BEGIN

  IF pIdProfessor ISNULL
  THEN
    RETURN QUERY
    SELECT
      public.kryptosgraphein(idprofessor),
      nome,
      email,
      telefone
    FROM
      Seguranca.Professor;

  ELSE

    vIdProfessorDescripto = public.dekryptosgraphein(pIdProfessor);

    RETURN QUERY
    SELECT
      public.kryptosgraphein(idprofessor),
      nome,
      email,
      telefone
    FROM
      Seguranca.Professor
    WHERE
      idprofessor = vIdProfessorDescripto;
  END IF;

  EXCEPTION WHEN OTHERS
  THEN
    GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
    GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
    RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;

END;
$$
LANGUAGE plpgsql;
--endregion

-- region SEGURANCA.EDITARPROFESSOR
-- DROP FUNCTION seguranca.editarprofessor(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION SEGURANCA.EDITARPROFESSOR(
  pIdProfessor VARCHAR,
  pNome        SEGURANCA.PROFESSOR.NOME%TYPE,
  pEmail       SEGURANCA.PROFESSOR.EMAIL%TYPE,
  pSenha       SEGURANCA.PROFESSOR.SENHA%TYPE,
  pTelefone    SEGURANCA.PROFESSOR.TELEFONE%TYPE
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: professor.sql
Objetivo..........: Editar um professor
Autor.............: Cleber Spirlandeli
Data..............: 04/07/2017
Ex................:
                    SELECT * FROM Seguranca.EditarProfessor(
                                                            'MjAxNy0wNy0wOCAxOV9eKkMuXzhfUzs3',
                                                            'cleber 88',
                                                            'teste_88@aaa.com',
                                                            '12388',
                                                            '123-888'
                                                            );

*/

DECLARE vErrorProcedure TEXT;
        vErrorMessage   TEXT;
        vIdProfessorDescripto INTEGER = public.dekryptosgraphein(pIdProfessor);

BEGIN

  IF EXISTS(SELECT 1
            FROM Seguranca.Professor
            WHERE idprofessor = vIdProfessorDescripto)
  THEN
    UPDATE Seguranca.Professor
    SET
      nome     = pNome,
      email    = pEmail,
      senha    = pSenha,
      telefone = pTelefone,
      usuarioalteracao = vIdProfessorDescripto,
      dataalteracao = CURRENT_TIMESTAMP
    WHERE
      idprofessor = vIdProfessorDescripto;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Professor editado com sucesso.',
        'content', json_build_object(
            'id', pIdProfessor
        )
    );

  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Professor não encontrado.',
        'content', json_build_object(
            'id', pIdProfessor
        )
    );
  END IF;

  EXCEPTION WHEN OTHERS
  THEN
    GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
    GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
    RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;
END;
$$
LANGUAGE plpgsql;
--endregion

-- region SEGURANCA.EXCLUIRPROFESSOR
-- DROP FUNCTION seguranca.excluirprofessor(INTEGER);
CREATE OR REPLACE FUNCTION SEGURANCA.EXCLUIRPROFESSOR(
  pIdProfessor VARCHAR
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: professor.sql
Objetivo..........: Excluir um professor
Autor.............: Cleber Spirlandeli
Data..............: 04/07/2017
Ex................:
                    SELECT * FROM Seguranca.ExcluirProfessor('MjAxNy0wNy0wOCAxOV9eKkMuXzVfUzs3');

*/

DECLARE vErrorProcedure TEXT;
        vErrorMessage   TEXT;
        vIdProfessorDescripto INTEGER = public.dekryptosgraphein(pIdProfessor);

BEGIN

  IF EXISTS(SELECT 1
            FROM Seguranca.Professor
            WHERE idprofessor = vIdProfessorDescripto)
  THEN
    DELETE FROM Seguranca.Professor
    WHERE
      idprofessor = vIdProfessorDescripto;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Professor excluido com sucesso.',
        'content', json_build_object(
            'id', pIdProfessor
        )
    );

  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Professor não encontrado.',
        'content', json_build_object(
            'id', pIdProfessor
        )
    );
  END IF;

  EXCEPTION WHEN OTHERS
  THEN
    GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
    GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
    RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;
END;
$$
LANGUAGE plpgsql;
--endregion