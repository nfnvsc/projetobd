insert into regiao values (0, 'Norte', 3689000); 
insert into regiao values (1, 'Centro', 2327000);
insert into regiao values (2, 'Lisboa', 504000);
insert into regiao values (3, 'Alentejo', 210000);
insert into regiao values (4, 'Algarve', 451000);

insert into concelho values (0, 3, 'Moura', 15167);
insert into concelho values (1, 2, 'Oeiras', 173000);
insert into concelho values (2, 0, 'Matosinhos', 200000);
insert into concelho values (3, 4, 'Silves', 80000);
insert into concelho values (4, 2, 'Lisboa', 1030000);
insert into concelho values (5, 0, 'Porto', 850000);
insert into concelho values (6, 0, 'Arouca', 850000);

insert into instituicao values ('São José', 'hospital', 0, 5);
insert into instituicao values ('Santa Maria', 'hospital', 2, 6);
insert into instituicao values ('Nova de Lisboa', 'hospital', 2, 4);
insert into instituicao values ('Joaquim Fernandes', 'clinica', 3, 0);

insert into medico values (0, 'António Costa', 'cardiologia');
insert into medico values (1, 'Marcelo Rebelo', 'pediatria');
insert into medico values (2, 'Joaquim Sousa', 'oftalmologia');

insert into consulta values (0, 0, '2019-05-10', 'Santa Maria');
insert into consulta values (1, 2, '2019-06-10', 'Santa Maria');
insert into consulta values (2, 1, '2019-07-10', 'São José');
insert into consulta values (1, 1, '2019-01-10', 'São José');
insert into consulta values (1, 2, '2019-02-10', 'São José');
insert into consulta values (2, 0, '2019-03-10', 'São José'); 

insert into prescricao values (0, 0, '2019-05-10', 'paracetamol', 1);
insert into prescricao values (1, 2, '2019-06-10', 'ibuprofeno', 6);
insert into prescricao values (2, 1, '2019-07-10', 'piperazina', 2);
insert into prescricao values (1, 1, '2019-01-10', 'aspirina', 6);
insert into prescricao values (1, 2, '2019-02-10', 'aspirina', 2);
insert into prescricao values (2, 0, '2019-03-10', 'aspirina', 1);
/*
insert into consulta values (0, 0, 2019-05-10, 'Santa Maria');
insert into consulta values (0, 2, 2019-07-10, 'Santa Maria');
insert into consulta values (1, 2, 2019-06-10, 'Santa Maria');
insert into consulta values (1, 1, 2019-08-03, 'São José');
insert into consulta values (1, 0, 2019-02-02, 'São José');
insert into consulta values (2, 1, 2019-05-12, 'São José');


insert into prescricao values (0, 0, 2019-05-10, 'paracetamol', 1);
insert into prescricao values (1, 2, 2019-06-10, 'ibuprofeno', 6);
insert into prescricao values (2, 1, 2019-07-10, 'piperazina', 2);
*/
insert into analise values (0, 'cardiologia', 0, 0, '2019-05-10', '2019-05-10', 'Hemograma' , 1, 'Santa Maria');
insert into analise values (1, 'cardiologia', 1, 2, '2019-06-10', '2019-06-10', 'Colestrol' , 1, 'Santa Maria');
--insert into analise values (2, 'pediatria', 1, , 2);
--insert into analise values (3, 'pediatria', 1, , 2);
--insert into analise values (4, 'pediatria', 1, , 2);

insert into venda_farmacia values (0, '2019-06-9', 'paracetamol', 100, 20, 'Santa Maria');
insert into venda_farmacia values (1, '2019-06-9', 'ibuprofeno', 100, 20, 'Nova de Lisboa');
insert into venda_farmacia values (2, '2019-06-9', 'piperazina', 100, 20, 'São José');
insert into venda_farmacia values (3, '2019-06-9', 'aspirina', 100, 20, 'Santa Maria');
insert into venda_farmacia values (4, '2019-06-10', 'aspirina', 250, 40, 'Joaquim Fernandes');

insert into prescricao_venda values (0, 0, '2019-05-10', 0);
insert into prescricao_venda values (1, 2, '2019-06-10', 1);
insert into prescricao_venda values (2, 1, '2019-07-10', 2);
insert into prescricao_venda values (1, 1, '2019-01-10', 3);
insert into prescricao_venda values (1, 2, '2019-02-10', 4);

--insert into prescricao_venda values (1, 2, '2019-06-10', 0);