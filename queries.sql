/**
* 1.
* Qual o concelho onde se fez o maior volume de vendas hoje?
*/

--venda_farmacia->inst->concelho
SELECT concelho.nome
FROM concelho
    NATURAL JOIN instituicao
    NATURAL JOIN(
        SELECT * 
        FROM venda_farmacia
        WHERE data_registo = GETDATE()
    ) 
-- tabela com todas vendas_farmacia do dia com os concelhos
GROUP BY concelho.nome
HAVING COUNT(*) > ALL
    (SELECT count(*)
    FROM concelho
    NATURAL JOIN instituicao
    NATURAL JOIN(
        SELECT * 
        FROM venda_farmacia
        WHERE data_registo = GETDATE()
    ) 
    GROUP BY concelho.nome)
-- tabela com todas vendas_farmacia do dia com os concelhos

/** 
* 2.
* Qual o médico que mais prescreveu no 1º semestre de 2019 em cada região?
*/
--prescricao->consulta->regiao
SELECT medico, regiao.nome
FROM(
    SELECT *
    FROM prescricao
    WHERE prescricao.data BETWEEN 01/01/2019 AND 15/06/2019
    NATURAL JOIN consulta
    NATURAL JOIN regiao
) 
GROUP BY regiao
HAVING COUNT(medico) > ALL --selecionar o medicos com mais consultas por regiao



/*
* 3.
* Quais são os médicos que já prescreveram aspirina em receitas aviadas em todas as farmácias
* do concelho de Arouca este ano? 
*/
SELECT medico
FROM


/*
* 4.
* Quais são os doentes que já fizeram análises mas ainda não aviaram prescrições este mês?
*/