/* Eliminação das tabelas */

drop table if exists d_tempo cascade;
drop table if exists d_instituicao cascade;
drop table if exists f_presc_venda cascade;
drop table if exists f_analise cascade;


/* Definição das tabelas */

create table d_tempo(
    id_tempo integer not null,
    dia smallint check (dia < 32 and dia > 0),
    dia_da_semana smallint check (dia_da_semana < 8 and dia_da_semana > 0),
    semana smallint check (semana < 5 and semana > 0),
    mes smallint check (mes < 13 and mes > 0),
    trimestre smallint check (trimestre < 5 and trimestre > 0),
    ano integer not null,
    primary key(id_tempo)
);

create table d_instituicao(
    id_inst integer not null,
    nome char(30) not null,
    tipo char(11) not null,
    num_regiao integer not null,
    num_concelho integer not null,
    primary key(id_inst),
    foreign key(nome) references instituicao(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(num_regiao) references regiao(num_regiao) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(num_concelho) references concelho(num_concelho) ON DELETE CASCADE ON UPDATE CASCADE
);

create table f_presc_venda(
    id_presc_venda integer unique not null,
    id_medico integer not null,
    num_doente integer not null,
    id_data_registo integer not null,
    id_inst integer not null,
    substancia char(30) not null,
    quant integer not null,
    primary key(id_presc_venda)
    foreign key(id_presc_venda) references prescricao_venda(num_venda),
    foreign key(id_medico) references medico(num_cedula),
    foreign key(id_data_registo) references d_tempo(id_tempo),
    foreign key(id_inst) references d_instituicao(id_inst)
);

create table f_analise(
    id_analise integer not null,
    id_medico integer not null,
    num_doente integer not null,
    id_data_registo integer not null,
    id_inst integer not null,
    nome char(20) not null,
    quant integer not null,
    primary key(id_analise),
    foreign key(id_analise) references analise(num_analise),
    foreign key(id_medico) references medico(num_cedula),
    foreign key(id_data_registo) references d_tempo(id_tempo),
    foreign key(id_inst) references d_instituicao(id_inst),
);


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
