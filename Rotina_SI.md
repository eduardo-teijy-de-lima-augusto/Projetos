>1. Inicio do processo para subir a base de SI mensal em DB. Os mesmos devem juntar com a mesma estrutura a principio copiando via CMD os tipos S e P. Abaixo vamos descrever esse processo.

---

>2. Copiar os conteudos dos arquivos para um arquivo em S.TXT e outro P.TXT

```txt
copy "* S d8" S.txt
```
>Copiando todos os arquivos que tem no nome o S d8 para S.TXT

```txt
copy "* p d8" P.txt
```
>Copiando todos os arquivos que tem no nome o P d8 para P.TXT

>3. Criação da estrutura das tabelas para inserção dos dados dos arquivos.

```sql
--Essa estrutura cria o arquivo que vai receber os campos que foram adicionados em P.TXT

CREATE TABLE CARGAS.[dbo].[D8P_Geral](
	[Orgao] [nvarchar](5) NULL,
	[Instituidor] [nvarchar](7) NULL,
	[Matricula] [nvarchar](8) NULL,
	[UPAG] [nvarchar](9) NULL,
	[UF] [nvarchar](2) NULL,
	[Nome] [nvarchar](45) NULL,
	[CPF] [nvarchar](11) NULL,
	[Rubrica] [nvarchar](5) NULL,
	[SeqRubrica] [int] NULL,
	[Valor_PMT] [nvarchar](11) NULL,
	[Prazo] [nvarchar](3) NULL,
	[NaoUsar1] [nvarchar](6) NULL,
	[NaoUsar2] [nvarchar](12) NULL,
	[Contrato] [nvarchar](20) NULL,
	[Naousar4] [nvarchar](7) NULL
) ON [PRIMARY]
GO

--Essa estrutura cria o arquivo que vai receber os campos que foram adicionados em S.TXT
CREATE TABLE CARGAS.[dbo].[D8S_Geral](
	[Orgao] [nvarchar](5) NULL,
	[Matricula] [nvarchar](7) NULL,
	[UPAG] [nvarchar](9) NULL,
	[UF] [nvarchar](2) NULL,
	[Nome] [nvarchar](50) NULL,
	[CPF] [nvarchar](11) NULL,
	[Rubrica] [nvarchar](5) NULL,
	[SeqRubrica] [int] NULL,
	[Valor_PMT] [nvarchar](11) NULL,
	[Prazo] [nvarchar](3) NULL,
	[NaoUsar1] [nvarchar](6) NULL,
	[NaoUsar2] [nvarchar](12) NULL,
	[Contrato] [nvarchar](20) NULL,
	[NaoUsar4] [nvarchar](7) NULL
) ON [PRIMARY]
GO
```
---

>4. Subir o arquivo P.TXT e S.TXT para tabelas lembrando que nao há delimitador, dessa forma a tabela terá apenas uma coluna. Usaremos a função SUBSTRING para que possamos inserir nas tabelas acima criadas os dados do arquivo. ***RETIRE A OPÇÃO DE CABEÇALHO POIS OS ARQUIVOS NAO POSSUEM CABEÇALHO**.
---

>5. Insira os dados de cada tabela para D8P_Geral e D8S_Geral.
```sql

--Inserindo dados da tabela CARGAS.P conforme orientação sobre as posições de cada campo.
INSERT INTO CARGAS..D8Pensao_Geral  
                            (Orgao
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
    SELECT  
        SUBSTRING([Column 0],1,5)     AS Orgao
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
    FROM CARGAS..P
GO

--Inserindo dados da tabela CARGAS.S conforme orientação sobre as posições de cada campo.
INSERT INTO CARGAS..D8Serv_Geral
                            (Orgao
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
    SELECT  
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
    FROM CARGAS..S

  ```
---
>6. O campo Valor_PMT vem no formato 0000139200. É necessario transormar ele para decimal(18,2), entretanto temos que nos atentar pois só mudar o campo para decimal fará com que 139200 fique como 13920.00 o que esta errado, o valor correto seria 1392.00.

```sql
--Deleta algum registro sujo vazio da tabela CARGAS..D8P_Geral
DELETE FROM CARGAS..D8P_Geral
WHERE Instituidor='' AND Matricula='' AND UPAG='' AND UF=''
GO

--Altera o campo para decimal da tabela CARGAS..D8P_Geral
ALTER TABLE CARGAS..D8P_Geral
ALTER COLUMN VALOR_PMT DECIMAL(18,2)
GO

--Update do valor correto dividindo por 100 da tabela CARGAS..D8P_Geral
UPDATE CARGAS..D8P_Geral
SET Valor_PMT=CAST(VALOR_PMT AS decimal (18,2)) /100
GO 


--Deleta algum registro sujo vazio da tabela CARGAS..D8Serv_Geral
DELETE FROM CARGAS..D8S_Geral
WHERE Valor_PMT='' AND Matricula='' AND UPAG='' AND UF=''
GO

--Altera o campo para decimal CARGAS..D8Serv_Geral
ALTER TABLE CARGAS..D8S_Geral
ALTER COLUMN VALOR_PMT DECIMAL(18,2)
GO

--Update do valor correto dividindo por 100. CARGAS..D8Serv_Geral
UPDATE CARGAS..D8S_Geral
SET Valor_PMT=CAST(VALOR_PMT AS decimal (18,2)) /100
GO 

  ```
