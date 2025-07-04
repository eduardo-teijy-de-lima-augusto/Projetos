USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[SiapeArquivosD8]    Script Date: 10/04/2025 08:25:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================
-- Author:      <Eduardo Augusto>
-- Create date: <22/02/2024>
-- Description: <Criação da tabela CARGAS..D8Pensionista - Rotina Mensal de atualização>
-- Necessário informar o nome da tabela que está em CARGAS..D8Pensionista na execução da procedure.
-- ================================================================================================================================

CREATE OR ALTER PROCEDURE [dbo].[SiapeArquivosD8]
	 @tabelaPENS NVARCHAR(255)  -- Informar o nome da tabela do mês que está em CARGAS..PENS
	,@tabelaSERV NVARCHAR(255)  -- Informar o nome da tabela do mês que esta em CARGAS..SERV
AS
BEGIN
    DECLARE @InicioOperacao DATETIME, @FimOperacao DATETIME
    DECLARE @Duracao INT
    DECLARE @TempoExecucao CHAR(8)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @IndexSQL NVARCHAR(MAX) = ''
    DECLARE @RowsAfetadas INT
    DECLARE @DescricaoLog NVARCHAR(MAX)
    DECLARE @QuerySQL NVARCHAR(MAX)

	BEGIN TRY
			--============================================================================
			-- Verifica e cria D8Pensionista
			--============================================================================	
    
			IF OBJECT_ID('CARGAS.dbo.D8Pensionista', 'U') IS NOT NULL

			   -- Deleta a tabela para evitar duplicidade dos dados.
			   EXEC('DROP TABLE [CARGAS].[dbo].[D8Pensionista]')
		
			   SET @SQL = 'CREATE TABLE CARGAS.[dbo].[D8Pensionista](
								[Orgao] [nvarchar](20) NULL,
								[Instituidor] [nvarchar](20) NULL,
								[Matricula] [nvarchar](20) NULL,
								[UPAG] [nvarchar](20) NULL,
								[UF] [nvarchar](2) NULL,
								[Nome] [nvarchar](150) NULL,
								[CPF] [nvarchar](11) NULL,
								[Rubrica] [nvarchar](20) NULL,
								[SeqRubrica] [int] NULL,
								[Valor_PMT] [nvarchar](20) NULL,
								[Prazo] [nvarchar](20) NULL,
								[NaoUsar1] [nvarchar](20) NULL,
								[NaoUsar2] [nvarchar](20) NULL,
								[Contrato] [nvarchar](20) NULL,
								[Naousar4] [nvarchar](20) NULL
							);'
		
				EXEC(@SQL)

				-- Log de criação de tabela
				SET @DescricaoLog = 'Tabela D8Pensionista Criada.'
				SET @QuerySQL = @SQL
				INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
				VALUES ('D8Pensionista', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))
    

			--============================================================================	
			-- Inserção em D8Pensionista
			--============================================================================
	
			SET @InicioOperacao= GETDATE()
			SET @SQL = N'INSERT INTO [CARGAS].[dbo].[D8Pensionista] ( Orgao
														,Instituidor
																	 ,Matricula
																	 ,UPAG
																	 ,UF
																	 ,Nome
																	 ,CPF
																	 ,Rubrica
																	 ,SeqRubrica
																	 ,Valor_PMT
																	 ,Prazo
																	 ,NaoUsar1
																	 ,NaoUsar2
																	 ,Contrato
																	 ,NaoUsar4) 
						  SELECT DISTINCT 
									   SUBSTRING([Column 0],1,5)    AS Orgao
									  ,SUBSTRING([Column 0],6,7)    AS Instituidor
									  ,SUBSTRING([Column 0],13,8)   AS Matricula
									  ,SUBSTRING([Column 0],21,9)   AS UPAG
									  ,SUBSTRING([Column 0],30,2)   AS UF
									  ,SUBSTRING([Column 0],32,45)  AS Nome
									  ,SUBSTRING([Column 0],77,11)  AS CPF
									  ,SUBSTRING([Column 0],88,5)   AS Rubrica
									  ,SUBSTRING([Column 0],93,1)   AS SeqRubrica
									  ,SUBSTRING([Column 0],94,11)  AS Valor_PMT
									  ,SUBSTRING([Column 0],105,3)  AS Prazo
									  ,SUBSTRING([Column 0],108,6)  AS NaoUsar1
									  ,SUBSTRING([Column 0],114,12) AS NaoUsar2
									  ,SUBSTRING([Column 0],126,20) AS Contrato
									  ,SUBSTRING([Column 0],146,7)  AS NaoUsar4
						  FROM ' + QUOTENAME('CARGAS') + '..' + QUOTENAME(@tabelaPENS) + ';'
			EXEC (@SQL)

			-- Log de inserção em D8Pensionista
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
			SET @DescricaoLog = 'Dados inseridos em D8Pensionista a partir da tabela ' + @tabelaPENS
			SET @QuerySQL = @SQL
			INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
			VALUES ('D8Pensionista', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))
	

			--============================================================================
			-- Verifica e cria D8Servidor
			--============================================================================
			BEGIN
				IF OBJECT_ID('CARGAS.dbo.D8Servidor', 'U') IS NOT NULL
				-- Deleta a tabela para evitar duplicidade dos dados.
					EXEC('DROP TABLE [CARGAS].[dbo].[D8Servidor]')
		
				SET @SQL = 'CREATE TABLE CARGAS.[dbo].[D8Servidor](
								   [Orgao] [nvarchar](20) NULL,
								   [Matricula] [nvarchar](20) NULL,
								   [UPAG] [nvarchar](20) NULL,
								   [UF] [nvarchar](2) NULL,
								   [Nome] [nvarchar](150) NULL,
								   [CPF] [nvarchar](11) NULL,
								   [Rubrica] [nvarchar](20) NULL,
								   [SeqRubrica] [int] NULL,
								   [Valor_PMT] [nvarchar](20) NULL,
								   [Prazo] [nvarchar](20) NULL,
								   [NaoUsar1] [nvarchar](20) NULL,
								   [NaoUsar2] [nvarchar](20) NULL,
								   [Contrato] [nvarchar](20) NULL,
								   [Naousar4] [nvarchar](20) NULL
							);'
		
				EXEC(@SQL)


				-- Log de criação de tabela
				SET @DescricaoLog = 'Tabela D8Servidor Criada.'
				SET @QuerySQL = @SQL
				INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
				VALUES ('D8Servidor', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))
			END
			--============================================================================	
			-- Inserção em D8Servidor
			--============================================================================
			SET @InicioOperacao= GETDATE()
			SET @SQL = N'INSERT INTO [CARGAS].[dbo].[D8Servidor] ( Orgao
																   ,Matricula
																   ,UPAG
																   ,UF
																   ,Nome
																   ,CPF
																   ,Rubrica
																   ,SeqRubrica
																   ,Valor_PMT
																   ,Prazo
																   ,NaoUsar1
																   ,NaoUsar2
																   ,Contrato
																   ,NaoUsar4) 
						  SELECT DISTINCT 
									 SUBSTRING([Column 0],1,5)     AS Orgao
									,SUBSTRING([Column 0],6,7)     AS Matricula
									,SUBSTRING([Column 0],13,9)    AS UPAG
									,SUBSTRING([Column 0],22,2)    AS UF
									,SUBSTRING([Column 0],24,50)   AS Nome
									,SUBSTRING([Column 0],74,11)   AS CPF
									,SUBSTRING([Column 0],85,5)    AS Rubrica
									,SUBSTRING([Column 0],90,1)    AS SeqRubrica
									,SUBSTRING([Column 0],91,11)   AS Valor_PMT
									,SUBSTRING([Column 0],102,3)   AS Prazo
									,SUBSTRING([Column 0],105,6)   AS NaoUsar1
									,SUBSTRING([Column 0],111,12)  AS NaoUsar2
									,SUBSTRING([Column 0],123,20)  AS Contrato
									,SUBSTRING([Column 0],143,7)   AS NaoUsar4
						  FROM ' + QUOTENAME('CARGAS') + '..' + QUOTENAME(@tabelaSERV) + ';'
			EXEC (@SQL)

			-- Log de inserção em D8Pensionista
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
			SET @DescricaoLog = 'Dados inseridos em D8Servidor a partir da tabela ' + @tabelaSERV
			SET @QuerySQL = @SQL
			INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
			VALUES ('D8Servidor', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

			--==========================================================================
			-- Uniao das tabelas D8Pensionista e D8Servidor para D8ContratoConsolidado
			--==========================================================================
			IF OBJECT_ID('[CARGAS].[dbo].[D8ContratoConsolidado]', 'U') IS NOT NULL
			BEGIN
				--Deleta a tabela para evitar duplicidade dos dados.
				EXEC ('DROP TABLE [CARGAS].[dbo].[D8ContratoConsolidado]')
			END
			-- Efetuando União das duas tabelas para CARGAS..D8ContratoConsolidado
			SET @SQL = N'SELECT [Orgao]
							   ,[Instituidor]
							   ,[Matricula]
							   ,[UPAG]
							   ,[UF]
							   ,[Nome]
							   ,[CPF]
							   ,[Rubrica]
							   ,[SeqRubrica]
							   ,[Valor_PMT]
							   ,[Prazo]
							   ,[NaoUsar1]
							   ,[NaoUsar2]
							   ,[Contrato]
							   ,[Naousar4]
						 INTO [CARGAS].[dbo].[D8ContratoConsolidado] 
						 FROM [CARGAS].[dbo].[D8Pensionista]

						 UNION ALL

						 SELECT [Orgao]
							   ,CAST(0 AS BIGINT)        AS Instituidor
							   ,[Matricula]
							   ,[UPAG]
							   ,[UF]
							   ,[Nome]
							   ,[CPF]
							   ,[Rubrica]
							   ,[SeqRubrica]
							   ,[Valor_PMT]
							   ,[Prazo]
							   ,[NaoUsar1]
							   ,[NaoUsar2]
							   ,[Contrato]
							   ,[NaoUsar4]
						 FROM [CARGAS].[dbo].[D8Servidor];'
			EXEC sp_executesql @SQL

			-- Log de inserção em D8ContratoConsolidado
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
			SET @DescricaoLog = 'Dados inseridos em D8ContratoConsolidado a partir das tabelas D8Pensionista e D8Servidor '
			SET @QuerySQL = @SQL
			INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
			VALUES ('D8ContratoConsolidado', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

			--==========================================================================
			-- Correção dos dados da Tabela D8ContratoConsolidado
			--==========================================================================

			-- Deletando registros invalidos
			SET @InicioOperacao=GETDATE()
			SET @SQL = N'DELETE FROM CARGAS.dbo.D8ContratoConsolidado WHERE Instituidor='''' AND Matricula='''' AND UPAG='''' AND UF=''''';
			SET @QuerySQL = @SQL
			EXEC sp_executesql @SQL;

			-- Log de delete dos registros invalidos
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
			SET @DescricaoLog = N'Registros invalidos removido da tabela D8ContratoConsolidado'
			SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
						 VALUES (''D8ContratoConsolidado'', ''Delete de Registros invalidos'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
			EXEC sp_executesql @SQL;

			--==========================================================================
			-- Altera coluna Valor_PMT da Tabela D8ContratoConsolidado para decimal
			--==========================================================================

			-- Alterando registros
			SET @InicioOperacao=GETDATE()
			SET @SQL = N'ALTER TABLE CARGAS.dbo.D8ContratoConsolidado ALTER COLUMN VALOR_PMT DECIMAL(18,2)';
			SET @QuerySQL = @SQL
			EXEC sp_executesql @SQL;

			-- Log de alteração dos registros
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
			SET @DescricaoLog = N'Alteração da coluna Valor_PMT para decimal(18,2)'
			SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
						 VALUES (''D8ContratoConsolidado'', ''Alter Column'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
			EXEC sp_executesql @SQL;

			--==========================================================================
			-- Update coluna Valor_PMT da Tabela D8ContratoConsolidado /100
			--==========================================================================

			-- Update registros Valor_PMT
			SET @InicioOperacao=GETDATE()
			SET @SQL = N'UPDATE CARGAS.dbo.D8ContratoConsolidado SET Valor_PMT=CAST(VALOR_PMT AS decimal (18,2)) /100';
			SET @QuerySQL = @SQL
			EXEC sp_executesql @SQL;

			-- Log do update
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
			SET @DescricaoLog = N'Update coluna Valor_PMT da Tabela D8ContratoConsolidado /100'
			SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
						 VALUES (''D8ContratoConsolidado'', ''Update coluna Valor_PMT'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
			EXEC sp_executesql @SQL;

			--==========================================================================================
			-- Delete da tabela ContratoConsolidado onde cpf=cpf de BlackListDetalhesPep
			-- ** Solicitado mes de Fevereiro remover Cpfs de Contrato que estejam na BlackListPep
			--==========================================================================================
	
			-- Deletando registros
			SET @InicioOperacao=GETDATE()
			SET @SQL = N'DELETE A FROM [CARGAS].[dbo].[D8ContratoConsolidado] A INNER JOIN [CAMPANHAS].[dbo].[BlackListPep] B ON A.CPF=B.CPF';
			SET @QuerySQL = @SQL
			EXEC sp_executesql @SQL;

			-- Log de delete dos registros invalidos
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
			SET @DescricaoLog = N'Delete dos registros de ContratoConsolidado x BlackListPep onde cpf=cpf'
			SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
						 VALUES (''D8ContratoConsolidado'', ''Delete Registros BlackListPep'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
			EXEC sp_executesql @SQL;



			PRINT ('Processamento concluído com sucesso')

			--==========================================================================
			-- Verifica e cria a tabela MOVEDB..Contrato_NEW
			--==========================================================================

			IF OBJECT_ID('[MOVEDB].[dbo].[Contrato_NEW]', 'U') IS NOT NULL
	
				-- Deleta a tabela para evitar duplicidade de dados
				EXEC ('DROP TABLE [MOVEDB].[dbo].[Contrato_NEW]')

			--Cria a tabela nova para receber os dados de D8ContratoConsolidado
			SET @SQL = N'CREATE TABLE [MOVEDB].[dbo].[Contrato_NEW] (
						  [IdContrato] [int] IDENTITY(1,1) NOT NULL,
						  [CodOrgao] [int] NULL,
						  [Instituidor] [int] NULL,
						  [Matricula] [bigint] NULL,
						  [Cpf] [bigint] NULL,
						  [Nome] [varchar](150) NULL,
						  [Valor] [numeric](18, 2) NULL,
						  [Prazo] [int] NULL,
						  [Banco] [int] NULL,
						  [Upag] [varchar](15) NULL,
						  [UfUpag] [char](2) NULL,
						  [Contrato] [varchar](150) NULL,
						  [Rubrica] [int] NULL,
						  [Tipo] [varchar](10) NULL,
						  [Margem] [numeric](18, 2) NULL,
						  [Ativo] [int] NULL
						 );'
			EXEC (@SQL)

			-- Log de criação de tabela
			SET @DescricaoLog = 'Tabela Contrato_NEW Criada.'
			SET @QuerySQL = @SQL
			INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
			VALUES ('Contrato_NEW', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))

			--=========================================================================================	
			-- Inserção em Contrato_NEW com cruzamento de Rubricas em CARGAS..ListagemRubrica
			--=========================================================================================
			SET @InicioOperacao = GETDATE()
			SET @SQL= N'INSERT INTO MOVEDB..Contrato_NEW 
						SELECT DISTINCT 
							   A.[Orgao]        AS CodOrgao
							  ,[Instituidor]    AS Instituidor
							  ,A.[Matricula]    AS Matricula
							  ,A.[CPF]          AS Cpf
							  ,A.[Nome]         AS Nome
							  ,[Valor_PMT]      AS Valor
							  ,[Prazo]          AS Prazo
							  ,NULL             AS Banco
							  ,A.[UPAG]         AS Upag
							  ,A.[UF]           AS UfUpag
							  ,A.[Contrato]     AS Contrato
							  ,A.[Rubrica]      AS Rubrica 
							  ,B.[Tipo]         AS Tipo
							  ,NULL             AS Margem
							  ,NULL             AS Ativo
						FROM [CARGAS].[dbo].[D8ContratoConsolidado] A
						INNER JOIN [CARGAS].[dbo].[ListagemRubrica] B on A.Rubrica=B.Rubrica;'
			 EXEC sp_executesql @SQL

			-- Log de inserção em Contrato_NEW
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
			SET @DescricaoLog = 'Dados inseridos em Contrato_NEW a partir de ContratoConsolidado x Join com ListagemRubricas'
			SET @QuerySQL = @SQL
			INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
			VALUES ('Contrato_NEW', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))


			--=====================================================================================================
			-- Update coluna Ativo  Contrato_New
			-- Criado campo chamado Tipo para especificar atraves de CARGAS..ListagemRubrica sua origem
			-- Query soma quantas vezes a condição Tipo=E aparece por Matricula e atualiza o campo Ativo
			--=====================================================================================================

			-- Update registros Ativo
			SET @InicioOperacao=GETDATE()
			SET @SQL = N'UPDATE A
							SET A.Ativo = SubQuery.QuantidadeTipo
							FROM MOVEDB..Contrato_NEW A
							JOIN (
								SELECT
									CPF,
									COUNT(*) AS QuantidadeTipo
								FROM MOVEDB..Contrato_NEW
								WHERE TIPO = ''E''
								GROUP BY CPF
							) AS SubQuery
							ON A.CPF = SubQuery.CPF
							WHERE A.TIPO = ''E'';';
			SET @QuerySQL = @SQL
			EXEC sp_executesql @SQL;

			-- Log do update
			SET @RowsAfetadas = @@ROWCOUNT
			SET @FimOperacao = GETDATE()
			SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
			-- Convertendo segundos para formato HH:MM:SS
			SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
								 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
			SET @DescricaoLog = N'Update coluna Ativo da Tabela Contrato_New somando Emprestimos por Matricula'
			SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
						 VALUES (''Contrato_New'', ''Update coluna Ativo'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
			EXEC sp_executesql @SQL;
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
		IF ERROR_MESSAGE() LIKE '%D8Pensionista%'
			SET @TabelaErro = 'D8Pensionista';
		ELSE IF ERROR_MESSAGE() LIKE '%D8Servidor%'
			SET @TabelaErro = 'D8Servidor';
		ELSE IF ERROR_MESSAGE() LIKE '%D8ContratoConsolidado%'
			SET @TabelaErro = 'D8ContratoConsolidado';
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



