
/**
* 1.
* Listar as datas de consulta de um doente
*/

/* RESPOSTA:
Criar um indice para organizar a coluna num_doente da tabela consulta, utilizando o ja existente num_doente,
de forma a tornar mais eficiente a comparação direta "num_doente = <valor>"
*/

create index indice1 on consulta(num_doente);

/**
* 2.
* Considere que há apenas seis especialidades: “E1” a “E6”. Pretende-se saber quantos médicos
* existem de cada especialidade.
*/

/* RESPOSTA:
Criar um indice para organizar os medicos por diferentes especialidades usando uma hastable,
desta forma, acedemos diretamente a uma lista com todos os medicos da especialidade pretendida
*/

create index indice2 on medico using hash(especialidade);


/**
* 3.
* Nomes dos médicos de uma determinada especialidade. Para a resolução desta alínea considere,
* para além do referido sobre a dimensão das tabelas, os seguintes aspetos:
*      1- Os blocos do disco são de 2K bytes e cada registo na tabela ocupa 1K bytes.
*      2- Os médicos estão uniformemente distribuídos pelas 6 especialidades.
*/


/**
* 4.
* Listar os nomes dos médicos que deram consultas entre duas datas
*/

/* RESPOSTA:
Utilizar um indice BTREE na coluna data_consulta da tabela consulta, de forma a otimizar
a seleção entre duas datas.
Para facilitar a operação "consulta.num_cedula = medico.num_cedula" cria-se um
indice em ambas colunas.
*/

create index index4 on consulta using BTREE(data_consulta);
create index index5 on consulta(num_cedula);
create index index6 on medico(num_cedula);