-- region ADMINISTRACAO.INSERIRHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.INSERIRLARESERVADO(
  pIdProfessor   VARCHAR,
  pIdLaboratorio VARCHAR,
  pIdHorario     VARCHAR,
  pDetalhe       VARCHAR
)
  RETURNS JSON AS $$

/*
Documentação
Arquivo Fonte.....: reservado.sql
Objetivo..........: Inserir um novo reservado
Autor.............: Cleber Spirlandeli
Data..............: 13/07/2017
Ex................:
    SELECT * FROM ADMINISTRACAO.INSERIRLARESERVADO(
                                                  '',
                                                  '',
                                                  '',
                                                  ''
                                                  );
*/

DECLARE vErrorProcedure         TEXT;
        vErrorMessage           TEXT;
        vReturningId            INTEGER;
        vIdProfessorDescripto   INTEGER = public.dekryptosgraphein(pIdProfessor);
        vIdLaboratorioDescripto INTEGER = public.dekryptosgraphein(pIdLaboratorio);
        vIdHorarioDescripto     INTEGER = public.dekryptosgraphein(pIdHorario);

BEGIN

  IF EXISTS(SELECT 1
            FROM Administracao.Reservado
            WHERE idLaboratorio = vIdHorarioDescripto
                  AND
                  bloqueado = 'N')
  THEN
    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Laboratório se encontra reservado por outro professor.'
    );

  ELSE
    INSERT INTO Administracao.Reservado (
      idProfessor,
      idLaboratorio,
      idHorario,
      detalhe,
      dataInsercao,
      usuarioInsercao,
      excluir,
      bloqueado
    )
    VALUES (
      vIdProfessorDescripto,
      vIdLaboratorioDescripto,
      vIdHorarioDescripto,
      pDetalhe,
      CURRENT_TIMESTAMP,
      vIdProfessorDescripto,
      'N',
      'N'
    )
    RETURNING idReservado
      INTO vReturningId;

    RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Laboratório reservado com sucesso.',
        'content', json_build_object(
            'id', public.kryptosgraphein(vReturningId)
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
CREATE OR REPLACE FUNCTION ADMINISTRACAO.LISTARRESERVADO(pIdReservado VARCHAR)
  RETURNS TABLE(
    "reservadoId"      VARCHAR(200),
    "professorId"      ADMINISTRACAO.HORARIO.HORARIOINICIO%TYPE,
    "laboratorioId"    ADMINISTRACAO.HORARIO.HORARIOFIM%TYPE,
    "ho"               ADMINISTRACAO.HORARIO.DATAINSERCAO%TYPE,
    "insercaoUsuario"  VARCHAR(200),
    "alteracaoData"    ADMINISTRACAO.HORARIO.DATAALTERACAO%TYPE,
    "alteracaoUsuario" VARCHAR(200)
  ) AS $$

/*
Documentação
Arquivo Fonte.....: reservado.sql
Objetivo..........: Listar todos os laboratórios reservados ou um laboratório reservado especifico
Autor.............: Cleber Spirlandeli
Data..............: 13/07/2017
Ex................:
                    SELECT * FROM ADMINISTRACAO.LISTARRESERVADO(null);
                    SELECT * FROM Administracao.LISTARRESERVADO('MjAxNy0wNy0xMiAyMF4qXzFfJCU=');
*/

BEGIN

  RETURN QUERY
  SELECT
    public.kryptosgraphein(r.idReservado) :: VARCHAR   AS idReservado,
    public.kryptosgraphein(r.idProfessor) :: VARCHAR   AS idProfessor,
    public.kryptosgraphein(r.idLaboratorio) :: VARCHAR AS idLaboratorio,
    public.kryptosgraphein(r.idHorario) :: VARCHAR     AS idHorario,
    r.detalhe,
    r.dataInsercao,
    r.usuarioInsercao
  FROM
    Administracao.Reservado r
  WHERE
    CASE
    WHEN pIdReservado IS NOT NULL
      THEN
        r.idReservado = public.dekryptosgraphein(pIdReservado) :: INTEGER
    ELSE
      TRUE
    END
    AND
    bloqueado = 'N'
    AND
    excluir = 'N';

END;
$$
LANGUAGE plpgsql;
--endregion

-- region ADMINISTRACAO.EDITARHORARIO
CREATE OR REPLACE FUNCTION ADMINISTRACAO.EDITARHORARIO(
  pIdUsuarioAlteracao VARCHAR(200),
  pIdReservado        VARCHAR(200),
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
      horarioInicio    = pHoraInicio,
      horarioFim       = pHoraFim,
      dataAlteracao    = CURRENT_TIMESTAMP,
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
        vIdHorario      INTEGER = public.dekryptosgraphein(pIdHorario);

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