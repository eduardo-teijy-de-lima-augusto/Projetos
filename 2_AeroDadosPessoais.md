# Rotina Mensal Aeronautica CA..AeroDadosPessoais. Começar com a tabela AeroReceitasDespesas_NEW para depois iniciar esse processo.

## Apos terminado esse ETL CONSULTE A DOCUMENTAÇÃO: AeroRobo, pois esse fluxo irá explicar o ETL a ser feito em relação a leitura de Holeriths.

>1. Crie a tabela que receberá os dados da AeroReceitasDespesas_NEW e updates da tabela em produção AeroDadosPessoais.

```sql

--Conte o numero de CPFs Distintos que vieram da fonte em AeroReceitasDespesas_New
 SELECT COUNT(DISTINCT CPF) FROM CA..AeroReceitasDespesas_New
GO

--Crie uma nova tabela de AeroDadosPessoais a princípio apenas com os CPFs distintos que estão em AeroReceitasDespesas_New
SELECT DISTINCT
       CAST(NULL         AS nvarchar(150))  AS NOME
      ,CAST(CPF          AS bigint)         AS CPF
      ,CAST(NULL         AS date)           AS DT_NASC
      ,CAST(NULL         AS int)            AS IDADE
      ,CAST(NULL         AS nvarchar(150))  AS NOME_MAE
      ,CAST(NULL         AS nvarchar(150))  AS ENDERECO
      ,CAST(NULL         AS nvarchar(150))  AS COMPLEMENTO
      ,CAST(NULL         AS nvarchar(150))  AS BAIRRO
      ,CAST(NULL         AS nvarchar(15))   AS NUMERO
      ,CAST(NULL         AS nvarchar(10))   AS CEP
      ,CAST(NULL         AS nvarchar(50))   AS CIDADE
      ,CAST(NULL         AS nvarchar(2))    AS UF
      ,CAST(NULL         AS decimal(18,2))  AS VLR_BRUTO
      ,CAST(0            AS decimal(18,2))  AS IR
      ,CAST(0            AS decimal(18,2))  AS VLR_BRUTO_IR
      ,CAST(0            AS decimal(18,2))  AS VLR_DESPESA
      ,CAST(0            AS decimal(18,2))  AS MARGEM70
      ,CAST(0            AS decimal(18,2))  AS MARGEM30
      ,CAST(0            AS decimal(18,2))  AS VLR_LIQUIDO
      ,CAST(NULL         AS nvarchar(3))    AS BANCO
      ,CAST(NULL         AS nvarchar(10))   AS AGENCIA
      ,CAST(NULL         AS nvarchar(15))   AS CONTA
      ,CAST(0            AS INT)            AS ISENCAO_IR
      ,CAST(0          	 AS int)            AS ACIONADO
      ,CAST(GETDATE()	 AS date)           AS ATUALIZACAO
      ,CAST(0          	 AS bit)            AS TB_TELEFONE
      ,CAST(NULL         AS nvarchar(10))   AS ORIGEM
  INTO CA..AeroDadosPessoais_NEW
  FROM CA..AeroReceitasDespesas_NEW
GO

  --Faça o update do nome para a nova tabela, garantindo assim a não repetição de CPFs na tabela.
  UPDATE A
  SET A.NOME=B.NOME
  FROM CA..AeroDadosPessoais_NEW A
  INNER JOIN CA..AeroReceitasDespesas_New B ON A.CPF=B.CPF


```

---

>2. Faça o update baseado nos dados da tabela anterior AeroDadosPessoais na nova tabela gerada.

```sql
--Certificar depois se atualizaram todos os dados pois pode ter CPFs diferentes que vieram da nova origem.
UPDATE A
SET
    A.DT_NASC=B.DT_NASC
   ,A.IDADE=B.IDADE
   ,A.NOME_MAE=B.NOME_MAE
   ,A.ENDERECO=B.ENDERECO
   ,A.COMPLEMENTO=B.COMPLEMENTO
   ,A.BAIRRO=B.BAIRRO
   ,A.NUMERO=B.NUMERO
   ,A.CEP=B.CEP
   ,A.CIDADE=B.CIDADE
   ,A.UF=B.UF
FROM CA..AeroDadosPessoais_NEW A
INNER JOIN CARGAS..AeroDadosPessoais B ON A.CPF=B.CPF

```
---
>3. Verifique se algum CPF esta sem data de nascimento e procure em CARGAS..CPF_UF.

