# Processo de ETL e inserção de atualização na tabelas de Aero.

## Robo faz a leitura dos arquivos de Aero e armazena no server de ETL na database FORNECEDOR, nas tabelas tbAero_CCH e tbAero_CCH_Discriminacao.

> 1. Quando for enviado novos arquivos para leitura do robo as tabelas devem ser truncadas para o recebimento de novos dados. Lembrando que os dados anteriores ja devem ser tratados e feito update nas tabelas de destino.

```sql
--Copia da tabelas para outra database afim de efetuar o ETL
SELECT * INTO CARGAS..tbAero_CCH FROM FORNECEDOR..tbAero_CCH

SELECT * INTO CARGAS..tbAero_CCH_Discriminacao FROM FORNECEDOR..tbAero_CCH_Discriminacao


--Inicio processo de ETL
--Removendo espaços no campo de matricula.
UPDATE CARGAS..tbAero_CCH
SET MATRICULA = RTRIM(LTRIM(REPLACE(MATRICULA, ' ', '')));

--Tome cuidado ao deletar registros, faça um select antes para certificar
DELETE FROM CARGAS..tbAero_CCH
WHERE ISNUMERIC(CPF)=0

```
>2. Tratamentos dos dados de valores.
```sql
UPDATE CARGAS..tbAero_CCH
SET VALOR_TOTAL_RECEITA=  CASE
                            WHEN LEN(VALOR_TOTAL_RECEITA) = 1 THEN '0'  
                            WHEN VALOR_TOTAL_RECEITA LIKE '%.%'AND VALOR_TOTAL_RECEITA LIKE '%,%' THEN REPLACE(REPLACE(VALOR_TOTAL_RECEITA, '.',''),',','.')
                            WHEN VALOR_TOTAL_RECEITA LIKE '%,%' THEN REPLACE(VALOR_TOTAL_RECEITA, ',','.')
                            ELSE VALOR_TOTAL_RECEITA
                          END
   ,VALOR_TOTAL_DESPESA = CASE
                            WHEN LEN(VALOR_TOTAL_DESPESA) = 1 THEN '0'
                            WHEN VALOR_TOTAL_DESPESA LIKE '%.%'AND VALOR_TOTAL_DESPESA LIKE '%,%' THEN REPLACE(REPLACE(VALOR_TOTAL_DESPESA, '.',''),',','.')
                            WHEN VALOR_TOTAL_DESPESA LIKE '%,%' THEN REPLACE(VALOR_TOTAL_DESPESA, ',','.')
                            ELSE VALOR_TOTAL_DESPESA
                          END
   ,VALOR_TOTAL_LIQUIDO = CASE
                            WHEN LEN(VALOR_TOTAL_LIQUIDO) = 1 THEN '0'
                            WHEN VALOR_TOTAL_LIQUIDO LIKE '%.%'AND VALOR_TOTAL_LIQUIDO LIKE '%,%' THEN REPLACE(REPLACE(VALOR_TOTAL_LIQUIDO, '.',''),',','.')
                            WHEN VALOR_TOTAL_LIQUIDO LIKE '%,%' THEN REPLACE(VALOR_TOTAL_LIQUIDO, ',','.')
                            ELSE VALOR_TOTAL_LIQUIDO
                          END
GO

--Alteração dos campos para decimal, nao pode dar erro.
ALTER TABLE CARGAS..TBAERO_CCH ALTER COLUMN VALOR_TOTAL_RECEITA DECIMAL(18,2)
ALTER TABLE CARGAS..TBAERO_CCH ALTER COLUMN VALOR_TOTAL_DESPESA DECIMAL(18,2)
ALTER TABLE CARGAS..TBAERO_CCH ALTER COLUMN VALOR_TOTAL_LIQUIDO DECIMAL(18,2)
ALTER TABLE CARGAS..TBAERO_CCH ALTER COLUMN CPF BIGINT
GO
```
---

> 3. Faça o update dos dados de BANCO, AGENCIA e CONTA da tabela que o Robo gerou para a tabela CAMPANHAS..AeroDadosPessoais_NEW

```sql
UPDATE A
SET A.BANCO=B.BANCO
   ,A.AGENCIA=B.AGENCIA
   ,A.CONTA=B.CONTA_CORRENTE
   ,A.ISENCAO_IR=B.ISENCAO_IR
FROM CAMPANHAS2..AeroDadosPessoais_NEW A
INNER JOIN CARGAS..tbAero_CCH B ON A.CPF=B.CPF
```

## Copie as novas tabelas CAMPANHAS2..AeroDadosPessoais_NEW e AeroReceitasDespesas_NEW e não ESQUEÇA DE CRIAR OS INDICES.