---

>7. Vamos juntar as duas tabelas vindas dos arquivos D8 em CARGAS..D8PENSAO_SERV. Abaixo o script para juntar as duas tabelas com todos os dados. A única diferença entre as duas é o campo INSTITUIDOR.

```sql
--Juntando as duas tabelas e na SERV ja criando o campo Instituidor com valor 0.
SELECT [Orgao]
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
  INTO CARGAS..D8P_SERV
  FROM [dbo].[D8Pensao_Geral]

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
  FROM [dbo].[D8S_Geral]

GO

```

---

>8. Agora importe as duas tabelas do excel enviadas do mes como exemplo P202306.xlsx e S202306.xlsx. ***ABRA OS ARQUIVOS E SALVE AS PLANILHAS PARA .TXT*** Coloque os nomes CARGAS..PXLS E SXLS para identificar as origens. *****FICAR ATENTO POIS PODE VIR MAIS DE UMA PLANILHA POR ARQUIVO***.  Caso de erro na importação, abra o arquivo de excel e grave as planilhas em .TXT, desta forma funcionará. Abaixo as querys para tratamento apos a correta importação.

```sql
--Select simples para visualizar o conteudo e se adequar as colunas.
--Se no arquivo SXLS veio mais de uma planilha, teremos que juntar o mesmo em uma tabela.
SELECT TOP 10 * FROM CARGAS..PXLS
SELECT TOP 10 * FROM CARGAS..SXLS
SELECT TOP 10 * FROM CARGAS..SXLS1

```
---
```sql
--Vamos padronizar nomes dos campos de CARGAS..PXLS, há muitos acentos e espaços nos nomes de colunas.
EXEC sp_rename 'CARGAS..PXLS.[OrgÆo]',         'Orgao',          'COLUMN'	
EXEC sp_rename 'CARGAS..PXLS.[Matricula]',     'Matricula',      'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Base Calc]',     'BaseCalc',       'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Bruta 5%]',      'Bruta5',         'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Utilz 5%]',      'Utilz5',         'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Saldo 5%]',      'Saldo5',         'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Bruta 35%]',     'Bruta35',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Utilz 35%]',     'Utilz35',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Saldo 35%]',     'Saldo35',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Bruta 70%]',     'Bruta70',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Utilz 70%]',     'Utilz70',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Saldo 70%]',     'Saldo70',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Cr‚ditos]',      'Creditos',       'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[D‚bitos]',       'Debitos',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[L¡quido]',       'Liquido',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[ARQ  UPAG]',     'ARQUPAG',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[EXC QTD]',       'EXCQTD',         'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[EXC Soma]',      'EXCSoma',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[RJUR]',          'RJUR',           'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Sit Func]',      'SitFunc',        'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[CPF]',           'CPF',            'COLUMN'
EXEC sp_rename 'CARGAS..PXLS.[Margem]',        'Margem',         'COLUMN'


--Vamos padronizar nomes dos campos de CARGAS..SXLS, há muitos acentos e espaços nos nomes de colunas.
EXEC sp_rename 'CARGAS..SXLS.[OrgÆo]',         'Orgao',          'COLUMN'	
EXEC sp_rename 'CARGAS..SXLS.[Matricula]',     'Matricula',      'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Base Calc]',     'BaseCalc',       'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Bruta 5%]',      'Bruta5',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Utilz 5%]',      'Utilz5',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Saldo 5%]',      'Saldo5',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Bruta 35%]',     'Bruta35',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Utilz 35%]',     'Utilz35',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Saldo 35%]',     'Saldo35',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Bruta 70%]',     'Bruta70',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Utilz 70%]',     'Utilz70',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Saldo 70%]',     'Saldo70',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Cr‚ditos]',      'Creditos',       'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[D‚bitos]',       'Debitos',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[L¡quido]',       'Liquido',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[ARQ  UPAG]',     'ARQUPAG',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[EXC QTD]',       'EXCQTD',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[EXC Soma]',      'EXCSoma',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[RJUR]',          'RJUR',           'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Sit Func]',      'SitFunc',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[CPF]',           'CPF',            'COLUMN'
EXEC sp_rename 'CARGAS..SXLS.[Margem]',        'Margem',         'COLUMN'

--Vamos padronizar nomes dos campos de CARGAS..SXLS1 **(SE HOUVER)**, há muitos acentos e espaços nos nomes de colunas.
EXEC sp_rename 'CARGAS..SXLS1.[OrgÆo]',         'Orgao',          'COLUMN'	
EXEC sp_rename 'CARGAS..SXLS1.[Matricula]',     'Matricula',      'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Base Calc]',     'BaseCalc',       'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Bruta 5%]',      'Bruta5',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Utilz 5%]',      'Utilz5',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Saldo 5%]',      'Saldo5',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Bruta 35%]',     'Bruta35',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Utilz 35%]',     'Utilz35',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Saldo 35%]',     'Saldo35',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Bruta 70%]',     'Bruta70',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Utilz 70%]',     'Utilz70',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Saldo 70%]',     'Saldo70',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Cr‚ditos]',      'Creditos',       'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[D‚bitos]',       'Debitos',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[L¡quido]',       'Liquido',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[ARQ  UPAG]',     'ARQUPAG',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[EXC QTD]',       'EXCQTD',         'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[EXC Soma]',      'EXCSoma',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[RJUR]',          'RJUR',           'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Sit Func]',      'SitFunc',        'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[CPF]',           'CPF',            'COLUMN'
EXEC sp_rename 'CARGAS..SXLS1.[Margem]',        'Margem',         'COLUMN'

```
---
>9. Vamos juntar SXLS com SXLS1, pois no arquivo de excel tinhamos duas abas que forma separadas por limitação do EXCEL em LINHAS.