```sql

--Verifcando quantos CPFs nao tem data de nascimento.
SELECT COUNT(CPF)
FROM CA..AeroDadosPessoais_NEW
WHERE DT_NASC IS NULL

--Verifique as linhas pois tem muitos nomes que estão em branco e podemos pegar em CARGAS..CPF_UF
SELECT *
FROM CA..AeroDadosPessoais_NEW
WHERE DT_NASC IS NULL

```
>4. Faça update nos campos que vieram com data nascimento vazios.

```sql
--Faça o update dos possiveis CPFs e se encontra nome, nome_mae e data nascimento dos cpfs em branco.
UPDATE A
SET A.NOME=B.NOME
   ,A.NOME_MAE=B.NOME_MAE
   ,A.DT_NASC=CAST(B.NASC AS date)
   ,A.IDADE=FLOOR(DATEDIFF(DAY, A.DT_NASC, GETDATE()) / 365.25)
FROM CA..AeroDadosPessoais_NEW A
INNER JOIN CARGAS..CPF_UF B ON A.CPF=B.CPF
WHERE A.DT_NASC IS NULL
GO

--Agora faça o update no restante com a tabela CARGAS..CPF_Pessoas
UPDATE A
SET A.NOME=B.NOME
   ,A.DT_NASC=CAST(B.NASC AS date)
   ,A.IDADE=FLOOR(DATEDIFF(DAY, A.DT_NASC, GETDATE()) / 365.25)
FROM CA..AeroDadosPessoais_NEW A
INNER JOIN CARGAS..CPF_Pessoas B ON A.CPF=B.CPF
WHERE A.DT_NASC IS NULL


--Delete da tabela os CPFs que estão nulos
DELETE FROM CA..AeroDadosPessoais_NEW
WHERE CPF IS NULL

```

---

>5. Faça a soma dos campos VLR_BRUTO e VLR_DESPESAS na tabela AeroDadosPessoais por CPF.

```sql
 --Some os campos que estão em AeroReceitasDespesas_NEW conforme regra do negocio tanto em receitas como despesas.
UPDATE CA..AeroDadosPessoais_NEW
SET VLR_BRUTO = (
                  SELECT SUM(A.VALOR)
                  FROM CA..AeroReceitasDespesas_NEW A
                  WHERE A.CPF = AeroDadosPessoais_NEW.CPF
                  AND A.ORIGEM = 'Receitas'
                  GROUP BY A.CPF	
				)
GO

--Soma das Despesas.
UPDATE CA..AeroDadosPessoais_NEW
SET VLR_DESPESA = (
                    SELECT SUM(A.VALOR)
                    FROM CA..AeroReceitasDespesas_NEW A
                    WHERE A.CPF = AeroDadosPessoais_NEW.CPF
                    AND A.ORIGEM = 'Despesas'
                    GROUP BY A.CPF
                  )
GO

```
---

>6. Revisar certinho mas é o que foi solicitado para os IRs no campo CAIXA, ou seja, os CPFs que tem a informação IR no campo caixa nao devem sofrer calculo do imposto de renda no campo IR da tabela AeroDadosPessoais, e os que nao possuem a informação IR em AeroReceitasDespesas devem ser calculados na AeroDadosPessoais.

