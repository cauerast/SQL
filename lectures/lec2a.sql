-- 1.
CREATE TABLE Alunos(
  RA int,
  cpf VARCHAR(11),
  nome varchar(80),
  fone varchar(30),
  pai varchar(80),
  mae varchar(80),
  data_nasc date
);

insert into Alunos
values(862, '12345678911', 'MATEUS', '11990000000', 'Daniel', 'Clara', '2002-05-06'),
  (1002, '12345678911', 'MARCOS', '169923443243', 'Fernando', 'Ana', '2008-12-25'),
  (103, '12345678911', 'LUCAS', '5498237746', 'Luis', 'Maria', '2006-07-12');

-- 2.
select * from Alunos;

-- 3.
select nome, cpf from Alunos
where mae = 'Ana';

-- 4. 
update Alunos
set mae = 'Luciana Ferreira'
where RA = 103;

-- 5.
delete from Alunos
where RA = 1002;

-- 6.
select * from Alunos
order by nome asc;


select * from Alunos;
drop table Alunos;