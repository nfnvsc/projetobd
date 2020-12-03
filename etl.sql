/* Carregar dados */

insert into d_tempo (
    select distinct 
    extract (day from data_consulta) as dia, 
    extract (month from data_consulta) as mes, 
    extract (year from data_consulta) as ano,
    extract (isodow from data_consulta) as dia_da_semana,
    extract (week from data_consulta) as semana,
    extract (quarter from data_consulta) as trimestre,
    from consulta
);

insert into d_instituicao (
    select nome, tipo, num_regiao, num_concelho from instituicao
);

insert into f_presc_venda (
    select num_venda as id_presc_venda, num_cedula as id_medico, num_doente, id_data_registo, id_inst, substancia, quant
    from prescricao
        natural join prescricao_venda
        natural join consulta
        inner join d_instituicao on d_instituicao.nome = nome_instituicao
        inner join d_tempo on d_tempo.dia = extract (day from data_consulta) and d_tempo.mes = extract (month from data_consulta) and d_tempo.ano = extract (year from data_consulta)
);

insert into f_analise (
    select num_analise as id_analise, num_cedula as id_medico, id_data_registo, id_inst, nome, quant
    from(
        select * from analise
        inner join d_instituicao on d_instituicao.nome = nome
        inner join d_tempo on d_tempo.dia = extract (day from data_consulta) and d_tempo.mes = extract (month from data_consulta) and d_tempo.ano = extract (year from data_consulta)
    )
);