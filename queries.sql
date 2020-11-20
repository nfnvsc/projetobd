/**
* 1.
* Qual o concelho onde se fez o maior volume de vendas hoje?
*/

/*
SELECT nome, COUNT(*)
FROM ((SELECT instituicao.num_concelho
    FROM (instituicao INNER JOIN venda_farmacia
            ON instituicao.nome = venda_farmacia.inst)
    WHERE data_registo = '2019-06-9') as S
    NATURAL JOIN concelho) as N
GROUP BY nome 
HAVING COUNT(*) >= ALL 
    (SELECT COUNT(*)
    FROM (instituicao INNER JOIN venda_farmacia
            ON instituicao.nome = venda_farmacia.inst)
    WHERE data_registo = '2019-06-9'
    GROUP BY num_concelho);
*/

/**
* 2.
* Qual o médico que mais prescreveu no 1º semestre de 2019 em cada região?
*/

/*
SELECT DISTINCT num_cedula, num_regiao
FROM(
    SELECT num_cedula, num_regiao, COUNT(num_cedula) as Aux
    FROM ((SELECT * FROM prescricao WHERE prescricao.data_consulta BETWEEN '2019-01-01' AND '2019-06-15') AS precricoes_semestre 
    NATURAL JOIN consulta
    INNER JOIN instituicao
        ON instituicao.nome = consulta.nome_instituicao) AS S 
    GROUP BY num_cedula, num_regiao) as t
GROUP BY num_regiao
*/

/**
* 3.
* Quais são os médicos que já prescreveram aspirina em receitas aviadas em todas as farmácias
* do concelho de Arouca este ano?
*/


SELECT num_cedula
FROM(
    (SELECT *
    FROM prescricao_venda
    WHERE data_consulta BETWEEN '2019-01-01' AND '2019-12-31') as T
    NATURAL JOIN(
        SELECT num_venda, inst as nome_instituicao
        FROM venda_farmacia
        WHERE substancia = 'aspirina') as X
    NATURAL JOIN(
        SELECT num_concelho, nome as nome_instituicao
        FROM instituicao
    ) as Y
    NATURAL JOIN(
        SELECT num_concelho, nome
        FROM concelho
        WHERE nome = 'Arouca'
    ) as B
)

/**
* 4.
* Quais são os doentes que já fizeram análises mas ainda não aviaram prescrições este mês?
*/

/*
SELECT DISTINCT num_doente
FROM analise
WHERE NOT EXISTS
    (SELECT num_doente FROM prescricao_venda WHERE analise.num_doente = prescricao_venda.num_doente)
*/