/**
* 1.
* Qual o concelho onde se fez o maior volume de vendas hoje?
*/

/*
SELECT nome, COUNT(*)
FROM ((SELECT instituicao.num_concelho
    FROM (instituicao INNER JOIN venda_farmacia
            ON instituicao.nome = venda_farmacia.inst)
    WHERE data_registo = GETDATE()) as S
    NATURAL JOIN concelho) as N
GROUP BY nome 
HAVING COUNT(*) >= ALL 
    (SELECT COUNT(*)
    FROM (instituicao INNER JOIN venda_farmacia
            ON instituicao.nome = venda_farmacia.inst)
    WHERE data_registo = GETDATE()
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

/*
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
*/

/**
* 4.
* Quais são os doentes que já fizeram análises mas ainda não aviaram prescrições este mês?
*/

/*
SELECT DISTINCT num_doente
FROM analise
WHERE NOT EXISTS(SELECT num_doente
    FROM(
    (SELECT num_doente, num_venda
    FROM prescricao_venda
    WHERE analise.num_doente = prescricao_venda.num_doente) as x
    NATURAL JOIN(
        SELECT num_venda, data_registo
        FROM venda_farmacia
        WHERE extract(MONTH FROM data_registo) = extract(MONTH FROM CURRENT_DATE)) as y
    )
)
*/

/**
* d.
* Listar as substância prescritas por um médico num dado mês do ano
*/

/*
SELECT substancia FROM prescricao WHERE num_cedula = request.form["num_cedula"] AND data_consulta = request.form["data_consulta"]
*/

/**
* e.
* Listar os valores de glicémia mais alto e mais baixo em cada concelho e respectivo doente.
*/

SELECT quant, num_doente, nome_concelho 
FROM(
    (SELECT quant, inst, num_doente
    FROM analise
    WHERE nome = 'glicemia') as a
    NATURAL JOIN(
        SELECT num_concelho FROM instituicao)  as i
    NATURAL JOIN(
        SELECT nome as nome_concelho FROM concelho) as c)
GROUP BY nome_concelho, num_doente, quant
HAVING quant = MAX(quant) or quant = MIN(quant)
