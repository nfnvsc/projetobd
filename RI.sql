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