
-- region ADMINISTRACAO.INSERIRHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.INSERIRHORARIO(
  pIdProfessor VARCHAR,
  pHoraInicio  ADMINISTRACAO.HORARIO.HORARIOINICIO%TYPE,
  pHoraFim     ADMINISTRACAO.HORARIO.HORARIOFIM%TYPE
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: horario.sql
Objetivo..........: Inserir um novo horário
Autor.............: Cleber Spirlandeli
Data..............: 07/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.INSERIRHORARIO(
                                                            'MjAxNy0wNy0xMCAyMl9eKkMuXzZfUzs3',
                                                            '21:00',
                                                            '22:30'
                                                            );
*/

DECLARE vErrorProcedure       TEXT;
        vErrorMessage         TEXT;
        vReturningId          INTEGER;
        vIdProfessorDescripto INTEGER = public.dekryptosgraphein(pIdProfessor);

BEGIN

  INSERT INTO Administracao.Horario (
    horarioinicio,
    horariofim,
    datainsercao,
    usuarioinsercao
  )
  VALUES (
    pHoraInicio,
    pHoraFim,
    CURRENT_TIMESTAMP,
    vIdProfessorDescripto
  )
  RETURNING idhorario
    INTO vReturningId;

  RETURN
  json_build_object(
      'executionCode', 1,
      'message', 'Horário cadastrado com sucesso.',
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

-- region ADMINISTRACAO.LISTARHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.LISTARHORARIO(pIdHorario VARCHAR)
  RETURNS TABLE(
    "horarioId"        VARCHAR(200),
    "inicioHorario"    ADMINISTRACAO.HORARIO.HORARIOINICIO%TYPE,
    "fimHorario"       ADMINISTRACAO.HORARIO.HORARIOFIM%TYPE,
    "insercaoData"     ADMINISTRACAO.HORARIO.DATAINSERCAO%TYPE,
    "insercaoUsuario"  VARCHAR(200),
    "alteracaoData"    ADMINISTRACAO.HORARIO.DATAALTERACAO%TYPE,
    "alteracaoUsuario" VARCHAR(200)
  ) AS $$

/*
Documentação
Arquivo Fonte.....: professor.sql
Objetivo..........: Listar todos os horários ou um especifico
Autor.............: Cleber Spirlandeli
Data..............: 06/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.LISTARHORARIO(null);
                    SELECT * FROM Administracao.ListarHorario('MjAxNy0wNy0xMiAyMF4qXzFfJCU=');
*/

BEGIN

  RETURN QUERY
  SELECT
    public.kryptosgraphein(h.idhorario) :: VARCHAR        AS idhorario,
    h.horarioinicio,
    h.horariofim,
    h.datainsercao,
    public.kryptosgraphein(h.usuarioinsercao) :: VARCHAR  AS usuarioinsercao,
    h.dataalteracao,
    public.kryptosgraphein(h.usuarioalteracao) :: VARCHAR AS usuarioalteracao
  FROM
    Administracao.Horario h
  WHERE
    CASE
    WHEN pIdHorario IS NOT NULL
      THEN
        h.idhorario = public.dekryptosgraphein(pIdHorario) :: INTEGER
    ELSE
      TRUE
    END;

END;
$$
LANGUAGE plpgsql;
--endregion

-- region ADMINISTRACAO.EDITARHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.EDITARHORARIO(
  pIdUsuarioAlteracao VARCHAR(200),
  pIdHorario          VARCHAR(200),
  pHoraInicio         ADMINISTRACAO.HORARIO.HORARIOINICIO%TYPE,
  pHoraFim            ADMINISTRACAO.HORARIO.HORARIOFIM%TYPE
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: horario.sql
Objetivo..........: Editar um horário
Autor.............: Cleber Spirlandeli
Data..............: 10/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.EDITARHORARIO(
                                                              'MjAxNy0wNy0xMCAyM19eKkMuXzZfUzs3',
                                                              'MjAxNy0wNy0xMCAyM19eKkMuXzRfUzs3',
                                                              '08:12',
                                                              '09:12'
                                                              );

*/

DECLARE vErrorProcedure     TEXT;
        vErrorMessage       TEXT;
        vIdHorario          INTEGER = public.dekryptosgraphein(pIdHorario);
        vIdUsuarioAlteracao INTEGER = public.dekryptosgraphein(pIdUsuarioAlteracao);
BEGIN

  IF EXISTS(SELECT 1
            FROM Administracao.Horario
            WHERE idHorario = vIdHorario)
  THEN
    UPDATE ADMINISTRACAO.horario
    SET
      horarioInicio = pHoraInicio,
      horarioFim = pHoraFim,
      dataAlteracao = CURRENT_TIMESTAMP,
      usuarioAlteracao = vIdUsuarioAlteracao
      WHERE
        idHorario = vIdHorario;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Horário editado com sucesso.',
        'content', json_build_object(
            'id', pIdHorario
        )
    );

  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Horário não encontrado.',
        'content', json_build_object(
            'id', pIdHorario
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
CREATE OR REPLACE FUNCTION ADMINISTRACAO.EXCLUIRHORARIO(
  pIdHorario VARCHAR(200)
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: horario.sql
Objetivo..........: Excluir um horário
Autor.............: Cleber Spirlandeli
Data..............: 04/07/2017
Ex................:
                    SELECT * FROM  ADMINISTRACAO.EXCLUIRHORARIO('MjAxNy0wNy0xMCAyM19eKkMuXzRfUzs3');

*/

DECLARE vErrorProcedure TEXT;
        vErrorMessage   TEXT;
        vIdHorario INTEGER = public.dekryptosgraphein(pIdHorario);

BEGIN

  IF EXISTS(SELECT 1
            FROM Administracao.Horario
            WHERE idHorario = vIdHorario)
  THEN
    DELETE FROM Administracao.Horario
    WHERE
      idHorario = vIdHorario;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Horário excluido com sucesso.',
        'content', json_build_object(
            'id', pIdHorario
        )
    );

  ELSE
    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Horário não encontrado.',
        'content', json_build_object(
            'id', pIdHorario
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
--