USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[SiapeTabelasApoio]    Script Date: 10/04/2025 08:26:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[SiapeTabelasApoio]
AS
BEGIN
    DECLARE @InicioOperacao DATETIME, @FimOperacao DATETIME
    DECLARE @Duracao INT
    DECLARE @TempoExecucao CHAR(8)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @RowsAfetadas INT
    DECLARE @DescricaoLog NVARCHAR(MAX)
    DECLARE @QuerySQL NVARCHAR(MAX)
	BEGIN TRY
		--============================================================================
		-- Criação da tabela CARGAS..CCSiapeServ
		--============================================================================
		IF OBJECT_ID('[CARGAS].[dbo].[CCSiapeServ]', 'U') IS NOT NULL
			EXEC('DROP TABLE [CARGAS].[dbo].[CCSiapeServ]')
    
		SET @SQL = 'CREATE TABLE CARGAS..CCSiapeServ (Campo1 VARCHAR(350) NULL);'
		EXEC(@SQL)

		-- Log da criação da tabela CCSiapeServ
		SET @DescricaoLog = 'Tabela CCSiapeServ criada.'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES ('CCSiapeServ', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

		--============================================================================
		-- BULK INSERT dos dados na tabela CARGAS..CCSiapeServ
		--============================================================================
		TRUNCATE TABLE CARGAS..CCSiapeServ

		SET @InicioOperacao = GETDATE()
		SET @SQL = N'BULK INSERT CARGAS..CCSiapeServ
					 FROM ''/mnt/sharewindows/CCSiapeServ.TXT''
					 WITH (
						 FIRSTROW = 2,
						 FIELDTERMINATOR = ''; '',
						 ROWTERMINATOR = ''\n''
					 );'
		EXEC(@SQL)

		-- Log do BULK INSERT em CCSiapeServ
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'BULK INSERT realizado para CCSiapeServ.'
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('CCSiapeServ', 'Bulk Insert', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@SQL, '''', ''''''))

		--============================================================================
		-- Criação da tabela CARGAS..CCSiapePens
		--============================================================================
		IF OBJECT_ID('[CARGAS].[dbo].[CCSiapePens]', 'U') IS NOT NULL
			EXEC('DROP TABLE [CARGAS].[dbo].[CCSiapePens]')
    
		SET @SQL = 'CREATE TABLE CARGAS..CCSiapePens (Campo1 VARCHAR(350) NULL);'
		EXEC(@SQL)

		-- Log da criação da tabela CCSiapePens
		SET @DescricaoLog = 'Tabela CCSiapePens criada.'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES ('CCSiapePens', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

		--============================================================================
		-- BULK INSERT dos dados na tabela CARGAS..CCSiapePens
		--============================================================================
		TRUNCATE TABLE CARGAS..CCSiapePens

		SET @InicioOperacao = GETDATE()
		SET @SQL = N'BULK INSERT CARGAS..CCSiapePens
					 FROM ''/mnt/sharewindows/CCSiapePens.TXT''
					 WITH (
						 FIRSTROW = 2,
						 FIELDTERMINATOR = ''; '',
						 ROWTERMINATOR = ''\n''
					 );'
		EXEC(@SQL)

		-- Log do BULK INSERT em CCSiapePens
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'BULK INSERT realizado para CCSiapePens.'
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('CCSiapePens', 'Bulk Insert', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@SQL, '''', ''''''))

		--============================================================================
		-- Criação da tabela CARGAS..PENS
		--============================================================================
		IF OBJECT_ID('[CARGAS].[dbo].[PENS]', 'U') IS NOT NULL
			EXEC('DROP TABLE [CARGAS].[dbo].[PENS]')
    
		SET @SQL = 'CREATE TABLE CARGAS..PENS ([Column 0] VARCHAR(350) NULL);'
		EXEC(@SQL)

		-- Log da criação da tabela PENS
		SET @DescricaoLog = 'Tabela PENS criada.'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES ('PENS', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

		--============================================================================
		-- BULK INSERT dos dados na tabela CARGAS..PENS
		--============================================================================
		TRUNCATE TABLE CARGAS..PENS

		SET @InicioOperacao = GETDATE()
		SET @SQL = N'BULK INSERT CARGAS..PENS
					 FROM ''/mnt/sharewindows/PENS.TXT''
					 WITH (
						 FIRSTROW = 2,
						 FIELDTERMINATOR = ''; '',
						 ROWTERMINATOR = ''\n''
					 );'
		EXEC(@SQL)

		-- Log do BULK INSERT em PENS
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'BULK INSERT realizado para PENS.'
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('PENS', 'Bulk Insert', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@SQL, '''', ''''''))

		--============================================================================
		-- Criação da tabela CARGAS..SERV
		--============================================================================
		IF OBJECT_ID('[CARGAS].[dbo].[SERV]', 'U') IS NOT NULL
			EXEC('DROP TABLE [CARGAS].[dbo].[SERV]')
    
		SET @SQL = 'CREATE TABLE CARGAS..SERV ([Column 0] VARCHAR(350) NULL);'
		EXEC(@SQL)

		-- Log da criação da tabela SERV
		SET @DescricaoLog = 'Tabela SERV criada.'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES ('SERV', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

		--============================================================================
		-- BULK INSERT dos dados na tabela CARGAS..SERV
		--============================================================================
		TRUNCATE TABLE CARGAS..SERV

		SET @InicioOperacao = GETDATE()
		SET @SQL = N'BULK INSERT CARGAS..SERV
					 FROM ''/mnt/sharewindows/SERV.TXT''
					 WITH (
						 FIRSTROW = 2,
						 FIELDTERMINATOR = ''; '',
						 ROWTERMINATOR = ''\n''
					 );'
		EXEC(@SQL)

		-- Log do BULK INSERT em SERV
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'BULK INSERT realizado para SERV.'
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('SERV', 'Bulk Insert', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@SQL, '''', ''''''))

		--============================================================================
		-- Criação da tabela CARGAS..ConsolidadoServidor
		--============================================================================
		IF OBJECT_ID('[CARGAS].[dbo].[ConsolidadoServidor]', 'U') IS NOT NULL
			EXEC('DROP TABLE [CARGAS].[dbo].[ConsolidadoServidor]')
    
		SET @SQL = 'CREATE TABLE CARGAS..ConsolidadoServidor ([Column 0] VARCHAR(350) NULL);'
		EXEC(@SQL)

		-- Log da criação da tabela ConsolidadoServidor
		SET @DescricaoLog = 'Tabela ConsolidadoServidor criada.'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES ('ConsolidadoServidor', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

		--============================================================================
		-- BULK INSERT dos dados na tabela CARGAS..ConsolidadoServidor
		--============================================================================
		TRUNCATE TABLE CARGAS..ConsolidadoServidor

		SET @InicioOperacao = GETDATE()
		SET @SQL = N'BULK INSERT CARGAS..ConsolidadoServidor
					 FROM ''/mnt/sharewindows/ConsolidadoServidor.TXT''
					 WITH (
						 FIRSTROW = 2,
						 FIELDTERMINATOR = ''; '',
						 ROWTERMINATOR = ''\r\n''
					 );'
		EXEC(@SQL)

		-- Log do BULK INSERT em ConsolidadoServidor
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'BULK INSERT realizado para ConsolidadoServidor.'
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('ConsolidadoServidor', 'Bulk Insert', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@SQL, '''', ''''''))

		--============================================================================
		-- Criação da tabela CARGAS..ConsolidadoPensionista
		--============================================================================
		IF OBJECT_ID('[CARGAS].[dbo].[ConsolidadoPensionista]', 'U') IS NOT NULL
			EXEC('DROP TABLE [CARGAS].[dbo].[ConsolidadoPensionista]')
    
		SET @SQL = 'CREATE TABLE CARGAS..ConsolidadoPensionista ([Column 0] VARCHAR(350) NULL);'
		EXEC(@SQL)

		-- Log da criação da tabela ConsolidadoPensionista
		SET @DescricaoLog = 'Tabela ConsolidadoPensionista criada.'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
		VALUES ('ConsolidadoPensionista', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

		--============================================================================
		-- BULK INSERT dos dados na tabela CARGAS..ConsolidadoPensionista
		--============================================================================
		TRUNCATE TABLE CARGAS..ConsolidadoPensionista

		SET @InicioOperacao = GETDATE()
		SET @SQL = N'BULK INSERT CARGAS..ConsolidadoPensionista
					 FROM ''/mnt/sharewindows/ConsolidadoPensionista.TXT''
					 WITH (
						 FIRSTROW = 2,
						 FIELDTERMINATOR = ''; '',
						 ROWTERMINATOR = ''\r\n''
					 );'
		EXEC(@SQL)

		-- Log do BULK INSERT em ConsolidadoPensionista
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'BULK INSERT realizado para ConsolidadoPensionista.'
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('ConsolidadoPensionista', 'Bulk Insert', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@SQL, '''', ''''''))

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
		IF ERROR_MESSAGE() LIKE '%CCSiapeServ%'
			SET @TabelaErro = 'CCSiapeServ';
		ELSE IF ERROR_MESSAGE() LIKE '%CCSiapePens%'
			SET @TabelaErro = 'CCSiapePens';
		ELSE IF ERROR_MESSAGE() LIKE '%PENS%'
			SET @TabelaErro = 'PENS';
		ELSE IF ERROR_MESSAGE() LIKE '%SERV%'
			SET @TabelaErro = 'SERV';
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
