
# Tabela CA AeroSetor e AeroBanco rotina mensal de atualização
---
## Essa documentação descreve o processo de atualização das tabelas AeroSetor e AeroBanco em CA.
---

>1. As duas tabelas tem dados provenientes de CAMPANHAS..AeroReceitasDespesas onde: Setor=UPAG, ou seja, após a atualização da descrição das UPAGs, geramos a tabela para que possa ser consultada pelo sistema. 

```sql
--Verificar antes se o número de UPAGs é o mesmo da tabela anterior, caso seja, não é necessário gerar nova tabela.
SELECT UPAG, DESC_UPAG
--INTO CA..AeroSetor_NEW      --retire os traços do começo se for gerar nova tabela.
FROM CA..AeroReceitasDespesas_NEW
GROUP BY UPAG, DESC_UPAG

```

>2. Tabela AeroBanco também é proveniente da tabela CA..AeroReceitasDespesas onde: CAIXA=Banco, e algumas regras são aplicadas para esse filtro. Em conversa com a liderança ficou estipulado que não é para subir os caixas que tem FH em seu nome e POUPEX na tabela AeroBanco.

```sql 
--Verificar antes se o numero de bancos é o mesmo da tabela anterior, caso seja, nao é necessário gerar nova tabela.
--Ao gerar nova tabela fique atento ao nome dos bancos para seguir um padrão.
SELECT CAIXA, DESC_CAIXA
--INTO CA..AeroBanco_NEW      --retire os traços do começo se for gerar nova tabela.
FROM CA..AeroReceitasDespesas_New
WHERE CAIXA LIKE 'J%' AND DESC_CAIXA NOT LIKE 'FH%' AND DESC_CAIXA NOT LIKE 'POUPE%'
GROUP BY CAIXA, DESC_CAIXA
ORDER BY CAIXA 

--Abaixo temos um exemplo de como verificar os bancos que faltam em ambas as tabelas USANDO O FULL OUTER JOIN.
SELECT DISTINCT A.CAIXA tabelaA, A.DESC_CAIXA tabelaA, B.CAIXA tabelaB, B.DESC_CAIXA tabelaB
FROM CA..AeroReceitasDespesas_New A
FULL OUTER JOIN CARGAS..AeroBanco B ON A.CAIXA=B.CAIXA
WHERE A.CAIXA IS NULL OR B.CAIXA IS NULL AND A.CAIXA LIKE 'J%' AND A.DESC_CAIXA NOT LIKE 'FH%'

```