```sql
--Calcula o IR dos CPFs onde não tenha CAIXA='IR'
UPDATE AP
SET AP.IR = CAST(
                  CASE
                     WHEN AP.VLR_BRUTO <= 2112.00 THEN 0
                     WHEN AP.VLR_BRUTO <= 2826.65 THEN (AP.VLR_BRUTO * 0.075) - 158.40
                     WHEN AP.VLR_BRUTO <= 3751.05 THEN (AP.VLR_BRUTO * 0.15) - 370.40
                     WHEN AP.VLR_BRUTO <= 4664.68 THEN (AP.VLR_BRUTO * 0.225) - 651.73
                     ELSE (AP.VLR_BRUTO * 0.275) - 884.96
                  END AS DECIMAL(18, 2)
				)
                FROM CA..AeroDadosPessoais_NEW AS AP 
                WHERE AP.CPF NOT IN ( SELECT CPF FROM CARGAS..AeroReceitasDespesas WHERE caixa = 'IR')


```
>7. Fazer update em VRL_BRUTO_IR caso o valor do IR seja maior que 0 conforme regra do Imposto de renda do item 6.

```sql
--Calculo do VLR_BRUTO_IR quando for maior que zero.
UPDATE CA..AeroDadosPessoais_NEW
SET VLR_BRUTO_IR=
                 CASE
                     WHEN IR > 0 THEN (VLR_BRUTO - IR)
                     ELSE 0
                 END
GO

```
---

---

>8. Update do campo MARGEM_70 baseado na tabela de IR item 6, e respeitando os valores da coluna VL_BRUTO_IR onde caso o valor de IR for maior que 0 faz o calculo por VL_BRUTO_IR senão fará pelo campo VLR_BRUTO.

```sql
--Calcule as Margens e o valor liquido de cada CPF
--Nesse caso VALOR BRUTO DO IR * 70% - VALOR DE DESPESAS SERA A MARGEM 70. ISSO ESTA CORRETO?
UPDATE CA..AeroDadosPessoais_NEW
SET MARGEM70 = 
              CASE
                  WHEN IR > 0 THEN ((VLR_BRUTO_IR * 0.7) - VLR_DESPESA)
                  ELSE((VLR_BRUTO * 0.7) - VLR_DESPESA)
              END
GO

```

>9. Update do campo MARGEM_30 baseado na tabela de IR item 6, e respeitando os valores da coluna VL_BRUTO_IR onde caso o valor de IR for maior que 0 faz o calculo por VL_BRUTO_IR senão fará pelo campo VLR_BRUTO.

```sql
--Calcule as Margens e o valor liquido de cada CPF
--Nesse caso VALOR BRUTO DO IR * 30% - VALOR DE DESPESAS SERA A MARGEM 70. ISSO ESTA CORRETO?
UPDATE CA..AeroDadosPessoais_NEW
SET MARGEM30 = 
              CASE
                  WHEN IR > 0 THEN ((VLR_BRUTO_IR * 0.3) - VLR_DESPESA)
                  ELSE((VLR_BRUTO * 0.3) - VLR_DESPESA)
              END
GO

```
---

>10. Update do valor líquido.

```sql
--Update valor liquido, VLR_BRUTO - VLR_DESPESA
UPDATE CA..AeroDadosPessoais_NEW
SET VLR_LIQUIDO = 
              CASE
                  WHEN IR > 0 THEN (VLR_BRUTO_IR - VLR_DESPESA)
                  ELSE(VLR_BRUTO - VLR_DESPESA)
              END
GO

```
> 11. Criação dos indices para AeroDadosPessoais_NEW e AeroReceitasDespesas_NEW

```sql
--Criação dos indices AeroDadosPessoais_NEW
USE [CA]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Cpf] ON [dbo].[AeroDadosPessoais_NEW]
(
	[CPF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Nasc] ON [dbo].[AeroDadosPessoais_NEW]
(
	[DT_NASC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Uf] ON [dbo].[AeroDadosPessoais_NEW]
(
	[UF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


--Criação dos indices AeroReceitasDespesas_NEW
USE [CA]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Caixa] ON [dbo].[AeroReceitasDespesas_NEW]
(
	[CAIXA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Cpf] ON [dbo].[AeroReceitasDespesas_NEW]
(
	[CPF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

```

---

## Apos terminado esse ETL CONSULTE A DOCUMENTAÇÃO: AeroRobo, pois esse fluxo irá explicar o ETL a ser feito em relação a leitura de Holeriths.

