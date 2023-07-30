## Solicitações de Rotina para higienização dos Telefones. Sempre na ****FAIXA ETÁRIA ENTRE 18 e 75 ANOS,** e CPFs DISTINTOS.

```sql

--Quantidade de CPFs que não estão na tabela Telefone x Entrante e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.CPF) AS Entrante_sem_Telefone 
FROM CAMPANHAS..Entrante A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.DataNascimento, GETDATE()) BETWEEN 18 AND 75


--Quantidade de CPFs que não estão na tabela Telefone x AtivoZero e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.CPF) AS Nao_Tomadores_sem_Telefone 
FROM CAMPANHAS..AtivoZero A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.DataNascimento, GETDATE()) BETWEEN 18 AND 75

--Quantidade de CPFs que não estão na tabela Telefone x DadosPessoais e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.CPF) AS Tomadores_sem_Telefone 
FROM CAMPANHAS..Dados_Pessoais A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.DataNascimento, GETDATE()) BETWEEN 18 AND 75

--Quantidade de CPFs que não estão na tabela Telefone x Aeronautica e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.CPF) AS Aeronautica_sem_Telefone 
FROM CAMPANHAS2..AeroDadosPessoais A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.DT_NASCIMENTO, GETDATE()) BETWEEN 18 AND 75

--Quantidade de CPFs que não estão na tabela Telefone x Exercito e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.CPF) AS Exercito_sem_Telefone 
FROM CAMPANHAS2..Exercito A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.Dt_Nasc, GETDATE()) BETWEEN 18 AND 75

--Quantidade de CPFs que não estão na tabela Telefone x Exercito e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.CPF) AS Governo_sem_Telefone 
FROM CAMPANHAS..GOVERNO A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.NASC, GETDATE()) BETWEEN 18 AND 75



--Quantidade de CPFs que não estão na tabela Telefone x FgtsCampanha e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.NR_CPF) AS FgtsCampanha_sem_Telefone 
FROM CAMPANHAS2..FgtsCampanha A
LEFT JOIN CAMPANHAS..Telefone B ON A.nr_cpf=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.nr_cpf=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.DT_NASCIMENTO, GETDATE()) BETWEEN 18 AND 75

--Quantidade de CPFs que não estão na tabela Telefone x SIAPE e que não estão na tabela BLACKLISTDETALHES
SELECT COUNT(DISTINCT A.nr_cpf) AS SIAPE_sem_Telefone 
FROM CARGAS..CadastroSIAPE A
LEFT JOIN CAMPANHAS..Telefone B ON A.nr_cpf=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.nr_cpf=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND DATEDIFF(YEAR, A.data_nasc, GETDATE()) BETWEEN 18 AND 75

```
>2. Quantidade de CPFs e CPFs do representante que não estão na tabela Telefone x AtivoZero e Dados_Beneficio e que não estão na tabela BLACKLISTDETALHES. Onde Representante =1 e qualquer idade.

```sql
--Pesquisando Dados_Beneficio
SELECT DISTINCT A.CPF CPF_Beneficiario, A.Cpf_Representante, A.NomeRepresentante
FROM CAMPANHAS..Dados_Beneficio A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND A.Representante=1 AND A.Cpf_Representante >0

```
```sql
--Pesquisando AtivoZero
SELECT DISTINCT A.CPF CPF_Beneficiario, A.Cpf_Representante, A.Nome_Representante
FROM CAMPANHAS..AtizoZero A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF=B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF=C.CPF
WHERE B.CPF IS NULL AND C.Cpf IS NULL AND A.Representante=1 AND A.Cpf_Representante >0

```
>3. Para os resultados acima de 1 milhao de linhas, temos que criar uma tabela temporaria com id auto-incremento para poder fazer um select em partes.

```sql
-- Criando uma nova tabela com auto incremento
CREATE TABLE CARGAS..AtivoZeroTEl (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CPF VARCHAR(11)
);

-- Inserindo o resultado na nova tabela.
INSERT INTO CARGAS..AtivoZeroTEl (CPF)
SELECT DISTINCT A.CPF 
FROM CAMPANHAS..AtivoZero A
LEFT JOIN CAMPANHAS..Telefone B ON A.CPF = B.CPF
LEFT JOIN CAMPANHAS..BlackListDetalhes C ON A.CPF = C.CPF
WHERE B.CPF IS NULL 
    AND C.Cpf IS NULL 
    AND DATEDIFF(YEAR, A.DataNascimento, GETDATE()) BETWEEN 18 AND 75;

--Select em partes iguais de 500.000 registros.
SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 1 AND 500000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 500001 AND 1000000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 1000001 AND 1500000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 1500001 AND 2000000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 2000001 AND 2500000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 2500001 AND 3000000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 3000001 AND 3500000
GO

SELECT *
FROM CARGAS..AtivoZeroTEL
WHERE ID BETWEEN 3500001 AND 4000000
GO

```