```sql
--Juntando o conteudo de SXLS1 na tabela SXLS para completar as duas planilhas de origem.
INSERT INTO CARGAS..SXLS
SELECT * FROM CARGAS..SXLS1

```
---
>10. Processo de ETL completo em PXLS e SXLS.

```sql
--Alteração dos campos da tabela CARGAS..PXLS para valores decimais padrão SQL.
UPDATE CARGAS..PXLS
SET BaseCalc =
    CASE
        WHEN BaseCalc LIKE '%.%' AND BaseCalc LIKE '%,%' THEN REPLACE(REPLACE(BaseCalc, '.', ''), ',', '.')
        WHEN BaseCalc LIKE '%,%' THEN REPLACE(BaseCalc, ',', '.')
        WHEN BaseCalc LIKE 'R$%' THEN REPLACE(BaseCalc, 'R$', '')
        WHEN BaseCalc LIKE '' THEN '0.00'
        ELSE BaseCalc
    END,
    Bruta5 =
    CASE
        WHEN Bruta5 LIKE '%.%' AND Bruta5 LIKE '%,%' THEN REPLACE(REPLACE(Bruta5, '.', ''), ',', '.')
        WHEN Bruta5 LIKE '%,%' THEN REPLACE(Bruta5, ',', '.')
        WHEN Bruta5 LIKE '' THEN '0.00'
        WHEN Bruta5 LIKE 'R$%' THEN REPLACE(Bruta5, 'R$', '')
        ELSE Bruta5
    END,
	Utilz5 =
    CASE
        WHEN Utilz5 LIKE '%.%' AND Utilz5 LIKE '%,%' THEN REPLACE(REPLACE(Utilz5, '.', ''), ',', '.')
        WHEN Utilz5 LIKE '%,%' THEN REPLACE(Utilz5, ',', '.')
        WHEN Utilz5 LIKE 'R$%' THEN REPLACE(Utilz5, 'R$', '')
        WHEN Utilz5 LIKE '' THEN '0.00'
        ELSE Utilz5
    END,
	Saldo5 =
    CASE
        WHEN Saldo5 LIKE '%.%' AND Saldo5 LIKE '%,%' THEN REPLACE(REPLACE(Saldo5, '.', ''), ',', '.')
        WHEN Saldo5 LIKE '%,%' THEN REPLACE(Saldo5, ',', '.')
        WHEN Saldo5 LIKE 'R$%' THEN REPLACE(Saldo5, 'R$', '')
        WHEN Saldo5 LIKE '' THEN '0.00'
        ELSE Saldo5
    END,
    Bruta35 =
    CASE
        WHEN Bruta35 LIKE '%.%' AND Bruta35 LIKE '%,%' THEN REPLACE(REPLACE(Bruta35, '.', ''), ',', '.')
        WHEN Bruta35 LIKE '%,%' THEN REPLACE(Bruta35, ',', '.')
        WHEN Bruta35 LIKE 'R$%' THEN REPLACE(Bruta35, 'R$', '')
        WHEN Bruta35 LIKE '' THEN '0.00'
        ELSE Bruta35
    END,
    Utilz35 =
    CASE
        WHEN Utilz35 LIKE '%.%' AND Utilz35 LIKE '%,%' THEN REPLACE(REPLACE(Utilz35, '.', ''), ',', '.')
        WHEN Utilz35 LIKE '%,%' THEN REPLACE(Utilz35, ',', '.')
        WHEN Utilz35 LIKE 'R$%' THEN REPLACE(Utilz35, 'R$', '')
        WHEN Utilz35 LIKE '' THEN '0.00'
        ELSE Utilz35
    END,
    Saldo35 =
    CASE
        WHEN Saldo35 LIKE '%.%' AND Saldo35 LIKE '%,%' THEN REPLACE(REPLACE(Saldo35, '.', ''), ',', '.')
        WHEN Saldo35 LIKE '%,%' THEN REPLACE(Saldo35, ',', '.')
        WHEN Saldo35 LIKE 'R$%' THEN REPLACE(Saldo35, 'R$', '')
        WHEN Saldo35 LIKE '' THEN '0.00'
        ELSE Saldo35
    END,
	Bruta70 =
    CASE
        WHEN Bruta70 LIKE '%.%' AND Bruta70 LIKE '%,%' THEN REPLACE(REPLACE(Bruta70, '.', ''), ',', '.')
        WHEN Bruta70 LIKE '%,%' THEN REPLACE(Bruta70, ',', '.')
        WHEN Bruta70 LIKE 'R$%' THEN REPLACE(Bruta70, 'R$', '')
        WHEN Bruta70 LIKE '' THEN '0.00'
        ELSE Bruta70
    END,
	Utilz70 =
    CASE
        WHEN Utilz70 LIKE '%.%' AND Utilz70 LIKE '%,%' THEN REPLACE(REPLACE(Utilz70, '.', ''), ',', '.')
        WHEN Utilz70 LIKE '%,%' THEN REPLACE(Utilz70, ',', '.')
        WHEN Utilz70 LIKE 'R$%' THEN REPLACE(Utilz70, 'R$', '')
        WHEN Utilz70 LIKE '' THEN '0.00'
        ELSE Utilz70	
    END,
	Saldo70 =
    CASE
        WHEN Saldo70 LIKE '%.%' AND Saldo70 LIKE '%,%' THEN REPLACE(REPLACE(Saldo70, '.', ''), ',', '.')
        WHEN Saldo70 LIKE '%,%' THEN REPLACE(Saldo70, ',', '.')
        WHEN Saldo70 LIKE 'R$%' THEN REPLACE(Saldo70, 'R$', '')
        WHEN Saldo70 LIKE '' THEN '0.00'
        ELSE Saldo70
    END,
	Creditos =
    CASE
        WHEN Creditos LIKE '%.%' AND Creditos LIKE '%,%' THEN REPLACE(REPLACE(Creditos, '.', ''), ',', '.')
        WHEN Creditos LIKE '%,%' THEN REPLACE(Creditos, ',', '.')
        WHEN Creditos LIKE 'R$%' THEN REPLACE(Creditos, 'R$', '')
        WHEN Creditos LIKE '' THEN '0.00'
        ELSE Creditos
    END,
	Debitos =
    CASE
        WHEN Debitos LIKE '%.%' AND Debitos LIKE '%,%' THEN REPLACE(REPLACE(Debitos, '.', ''), ',', '.')
        WHEN Debitos LIKE '%,%' THEN REPLACE(Debitos, ',', '.')
        WHEN Debitos LIKE 'R$%' THEN REPLACE(Debitos, 'R$', '')
        WHEN Debitos LIKE '' THEN '0.00'
        ELSE Debitos
    END,
	Liquido =
    CASE
        WHEN Liquido LIKE '%.%' AND Liquido LIKE '%,%' THEN REPLACE(REPLACE(Liquido, '.', ''), ',', '.')
        WHEN Liquido LIKE '%,%' THEN REPLACE(Liquido, ',', '.')
        WHEN Liquido LIKE 'R$%' THEN REPLACE(Liquido, 'R$', '')
        WHEN Liquido LIKE '' THEN '0.00'
        ELSE Liquido
    END,
	CPF =
    CASE
        WHEN CPF LIKE '%.%' AND CPF LIKE '%-%' THEN REPLACE(REPLACE(CPF, '.', ''), '-', '')
        ELSE CPF
    END,
	Margem =
    CASE
        WHEN Margem LIKE '%.%' AND Margem LIKE '%,%' THEN REPLACE(REPLACE(Margem, '.', ''), ',', '.')
        WHEN Margem LIKE '%,%' THEN REPLACE(Margem, ',', '.')
        WHEN Margem LIKE 'R$%' THEN REPLACE(Margem, 'R$', '')
        WHEN Margem LIKE '' THEN '0.00'
        ELSE Margem
    END

    --Alteração dos campos para decimal padrão sql.
    ALTER TABLE CARGAS..PXLS ALTER COLUMN BaseCalc decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Bruta5 decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Utilz5 decimal(18,2)
    GO
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Saldo5 decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Bruta35 decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Utilz35 decimal(18,2)
    GO
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Saldo35 decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Bruta70 decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Utilz70 decimal(18,2)
    GO
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Saldo70 decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Creditos decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Debitos decimal(18,2)
    GO    
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Liquido decimal(18,2)
    ALTER TABLE CARGAS..PXLS ALTER COLUMN CPF bigint
    ALTER TABLE CARGAS..PXLS ALTER COLUMN Margem decimal(18,2)
    GO

```
---
>11. Vamos fazer o ETL de CARAS..SXLS ***(VERFICAR SE PODEMOS JUNTAR AS DUAS PARA UM ETL SO)*******
```sql
--Alteração dos campos da tabela CARGAS..SXLS para valores decimais padrão SQL.
UPDATE CARGAS..SXLS
SET BaseCalc =
    CASE
        WHEN BaseCalc LIKE '%.%' AND BaseCalc LIKE '%,%' THEN REPLACE(REPLACE(BaseCalc, '.', ''), ',', '.')
        WHEN BaseCalc LIKE '%,%' THEN REPLACE(BaseCalc, ',', '.')
        WHEN BaseCalc LIKE 'R$%' THEN REPLACE(BaseCalc, 'R$', '')
        WHEN BaseCalc LIKE '' THEN '0.00'
        ELSE BaseCalc
    END,
    Bruta5 =
    CASE
        WHEN Bruta5 LIKE '%.%' AND Bruta5 LIKE '%,%' THEN REPLACE(REPLACE(Bruta5, '.', ''), ',', '.')
        WHEN Bruta5 LIKE '%,%' THEN REPLACE(Bruta5, ',', '.')
        WHEN Bruta5 LIKE '' THEN '0.00'
        WHEN Bruta5 LIKE 'R$%' THEN REPLACE(Bruta5, 'R$', '')
        ELSE Bruta5
    END,
	Utilz5 =
    CASE
        WHEN Utilz5 LIKE '%.%' AND Utilz5 LIKE '%,%' THEN REPLACE(REPLACE(Utilz5, '.', ''), ',', '.')
        WHEN Utilz5 LIKE '%,%' THEN REPLACE(Utilz5, ',', '.')
        WHEN Utilz5 LIKE 'R$%' THEN REPLACE(Utilz5, 'R$', '')
        WHEN Utilz5 LIKE '' THEN '0.00'
        ELSE Utilz5
    END,
	Saldo5 =
    CASE
        WHEN Saldo5 LIKE '%.%' AND Saldo5 LIKE '%,%' THEN REPLACE(REPLACE(Saldo5, '.', ''), ',', '.')
        WHEN Saldo5 LIKE '%,%' THEN REPLACE(Saldo5, ',', '.')
        WHEN Saldo5 LIKE 'R$%' THEN REPLACE(Saldo5, 'R$', '')
        WHEN Saldo5 LIKE '' THEN '0.00'
        ELSE Saldo5
    END,
    Bruta35 =
    CASE
        WHEN Bruta35 LIKE '%.%' AND Bruta35 LIKE '%,%' THEN REPLACE(REPLACE(Bruta35, '.', ''), ',', '.')
        WHEN Bruta35 LIKE '%,%' THEN REPLACE(Bruta35, ',', '.')
        WHEN Bruta35 LIKE 'R$%' THEN REPLACE(Bruta35, 'R$', '')
        WHEN Bruta35 LIKE '' THEN '0.00'
        ELSE Bruta35
    END,
    Utilz35 =
    CASE
        WHEN Utilz35 LIKE '%.%' AND Utilz35 LIKE '%,%' THEN REPLACE(REPLACE(Utilz35, '.', ''), ',', '.')
        WHEN Utilz35 LIKE '%,%' THEN REPLACE(Utilz35, ',', '.')
        WHEN Utilz35 LIKE 'R$%' THEN REPLACE(Utilz35, 'R$', '')
        WHEN Utilz35 LIKE '' THEN '0.00'
        ELSE Utilz35
    END,
    Saldo35 =
    CASE
        WHEN Saldo35 LIKE '%.%' AND Saldo35 LIKE '%,%' THEN REPLACE(REPLACE(Saldo35, '.', ''), ',', '.')
        WHEN Saldo35 LIKE '%,%' THEN REPLACE(Saldo35, ',', '.')
        WHEN Saldo35 LIKE 'R$%' THEN REPLACE(Saldo35, 'R$', '')
        WHEN Saldo35 LIKE '' THEN '0.00'
        ELSE Saldo35
    END,
	Bruta70 =
    CASE
        WHEN Bruta70 LIKE '%.%' AND Bruta70 LIKE '%,%' THEN REPLACE(REPLACE(Bruta70, '.', ''), ',', '.')
        WHEN Bruta70 LIKE '%,%' THEN REPLACE(Bruta70, ',', '.')
        WHEN Bruta70 LIKE 'R$%' THEN REPLACE(Bruta70, 'R$', '')
        WHEN Bruta70 LIKE '' THEN '0.00'
        ELSE Bruta70
    END,
	Utilz70 =
    CASE
        WHEN Utilz70 LIKE '%.%' AND Utilz70 LIKE '%,%' THEN REPLACE(REPLACE(Utilz70, '.', ''), ',', '.')
        WHEN Utilz70 LIKE '%,%' THEN REPLACE(Utilz70, ',', '.')
        WHEN Utilz70 LIKE 'R$%' THEN REPLACE(Utilz70, 'R$', '')
        WHEN Utilz70 LIKE '' THEN '0.00'
        ELSE Utilz70	
    END,
	Saldo70 =
    CASE
        WHEN Saldo70 LIKE '%.%' AND Saldo70 LIKE '%,%' THEN REPLACE(REPLACE(Saldo70, '.', ''), ',', '.')
        WHEN Saldo70 LIKE '%,%' THEN REPLACE(Saldo70, ',', '.')
        WHEN Saldo70 LIKE 'R$%' THEN REPLACE(Saldo70, 'R$', '')
        WHEN Saldo70 LIKE '' THEN '0.00'
        ELSE Saldo70
    END,
	Creditos =
    CASE
        WHEN Creditos LIKE '%.%' AND Creditos LIKE '%,%' THEN REPLACE(REPLACE(Creditos, '.', ''), ',', '.')
        WHEN Creditos LIKE '%,%' THEN REPLACE(Creditos, ',', '.')
        WHEN Creditos LIKE 'R$%' THEN REPLACE(Creditos, 'R$', '')
        WHEN Creditos LIKE '' THEN '0.00'
        ELSE Creditos
    END,
	Debitos =
    CASE
        WHEN Debitos LIKE '%.%' AND Debitos LIKE '%,%' THEN REPLACE(REPLACE(Debitos, '.', ''), ',', '.')
        WHEN Debitos LIKE '%,%' THEN REPLACE(Debitos, ',', '.')
        WHEN Debitos LIKE 'R$%' THEN REPLACE(Debitos, 'R$', '')
        WHEN Debitos LIKE '' THEN '0.00'
        ELSE Debitos
    END,
	Liquido =
    CASE
        WHEN Liquido LIKE '%.%' AND Liquido LIKE '%,%' THEN REPLACE(REPLACE(Liquido, '.', ''), ',', '.')
        WHEN Liquido LIKE '%,%' THEN REPLACE(Liquido, ',', '.')
        WHEN Liquido LIKE 'R$%' THEN REPLACE(Liquido, 'R$', '')
        WHEN Liquido LIKE '' THEN '0.00'
        ELSE Liquido
    END,
	CPF =
    CASE
        WHEN CPF LIKE '%.%' AND CPF LIKE '%-%' THEN REPLACE(REPLACE(CPF, '.', ''), '-', '')
        ELSE CPF
    END,
	Margem =
    CASE
        WHEN Margem LIKE '%.%' AND Margem LIKE '%,%' THEN REPLACE(REPLACE(Margem, '.', ''), ',', '.')
        WHEN Margem LIKE '%,%' THEN REPLACE(Margem, ',', '.')
        WHEN Margem LIKE 'R$%' THEN REPLACE(Margem, 'R$', '')
        WHEN Margem LIKE '' THEN '0.00'
        ELSE Margem
    END

    --Alteração dos campos para decimal padrão sql.
    ALTER TABLE CARGAS..SXLS ALTER COLUMN BaseCalc decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Bruta5 decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Utilz5 decimal(18,2)
    GO
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Saldo5 decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Bruta35 decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Utilz35 decimal(18,2)
    GO
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Saldo35 decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Bruta70 decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Utilz70 decimal(18,2)
    GO
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Saldo70 decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Creditos decimal(18,2)
    GO
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Debitos decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Liquido decimal(18,2)
    ALTER TABLE CARGAS..SXLS ALTER COLUMN CPF bigint
    ALTER TABLE CARGAS..SXLS ALTER COLUMN Margem decimal(18,2)
    GO

```
---
>12. Após o ETL pronto, vamos juntar as duas tabelas, PXLS e SXLS. 

