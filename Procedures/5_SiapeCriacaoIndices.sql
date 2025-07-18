USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[SiapeCriacaoIndices]    Script Date: 10/04/2025 08:26:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================================================================================
-- Author:      <Eduardo Augusto>
-- Create date: <18/02/2024>
-- Description: <Criação de indices e troca das tabelas - Rotina Mensal de atualização>
-- ===============================================================================================================================================================================

-- Cria a procedure
CREATE OR ALTER         PROCEDURE [dbo].[SiapeCriacaoIndices]
AS
BEGIN



	
    SET NOCOUNT ON;
	-- ================================================================================================================================
	--Declaração das variáveis.
    -- ================================================================================================================================
	DECLARE @InicioOperacao DATETIME, @FimOperacao DATETIME 
	DECLARE @Duracao INT
    DECLARE @IndexSQL NVARCHAR(MAX) = ''
	DECLARE @Descricao NVARCHAR(MAX)
	DECLARE @TempoExecucao CHAR(8)
	DECLARE @QuerySQL NVARCHAR(MAX)
	DECLARE @QueryLog NVARCHAR(MAX)
	DECLARE @RowsAfetadas INT

	-- ================================================================================================================================
	-- Índices para Consolidado_NEW
	-- ================================================================================================================================
    BEGIN TRY
	SET @InicioOperacao = GETDATE()
    SET @IndexSQL = 
        N'CREATE NONCLUSTERED INDEX [Idx_Consolidade_BaseCalc] ON MOVEDB..Consolidado_NEW ([BaseCalc] ASC)
          CREATE CLUSTERED INDEX [Idx_Consolidado_Cpf] ON MOVEDB..Consolidado_NEW ([Cpf] ASC)
          CREATE NONCLUSTERED INDEX [IDX_N_CLU_BaseCalc_MargemSaldo] ON MOVEDB..Consolidado_NEW ([BaseCalc] ASC, [MargemSaldo] ASC)
          CREATE NONCLUSTERED INDEX [IDX_N_CLU_BaseCalc_SituacaoFuncional_MargemSaldo_INCLUDE_Orgao] ON MOVEDB..Consolidado_NEW ([BaseCalc] ASC, [SituacaoFuncional] ASC, [MargemNova] ASC) INCLUDE([Orgao]) 
          CREATE NONCLUSTERED INDEX [IDX_N_CLU_OrgaoBaseCalSitucaoFuncionalMargemSaldo] ON MOVEDB..Consolidado_NEW ([Orgao] ASC, [BaseCalc] ASC, [SituacaoFuncional] ASC, [MargemNova] ASC);';
    EXEC sp_executesql @IndexSQL;
	SET @FimOperacao = GETDATE()
	SET @Duracao = DATEDIFF(SECOND,@InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    SET @Descricao = 'Indices na tabela Consolidado_NEW criado.'
    SET @QuerySQL = @IndexSQL

	-- Log na tabela LogOperacoes
    INSERT INTO DB_MONITORAMENTO..LogOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
    VALUES ('Consolidado_NEW', 'Create Index', @Descricao, @TempoExecucao, REPLACE(@QuerySQL, '''', ''''''));

	-- ================================================================================================================================
    -- Índices para Contrato_NEW
	-- ================================================================================================================================
	SET @InicioOperacao = GETDATE()
    SET @IndexSQL = N'CREATE CLUSTERED INDEX [idx_Contrato_CPF] ON MOVEDB..Contrato_NEW ([Cpf] ASC)
                      CREATE NONCLUSTERED INDEX [IDX_N_CLU_Prazo_Ufupag_INDLUCE_Nome_Rubrica] ON MOVEDB..Contrato_NEW ([Prazo] ASC, [UfUpag] ASC) INCLUDE([Nome],[Rubrica]) 
                      CREATE NONCLUSTERED INDEX [IDX_N_CLU_Rubrica_Prazo_ufuPAG_INCLUDE_nome] ON MOVEDB..Contrato_NEW ([Rubrica] ASC, [Prazo] ASC, [UfUpag] ASC) INCLUDE([Nome]) 
                      CREATE NONCLUSTERED INDEX [IDX_N_CLU_Valor_Prazo_UFUPag_INCLUDE_Nome] ON MOVEDB..Contrato_NEW ([Valor] ASC, [Prazo] ASC, [UfUpag] ASC) INCLUDE([Nome]) 
                      CREATE NONCLUSTERED INDEX [idxnc_Contrato_Rubrica] ON MOVEDB..Contrato_NEW ([Rubrica] ASC) INCLUDE([Cpf])
					  CREATE NONCLUSTERED INDEX [IDX_N_CLU_Ativo] ON MOVEDB..Contrato_NEW ([Ativo] ASC);';
    EXEC sp_executesql @IndexSQL;
	SET @FimOperacao = GETDATE()
	SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    SET @Descricao = 'Indices na tabela Contrato_NEW criado.'
    SET @QuerySQL = @IndexSQL

	-- Log na tabela LogOperacoes
    INSERT INTO DB_MONITORAMENTO..LogOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
    VALUES ('Contrato_NEW', 'Create Index', @Descricao, @TempoExecucao, REPLACE(@QuerySQL, '''', ''''''));

    -- ================================================================================================================================
	-- Rename tabelas: 
	                  -- Contrato para Contrato_OLD e Contrato_NEW para Contrato
	                  -- Consolidado para Consolidado_OLD e Consolidado_NEW para Consolidado
	-- ================================================================================================================================

	-- ================================================================================================================================
	-- Rename Contrato para Contrato_OLD
	-- Rename Contrato_NEW para Contrato
	-- ================================================================================================================================
	-- Início da operação
	SET @InicioOperacao = GETDATE();
	
	-- Verifica se existe a tabela Dados_Pessoais_OLD e deleta
	IF OBJECT_ID('MOVEDB.dbo.Contrato_OLD', 'U') IS NOT NULL
		BEGIN
			DROP TABLE MOVEDB.dbo.Contrato_OLD
        END

	-- Renomeia as tabelas
	   	EXEC sp_rename 'MOVEDB.dbo.Contrato', 'Contrato_OLD';
	   	EXEC sp_rename 'MOVEDB.dbo.Contrato_NEW', 'Contrato';	

	-- Log da operação
	SET @RowsAfetadas = @@ROWCOUNT;
	SET @FimOperacao = GETDATE();
	SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao);
	
	-- Convertendo segundos para formato HH:MM:SS
	SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
	                     RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
	                     RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2);
	
	SET @Descricao = N'Rename Contrato para Contrato_OLD e Contrato_NEW para Contrato';

	SET @QueryLog = N'EXEC sp_rename ''MOVEDB.dbo.Contrato'', ''Contrato_OLD''; ' +  
	                N'EXEC sp_rename ''MOVEDB.dbo.Contrato_NEW'', ''Contrato'';'
	
	-- Preparando a string SQL para inserção de forma segura
	SET @QuerySQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
	             VALUES (''Contrato'', ''Rename da tabela Contrato'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @Descricao + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QueryLog, '''', '''''') + N''')';
	-- Executando a inserção
	EXEC sp_executesql @QuerySQL

	-- ================================================================================================================================
	--Rename Consolidado para Consolidado_OLD
	--Rename Consolidado_NEW para Consolidado
	-- ================================================================================================================================
		-- Início da operação
	SET @InicioOperacao = GETDATE();
	
	-- Verifica se existe a tabela Dados_Pessoais_OLD e deleta
	IF OBJECT_ID('MOVEDB.dbo.Consolidado_OLD', 'U') IS NOT NULL
		BEGIN
			DROP TABLE MOVEDB.dbo.Consolidado_OLD
        END

	-- Renomeia as tabelas
	    EXEC sp_rename 'MOVEDB.dbo.Consolidado', 'Consolidado_OLD';
	   	EXEC sp_rename 'MOVEDB.dbo.Consolidado_NEW', 'Consolidado';	

	-- Log da operação
	SET @RowsAfetadas = @@ROWCOUNT;
	SET @FimOperacao = GETDATE();
	SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao);
	
	-- Convertendo segundos para formato HH:MM:SS
	SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
	                     RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
	                     RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2);
	
	SET @Descricao = N'Rename Consolidado para Consolidado_OLD e Consolidado_NEW para Consolidado';

	SET @QueryLog = N'EXEC sp_rename ''MOVEDB.dbo.Consolidado'', ''Consolidado_OLD''; ' +  
	                N'EXEC sp_rename ''MOVEDB.dbo.Consolidado_NEW'', ''Consolidado'';'
	
	-- Preparando a string SQL para inserção de forma segura
	SET @QuerySQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
	             VALUES (''Consolidado'', ''Rename da tabela Consolidado'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @Descricao + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QueryLog, '''', '''''') + N''')';
	-- Executando a inserção de forma segura usando parâmetros
	EXEC sp_executesql @QuerySQL

	END TRY

	BEGIN CATCH 
	
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		DECLARE @ErrorLine INT;
		DECLARE @TabelaErro NVARCHAR(255);
		DECLARE @EmailSubject NVARCHAR(255);
		DECLARE @EmailBody NVARCHAR(MAX);
		DECLARE @Recipients NVARCHAR(MAX) = 'duaugusto@hotmail.com; mauriciomarinho807@gmail.com';

		-- Captura detalhes do erro
		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE(),
			@ErrorLine = ERROR_LINE();

		-- Determina a tabela que causou o erro
		IF ERROR_MESSAGE() LIKE '%Contrato_NEW%'
			SET @TabelaErro = 'Contrato_NEW';
		ELSE IF ERROR_MESSAGE() LIKE '%Consolidado_NEW%'
			SET @TabelaErro = 'Consolidado_NEW';
		ELSE
			SET @TabelaErro = 'Tabela Desconhecida';

		-- Log do erro
		INSERT INTO DB_MONITORAMENTO..logOperacoes (Usuario, Convenio, NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES (SUSER_NAME(), 'Siape', @TabelaErro, 'Erro', @ErrorMessage, NULL, 'Processo ABORTADO. Verifique e corrija o erro.');

		-- Prepara o email
		SET @EmailSubject = 'Erro no processo Siape - Rotina Mensal';
		SET @EmailBody = 'Ocorreu um erro na tabela: ' + @TabelaErro + CHAR(13) + CHAR(10) +
							'Mensagem de erro: ' + @ErrorMessage + CHAR(13) + CHAR(10) +
							'Linha: ' + CAST(@ErrorLine AS NVARCHAR);

		-- Envia email de notificação de erro
		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Alertas',
			@recipients = @Recipients,
			@subject = @EmailSubject,
			@body = @EmailBody;

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

		RETURN;
	
	END CATCH


END

