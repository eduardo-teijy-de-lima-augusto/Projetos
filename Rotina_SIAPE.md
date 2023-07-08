>1. Inicio do processo para subir a base de SIAPE mensal em MOVEDB. Os arquivos vem dessa forma como a figura demonstra. Os mesmos devem juntar com a mesma estrutura a principio copiando via CMD os tipos SERV e PENS. Abaixo vamos descrever esse processo.



<div align="center">
    <img src="./Pngs/RotinaSIAPEArquivos.png" alt="DashGo Sistema" height="200">
</div>


>>Essa informação foi repassada pelo Tiago no dia 04/07/2023 pois se trata das Rubricas que estão no ONEDRIVE pasta Anderson (em relação ao SIAPE) e importadas na Tabela CARGAS..RUBRICA1. Apenas para informação registrada por enquanto.

```txt
00 rubricas de Rendimento e descontos
01 obrigatórias sindicatos e afins
02 facultativas 
03 planos de saúde
05 cartão de crédito
99 obrigatórias oficiais

```

>2. Então vamos copiar os conteudos dos arquivos para um arquivo em SERV.TXT e outro PENS.TXT

```txt
copy "* SERV d8" SERV.txt
```
>Copiando todos os arquivos que tem no nome o SERV d8 para SERV.TXT

```txt
copy "* pens d8" PENS.txt
```
>Copiando todos os arquivos que tem no nome o PENS d8 para PENS.TXT

>3. Essa é a estrutura das tabelas para inserção dos dados do arquivo.

```sql
--Essa estrutura cria o arquivo que vai receber os campos que foram adicionados em PENS.TXT

CREATE TABLE CARGAS.[dbo].[D8Pensao_Geral](
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

--Essa estrutura cria o arquivo que vai receber os campos que foram adicionados em SERV.TXT
CREATE TABLE CARGAS.[dbo].[D8Serv_Geral](
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

>4. Subir o arquivo PENS.TXT e SERV.TXT para tabelas mesmo com apenas uma coluna, pois vamos usar o SUBSTRING para que possamos inserir nas tabelas acima criadas os dados do arquivo. ***RETIRE A OPÇÃO DE CABEÇALHO POIS OS ARQUIVOS NAO POSSUEM CABEÇALHO**.
---

>5. Essa é a forma para padronizar os campos da tabela D8Pensao_Geral e D8Serv_Geral.
```sql

