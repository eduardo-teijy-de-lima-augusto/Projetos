
# Tabela DB..Cadastro x DB..Consolidado.
---
## Solictação enviada dia 05/07/2023 para verificar quantos CPFs estão em Consolidados mas não estão em Cadastro do SI.
---

>1. Verificado a quantidade de CPFs, e foram encontrados 96.808 CPFs DISTINTOS que estão em Consolidado e não estão em Cadastro.

```sql
--Selecionando os CPFs de Consolidado que não estão em Cadastro. -- Total de 96.808 distintos.
SELECT DISTINCT A.CPF
FROM DB..Consolidado A
LEFT JOIN DB..Cadastro B on A.CPF=B.NR_CPF
WHERE B.NR_CPF IS NULL

```

>2. Cruzar com a tabela de CARGAS..CPF_UF para pegar as datas de nascimento, nome e nome da mãe. Encontrado 96.349 CPFs, DT_NASCIMENTO e NOME. Destes, 459 registros não retornaram e conforme informação da liderança os mesmos não devem ser higienizados pois em consulta online de amostra, nao retornaram.

```sql
--Cruzando com CPF_UF PARA PEGAR A O NOME DA MAE.
UPDATE A
SET A.DT_NASCIMENTO=B.NASC
   ,A.NOME=B.NOME
   ,A.NOME_MAE=B.NOME_MAE 
FROM SI..SIConsolidadoCadastro A
INNER JOIN CARGAS..CPF_UF  B ON A.Cpf=B.CPF
WHERE A.NOME IS NULL

--Cruzando com CPF_Pessoas PARA PEGAR A O NOME e NASC.
UPDATE A
SET A.DT_NASCIMENTO=B.NASC
   ,A.NOME=B.NOME
   ,A.NOME_MAE=B.NOME_MAE 
FROM SI..SIConsolidadoCadastro A
INNER JOIN CARGAS..CPF_UF  B ON A.Cpf=B.CPF
WHERE A.NOME IS NULL

```
>3. Importar para produção essa tabela higienizada e inserir na tabela DB..Cadatro esses 96.349 registros com cpf, nome, nome mae e dt_nascimento. Informar a diretoria sobre essa inserção.

```sql
INSERT INTO DB..Cadastro (matricula, nr_cpf, ds_nome, ds_nome_mae, data_nasc)
SELECT  Matricula       AS MATRICULA
       ,CPF             AS NR_CPF
       ,NOME            AS DS_NOME
       ,NOME_MAE        AS DS_NOME_MAE
       ,DT_NASCIMENTO   AS DATA_NASC
FROM CARGAS..SIConsolidadoCadastro
WHERE DT_NASCIMENTO IS NOT NULL   --Desta forma nao estamos inserindo os 459 que não tem dt_nascimento
```
>4. Verificar agora novamente quantos CPFs de consolidado não estão em cadastro.

```sql
--Retornou correto, apenas 459 CPFs que não serão higienizados pois nao irá retornar.
SELECT DISTINCT A.CPF
FROM DB..Consolidado A
LEFT JOIN DB..Cadastro B on A.CPF=B.NR_CPF
WHERE B.NR_CPF IS NULL

```
>5. Pesquisar nas duas tabelas DB..Consolidado e DB..Cadastro o numero de CPFs que não estão em CAMPANHAS..Telefone.

```sql
--Verficando consolidado  --104.514
SELECT COUNT(DISTINCT A.CPF)
FROM DB..Consolidado A
LEFT JOIN CAMPANHAS..Telefone B on A.CPF=B.CPF
WHERE B.CPF IS NULL

--Lista com os CPFs para ser gravado em um excel e enviado para higienização.
SELECT DISTINCT A.CPF
FROM DB..Consolidado A
LEFT JOIN CAMPANHAS..Telefone B on A.CPF=B.CPF
WHERE B.CPF IS NULL 

```
>5. Ao retornar, validar quantos CPFs foram higienizados e contabilizar.

```sql