```sql
--Juntando as duas tabelas PXLS e SXLS que vieram dos arquivos em EXCEL.
SELECT [Orgao]
      ,[Instituidor]
      ,[Matricula]
      ,[BaseCalc]
      ,[Bruta5]
      ,[Utilz5]
      ,[Saldo5]
      ,[Bruta35]
      ,[Utilz35]
      ,[Saldo35]
      ,[Bruta70]
      ,[Utilz70]
      ,[Saldo70]
      ,[Creditos]
      ,[Debitos]
      ,[Liquido]
      ,[ARQUPAG]
      ,[EXCQTD]
      ,[EXCSoma]
      ,[RJUR]
      ,[SitFunc]
      ,[CPF]
      ,[Margem]
  INTO CARGAS..PXLS_SXLS
  FROM CARGAS..[PXLS]

  UNION ALL

SELECT [Orgao]
      ,CAST(0 AS BIGINT)      AS Instituidor
      ,[Matricula]
      ,[BaseCalc]
      ,[Bruta5]
      ,[Utilz5]
      ,[Saldo5]
      ,[Bruta35]
      ,[Utilz35]
      ,[Saldo35]
      ,[Bruta70]
      ,[Utilz70]
      ,[Saldo70]
      ,[Creditos]
      ,[Debitos]
      ,[Liquido]
      ,[ARQUPAG]
      ,[EXCQTD]
      ,[EXCSoma]
      ,[RJUR]
      ,[SitFunc]
      ,[CPF]
      ,[Margem]
  FROM CARGAS..SXLS

GO
```
---