--Inserindo dados da tabela CARGAS.PENS conforme orientação sobre as posições de cada campo.
INSERT INTO CARGAS..D8Pensao_Geral  (Orgao
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
    FROM CARGAS..PENS
GO

--Inserindo dados da tabela CARGAS.SERV conforme orientação sobre as posições de cada campo.
INSERT INTO CARGAS..D8Serv_Geral(Orgao
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
    FROM CARGAS..SERV

  ```
---
>6. O campo Valor_PMT vem no formato 0000139200. É necessario transormar ele para decimal(18,2), entretanto temos que nos atentar pois só mudar o campo para decimal fará com que 139200 fique como 13920.00 o que esta errado, o valor correto seria 1392.00.

```sql
--Deleta algum registro sujo vazio da tabela CARGAS..D8Pensao_Geral
DELETE FROM CARGAS..D8Pensao_Geral
WHERE Instituidor='' AND Matricula='' AND UPAG='' AND UF=''
GO

--Altera o campo para decimal da tabela CARGAS..D8Pensao_Geral
ALTER TABLE CARGAS..D8Pensao_Geral
ALTER COLUMN VALOR_PMT DECIMAL(18,2)
GO

--Update do valor correto dividindo por 100 da tabela CARGAS..D8Pensao_Geral
UPDATE CARGAS..D8Pensao_Geral
SET Valor_PMT=CAST(VALOR_PMT AS decimal (18,2)) /100
GO 


--Deleta algum registro sujo vazio da tabela CARGAS..D8Serv_Geral
DELETE FROM CARGAS..D8Serv_Geral
WHERE Valor_PMT='' AND Matricula='' AND UPAG='' AND UF=''
GO

--Altera o campo para decimal CARGAS..D8Serv_Geral
ALTER TABLE CARGAS..D8Serv_Geral
ALTER COLUMN VALOR_PMT DECIMAL(18,2)
GO

--Update do valor correto dividindo por 100. CARGAS..D8Serv_Geral
UPDATE CARGAS..D8Serv_Geral
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
  INTO CARGAS..D8PENSAO_SERV
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
  FROM [dbo].[D8Serv_Geral]

GO

```

---

>8. Agora importe as duas tabelas do excel enviadas do mes como exemplo PENS 2023 06 (2306 1945-WINDOWS-PC).xlsx e SERV 2023 06 (2306 1946-WINDOWS-PC).xlsx. ***ABRA OS ARQUIVOS E SALVE AS PLANILHAS PARA .TXT*** Coloque os nomes CARGAS..PENSXLS E SERVXLS para identificar as origens. *****FICAR ATENTO POIS PODE VIR MAIS DE UMA PLANILHA POR ARQUIVO***.  Caso de erro na importação, abra o arquivo de excel e grave as planilhas em .TXT, desta forma funcionará. Abaixo as querys para tratamento apos a correta importação.

```sql
--Select simples para visualizar o conteudo e se adequar as colunas.
--Se no arquivo SERVXLS veio mais de uma planilha, teremos que juntar o mesmo em uma tabela.
SELECT TOP 10 * FROM CARGAS..PENSXLS
SELECT TOP 10 * FROM CARGAS..SERVXLS
SELECT TOP 10 * FROM CARGAS..SERVXLS1

```
---
```sql
--Vamos padronizar nomes dos campos de CARGAS..PENSXLS, há muitos acentos e espaços nos nomes de colunas.
EXEC sp_rename 'CARGAS..PENSXLS.[OrgÆo]',         'Orgao',          'COLUMN'	
EXEC sp_rename 'CARGAS..PENSXLS.[Matricula]',     'Matricula',      'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Base Calc]',     'BaseCalc',       'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Bruta 5%]',      'Bruta5',         'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Utilz 5%]',      'Utilz5',         'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Saldo 5%]',      'Saldo5',         'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Bruta 35%]',     'Bruta35',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Utilz 35%]',     'Utilz35',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Saldo 35%]',     'Saldo35',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Bruta 70%]',     'Bruta70',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Utilz 70%]',     'Utilz70',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Saldo 70%]',     'Saldo70',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Cr‚ditos]',      'Creditos',       'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[D‚bitos]',       'Debitos',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[L¡quido]',       'Liquido',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[ARQ  UPAG]',     'ARQUPAG',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[EXC QTD]',       'EXCQTD',         'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[EXC Soma]',      'EXCSoma',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[RJUR]',          'RJUR',           'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Sit Func]',      'SitFunc',        'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[CPF]',           'CPF',            'COLUMN'
EXEC sp_rename 'CARGAS..PENSXLS.[Margem]',        'Margem',         'COLUMN'


--Vamos padronizar nomes dos campos de CARGAS..SERVXLS, há muitos acentos e espaços nos nomes de colunas.
EXEC sp_rename 'CARGAS..SERVXLS.[OrgÆo]',         'Orgao',          'COLUMN'	
EXEC sp_rename 'CARGAS..SERVXLS.[Matricula]',     'Matricula',      'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Base Calc]',     'BaseCalc',       'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Bruta 5%]',      'Bruta5',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Utilz 5%]',      'Utilz5',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Saldo 5%]',      'Saldo5',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Bruta 35%]',     'Bruta35',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Utilz 35%]',     'Utilz35',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Saldo 35%]',     'Saldo35',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Bruta 70%]',     'Bruta70',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Utilz 70%]',     'Utilz70',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Saldo 70%]',     'Saldo70',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Cr‚ditos]',      'Creditos',       'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[D‚bitos]',       'Debitos',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[L¡quido]',       'Liquido',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[ARQ  UPAG]',     'ARQUPAG',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[EXC QTD]',       'EXCQTD',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[EXC Soma]',      'EXCSoma',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[RJUR]',          'RJUR',           'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Sit Func]',      'SitFunc',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[CPF]',           'CPF',            'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS.[Margem]',        'Margem',         'COLUMN'

--Vamos padronizar nomes dos campos de CARGAS..SERVXLS1 **(SE HOUVER)**, há muitos acentos e espaços nos nomes de colunas.
EXEC sp_rename 'CARGAS..SERVXLS1.[OrgÆo]',         'Orgao',          'COLUMN'	
EXEC sp_rename 'CARGAS..SERVXLS1.[Matricula]',     'Matricula',      'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Base Calc]',     'BaseCalc',       'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Bruta 5%]',      'Bruta5',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Utilz 5%]',      'Utilz5',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Saldo 5%]',      'Saldo5',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Bruta 35%]',     'Bruta35',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Utilz 35%]',     'Utilz35',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Saldo 35%]',     'Saldo35',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Bruta 70%]',     'Bruta70',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Utilz 70%]',     'Utilz70',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Saldo 70%]',     'Saldo70',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Cr‚ditos]',      'Creditos',       'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[D‚bitos]',       'Debitos',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[L¡quido]',       'Liquido',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[ARQ  UPAG]',     'ARQUPAG',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[EXC QTD]',       'EXCQTD',         'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[EXC Soma]',      'EXCSoma',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[RJUR]',          'RJUR',           'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Sit Func]',      'SitFunc',        'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[CPF]',           'CPF',            'COLUMN'
EXEC sp_rename 'CARGAS..SERVXLS1.[Margem]',        'Margem',         'COLUMN'

