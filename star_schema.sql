drop table if exists d_tempo cascade;
drop table if exists d_instituicao cascade;
drop table if exists f_presc_venda cascade;
drop table if exists f_analise cascade;

create table d_tempo(
    id_tempo integer not null,
    dia integer not null,
    dia_da_semana integer not null,
    semana integer not null,
    mes integer not null,
    trimestre integer not null,
    ano integer not null,
    primary key(id_tempo)
);

create table d_instituicao(
    id_inst integer not null,
    nome char(30) not null,
    tipo char(30) not null,
    num_regiao integer not null,
    num_concelho integer not null,
    primary key(id_inst),
    foreign key(nome) references instituicao(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(num_regiao) references regiao(num_regiao) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(num_concelho) references concelho(num_concelho) ON DELETE CASCADE ON UPDATE CASCADE
);

create table f_presc_venda(
    id_presc_venda integer unique?? not null,
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
    nome char(30) not null,
    quant integer not null,
    primary key(id_analise),
    foreign key(id_analise) references analise(num_analise),
    foreign key(id_medico) references medico(num_cedula),
    foreign key(id_data_registo) references d_tempo(id_tempo),
    foreign key(id_inst) references d_instituicao(id_inst),
);


insert into d_tempo (
    select ean, categoria, forn_primario from produto
);

insert into d_instituicao (
    select 
);

insert into f_presc_venda (
    select distinct extract (day from instante) as day, extract (month from instante) as month, extract (year from instante) as year, ean from reposicao
);

insert into f_analise (
    select distinct extract (day from instante) as day, extract (month from instante) as month, extract (year from instante) as year, ean from reposicao
);