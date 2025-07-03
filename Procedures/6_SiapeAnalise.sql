USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[SiapeAnalise]    Script Date: 22/06/2025 11:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================================================================================
-- Author:      <Eduardo Augusto>
-- Create date: <18/02/2024>
-- Description: <Analise de SIAPE>
-- Irá gerar duas tabelas uma de Clientes e outra de Contratos.
-- ===============================================================================================================================================================================

CREATE OR ALTER   PROCEDURE [dbo].[SiapeAnalise]
AS
BEGIN
    DECLARE @InicioOperacao DATETIME, @FimOperacao DATETIME
    DECLARE @Duracao INT
    DECLARE @TempoExecucao CHAR(8)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @RowsAfetadas INT
    DECLARE @DescricaoLog NVARCHAR(MAX)
    DECLARE @QuerySQL NVARCHAR(MAX)
    DECLARE @NomeTabela NVARCHAR(100)


    BEGIN TRY

	    --============================================================================
		-- Gera o select para analise de SIAPE
		-- Analise_SIAPE_Contratos_
		-- Altere a consulta caso seja necessário
		--============================================================================

        -- Define o nome da nova tabela com base na data atual (MM_YYYY)
        SET @NomeTabela = 'Analise_SIAPE_Contratos_' +
                          RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR), 2) +
                          CAST(YEAR(GETDATE()) AS VARCHAR)

        SET @InicioOperacao = GETDATE()

        SET @SQL = '
        SELECT
            A.Vinculo AS Tipo,
            A.Matricula,
            A.Cpf,
            A.Nome,
            A.Rubrica,
            B.NomeRubrica,
            SUM(A.Valor) AS PMT,
            COUNT(*) AS Contratos,
            BN.Banco_Pagamento
        INTO ' + QUOTENAME(@NomeTabela) + '
        FROM MOVEDB..Contrato A
        INNER JOIN CARGAS..NomeRubricas B ON A.Rubrica = B.Rubrica
        INNER JOIN MOVEDB..Cadastro C ON A.CPF = C.NR_CPF
        INNER JOIN CARGAS..BancoNomes BN ON LEFT(BN.Banco_Pagamento, 3) = C.cs_banco
        GROUP BY 
            A.Vinculo,
            A.Matricula,
            A.Cpf,
            A.Nome,
            A.Rubrica,
            B.NomeRubrica,
            BN.Banco_Pagamento;'

        EXEC (@SQL)

        -- Log
        SET @RowsAfetadas = @@ROWCOUNT
        SET @FimOperacao = GETDATE()
        SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)

        SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                             RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                             RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)

        SET @DescricaoLog = 'Dados inseridos em ' + @NomeTabela + ' a partir das tabelas de Contrato, Cadastro, NomeRubricas e BancoNomes.'

        SET @QuerySQL = @SQL

        INSERT INTO DB_MONITORAMENTO..logOperacoes 
        (Usuario, Convenio, NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
        VALUES 
        (SUSER_SNAME(), 'Siape', @NomeTabela, 'Criação e Inserção', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''', ''''''))

	    --============================================================================
		-- Gera o select para analise de SIAPE
		-- Analise_SIAPE_Clientes_
		-- Altere a consulta caso seja necessário
		--============================================================================

        -- Define o nome da nova tabela com base na data atual (MM_YYYY)
        SET @NomeTabela = 'Analise_SIAPE_Clientes_' +
                          RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR), 2) +
                          CAST(YEAR(GETDATE()) AS VARCHAR)

        SET @InicioOperacao = GETDATE()

        SET @SQL = '
        SELECT DISTINCT  A.Cpf
						,B.ds_nome				AS Nome
						,A.Vinculo				AS Tipo
						,A.Matricula
						,B.cs_banco 			AS Banco
						,B.agencia				AS Agencia
						,B.data_nasc			AS Dt_Nascimento
						,A.BaseCalc
						,A.Saldo5				AS SaldoCartaoCredito	--A confirmar coluna
						,A.Beneficio5			AS SaldoCartaoBeneficio --A confirmar coluna
						,A.Saldo30				AS MargemSaldo30		--A confirmar coluna
						,A.Saldo70				AS MargemSaldo70		--A confirmar coluna
						,A.RendaBruta
						,A.Desconto
						,A.TotalLiquido
						,A.Upag
						,A.Sigla
						,A.Rjur
						,A.SituacaoFuncional
						,''False''				AS Cartao				--A confirmar coluna
						,''False''				AS CartaoBeneficio		--A confirmar coluna
						,A.MargemSaldo
		INTO ' + QUOTENAME(@NomeTabela) + '
		FROM Movedb..Consolidado A
		INNER JOIN Movedb..Cadastro B ON A.Cpf=B.nr_cpf;'

        EXEC (@SQL)

        -- Log
        SET @RowsAfetadas = @@ROWCOUNT
        SET @FimOperacao = GETDATE()
        SET @Duracao = DATEDIFF(SECOND, @InicioOperacao, @FimOperacao)

        SET @TempoExecucao = RIGHT('0' + CAST(@Duracao / 3600 AS VARCHAR), 2) + ':' + 
                             RIGHT('0' + CAST((@Duracao % 3600) / 60 AS VARCHAR), 2) + ':' + 
                             RIGHT('0' + CAST(@Duracao % 60 AS VARCHAR), 2)

        SET @DescricaoLog = 'Dados inseridos em ' + @NomeTabela + ' a partir das tabelas de Consolidado, e Cadastro.'

        SET @QuerySQL = @SQL

        INSERT INTO DB_MONITORAMENTO..logOperacoes 
        (Usuario, Convenio, NomeTabela, Operacao, QuantidadeAfetada, Descricao, TempoExecucao, Query)
        VALUES 
        (SUSER_SNAME(), 'Siape', @NomeTabela, 'Criação e Inserção', CAST(@RowsAfetadas AS NVARCHAR(MAX)), @DescricaoLog, @TempoExecucao, REPLACE(@QuerySQL, '''', ''''''))







    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorLine INT;
        DECLARE @TabelaErro NVARCHAR(255);
        DECLARE @EmailSubject NVARCHAR(255);
        DECLARE @EmailBody NVARCHAR(MAX);
        DECLARE @Recipients NVARCHAR(MAX) = 'duaugusto@hotmail.com';

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorLine = ERROR_LINE();

        SET @TabelaErro = @NomeTabela;

        INSERT INTO DB_MONITORAMENTO..logOperacoes 
        (Usuario, Convenio, NomeTabela, Operacao, Descricao, TempoExecucao, Query)
        VALUES 
        (SUSER_SNAME(), 'Siape', @TabelaErro, 'Erro', @ErrorMessage, NULL, 'Processo ABORTADO. Verifique e corrija o erro.')

        SET @EmailSubject = 'Erro no processo Siape - Rotina Mensal';
        SET @EmailBody = 'Ocorreu um erro na tabela: ' + @TabelaErro + CHAR(13) + CHAR(10) +
                         'Mensagem de erro: ' + @ErrorMessage + CHAR(13) + CHAR(10) +
                         'Linha: ' + CAST(@ErrorLine AS NVARCHAR);

        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Alertas',
            @recipients = @Recipients,
            @subject = @EmailSubject,
            @body = @EmailBody;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN;
    END CATCH
END