>13. Todos esses dados serão inseridos em diferentes tabelas, então deixei uma query pronta para criação das tabelas usadas em DB, Cadastro_NEW, Consolidado_NEW, Contrato_NEW. Verificar se precisa de mais tabelas.

```sql
--Tabela Consolidado em DB
CREATE TABLE DB..Consolidado_NEW(
	[Orgao] [int] NOT NULL,
	[Instituidor] [bigint] NULL,
	[Matricula] [bigint] NULL,
	[BaseCalc] [numeric](18, 2) NULL,
	[Bruta5] [numeric](18, 2) NULL,
	[Util5] [numeric](18, 2) NULL,
	[Saldo5] [numeric](18, 2) NULL,
	[Bruta30] [numeric](18, 2) NULL,
	[Util30] [numeric](18, 2) NULL,
	[Saldo30] [numeric](18, 2) NULL,
	[Bruta70] [numeric](18, 2) NULL,
	[Util70] [numeric](18, 2) NULL,
	[Saldo70] [numeric](18, 2) NULL,
	[RendaBruta] [numeric](18, 2) NULL,
	[Desconto] [numeric](18, 2) NULL,
	[TotalLiquido] [numeric](18, 2) NULL,
	[Upag] [varchar](15) NULL,
	[Sigla] [char](2) NULL,
	[Lixo] [varchar](70) NULL,
	[Rjur] [char](3) NULL,
	[SituacaoFuncional] [varchar](50) NULL,
	[Cpf] [bigint] NULL,
	[MargemNova] [numeric](18, 2) NULL,
	[Cartao] [bit] NULL,
	[MargemSaldo] [numeric](18, 2) NULL,
	[Margem_Antiga] [numeric](18, 2) NULL
) ON [PRIMARY]
GO

--Tabela Contrato em DB
CREATE TABLE DB..Contrato_NEW(
	[IdContrato] [int] IDENTITY(1,1) NOT NULL,
	[CodOrgao] [int] NULL,
	[Instituidor] [int] NULL,
	[Matricula] [bigint] NULL,
	[Cpf] [bigint] NULL,
	[Nome] [varchar](50) NULL,
	[Valor] [numeric](18, 2) NULL,
	[Prazo] [int] NULL,
	[Banco] [int] NULL,
	[Upag] [varchar](15) NULL,
	[UfUpag] [char](2) NULL,
	[Contrato] [varchar](255) NULL,
	[Rubrica] [int] NULL,
	[Margem] [numeric](18, 2) NULL
) ON [PRIMARY]
GO

```
>14. Na data de 03/07/2023 alinhamos sobre a inserção dos dados nas tabelas de produção e o que foi acordado até o momento é que vamos nos basear no que está até então na tabela de produção. Desta forma pegamos as rubricas que o DBA até o momento separa e encontramos um total de 106.

