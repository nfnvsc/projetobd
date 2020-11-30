create table regiao (
    num_regiao int,
    nome char(8),
    num_habitantes int, 
    primary key (num_regiao),
    check (nome in ('Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve'))
);

create table concelho (
    num_concelho int,
    num_regiao int,
    nome char(20), 
    num_habitantes int,
    primary key (num_concelho),
    foreign key (num_regiao) references regiao on delete cascade
    /*
    check (nome in (OPENROWSET('Microsot.ACE.OLEDB.12.0',
    'Excel 12.0; Database=~/ListaFreguesiasVigentes_SFs.xls; HDR_YES; IMEX = 1',
    'SELECT * FROM [sheet1$D2:3093')));
    */
);

create table instituicao (
    nome char(30),
    tipo char(11),
    num_regiao int,
    num_concelho int,
    primary key (nome),
    foreign key (num_regiao) references regiao on delete cascade,
    foreign key (num_concelho) references concelho on delete cascade,
    check (tipo in ('farmacia', 'laboratorio', 'clinica', 'hospital'))
);

create table medico (
    num_cedula int,
    nome char(20),
    especialidade char(20),
    primary key (num_cedula)
);

create table consulta (
    num_cedula int,
    num_doente int,
    data_consulta date,
    nome_instituicao char(20),
    primary key (num_cedula, num_doente, data_consulta),
    foreign key (num_cedula) references medico on delete cascade,
    foreign key (nome_instituicao) references instituicao on delete cascade
    --CHECK    check (select DATENAME(weekday, data_consulta) not in ('Saturday', 'Sunday'))
);

create table prescricao(
    num_cedula int,
    num_doente int,
    data_consulta date,
    substancia char(30),
    quant int,
    primary key (num_cedula, num_doente, data_consulta, substancia),
    foreign key (num_cedula, num_doente, data_consulta) 
        references consulta(num_cedula, num_doente, data_consulta)
        on delete cascade
);

create table analise (
    num_analise int,
    especialidade char(20),
    num_cedula int not null,
    num_doente int not null,
    data_consulta date not null,
    data_registo date,
    nome char(20), 
    quant int,
    inst char(20),
    primary key (num_analise),
    foreign key (num_cedula, num_doente, data_consulta) references consulta(num_cedula, num_doente, data_consulta) on delete cascade,
    foreign key (inst) references instituicao on delete cascade
);

create table venda_farmacia (
    num_venda int,
    data_registo date,
    substancia char(30),
    quant int,
    preco int,
    inst char(20),
    primary key (num_venda),
    foreign key (inst) references instituicao
);

create table prescricao_venda (
    num_cedula int,
    num_doente int,
    data_consulta date,
    num_venda int,
    primary key (num_cedula, num_doente, data_consulta, num_venda),
    foreign key (num_venda) references venda_farmacia on delete cascade,
    foreign key (num_cedula, num_doente, data_consulta) references consulta(num_cedula, num_doente, data_consulta) on delete cascade
);

/**
* 1.
* RI-100: um médico não pode dar mais de 100 consultas por semana na mesma instituição
*/
drop trigger if exists max_consultas_trigger on consulta;

create or replace function max_consultas() returns trigger as $$
begin
    if (select count(*) from consulta where
            consulta.num_cedula == new.num_cedula and 
            consulta.nome_instituicao == new.nome_instituicao and 
            consulta.data_consulta between 
            (semana..)) >= 100

        raise exception 'O Médico % excedeu o número máximo de consultas possiveis semanais.', new.num_cedula;
    end if;

    return new;

End;
$$ Language plpgsql;

create trigger max_consultas_trigger after update on consulta
for each row execute procedure max_consultas()


/**
* 2.
* RI-análise: numa análise, a consulta associada pode estar omissa; não estando, a especialidade
* da consulta tem de ser igual à do médico.
*/

drop trigger if exists check_analise_consulta_trigger on analise;

create or replace function check_analise_consulta() returns trigger as $$
begin
    if (new.num_cedula != null and new.num_doente != null and new.data_consulta != null)
        if new.especialidade not in (select especialidade from medico where medico.num_cedula == new.num_cedula)
            raise exception 'A especialidade % da analise não é a mesma que a do médico que a realizou.', new.especialidade;
        end if;
    end if;
    return new;

End;
$$ Language plpgsql;

create trigger check_analise_consulta_trigger after update on analise
for each row execute procedure check_analise_consulta()
