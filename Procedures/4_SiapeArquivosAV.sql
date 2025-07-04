USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[SiapeArquivosAV]    Script Date: 10/04/2025 08:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================================
-- Author:      <Eduardo Augusto>
-- Create date: <23/02/2024>
-- Description: <Update das contas correntes dos arquivos AVTXT - Rotina Mensal de atualização>

-- ================================================================================================================================================

CREATE OR ALTER  PROCEDURE [dbo].[SiapeArquivosAV]

AS
BEGIN
	
	BEGIN TRY 
	
    DECLARE @InicioOperacao DATETIME, @FimOperacao DATETIME
	DECLARE @Duracao INT
	DECLARE @TempoExecucao CHAR(8)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @IndexSQL NVARCHAR(MAX) = ''
    DECLARE @RowsAfetadas INT
    DECLARE @DescricaoLog NVARCHAR(MAX)
    DECLARE @QuerySQL NVARCHAR(MAX)
	DECLARE @RebuildIndexLog NVARCHAR(MAX)

	--============================================================================
    -- Verifica e cria CARGAS..CCSiapeServID
    --============================================================================	
    
	IF OBJECT_ID('[CARGAS].[dbo].[CCSiapeServID]', 'U') IS NOT NULL

       -- Deleta a tabela para evitar duplicidade dos dados.
	   EXEC('DROP TABLE [CARGAS].[dbo].[CCSiapeServID]')
		
	   SET @SQL = 'CREATE TABLE CARGAS..CCSiapeServID (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          CAMPO1 VARCHAR(255) );' 
		
        EXEC(@SQL)

        -- Log de criação de tabela
        SET @DescricaoLog = 'Tabela CCSiapeServID Criada para insert Contas Correntes Servidores.'
        SET @QuerySQL = @SQL
        INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
        VALUES ('CCSiapeServID', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))
    

    --============================================================================	
    -- Inserção em CCSiapeServID
    --============================================================================
	
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'INSERT INTO CARGAS..CCSiapeServID(Campo1)
                 SELECT Campo1
                 FROM CARGAS..CCSiapeServ;'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Dados inseridos em CCSiapeServerID a partir das tabelas CARGAS..CCSiapeServidor'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('CCSiapeServerID', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

	--============================================================================
    -- Verifica e cria MOVEDB..CCSiapePensID
    --============================================================================	
    
	IF OBJECT_ID('[CARGAS].[dbo].[CCSiapePensID]', 'U') IS NOT NULL

       -- Deleta a tabela para evitar duplicidade dos dados.
	   EXEC('DROP TABLE [CARGAS].[dbo].[CCSiapePensID]')
		
	   SET @SQL = 'CREATE TABLE CARGAS..CCSiapePensID (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          CAMPO1 VARCHAR(255) );' 
		
        EXEC(@SQL)

        -- Log de criação de tabela
        SET @DescricaoLog = 'Tabela CCSiapePensID Criada para insert Contas Correntes Servidores.'
        SET @QuerySQL = @SQL
        INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
        VALUES ('CCSiapePensID', 'Create Table', @DescricaoLog, '00:00:00', REPLACE(@QuerySQL, '''', ''''''))
    

    --============================================================================	
    -- Inserção em CCSiapePensID
    --============================================================================
	
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'INSERT INTO CARGAS..CCSiapePensID(Campo1)
                 SELECT Campo1
                 FROM CARGAS..CCSiapePens;'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Dados inseridos em CCSiapeServID a partir das tabelas CARGAS..CCSiapeServidor'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('CCSiapeServID', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

    --============================================================================	
    -- Inserção em CCSiapeServidor já tratado a partir de CCSiapeServID.
    --============================================================================
	IF OBJECT_ID('[CARGAS].[dbo].[CCSiapeServidor]', 'U') IS NOT NULL

       -- Deleta a tabela para evitar duplicidade dos dados.
	   EXEC('DROP TABLE [CARGAS].[dbo].[CCSiapeServidor]')

	SET @InicioOperacao= GETDATE()
    SET @SQL = N'SELECT DISTINCT
                        LEFT(CAMPO1, 8) AS MATRICULA,
                        (select SUBSTRING(CAMPO1, 32,12)  from CARGAS..CCSiapeServID
                        where id = a.id + 1 ) CPF,
                        SUBSTRING(CAMPO1, 18,50) AS NOME,
                        SUBSTRING(CAMPO1, 10,7) AS ORIGEM,
                        LEFT(RIGHT(CAMPO1,34),4) AS BANCO,
                        SUBSTRING(RIGHT(CAMPO1,34),6,7) AS AGENCIA,
                        SUBSTRING(RIGHT(CAMPO1,34),14,14) AS CONTA_CORRENTE
                        INTO CARGAS..CCSiapeServidor
                        FROM CARGAS..CCSiapeServID A
                        WHERE ISNUMERIC (LEFT(CAMPO1,7))=1 
                        AND LEFT(CAMPO1,4) <>''0000'' 
	                    AND LEFT(CAMPO1,1) <> '' '' 
	                    AND LEFT(CAMPO1,5) <> ''10000''
	                    AND LEFT(RIGHT(CAMPO1,34),4) <> ''''
	                    AND ISNUMERIC (LEFT(RIGHT(CAMPO1,34),4)) =1
	                    AND LEFT(CAMPO1, 8) <> ''00100000''
	                    AND SUBSTRING(CAMPO1, 18,2) <> ''  ''
                        --Abaixo precisamos nos certificar se vamos usar assim ou nao.
                        --AND NOT EXISTS (SELECT TOP 1 1 FROM MOVEDB..CONSOLIDADO B WHERE B.Matricula=SUBSTRING(A.campo1, 1,7))
	                    ORDER BY 3;'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Dados inseridos em CCSiapeServidor a partir das tabelas CARGAS..CCSiapeServID'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('CCSiapeServidor', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

    --============================================================================	
    -- Inserção em CCSiapePensionista já tratado a partir de CCSiapePensID.
    --============================================================================
	IF OBJECT_ID('[CARGAS].[dbo].[CCSiapePensionista]', 'U') IS NOT NULL

       -- Deleta a tabela para evitar duplicidade dos dados.
	   EXEC('DROP TABLE [CARGAS].[dbo].[CCSiapePensionista]')

	SET @InicioOperacao= GETDATE()
    SET @SQL = N'  SELECT distinct   
                        LEFT(CAMPO1, 8) AS MATRICULA,
                        SUBSTRING(CAMPO1, 12, 57) AS NOME,
                        (select substring ( campo1, 78,12)  from CARGAS..CCSiapePensID
                        where id = a.id + 1 ) CPF,
                        (select substring ( campo1, 2,7)  from CARGAS..CCSiapePensID
                        where id = a.id + 1 ) Instituidor,
                        (select substring ( campo1, 12, 57)  from CARGAS..CCSiapePensID
                        where id = a.id + 1 ) NomeInstituidor,
                        (select LEFT(RIGHT(CAMPO1,27),4)  from CARGAS..CCSiapePensID
                        where id = a.id + 1 ) Banco,
                        (select SUBSTRING(RIGHT(CAMPO1,27),6,7)  from CARGAS..CCSiapePensID
                        where id = a.id + 1 ) Agencia,
                        (select SUBSTRING(RIGHT(CAMPO1,27),14,14)  from CARGAS..CCSiapePensID
                        where id = a.id + 1 ) Conta_Corrente,
                        left(RIGHT(CAMPO1,19),10) AS NATUREZA
                        INTO [CARGAS]..[CCSiapePensionista]
                        FROM [CARGAS]..[CCSiapePensID] A
                        WHERE ISNUMERIC (LEFT(CAMPO1,7))=1 
                          AND LEFT(CAMPO1,4) <>''0000'' 
	                      AND LEFT(CAMPO1,1) <> ''''
	                      AND LEFT(CAMPO1,5) <> ''10000'';'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Dados inseridos em CCSiapePensionista a partir das tabelas CARGAS..CCSiapePensID'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('CCSiapePensionista', 'Insert de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

    --============================================================================	
    -- Update em CCSiapeServidor.
    --============================================================================
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'UPDATE CARGAS..CCSiapeServidor SET CPF=REPLACE(CPF,''-'','''');'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Update do CPF na tabela CCSiapeServidor'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('CCSiapeServidor', 'Update de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))


	--============================================================================	
    -- Insert Cpfs Cadastro/Consolidado 
    --============================================================================

	-- Insere dados dos cpfs que estao em consolidado e nao estao em cadastro 
	-- Busca do nome da mae, data de nascimento e sexo
		SET @InicioOperacao= GETDATE()
		SET @SQL = '
			INSERT INTO MOVEDB..Cadastro(nr_cpf, ds_nome, ds_nome_mae, dt_nascimento)
			SELECT DISTINCT A.CPF, C.Nome, C.NomeMae, C.DataNascimento
			FROM MOVEDB..Consolidado_NEW A
			LEFT JOIN MOVEDB..Cadastro B on A.CPF=B.NR_CPF
			INNER JOIN CARGAS..CPF C ON A.CPF=C.CPF
			WHERE B.NR_CPF IS NULL';

		EXEC (@SQL)
		-- Log de inserção em CCSiapeServID
		SET @RowsAfetadas = @@ROWCOUNT
		SET @FimOperacao = GETDATE()
		SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
		-- Convertendo segundos para formato HH:MM:SS
		SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
							 RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
		SET @DescricaoLog = 'Insert CPF Cadastro, usando a consolidado, somente os que nao existe'
		SET @QuerySQL = @SQL
		INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
		VALUES ('CADASTRO', 'INSERT CPF/CADASTRO', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))


    --============================================================================	
    -- Update em CCSiapePensionista.
    --============================================================================
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'UPDATE CARGAS..CCSiapePensionista SET CPF=REPLACE(CPF,''-'','''');'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Update do CPF na tabela CCSiapePensionista'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('CCSiapePensionista', 'Update de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

    --==================================================================================	
    -- Update Contas Correntes em MOVEDB..Cadastro da tabela CARGAS..CCSiapePensionista.
    --==================================================================================
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'UPDATE A SET A.cs_banco=B.Banco ,A.agencia=B.Agencia ,A.conta_corrente = B.conta_corrente FROM MOVEDB..Cadastro A INNER JOIN CARGAS..CCSiapePensionista B ON A.nr_CPF=TRY_CAST(B.CPF AS BIGINT);'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Update de Contas Correntes em MOVEDB..Cadastro da tabela CARGAS..CCSiapePensionista'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('Cadastro', 'Update de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

    --==================================================================================	
    -- Update Contas Correntes em MOVEDB..Cadastro da tabela CARGAS..CCSiapeServidor.
    --==================================================================================
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'UPDATE A SET A.cs_banco=B.Banco ,A.agencia=B.Agencia ,A.conta_corrente = B.conta_corrente FROM MOVEDB..Cadastro A INNER JOIN CARGAS..CCSiapeServidor B ON A.nr_CPF=TRY_CAST(B.CPF AS BIGINT);'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Update de Contas Correntes em MOVEDB..Cadastro da tabela CARGAS..CCSiapeServidor'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('Cadastro', 'Update de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

	--==================================================================================	
    -- Update MOVEDB..Orgao setando os órgaos de consolidado que estão em órgao.
	-- Seta a coluna Ativo para 1 no Inner Join e seta para 0 o left join
	-- Alteração efetuada em 20/05/2025
    --==================================================================================
	SET @InicioOperacao= GETDATE()
    SET @SQL = N'UPDATE A
				SET A.Ativo = CASE 
				                 WHEN B.ORGAO IS NOT NULL THEN 1  
				                 ELSE 0                           
				              END
				FROM MOVEDB..Orgao A
				LEFT JOIN MOVEDB..Consolidado_NEW B ON A.Id = B.ORGAO;'
    EXEC (@SQL)

    -- Log de inserção em CCSiapeServID
	SET @RowsAfetadas = @@ROWCOUNT
	SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    -- Convertendo segundos para formato HH:MM:SS
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @DescricaoLog = 'Update MOVEDB..Orgao setando os orgaos de consolidado que estao em orgao.'
    SET @QuerySQL = @SQL
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
    VALUES ('Orgao', 'Update de Dados', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''''''', ''''''))

    --==================================================================================	
    -- Rebuild dos índices da tabela MOVEDB..Cadastro e registro de log para cada operação
    --==================================================================================
   
    -- Rebuild do índice IDX_Cpf
    SET @InicioOperacao = GETDATE()
    SET @IndexSQL = 'ALTER INDEX [Idx_Cpf] ON [MOVEDB].[dbo].Cadastro REBUILD WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);'
    EXEC sp_executesql @IndexSQL
    
    SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @RebuildIndexLog = 'Rebuild do índice IDX_Cpf completado'
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
    VALUES ('Cadastro', 'Rebuild Index', @RebuildIndexLog, @TempoExecucao, REPLACE(@IndexSQL, '''', ''''''))
    
    -- Rebuild do índice IDX_N_CLU_cs_banco_data_nasc_INDLUCE_acionado
    SET @InicioOperacao = GETDATE()
    SET @IndexSQL = 'ALTER INDEX [IDX_N_CLU_cs_banco_data_nasc_INDLUCE_acionado] ON [MOVEDB].[dbo].Cadastro REBUILD WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);'
    EXEC sp_executesql @IndexSQL
    
    SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @RebuildIndexLog = 'Rebuild do índice IDX_N_CLU_cs_banco_data_nasc_INDLUCE_acionado completado'
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
    VALUES ('Cadastro', 'Rebuild Index', @RebuildIndexLog, @TempoExecucao, REPLACE(@IndexSQL, '''', ''''''))
    
    -- Rebuild do índice IDX_N_CLU_Data_nasc_INDLUCE_Acionado
    SET @InicioOperacao = GETDATE()
    SET @IndexSQL = 'ALTER INDEX [IDX_N_CLU_Data_nasc_INDLUCE_Acionado] ON [MOVEDB].[dbo].Cadastro REBUILD WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);'
    EXEC sp_executesql @IndexSQL
    
    SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @RebuildIndexLog = 'Rebuild do índice IDX_N_CLU_Data_nasc_INDLUCE_Acionado completado'
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
    VALUES ('Cadastro', 'Rebuild Index', @RebuildIndexLog, @TempoExecucao, REPLACE(@IndexSQL, '''', ''''''))
    
    -- Rebuild do índice IDX_N_CLU_DataNascimento
    SET @InicioOperacao = GETDATE()
    SET @IndexSQL = 'ALTER INDEX [IDX_N_CLU_DataNascimento] ON [MOVEDB].[dbo].Cadastro REBUILD WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);'
    EXEC sp_executesql @IndexSQL
    
    SET @FimOperacao = GETDATE()
    SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)
    SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                         RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)
    
    SET @RebuildIndexLog = 'Rebuild do índice IDX_N_CLU_DataNascimento completado'
    INSERT INTO DB_MONITORAMENTO..logOperacoes (NomeTabela, Operacao, Descricao, TempoExecucao, Query)
    VALUES ('Cadastro', 'Rebuild Index', @RebuildIndexLog, @TempoExecucao, REPLACE(@IndexSQL, '''', ''''''))
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
		IF ERROR_MESSAGE() LIKE '%CCSiapeServID%'
			SET @TabelaErro = 'CCSiapePensID';
		ELSE IF ERROR_MESSAGE() LIKE '%CCSiapePensID%'
			SET @TabelaErro = 'CCSiapePensID';
		ELSE IF ERROR_MESSAGE() LIKE '%Cadastro%'
			SET @TabelaErro = 'Cadastro';
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

