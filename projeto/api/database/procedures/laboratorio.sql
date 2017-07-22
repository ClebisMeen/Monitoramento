

-- region ADMINISTRACAO.INSERIRHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.INSERIRLABORATORIO(
  pIdProfessor     VARCHAR,
  pNomeLaboratorio ADMINISTRACAO.LABORATORIO.NOME%TYPE
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: laboratorio.sql
Objetivo..........: Inserir um novo laboratório
Autor.............: Cleber Spirlandeli
Data..............: 09/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.INSERIRLABORATORIO(
                                                            'MjAxNy0wNy0xMyAwMF4qXzhfJCU$',
                                                            'Sala IIIII'
                                                            );

                    SELECT * FROM ADMINISTRACAO.INSERIRLABORATORIO(
                                                            'MjAxNy0wNy0xMyAwMF4qXzBfJCU$',
                                                            'Sala IIIII'
                                                            );
*/

DECLARE vErrorProcedure       TEXT;
        vErrorMessage         TEXT;
        vReturningId          INTEGER;
        vIdProfessorDescripto INTEGER = public.dekryptosgraphein(pIdProfessor);

BEGIN
  IF vIdProfessorDescripto <> 0
  THEN
    INSERT INTO Administracao.Laboratorio (
      nome,
      datainsercao,
      usuarioinsercao
    )
    VALUES (
      pNomeLaboratorio,
      CURRENT_TIMESTAMP,
      vIdProfessorDescripto
    )
    RETURNING idlaboratorio
      INTO vReturningId;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Laboratório cadastrado com sucesso.',
        'content', json_build_object(
            'id', public.kryptosgraphein(vReturningId)
        )
    );
  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Usuário não cadastrado.',
        'content', json_build_object(
            'id', public.kryptosgraphein(pIdProfessor)
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

-- region ADMINISTRACAO.LISTARHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.LISTARLABORATORIO(pIdLaboratorio VARCHAR)
  RETURNS TABLE(
    "laboratorioId"    VARCHAR(200),
    "nomeLaboratorio"  ADMINISTRACAO.LABORATORIO.NOME%TYPE,
    "insercaoData"     ADMINISTRACAO.LABORATORIO.DATAINSERCAO%TYPE,
    "insercaoUsuario"  VARCHAR(200),
    "alteracaoData"    ADMINISTRACAO.LABORATORIO.DATAALTERACAO%TYPE,
    "alteracaoUsuario" VARCHAR(200)
  ) AS $$

/*
Documentação
Arquivo Fonte.....: laboratorio.sql
Objetivo..........: Listar todos os laboratórios ou um especifico
Autor.............: Cleber Spirlandeli
Data..............: 09/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.LISTARLABORATORIO(null);
                    SELECT * FROM ADMINISTRACAO.LISTARLABORATORIO('MjAxNy0wNy0xMyAwMF4qXzJfJCU$');
*/

BEGIN

  RETURN QUERY
  SELECT
    public.kryptosgraphein(p.idlaboratorio) :: VARCHAR    AS idlaboratorio,
    p.nome,
    p.datainsercao,
    public.kryptosgraphein(p.usuarioinsercao) :: VARCHAR  AS usuarioinsercao,
    p.dataalteracao,
    public.kryptosgraphein(p.usuarioalteracao) :: VARCHAR AS usuarioalteracao
  FROM
    Administracao.Laboratorio p
  WHERE
    CASE
    WHEN pIdLaboratorio IS NOT NULL
      THEN
        p.idlaboratorio = public.dekryptosgraphein(pIdLaboratorio) :: INTEGER
    ELSE
      TRUE
    END;

END;
$$
LANGUAGE plpgsql;
--endregion

-- region ADMINISTRACAO.EDITARHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.EDITARLABORATORIO(
  pIdUsuarioAlteracao VARCHAR(200),
  pIdLaboratorio      VARCHAR(200),
  pNomeLaboratorio    ADMINISTRACAO.HORARIO.HORARIOINICIO%TYPE
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: horario.sql
Objetivo..........: Editar um laboratório
Autor.............: Cleber Spirlandeli
Data..............: 10/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.EDITARLABORATORIO(
                                                              'MjAxNy0wNy0xMyAwMF4qXzhfJCU$',
                                                              'MjAxNy0wNy0xMyAwMF4qXzRfJC$',
                                                              'Laboratorio IV'
                                                              );

*/

DECLARE vErrorProcedure     TEXT;
        vErrorMessage       TEXT;
        vIdLaboratorio      INTEGER = public.dekryptosgraphein(pIdLaboratorio);
        vIdUsuarioAlteracao INTEGER = public.dekryptosgraphein(pIdUsuarioAlteracao);
BEGIN

  IF EXISTS(SELECT 1
            FROM Administracao.Laboratorio
            WHERE idlaboratorio = vIdLaboratorio)
  THEN
    UPDATE Administracao.Laboratorio
    SET
      nome             = pNomeLaboratorio,
      dataalteracao    = CURRENT_TIMESTAMP,
      usuarioalteracao = vIdUsuarioAlteracao
    WHERE
      idlaboratorio = vIdLaboratorio;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Laboratório editado com sucesso.',
        'content', json_build_object(
            'id', pIdLaboratorio
        )
    );

  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Laboratório não encontrado.',
        'content', json_build_object(
            'id', pIdLaboratorio
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
CREATE OR REPLACE FUNCTION ADMINISTRACAO.EXCLUIRLABORATORIO(
  pIdLaboratorio VARCHAR(200)
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: laboratorio.sql
Objetivo..........: Excluir um laboratório
Autor.............: Cleber Spirlandeli
Data..............: 09/07/2017
Ex................:
      SELECT * FROM ADMINISTRACAO.EXCLUIRLABORATORIO('MjAxNy0wNy0xMyAwMF4qXzRfJCU$');

*/

DECLARE vErrorProcedure TEXT;
        vErrorMessage   TEXT;
        vIdLaboratorio  INTEGER = public.dekryptosgraphein(pIdLaboratorio);

BEGIN

  IF EXISTS(SELECT 1
            FROM Administracao.Laboratorio
            WHERE idlaboratorio = vIdLaboratorio)
  THEN
    DELETE FROM Administracao.Laboratorio
    WHERE
      idlaboratorio = vIdLaboratorio;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Laboratório excluido com sucesso.',
        'content', json_build_object(
            'id', pIdLaboratorio
        )
    );

  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Laboratório não encontrado.',
        'content', json_build_object(
            'id', pIdLaboratorio
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