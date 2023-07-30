>1. Analise efetuada no dia 06/07/2023. Ajustar a documentação pois pode ser que usemos novamente. Tabela CAMPANHAS2..FgtsCampanha, verificando quais UFs estão diferentes com a CAMPANHAS..Telefone baseado no DDD de Tel1.

```sql

SELECT TOP 10 *
FROM CAMPANHAS2..FgtsCampanha
WHERE NR_CPF IN ('15584628808')


--Verificando a quantidade de CPFs DISTINTOS --2.418.194
SELECT COUNT(DISTINCT NR_CPF) FROM CAMPANHAS2..FgtsCampanha

--Verificando o porque das repetições dos CPFs.
SELECT NR_CPF, COUNT(NR_CPF) REPETICAO
FROM CAMPANHAS2..FgtsCampanha
GROUP BY NR_CPF
HAVING COUNT(NR_CPF) >1
ORDER BY REPETICAO DESC

--Verificando os registros que nao tem UF com campo NULL --887 REGISTROS
SELECT *
FROM CAMPANHAS2..FgtsCampanha
WHERE NM_ESTADO IS NULL


--Verificando os registros que nao tem UF com campo VAZIO --2.940 REGISTROS
SELECT *
FROM CAMPANHAS2..FgtsCampanha
WHERE NM_ESTADO =''

SELECT TOP 10 * FROM CARGAS..POTE_DE_OURO
WHERE STATUS_HIGIEN=0



--Verificando quantos CPFs tem na tabela de Telefone --2.242.315 
SELECT COUNT(DISTINCT A.NR_CPF)
FROM CAMPANHAS2..FgtsCampanha A
INNER JOIN CAMPANHAS..Telefone B ON A.NR_CPF=B.Cpf

--Verificando quantos CPFs nao tem na tabela de Telefone --175.879
SELECT COUNT(DISTINCT A.NR_CPF)
FROM CAMPANHAS2..FgtsCampanha A
LEFT JOIN CAMPANHAS..Telefone B ON A.NR_CPF=B.Cpf
WHERE B.Cpf IS NULL

--Verificando a partir da tabela DDD_UF quantos estados são diferentes na tabela fgtscampanhas.
SELECT A.NR_CPF
      ,A.NM_NOME
	  ,B.Tel1
	  ,A.NM_ESTADO AS UF_FGTS
	  ,C.UF AS UF_DDD
FROM CAMPANHAS2..FgtsCampanha A 
INNER JOIN CAMPANHAS..Telefone B ON A.NR_CPF = B.Cpf
INNER JOIN CARGAS..DDD_UF C ON C.DDD = LEFT(B.Tel1, 2)
WHERE A.NM_ESTADO <> C.UF
ORDER BY UF_FGTS

UPDATE A
SET A.NM_ESTADO=C.UF
FROM CAMPANHAS2..FgtsCampanha A 
INNER JOIN CAMPANHAS..Telefone B ON A.NR_CPF = B.Cpf
INNER JOIN CARGAS..DDD_UF C ON C.DDD = LEFT(B.Tel1, 2)
WHERE A.NM_ESTADO <> C.UF

```