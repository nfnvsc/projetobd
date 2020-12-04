/* Carregar dados */

insert into d_tempo (dia, dia_da_semana, semana, mes, trimestre, ano)
    select distinct
        extract(day from data_consulta) as dia, 
        extract(isodow from data_consulta) as dia_da_semana,
        extract(week from data_consulta) as semana,
        extract(month from data_consulta) as mes, 
        extract(quarter from data_consulta) as trimestre,
        extract(year from data_consulta) as ano
    from consulta
    ;

insert into d_instituicao (nome, tipo, num_regiao, num_concelho)
    select nome, tipo, num_regiao, num_concelho from instituicao
;


insert into f_presc_venda (id_presc_venda, id_medico, num_doente, id_data_registo, id_inst, substancia, quant)
    select num_venda as id_presc_venda, num_cedula as id_medico, num_doente, id_tempo as id_data_registo, id_inst, substancia, quant
    from prescricao
        natural join prescricao_venda
        natural join consulta
        inner join d_instituicao on d_instituicao.nome = nome_instituicao
        inner join d_tempo on d_tempo.dia = extract (day from data_consulta) and d_tempo.mes = extract (month from data_consulta) and d_tempo.ano = extract (year from data_consulta)
;

insert into f_analise (id_analise, id_medico, num_doente, id_data_registo, id_inst, nome, quant)
    select num_analise as id_analise, num_cedula as id_medico, num_doente, id_tempo as id_data_registo, id_inst, nome, quant
    from analise
        inner join (select id_inst, nome as inst_nome from d_instituicao) as X on inst_nome = inst
        inner join d_tempo on d_tempo.dia = extract (day from data_consulta) and d_tempo.mes = extract (month from data_consulta) and d_tempo.ano = extract (year from data_consulta)
;