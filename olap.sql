SELECT especialidade, mes, ano, SUM(id_analise) as numAnalises 
FROM (f_analise NATURAL JOIN medico NATURAL JOIN d_tempo)
WHERE nome = 'glicémia' AND 
      ano <= 2020 AND
      a >= 2017 
GROUP BY 
    CUBE (especialidade, mes, ano)