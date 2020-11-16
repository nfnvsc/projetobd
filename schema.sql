create table regiao (
    num_regiao int,
    nome char(7),
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
    foreign key (num_regiao) references regiao
);

create table instituicao (
    nome char(20),
    tipo char(11),
        check (tipo in ('farmacia', 'laboratorio', 'clinica', 'hospital')), 
    num_regiao int,
    num_concelho int,
    primary key (nome),
    foreign key (num_regiao) references regiao,
    foreign key (num_concelho) references concelho
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
    data_consulta date
        check (datename(dw, data_consulta) not in ('Saturday', 'Sunday'),
    nome_instituicao char(20),
    primary key (num_cedula, num_doente, data_consulta),
    foreign key (num_cedula) references medico,
    foreign key (nome_instituicao) references instituicao
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
    foreign key (num_cedula, num_doente, data_consulta) 
        references consulta(num_cedula, num_doente, data_consulta)),
    foreign key inst references instituicao
    check (especialidade in 
        (select M.especialidade
        from medico as M
        where num_cedula = M.num_cedula))
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
    foreign key (num_venda) references venda_farmacia,
    foreign key (num_cedula, num_doente, data_consulta) 
        references consulta(num_cedula, num_doente, data_consulta))
);


-- DELETE CLAUSES MAY BE MISSING