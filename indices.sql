
/**
* 1.
* Listar as datas de consulta de um doente
*/

/* RESPOSTA:
Criar um indice para organizar a coluna num_doente da tabela consulta com uma HashTable,
de forma a tornar mais eficiente a comparação direta "num_doente = <valor>"
*/

create index indice1 on consulta using hash(num_doente)

/**
* 2.
* Considere que há apenas seis especialidades: “E1” a “E6”. Pretende-se saber quantos médicos
* existem de cada especialidade.
*/

/* RESPOSTA:
ou hashtable?
Utilizar um indice bit map, em que cada uma das 6 especialidades
representa uma sequencia diferente num total de 3 bits (necessarios) 
para a representação de pelo menos 6 especidades diferentes.
000 - especialidade 1,
001 - especialidade 2,
etc..
*/

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
Utilizar um indice BTREE na coluna data da tabela consulta, de forma a otimizar
a seleção entre duas datas.
Para facilitar a operação "consulta.num_cedula = medico.num_cedula" cria-se um
indice Hastable em ambas colunas.
*/