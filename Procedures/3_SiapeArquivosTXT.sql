USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[SiapeArquivosTXT]    Script Date: 10/04/2025 08:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================================
-- Author:      <Eduardo Augusto>
-- Create date: <23/02/2024>
-- Description: <Criação da tabela MOVEDB..Consolidado a partir de ConsolidadoServidor e ConsolidadoPensionista - Rotina Mensal de atualização>

-- ================================================================================================================================================

CREATE OR ALTER      PROCEDURE .[dbo].[SiapeArquivosTXT]

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
		-- Verifica e cria MOVEDB..Consolidado_NEW
		--============================================================================	
    
		IF OBJECT_ID('[MOVEDB].[dbo].[Consolidado_NEW]', 'U') IS NOT NULL

		   -- Deleta a tabela para evitar duplicidade dos dados.
		   EXEC('DROP TABLE [MOVEDB].[dbo].[Consolidado_NEW]')
		
		   SET @SQL = 'CREATE TABLE MOVEDB..Consolidado_NEW(
							  [Orgao] nvarchar(50) NOT NULL,
							  [Instituidor] nvarchar(50) NULL,
							  [Matricula] nvarchar(50) NULL,
							  [BaseCalc] nvarchar(50) NULL,
							  [Bruta5] nvarchar(50) NULL,
							  [Util5] nvarchar(50) NULL,
							  [Saldo5] nvarchar(50) NULL,
							  [Beneficio5] nvarchar(50) NULL,
							  [BenefUtil5] nvarchar(50) NULL,
							  [BenefSaldo5] nvarchar(50) NULL,
							  [Bruta30] nvarchar(50) NULL,
							  [Util30] nvarchar(50) NULL,
							  [Saldo30] nvarchar(50) NULL,
							  [Bruta70] nvarchar(50) NULL,
							  [Util70] nvarchar(50) NULL,
							  [Saldo70] nvarchar(50) NULL,
							  [RendaBruta] nvarchar(50) NULL,
							  [Desconto] nvarchar(50) NULL,
							  [TotalLiquido] nvarchar(50) NULL,
							  [Upag] [varchar](15) NULL,
							  [Sigla] [char](3) NULL,
							  [Lixo] [varchar](70) NULL,
							  [Rjur] [char](3) NULL,
							  [SituacaoFuncional] [varchar](50) NULL,
							  [MargemNova] nvarchar(50) NULL,
							  [Cartao] bit NULL,
							  [CartaoBeneficio] bit NULL,
							  [Cpf] nvarchar(50) NULL,
							  [MargemSaldo] nvarchar(50) NULL,
							  [Margem_Antiga] nvarchar(50) NULL
					   );' 
		
			EXEC(@SQL)

			-- Log de criação de tabela
			SET @DescricaoLog = 'Tabela Consolidado_NEW Criada.'
			SET @QuerySQL = @SQL
			INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
			VALUES ('Consolidado_NEW', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))
    

		--============================================================================	
		-- Inserção em D8Pensionista
		--============================================================================
	
		SET @InicioOperacao= GETDATE()
		SET @SQL = N'INSERT INTO MOVEDB..Consolidado_NEW
					 SELECT 
						   SUBSTRING([column 0],1,5)     AS Orgao,
						   CAST(0 AS INT)	             AS Instituidor,
						   SUBSTRING([column 0],6,8)     AS Matricula,
						   SUBSTRING([column 0],14,13)   AS BaseCalc,
						   SUBSTRING([column 0],27,13)   AS Bruta5,
						   SUBSTRING([column 0],40,13)   AS Util5,
						   SUBSTRING([column 0],53,13)   AS Saldo5,
						   SUBSTRING([column 0],66,13)   AS Beneficio5,
						   SUBSTRING([column 0],79,13)   AS BenefUtil5,
						   SUBSTRING([column 0],92,13)   AS BenefSaldo5,
						   SUBSTRING([column 0],105,13)  AS Bruta30,
						   SUBSTRING([column 0],118,13)  AS Util30,
						   SUBSTRING([column 0],131,13)  AS Saldo30,
						   SUBSTRING([column 0],144,13)  AS Bruta70,
						   SUBSTRING([column 0],157,13)  AS Util70,
						   SUBSTRING([column 0],170,13)  AS Saldo70,
						   SUBSTRING([column 0],183,13)  AS RendaBruta,
						   SUBSTRING([column 0],196,13)  AS Desconto,
						   SUBSTRING([column 0],209,13)  AS TotalLiquido,
						   SUBSTRING([column 0],222,11)  AS Upag,
						   SUBSTRING([column 0],233,3)   AS Sigla,
						   SUBSTRING([column 0],239,14)  AS Lixo,
						   SUBSTRING([column 0],256,3)   AS Rjur,
						   SUBSTRING([column 0],259,28)  AS SituacaoFuncional,
						   CAST(null AS DECIMAL(18,2))   AS MargemNova,
						   CAST(0 AS bit)                AS Cartao,
						   CAST(0 AS bit)                AS CartaoBeneficio,
						   SUBSTRING([column 0],287,15)  AS CPF,
						   SUBSTRING([column 0],302,13)  AS MargemSaldo,
						   CAST(null AS DECIMAL(18,2))   AS MargemNova
					 FROM CARGAS.dbo.ConsolidadoServidor
					 WHERE [column 0] NOT LIKE ''%===%'' AND [Column 0] NOT LIKE ''%exec%''
	
					 UNION ALL

  					 SELECT 
						   RTRIM(LTRIM(SUBSTRING([column 0],1,6)))     AS Orgao,
						   RTRIM(LTRIM(SUBSTRING([column 0],6,9)))     AS Instituidor,
						   RTRIM(LTRIM(SUBSTRING([column 0],14,9)))    AS Matricula,
						   RTRIM(LTRIM(SUBSTRING([column 0],24,13)))   AS BaseCalc,
						   RTRIM(LTRIM(SUBSTRING([column 0],37,13)))   AS Bruta5,
						   RTRIM(LTRIM(SUBSTRING([column 0],50,13)))   AS Util5,
						   RTRIM(LTRIM(SUBSTRING([column 0],63,13)))   AS Saldo5,
						   RTRIM(LTRIM(SUBSTRING([column 0],76,13)))   AS Beneficio5,
						   RTRIM(LTRIM(SUBSTRING([column 0],89,13)))   AS BenefUtil5,
						   RTRIM(LTRIM(SUBSTRING([column 0],102,13)))  AS BenefSaldo5,
						   RTRIM(LTRIM(SUBSTRING([column 0],115,13)))  AS Bruta30,
						   RTRIM(LTRIM(SUBSTRING([column 0],128,13)))  AS Util30,
						   RTRIM(LTRIM(SUBSTRING([column 0],141,13)))  AS Saldo30,
						   RTRIM(LTRIM(SUBSTRING([column 0],154,13)))  AS Bruta70,
						   RTRIM(LTRIM(SUBSTRING([column 0],167,13)))  AS Util70,
						   RTRIM(LTRIM(SUBSTRING([column 0],180,13)))  AS Saldo70,
						   RTRIM(LTRIM(SUBSTRING([column 0],193,13)))  AS RendBruto,
						   RTRIM(LTRIM(SUBSTRING([column 0],206,13)))  AS Desconto,
						   RTRIM(LTRIM(SUBSTRING([column 0],219,13)))  AS TotalLiquido,
						   RTRIM(LTRIM(SUBSTRING([column 0],232,11)))  AS Upag,
						   RTRIM(LTRIM(SUBSTRING([column 0],243,3)))   AS Sigla,
						   RTRIM(LTRIM(SUBSTRING([column 0],248,14)))  AS Lixo,
						   RTRIM(LTRIM(SUBSTRING([column 0],265,3)))   AS Rjur,
						   RTRIM(LTRIM(SUBSTRING([column 0],270,20)))  AS SituacaoFuncional,
						   CAST(null AS DECIMAL(18,2))   AS MargemNova,
						   CAST(0 AS bit)                AS Cartao,
						   CAST(0 AS bit)                AS CartaoBeneficio,
						   RTRIM(LTRIM(SUBSTRING([column 0],296,14)))  AS CPF,
						   RTRIM(LTRIM(SUBSTRING([column 0],315,13)))  AS MargemSaldo,
						   CAST(null AS DECIMAL(18,2))   AS MargemNova
					 FROM CARGAS.dbo.ConsolidadoPensionista
					 WHERE [column 0] NOT LIKE ''%===%'' AND [Column 0] NOT LIKE ''%exec%'';'
		EXEC (@SQL)

		-- Log de inserção em Consolidado_NEW
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
		SET @DescricaoLog = 'Dados inseridos em Consolidado_NEW a partir das tabelas CARGAS..ConsolidadoServidor e ConsolidadoPensionista '
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('Consolidado_NEW', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

		--============================================================================	
		-- Correção dos dados de Consolidado_NEW
		--============================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL = N'UPDATE MOVEDB..Consolidado_NEW
					 SET
						BaseCalc =     COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(BaseCalc, ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Bruta5 =       COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Bruta5,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Util5 =        COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Util5,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Saldo5 =       COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Saldo5,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Beneficio5 =   COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Beneficio5,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						BenefUtil5 =   COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(BenefUtil5,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						BenefSaldo5 =  COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(BenefSaldo5,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Bruta30 =      COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Bruta30,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Util30 =       COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Util30,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Saldo30 =      COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Saldo30,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Bruta70 =      COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Bruta70,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Util70 =       COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Util70,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Saldo70 =      COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Saldo70,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						RendaBruta =   COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(RendaBruta,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						Desconto =     COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(Desconto,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						TotalLiquido = COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(TotalLiquido,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0''),
						CPF =          REPLACE(REPLACE(CPF, ''.'', ''''), ''-'', ''''),
						MargemSaldo =  COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(MargemSaldo,  ''.'', ''''), '','', ''.''), ''R$'', ''''), ''''), ''0'');'
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de Correção dados
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Update valores numéricos e cpf corrigidos na tabela Consolidado_NEW'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''Consolidado_NEW'', ''Update de Valores numéricos e CPF'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
		EXEC sp_executesql @SQL;

		--===============================================================================================
		--Alteração dos campos para decimal padrão sql.
		--===============================================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL= N'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN BaseCalc      decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Bruta5        decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Util5         decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Saldo5        decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Beneficio5    decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN BenefUtil5    decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN BenefSaldo5   decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Bruta30       decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Util30        decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Saldo30       decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Bruta70       decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Util70        decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Saldo70       decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN RendaBruta    decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Desconto      decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN TotalLiquido  decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN CPF           bigint;'        +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN MargemSaldo   decimal(18,2);' +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Orgao         int;'           +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Instituidor   bigint;'        +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Matricula     bigint;'        +
				   'ALTER TABLE MOVEDB..Consolidado_NEW ALTER COLUMN Cartao        bit;';          	
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de Alter tipagem dos dados
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Alter de colunas para tipagem correta na tabela Consolidado_NEW'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''Consolidado_NEW'', ''Alter Column'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
		EXEC sp_executesql @SQL;

		--===============================================================================================
		--Delete de Consolidado_NEW x BlackListPep onde cpf=cpf (Pessoas Politicamente expostas).
		--Solicitação efetuada pela liderança em fevereiro/2024.
		--===============================================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL= N' DELETE A FROM MOVEDB.dbo.Consolidado_NEW A INNER JOIN CAMPANHAS.dbo.BlackListPep B ON A.CPF=B.CPF'
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de delete BlackListPep
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Delete de registros na tabela Consolidado_NEW x BlackListPep'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''Consolidado_NEW'', ''Delete de registros Consolidado_NEW'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
		EXEC sp_executesql @SQL;

		--===============================================================================================
		--Update Cartao = 1 onde Util5 > 0
		--===============================================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL= N' UPDATE MOVEDB.dbo.Consolidado_NEW SET Cartao=1 WHERE Util5 > 0'
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de Update Cartao = 1
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Update Cartao=1 onde Util5 > 0'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''Consolidado_NEW'', ''Update de registros Cartao=1 onde Util5 > 0 na tabela Consolidado_NEW'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
		EXEC sp_executesql @SQL;

		--===============================================================================================
		--Update CartaoBeneficio = 1 onde BenefUtil5 > 0
		--===============================================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL= N' UPDATE MOVEDB.dbo.Consolidado_NEW SET CartaoBeneficio=1 WHERE BenefUtil5 > 0'
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de Update Cartao = 1
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Update CartaoBeneficio=1 onde BenefUtil5 > 0'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''Consolidado_NEW'', ''Update de registros CartaoBeneficio=1 onde BenefUtil5 > 0 na tabela Consolidado_NEW'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
		EXEC sp_executesql @SQL;

		--===============================================================================================
		--Update para remover espaços dos campos Upag, Sigla, Rjur e Situação funcional
		--===============================================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL= N' UPDATE MOVEDB.dbo.Consolidado_NEW SET Upag=RTRIM(LTRIM(UPAG)) ,Sigla=RTRIM(LTRIM(SIGLA)) ,Rjur=RTRIM(LTRIM(RJUR)) ,SituacaoFuncional=RTRIM(LTRIM(SituacaoFuncional))'
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de Update Registros
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Update para remoção de espaços > 0'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''Consolidado_NEW'', ''Update para remover espaços dos campos Upag, Sigla, Rjur e Situação funcional na tabela Consolidado_NEW'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
		EXEC sp_executesql @SQL;

		--===============================================================================================
		--Insert de MOVEDB..Cadastro agrupamento de cs_banco em MOVEDB..Bancopagamento
		--===============================================================================================
		SET @InicioOperacao = GETDATE()
		SET @SQL= N'INSERT INTO MOVEDB..BancoPagamento SELECT CS_BANCO, ''1'' FROM MOVEDB..Cadastro WHERE cs_banco NOT IN (SELECT ID FROM BancoPagamento) AND CS_BANCO NOT IN (''888'',''0'') GROUP BY cs_banco'
		SET @QuerySQL=@SQL
		EXEC (@SQL)

		-- Log de Update Registros
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = N'Insert da lista de Bancos de Cadastro para BancoPagamento'
		SET @SQL = N'INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query) 
					 VALUES (''BancoPagamento'', ''Insert lista de Bancos na tabela BancoPagamento'', ''' + CAST(@RowsAfetadas AS NVARCHAR(MAX)) + N''', ''' + @DescricaoLog + N''', ''' + @TempoExecucao + N''', ''' + REPLACE(@QuerySQL, '''', '''''') + N''')';
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
			DECLARE @Recipients NVARCHAR(MAX) =  'duaugusto@hotmail.com; mauriciomarinho807@gmail.com';

			-- Captura detalhes do erro
			SELECT 
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE();

			-- Determina a tabela que causou o erro
			IF ERROR_MESSAGE() LIKE '%Consolidado_NEW%'
				SET @TabelaErro = 'Consolidado_NEW';
			ELSE IF ERROR_MESSAGE() LIKE '%BancoPagamento%'
				SET @TabelaErro = 'BancoPagamento';
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