```
---
>9. Vamos juntar SERVXLS com SERVXLS1, pois no arquivo de excel tinhamos duas abas que forma separadas por limitação do EXCEL em LINHAS.

```sql
--Juntando o conteudo de SERVXLS1 na tabela SERVXLS para completar as duas planilhas de origem.
INSERT INTO CARGAS..SERVXLS
SELECT * FROM CARGAS..SERVXLS1

```
---
>10. Processo de ETL completo em PENSXLS e SERVXLS.

```sql
--Alteração dos campos da tabela CARGAS..PENSXLS para valores decimais padrão SQL.
UPDATE CARGAS..PENSXLS
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
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN BaseCalc decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Bruta5 decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Utilz5 decimal(18,2)
    GO
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Saldo5 decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Bruta35 decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Utilz35 decimal(18,2)
    GO
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Saldo35 decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Bruta70 decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Utilz70 decimal(18,2)
    GO
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Saldo70 decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Creditos decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Debitos decimal(18,2)
    GO    
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Liquido decimal(18,2)
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN CPF bigint
    ALTER TABLE CARGAS..PENSXLS ALTER COLUMN Margem decimal(18,2)
    GO

```
---
>11. Vamos fazer o ETL de CARAS..SERVXLS ***(VERFICAR SE PODEMOS JUNTAR AS DUAS PARA UM ETL SO)*******
```sql
--Alteração dos campos da tabela CARGAS..SERVXLS para valores decimais padrão SQL.
UPDATE CARGAS..SERVXLS
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
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN BaseCalc decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Bruta5 decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Utilz5 decimal(18,2)
    GO
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Saldo5 decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Bruta35 decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Utilz35 decimal(18,2)
    GO
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Saldo35 decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Bruta70 decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Utilz70 decimal(18,2)
    GO
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Saldo70 decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Creditos decimal(18,2)
    GO
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Debitos decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Liquido decimal(18,2)
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN CPF bigint
    ALTER TABLE CARGAS..SERVXLS ALTER COLUMN Margem decimal(18,2)
    GO

```
---
>12. Após o ETL pronto, vamos juntar as duas tabelas, PENSXLS e SERVXLS. Confirmar com Anderson se podemos juntar as duas.

```sql
--Juntando as duas tabelas PENSXLS e SERVXLS que vieram dos arquivos em EXCEL.
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
  INTO CARGAS..PENSXLS_SERVXLS
  FROM CARGAS..[PENSXLS]

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
  FROM CARGAS..SERVXLS