```sql
--Essa query abaixo retirou as 106 da tabela que esta em DB. Pensando que as rubricas ate entao corretas vieram do ultimo carregamento do Fernando dos dados de SIAPE.
SELECT DISTINCT RUBRICA 
INTO CARGAS..ListagemRubrica
FROM DB..Contrato

```
>15. Baseando-se pela rubricas extraidas vamos fazer um Join entre os dados com essa tabela para inserir corretamente.

```sql
--Importante esse select para inserir na nova tabela.
--Os dados estão vindo de um join com tabela de rubrica que hoje esta rodando no servidor tabela CONTRATO EM DB.
--Será verificada possibilidade de mudança com as rubricas corretas, deixar essa listagem de rubrica sempre a mão para usar.
INSERT INTO DB..Contrato_NEW 
SELECT A.[Orgao]        AS CodOrgao
      ,[Instituidor]	AS Instituidor
      ,A.[Matricula]	AS Matricula
      ,A.[CPF]          AS Cpf
      ,A.[Nome]         AS Nome
      ,[Valor_PMT]      AS Valor
      ,[Prazo]          AS Prazo
      ,NULL             AS Banco
      ,A.[UPAG]         AS Upag
      ,A.[UF]           AS UfUpag
      ,A.[Contrato]     AS Contrato
      ,A.[Rubrica]      AS Rubrica 
      ,NULL             AS Margem
  FROM [CARGAS].[dbo].[D8P_SERV] a
  INNER JOIN CARGAS..listagemrubrica  b on a.Rubrica=b.Rubrica

  ```
  ---
  >16. Agora vamos inserir os dados na tabela DB..Consolidado_NEW, respeitando alguns campos da forma como é feita hoje (julho23). A coluna "Lixo" ja estava no ETL e estamos continuando o processo. Conforme informações esses campos em breve sofrerão atualizações. Outra regra é fazer o update para atualizar o campo Cartao onde Util5 maior que 0.

  ```sql
  --INSERT DOS ARQUIVOS JUNTOS VINDO DO EXCEL, PXLS e SXLS na tabela nova de DB..Consolidado_NEW
INSERT INTO DB..Consolidado_NEW
SELECT 
       [Orgao]                        AS Orgao
      ,[Instituidor]                  AS Instituidor
      ,[Matricula]                    AS Matricula
      ,[BaseCalc]                     AS BaseCalc
      ,[Bruta5]                       AS Bruta5
      ,[Utilz5]                       AS Util5
      ,[Saldo5]                       AS Saldo5
      ,[Bruta35]                      AS Bruta30
      ,[Utilz35]                      AS Util30
      ,[Saldo35]                      AS Saldo30
      ,[Bruta70]                      AS Bruta70
      ,[Utilz70]                      AS Util70
      ,[Saldo70]                      AS Saldo70
      ,[Creditos]                     AS RendaBruta
      ,[Debitos]                      AS Desconto
      ,[Liquido]                      AS TotalLiquido
      ,(SUBSTRING ([ARQUPAG],1,9))    AS UPAG
      ,(SUBSTRING ([ARQUPAG],11,12))  AS Sigla
      ,CONCAT(EXCQTD, ' - ', EXCSoma) AS Lixo
      ,[RJUR]                         AS RJUR
      ,[SitFunc]                      AS SituacaoFuncional
      ,[CPF]                          AS CPF
	  ,NULL                           AS MargemNova
	  ,0                              AS Cartao
      ,[Margem]                       AS MargemSaldo
	  ,NULL                           AS Margem_Antiga
  FROM CARGAS..PXLS_SXLS
  WHERE BaseCalc >0       -- Baseando-se na ultima atualização feita pelo DBA

GO

--Update coluna Cartao onde a coluna Util5 maior que 0.00
UPDATE DB..Consolidado_NEW
SET Cartao=1
WHERE Util5 >0.00

```
>17. Apos a inserção dos dados vamos criar os indices das tabelas DB..Contrato_NEW e DB..Consolidado_NEW. ***Obervação: Se o processo foi feito no servidor de ETL temos que carregar no de Produção e depois rodar os indices. 

