
>1. Função criada pelo Desenvolvimento a pedido da Diretoria para calcular a taxa dos emprestimos. Esse calculo deve ser feito na tabela Dados_Aivos em uma coluna nova chamada Taxa2. A função abaixo se encontra no SQL Server com o nome CalcularTaxa2. **Nao é necessario rodar essa função ela ja esta no SQL Server, serve como documentação apenas**.




```sql
USE [CAMP]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularTaxa2]    Script Date: 24/06/2023 12:56:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[CalcularTaxa2]
(
    @per_int INT,
    @parcela_float FLOAT,
    @montante_float FLOAT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @juros_inicial FLOAT
    DECLARE @juros_final FLOAT
    DECLARE @suposto_juros FLOAT
    DECLARE @suposto_parcela FLOAT
    DECLARE @cont INT
    DECLARE @achou BIT
    DECLARE @suposta_diferenca FLOAT
    DECLARE @juros_float FLOAT
    DECLARE @s VARCHAR(50)
    DECLARE @i INT

    SET @juros_inicial = CONVERT(FLOAT, -1)
    SET @juros_final = CONVERT(FLOAT, 99999)
    SET @suposto_juros = CONVERT(FLOAT, 0)
    SET @suposto_parcela = CONVERT(FLOAT, 0)
    SET @cont = 1
    SET @achou = 0

    WHILE (1 = 1)
    BEGIN
        SET @suposto_juros = (@juros_final + @juros_inicial) / 2
        SET @suposto_parcela = (@montante_float * @suposto_juros) / (1 - POWER(1 / (1 + @suposto_juros), @per_int))
        SET @suposta_diferenca = ABS(@parcela_float - @suposto_parcela)

        IF (@suposta_diferenca > 0.000000001)
        BEGIN
            IF (@suposto_parcela > @parcela_float)
            BEGIN
                SET @juros_final = @suposto_juros
            END
            ELSE
            BEGIN
                SET @juros_inicial = @suposto_juros
            END
        END
        ELSE
        BEGIN
            SET @achou = 1
            BREAK
        END

        IF (@cont > 5000)
        BEGIN
            BREAK
        END

        SET @cont = @cont + 1
    END

    IF (@achou = 0)
    BEGIN
        RETURN NULL
    END
    ELSE
    BEGIN
        IF (@suposto_juros != -100)
        BEGIN
            SET @suposto_juros = @suposto_juros * 100
        END

        SET @juros_float = ROUND(@suposto_juros * 100000,2) / 100000
        SET @s = CAST(@juros_float AS VARCHAR(50))
        SET @i = CHARINDEX('.', @s)

        IF (@i != -1)
        BEGIN
            SET @s = SUBSTRING(@s, 1, @i) + ',' + SUBSTRING(@s, @i + 1, LEN(@s))
        END
    END

    IF (@juros_float < 0.5 OR @juros_float > 2.7)
    BEGIN
        RETURN 1.5
    END

    RETURN @juros_float
END
```

---

>2. **Antes de rodar essa atualização crie uma nova tabela Dados_Aivos_Taxa para ter um backup**. Crie os indices para que o processo seja mais rápido.

```sql
--Cria uma cópia de segurança para manipular os dados.
SELECT * INTO CAMP..Dados_Aivos_NEW FROM CAMP..Dados_Aivos
GO

--Adicionando as colunas na tabela.
ALTER TABLE CAMP..Dados_Aivos_NEW
ADD Taxa2 DECIMAL(18,2)
GO
ALTER TABLE CAMP..Dados_Aivos_NEW
ADD SaldoDevedor DECIMAL(18,2)
GO

--Crie os indices na tabela
USE CAMP
GO
CREATE NONCLUSTERED INDEX [IDX_CLU_Cpf] ON [dbo].[Dados_Aivos_NEW]
(
	[Cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Ativo] ON [dbo].[Dados_Aivos_NEW]
(
	[Ativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Banco] ON [dbo].[Dados_Aivos_NEW]
(
	[Banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_BancoPagamento] ON [dbo].[Dados_Aivos_NEW]
(
	[BancoPagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Beneficio] ON [dbo].[Dados_Aivos_NEW]
(
	[Beneficio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Esp] ON [dbo].[Dados_Aivos_NEW]
(
	[Esp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Margem] ON [dbo].[Dados_Aivos_NEW]
(
	[Margem35] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_ParcelasPagas] ON [dbo].[Dados_Aivos_NEW]
(
	[ParcelasPagas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Prazo] ON [dbo].[Dados_Aivos_NEW]
(
	[Prazo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Rmc] ON [dbo].[Dados_Aivos_NEW]
(
	[Rmc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Salario] ON [dbo].[Dados_Aivos_NEW]
(
	[Salario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Taxa] ON [dbo].[Dados_Aivos_NEW]
(
	[Taxa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [IDX_N_CLU_Ddb] ON [dbo].[Dados_Aivos_NEW]
(
	[Ddb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Dib] ON [dbo].[Dados_Aivos_NEW]
(
	[Dib] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Tipo] ON [dbo].[Dados_Aivos_NEW]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_ValorParcela] ON [dbo].[Dados_Aivos_NEW]
(
	[ValorParcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Rcc] ON [dbo].[Dados_Aivos_NEW]
(
	[Rcc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

```