GO
```
---

>13. Todos esses dados serão inseridos em diferentes tabelas, então deixei uma query pronta para criação das supostas tabelas usadas em MOVEDB, Cadastro_NEW, Consolidado_NEW, Contrato_NEW. Verificar se precisa de mais tabelas.

```sql
--Tabela Consolidado em MOVEDB
CREATE TABLE MOVEDB..Consolidado_NEW(
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

--Tabela Contrato em MOVEDB
CREATE TABLE MOVEDB..Contrato_NEW(
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
--Essa query abaixo retirou as 106 da tabela que esta em MOVEDB. Pensando que as rubricas ate entao corretas vieram do ultimo carregamento do Fernando dos dados de SIAPE.
SELECT DISTINCT RUBRICA 
INTO CARGAS..ListagemRubrica
FROM MOVEDB..Contrato

```
>15. Baseando-se pela rubricas extraidas vamos fazer um Join entre os dados com essa tabela para inserir corretamente.

```sql
--Importante esse select para inserir na nova tabela.
--Os dados estão vindo de um join com tabela de rubrica que hoje esta rodando no servidor tabela CONTRATO EM MOVEDB.
--Será verificada possibilidade de mudança com as rubricas corretas, deixar essa listagem de rubrica sempre a mão para usar.
INSERT INTO MOVEDB..Contrato_NEW 
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
  FROM [CARGAS].[dbo].[D8PENSAO_SERV] a
  INNER JOIN CARGAS..listagemrubrica  b on a.Rubrica=b.Rubrica

  ```
  ---
  >16. Agora vamos inserir os dados na tabela MOVEDB..Consolidado_NEW, respeitando alguns campos da forma como é feita hoje (julho23). A coluna "Lixo" ja estava no ETL e estamos continuando o processo. Conforme informações do Anderson esses campos em breve sofrerão atualizações. Outra regra é fazer o update para atualizar o campo Cartao onde Util5 maior que 0.

  ```sql
  --INSERT DOS ARQUIVOS JUNTOS VINDO DO EXCEL, PENXLS e SERVXLS na tabela nova de MOVEDB..Consolidado_NEW
INSERT INTO MOVEDB..Consolidado_NEW
SELECT [Orgao]                        AS Orgao
      ,[Instituidor]                  AS Instituidor
      ,[Matricula]                    AS Matricula
      ,[BaseCalc]                     AS BaseCalc
      ,[Bruta5]	                      AS Bruta5
      ,[Utilz5]	                      AS Util5
      ,[Saldo5]	                      AS Saldo5
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
      ,[SitFunc]			          AS SituacaoFuncional
      ,[CPF]                          AS CPF
	  ,NULL                           AS MargemNova
	  ,0                              AS Cartao
      ,[Margem]                       AS MargemSaldo
	  ,NULL                           AS Margem_Antiga
  FROM CARGAS..PENSXLS_SERVXLS
  WHERE BaseCalc >0       -- Baseando-se na ultima atualização feita pelo DBA

GO

--Update coluna Cartao onde a coluna Util5 maior que 0.00
UPDATE MOVEDB..Consolidado_NEW
SET Cartao=1
WHERE Util5 >0.00

```
>17. Apos a inserção dos dados vamos criar os indices das tabelas MOVEDB..Contrato_NEW e MOVEDB..Consolidado_NEW. ***Obervação: Se o processo foi feito no servidor de ETL temos que carregar no de Produção e depois rodar os indices. 

```sql
--Criação dos Indices tabela MOVEDB..Consolidado_NEW
CREATE NONCLUSTERED INDEX [Idx_Consolidade_BaseCalc] ON MOVEDB..Consolidado_NEW
(
	[BaseCalc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [Idx_Consolidado_Cpf] ON MOVEDB..Consolidado_NEW
(
	[Cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_BaseCalc_MargemSaldo] ON MOVEDB..Consolidado_NEW
(
	[BaseCalc] ASC,
	[MargemSaldo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_BaseCalc_SituacaoFuncional_MargemSaldo_INCLUDE_Orgao] ON MOVEDB..Consolidado_NEW
(
	[BaseCalc] ASC,
	[SituacaoFuncional] ASC,
	[MargemNova] ASC
)
INCLUDE([Orgao]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_OrgaoBaseCalSitucaoFuncionalMargemSaldo] ON MOVEDB..Consolidado_NEW
(
	[Orgao] ASC,
	[BaseCalc] ASC,
	[SituacaoFuncional] ASC,
	[MargemNova] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

--Criação dos Indices tabela MOVEDB..Contrato_NEW
CREATE CLUSTERED INDEX [idx_Contrato_CPF] ON MOVEDB..Contrato_NEW
(
	[Cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Prazo_Ufupag_INDLUCE_Nome_Rubrica] ON MOVEDB..Contrato_NEW
(
	[Prazo] ASC,
	[UfUpag] ASC
)
INCLUDE([Nome],[Rubrica]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Rubrica_Prazo_ufuPAG_INCLUDE_nome] ON MOVEDB..Contrato_NEW
(
	[Rubrica] ASC,
	[Prazo] ASC,
	[UfUpag] ASC
)
INCLUDE([Nome]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_N_CLU_Valor_Prazo_UFUPag_INCLUDE_Nome] ON MOVEDB..Contrato_NEW
(
	[Valor] ASC,
	[Prazo] ASC,
	[UfUpag] ASC
)
INCLUDE([Nome]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idxnc_Contrato_Rubrica] ON MOVEDB..Contrato_NEW
(
	[Rubrica] ASC
)
INCLUDE([Cpf]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

```

>18. Terminado o processo renomeie MOVEDB..Consolidado para MOVEDB..Consolidado_OLD e depois MOVEDB..Consolidado_NEW para MOVEDB..Consolidado, faça isso também com a Contrato.

```sql

EXEC sp_rename 'MOVEDB..Consolidado', 'Consolidado_OLD'
EXEC sp_rename 'MOVEDB..Consolidado_NEW', 'Consolidado'
GO

EXEC sp_rename 'MOVEDB..Contrato', 'Contrato_OLD'
EXEC sp_rename 'MOVEDB..Contrato_NEW', 'Contrato'

```