```sql
--Criação dos Indices tabela DB..Consolidado_NEW
CREATE NONCLUSTERED INDEX [Idx_Consolidade_BaseCalc] ON DB..Consolidado_NEW
(
	[BaseCalc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [Idx_Consolidado_Cpf] ON DB..Consolidado_NEW
(
	[Cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_BaseCalc_MargemSaldo] ON DB..Consolidado_NEW
(
	[BaseCalc] ASC,
	[MargemSaldo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_BaseCalc_SituacaoFuncional_MargemSaldo_INCLUDE_Orgao] ON DB..Consolidado_NEW
(
	[BaseCalc] ASC,
	[SituacaoFuncional] ASC,
	[MargemNova] ASC
)
INCLUDE([Orgao]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_OrgaoBaseCalSitucaoFuncionalMargemSaldo] ON DB..Consolidado_NEW
(
	[Orgao] ASC,
	[BaseCalc] ASC,
	[SituacaoFuncional] ASC,
	[MargemNova] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

--Criação dos Indices tabela DB..Contrato_NEW
CREATE CLUSTERED INDEX [idx_Contrato_CPF] ON DB..Contrato_NEW
(
	[Cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Prazo_Ufupag_INDLUCE_Nome_Rubrica] ON DB..Contrato_NEW
(
	[Prazo] ASC,
	[UfUpag] ASC
)
INCLUDE([Nome],[Rubrica]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Rubrica_Prazo_ufuPAG_INCLUDE_nome] ON DB..Contrato_NEW
(
	[Rubrica] ASC,
	[Prazo] ASC,
	[UfUpag] ASC
)
INCLUDE([Nome]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Valor_Prazo_UFUPag_INCLUDE_Nome] ON DB..Contrato_NEW
(
	[Valor] ASC,
	[Prazo] ASC,
	[UfUpag] ASC
)
INCLUDE([Nome]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idxnc_Contrato_Rubrica] ON DB..Contrato_NEW
(
	[Rubrica] ASC
)
INCLUDE([Cpf]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

```

>18. Terminado o processo renomeie DB..Consolidado para DB..Consolidado_OLD e depois DB..Consolidado_NEW para DB..Consolidado, faça isso também com a Contrato.


<div align="center">
    <img src="./Pngs/Tabelas_NEW.png" alt="DashGo Sistema" height="150">
</div>

```sql

EXEC sp_rename 'DB..Consolidado', 'Consolidado_OLD'
EXEC sp_rename 'DB..Consolidado_NEW', 'Consolidado'
GO

EXEC sp_rename 'DB..Contrato', 'Contrato_OLD'
EXEC sp_rename 'DB..Contrato_NEW', 'Contrato'

```