USE [MOVEDB]
GO
/****** Object:  StoredProcedure [dbo].[Siape]    Script Date: 10/04/2025 08:23:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================
-- Author:      <Eduardo Augusto>
-- Create date: <22/02/2024>
-- Description: <Rotina troca Tabelas>
-- ================================================================================================================================

CREATE OR ALTER PROCEDURE [dbo].[Siape]

AS
BEGIN 
    DECLARE @NomeProcedure NVARCHAR(255);
    DECLARE @RowsAfetadas INT;

    BEGIN TRY

		 -- Criação da tabela CARGAS..CCSiapeServ , CCSiapePens , ConsolidadoServidor, ConsolidadoPensionista
		 --  BULK INSERT dos dados nas tabelas
		 
		SET @NomeProcedure = 'SiapeTabelasApoio';
		EXEC SiapeTabelasApoio;

		    -- Executa os processos para correção de dados criação da tabela Contrato_NEW e inserts dos Arquivos do tipo D8.
		SET @NomeProcedure = 'SiapeArquivosD8';
		EXEC SiapeArquivosD8 'PENS', 'SERV';
	
		-- Executa a criação da tabela Consolidado_NEW, updates e inserts.
		SET @NomeProcedure = 'SiapeArquivosTXT';
		EXEC SiapeArquivosTXT
	
		-- Update das contas correntes originada dos arquivos AVTXT para tabela MOVEDB..Cadastro
		SET @NomeProcedure = 'SiapeArquivosAV';
		EXEC SiapeArquivosAV
	
		-- ================================================================================================================================
		-- Conta o número de linhas na tabela AtivoZero_NEW
		-- ================================================================================================================================
		SELECT @RowsAfetadas = COUNT(*) FROM [MOVEDB].[dbo].[Consolidado];

		-- Cria os indices das tabelas e faz a troca das mesmas.
		SET @NomeProcedure = 'SiapeCriacaoIndices';
		EXEC SiapeCriacaoIndices

		-- ================================================================================================================================
        -- Envia email de sucesso
		-- ================================================================================================================================
		DECLARE @EmailSubjectSuccess NVARCHAR(255) = 'Processo Siape - Rotina concluída com Sucesso!';
		DECLARE @EmailBodySuccess NVARCHAR(MAX) = 'O processo "Siape" foi concluído com sucesso. Número de linhas inseridas em Siape: ' + CAST(@RowsAfetadas AS NVARCHAR(MAX));
		DECLARE @RecipientsSuccess NVARCHAR(MAX) = 'duaugusto@hotmail.com; mauriciomarinho807@gmail.com';  -- Adicione os emails separados por ponto e vírgula

		EXEC msdb.dbo.sp_send_dbmail
			    @profile_name = 'Alertas',
			    @recipients = @RecipientsSuccess,
			    @subject = @EmailSubjectSuccess,
			    @body = @EmailBodySuccess;

	END TRY

	BEGIN CATCH
       
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Log de erro
        INSERT INTO DB_MONITORAMENTO..logOperacoes (Usuario, Convenio, NomeTabela, Operacao, Descricao, TempoExecucao, Query)
        VALUES (SUSER_NAME(), 'Siape', @NomeProcedure, 'Erro', @ErrorMessage, NULL, 'Processo ABORTADO. Verifique e corrija o erro.');

        -- Envia email de notificação de erro
        DECLARE @EmailSubjectError NVARCHAR(255) = 'Erro no processo Siape - Rotina Mensal';
        DECLARE @EmailBodyError NVARCHAR(MAX) = 'Ocorreu um erro na procedure "' + @NomeProcedure + '", processo ABORTADO. Mensagem: ' + QUOTENAME(@ErrorMessage, '''');
	    DECLARE @RecipientsError NVARCHAR(MAX) = 'duaugusto@hotmail.com;mauriciomarinho807@gmail.com';  -- Adicione os emails separados por ponto e vírgula

        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Alertas',
            @recipients = @RecipientsError,
            @subject = @EmailSubjectError,
            @body = @EmailBodyError;

        -- Lança o erro para interromper a execução
        THROW;
    END CATCH

END