>3. ***Antes de rodar a query veja que temos duas opções, leia o descritivo**. Para chamar a função temos o update abaixo que faz o calculo baseado na função e atualiza a coluna Taxa2. Alguns pontos importantes: A mesma deve rodar a cada 1.000.000 de linhas para nao gerar gargalo no SQL Server. Outro ponto a observar é que nessa função foi alterado para que caso encontra algum valor varchar e nao consiga converter para float, a mesma deixe como NULL esses dados. Na ultima atualização tivemos apenas 8 registros que nao foram atualizados. A Diretoria então orientou a setar os valores da taxa em 1.5. 

```sql

--Importante: Essa query fará ate que a contagem acabe. Entretando ainda temos 
--Problema com dados que não são atualizado (8 linhas na ultima) sendo assim
--A Função deve ser corrigida para que os campos nao fiquem nulos. 
--Senão essa query entrará em looping infinito.
DECLARE @RowCount INT = 1;
DECLARE @BatchSize INT = 1000000;

WHILE (@RowCount > 0)
BEGIN
UPDATE TOP (@BatchSize) C
    SET C.Taxa2 = [dbo].CalcularTaxa2(C.Prazo, C.ValorParcela, C.ValorEmprestimo)
    FROM [CAMP].[dbo].[Dados_Aivos_NEW] C
	WHERE C.[Taxa2] IS NULL -- Atualiza apenas os registros não atualizados
 SET @RowCount = @@ROWCOUNT;

    -- Aguarda um tempo para evitar sobrecarga no servidor (opcional)
    WAITFOR DELAY '00:00:03'; -- Aguarda 3 segundos
	PRINT 'OK'
END


--Essa query fará o update completo entretanto de uma vez só. O que pode causar gargalo no SQL Server.

UPDATE C
    SET C.Taxa2 = [dbo].CalcularTaxa2(C.Prazo, C.ValorParcela, C.ValorEmprestimo)
    FROM [CAMP].[dbo].[Dados_Aivos_NEW] C

  ```
---
  >4. Após atualizar o Taxa2 vamos atualizar o SaldoDevedor. Abaixo esta a função que esta no SQL Server desenvolvida. **Nao é necessario rodar essa função ela ja esta no SQL Server, serve como documentação apenas**

  ```sql
  USE [CAMP]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularSaldo]    Script Date: 24/06/2023 13:09:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[CalcularSaldo]
(
    @prazo INT,
	@pagas INT,
    @taxa FLOAT,
    @parcela FLOAT
)
RETURNS FLOAT
AS
BEGIN
    SET @taxa = (@taxa / 100);
    SET @prazo = (@prazo - @pagas) * (-1);

    DECLARE @v1 FLOAT
    DECLARE @v2 FLOAT
    DECLARE @v3 FLOAT
    DECLARE @saldoDevedor FLOAT

    SET @v1 = POWER((1 + @taxa), @prazo)
    SET @v2 = (1 - @v1)
    SET @v3 = @v2 / @taxa
    SET @saldoDevedor = @v3 * @parcela

    RETURN ROUND(@saldoDevedor, 2);
END

```

---
>5. **Antes de usar a query veja que temos duas opções**. Faça o update para a coluna SaldoDevedor com a query abaixo. 

```sql

--Importante: Essa query fará ate que a contagem acabe. Entretando ainda temos 
--Problema com dados que não são atualizado (8 linhas na ultima) na coluna Taxa2 sendo assim a Função deve ser corrigida para que os campos nao fiquem nulos. 
--Senão essa query entrará em looping infinito.
DECLARE @RowCount INT = 1;
DECLARE @BatchSize INT = 1000000;

WHILE (@RowCount > 0)
BEGIN
    UPDATE TOP (@BatchSize) [CAMP].[dbo].[Dados_Aivos_NEW]
    SET SaldoDevedor = [dbo].CalcularSaldo(Prazo, ParcelasPagas, Taxa2, ValorParcela)
        WHERE [SaldoDevedor] IS NULL -- Atualiza apenas os registros não atualizados
    SET @RowCount = @@ROWCOUNT;

    -- Aguarda um tempo para evitar sobrecarga no servidor (opcional)
    WAITFOR DELAY '00:00:03'; -- Aguarda 3 segundos
	PRINT 'OK'
END

--Essa query fará o update completo entretanto de uma vez só. O que pode causar gargalo no SQL Server.
UPDATE [CAMP].[dbo].[Dados_Aivos_NEW]
    SET SaldoDevedor = [dbo].CalcularSaldo(Prazo, ParcelasPagas, Taxa2, ValorParcela)
```

---

>6. Ao final do processo certifique-se que todos os dados foram atualizados, pois na última atualização 8 linhas de Taxa2 não foram calculadas devido erro em algo na função. Precisamos rever esse ponto. Diretoria orientou a colocar a taxa como 1.5 mas valide com a mesma para correção.

```sql
--Procurando Taxa2 que não foi calculada.
SELECT *
FROM CAMP..Dados_Aivos_NEW
WHERE Taxa2 IS NULL

--Caso seja encontrada linhas nulas verificar com a liderança o que fazer nesse caso, a ultima atualização foi orientado colocar o valor de 1.5
```
---


>7. Após a atualização das duas colunas Taxa2 e SaldoDevedor, renomeie a Coluna Taxa para Taxaold e a Taxa2 para Taxa da tabela Dados_Aivos_NEW. Apos renomeie a tabela em produção Dados_Aivos para Dados_Aivos_OLD e coloque a outra em produção renomenando (retire o _NEW).

```sql
-- Renomear a coluna "taxa" para "taxaold"
EXEC sp_rename 'CAMP.dbo.Dados_Aivos_NEW.taxa', 'Taxaold', 'COLUMN';

-- Renomear a coluna "taxa2" para "taxa"
EXEC sp_rename 'CAMP.dbo.Dados_Aivos_NEW.taxa2', 'Taxa', 'COLUMN';


-- Renomear a tabela "Dados_Aivos" para "Dados_Aivos_OLD"
EXEC sp_rename 'CAMP.dbo.Dados_Aivos', 'Dados_Aivos_OLD';

-- Renomear a tabela "Dados_Aivos_NEW" para "Dados_Aivos"
EXEC sp_rename 'CAMP.dbo.Dados_Aivos_NEW', 'Dados_Aivos';

```

---

>8. *********A função utilizada esta sendo a CalculoTaxa2 pois a primeira versão CalculoTaxa apresenta erros de varchar para float, pois por algum motivo ele nao calcula essas informações e para o processo. Verificar com o desenvolvimento como corrigir para melhor aproveitamento.

---

>9. Faz a contagem do processo de atualização se desejar acompanhar. Tem que ir parando a query para mostrar os resultados

```sql
DECLARE @TotalRows INT;
DECLARE @UpdatedRows INT;
DECLARE @BatchSize INT = 100000;

SELECT @TotalRows = COUNT(*) FROM [CAMP].[dbo].[Dados_Aivos_Taxa];

WHILE (@TotalRows > 0)
BEGIN
    SELECT @UpdatedRows = COUNT(*) FROM [CAMP].[dbo].[Dados_Aivos_Taxa] WHERE [SaldoDevedor] IS NOT NULL;

    PRINT CONCAT('Progresso: ', @UpdatedRows, ' de ', @TotalRows, ' linhas atualizadas.');

    SET @TotalRows = @TotalRows - @BatchSize;

    IF (@TotalRows > 0)
    BEGIN
        -- Aguarda um tempo para evitar sobrecarga no servidor (opcional)
        WAITFOR DELAY '00:00:05'; -- Aguarda 5 segundos antes de verificar novamente
    END
END

```