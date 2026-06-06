create database hospital;
use hospital;

create table especialidades(
    codEsp int PRIMARY KEY IDENTITY(10, 10),
    nome varchar(80)
);

create table medicos(
    codMed int PRIMARY KEY IDENTITY(1,1),
    nome varchar(80),
    idade int,
    salario money,
    codEsp int FOREIGN KEY REFERENCES especialidades(codEsp)
);

-- cadastro das especialidades 
insert into especialidades
values ('OTORRINO'),
       ('OBSTETRA'),
       ('PEDIATRA'),
       ('CARDIOLOGISTA'),
       ('DERMATOLOGISTA'),
       ('ORTOPEDISTA')

-- cadastro dos medicos (preenchendo todos os campos)
insert into medicos
values ('JOAO', 48, 800, 10),
       ('JOSE', 35, 1200, 10),
       ('ANA', 47, 1400, 30),
       ('IVO', 51, 750, NULL),
       ('SILVIO', NULL, 2550, 20),
       ('ADÃO', 62, 1950, 50),
       ('EVA', 42, 800, NULL),
       ('JOANA', 39, 1200, 10),
       ('AFONSO', NULL, 800, 30);

-- cadastro dos medicos (preenchendo apenas alguns campos)
insert into medicos (nome, idade, salario)
values ('KARINA', 40, 750),
       ('CARLA', 41, 1950);

-- cadastro dos medicos (preenchendo apenas alguns campos)
insert into medicos (nome, salario)
values ('RODOLFO', 1330);




-- joins
-- medicos com especialidades e sem especialidades
select m.nome, e.nome from
    medicos AS m LEFT JOIN especialidades AS e
    ON
    m.codEsp = e.codEsp;

-- medicos com especialidade
select m.nome, e.nome from
    medicos AS m INNER JOIN especialidades AS e
    ON
    m.codEsp = e.codEsp;

-- medicos sem especialidade
select m.nome AS nomeMed, e.nome AS nomeEspec from 
    medicos AS m LEFT JOIN especialidades AS e
    ON
    m.codEsp = e.codEsp
WHERE e.codEsp IS NULL; 




-- create table paciente
create table pacientes (
    codPac int PRIMARY KEY IDENTITY(1,1),
    nome varchar(80),
    fone varchar(30)
)

-- create table consulta
create table consultas (
    codCon int PRIMARY KEY IDENTITY(1, 1),
    data date,
    convenio varchar(50),
    codMed int FOREIGN KEY REFERENCES medicos(codMed) NOT NULL,
    codPac int FOREIGN KEY REFERENCES pacientes(codPac) NOT NULL
)



-- joins
SELECT m.nome AS nomeMedico, c.data, p.nome AS nomePaciente FROM 
    medicos AS m INNER JOIN consultas AS c
        ON m.codMed = c.codMed
    INNER JOIN pacientes AS p
        ON p.codPac = c.codPac
    INNER JOIN especialidades as e
        ON e.codEsp = m.codEsp
WHERE c.data >= '2026/05/20' AND c.data <= '2026/05/31' 
    AND e.nome = 'PEDIATRA';



select * from especialidades;
select * from medicos;
select * from consultas;
select * from pacientes;


-- Fix exercises
-- 1) Cadastre 6 pacientes
INSERT INTO pacientes
VALUES ('pac1', '1199123-4567'),
       ('pac2', '1199123-4567'),
       ('pac3', '1199123-4567'),
       ('pac4', '1199123-4567'),
       ('pac5', '1199123-4567'),
       ('pac6', '1199123-4567');


-- 2) Cadastre 10 consultas para medicos e pacientes diversos
INSERT INTO consultas
VALUES ('2026/10/1', 'SUS', 1, 1),
       ('2026/1/2', 'UNIMED', 2, 1),
       ('2026/10/3', 'SUS', 3, 2),
       ('2026/7/4', 'UNIMED', 4, 2),
       ('2026/10/25', 'UNIMED', 5, 3),
       ('2026/10/2', 'UNIMED', 6, 3),
       ('2026/2/21', 'SUS', 7, 4),
       ('2026/8/8', 'SUS', 8, 4),
       ('2026/6/18', 'UNIMED', 9, 5),
       ('2026/8/1', 'SUS', 10, 6)

-- 3) Atualize o nome do medico 'JOAO' para 'JOÃO DA SILVA'
UPDATE medicos 
SET nome = 'JOÃO DA SILVA'
WHERE NOME = 'JOAO';

-- 4) A data da consulta numero 3 é 15/maio/2025 (atualize essa info)
UPDATE consultas 
SET data = '2025/5/15'
WHERE codCon = 3;

-- 5) Exclua a primeira consulta cadastrada
DELETE FROM consultas 
WHERE codCon = 1;

-- 6) Liste os nomes dos médicos e a especialidade de cada um
SELECT m.nome as nomeMed, e.nome as nomeEsp
FROM medicos as m LEFT JOIN especialidades as e
ON m.codEsp = e.codEsp

-- 7) Liste os médicos que nao têm especialidades
SELECT m.nome as nomeMedico
FROM medicos as m LEFT JOIN especialidades as e
ON m.codEsp = e.codEsp
WHERE e.codEsp IS NULL;

-- 8) liste as consultas feitas pelo convenio UNIMED no mes de abril
SELECT * 
FROM consultas
WHERE convenio = 'UNIMED'

-- 9) liste os nomes dos pacientes e os convenios que usaram nas suas consultas
select p.nome as nomePaciente, c.convenio as convenioPaciente
from pacientes as p LEFT JOIN consultas as c 
ON p.codPac = c.codPac;


-- 10) Liste os telefones dos pacientes que nunca consultaram
SELECT p.fone 
FROM pacientes AS p 
LEFT JOIN consultas AS c 
    ON p.codPac = c.codPac 
WHERE c.codCon IS NULL;

-- 11) Liste os convênios das consultas feitas por ORTOPEDISTAS
select c.convenio
from consultas as c INNER JOIN medicos as m
on c.codMed = m.codMed
INNER JOIN especialidades as e
on e.codEsp = m.codEsp
where e.nome = 'ORTOPEDISTA'

-- 12) Liste os nomes e fones dos pacientes atendidos por PEDIATRAS ou DERMATOLOGISTAS em abril/2026
select p.nome, p.fone 
from pacientes as p INNER JOIN consultas as c
    on p.codPac = c.codPac
INNER JOIN medicos as m
    on m.codMed = c.codMed
INNER JOIN especialidades as e
    on e.codEsp = m.codEsp
WHERE (e.nome = 'PEDIATRA' or e.nome = 'DERMATOLOGISTA') and c.data BETWEEN '2026/04/01' and '2026/04/30';

-- 13) Cadastre a especialidade 'NEUROLOGISTA' e atualize as especialidades de 2 médicos para esta nova
insert into especialidades
values ('NEUROLOGISTA');

update medicos
set codEsp = 70
where codMed = 1 or codMed = 2 or codEsp IS NULL;

-- 14) Crie 3 consultas para médicos NEUROLOGISTAS no mes de maio/2026
insert into consultas
values ('2026/10/1', 'UNIMED', 11, 4),
       ('2026/06/1', 'SUS', 12, 5),
       ('2026/04/1', 'UNIMED', 7, 6)

-- 15) As consultas feitas pelos PEDIATRAS em abril/2026 devem ser somente do convenio 'SUS'. Atualize essa info.
update c -- consultas, mas como eu renomeei ali em baixo seria melhor usar aqui tambem o c' como consultas'
set convenio = 'SUS'
from especialidades as e INNER JOIN medicos as m
    on e.codEsp = m.codEsp
INNER JOIN consultas as c
    on c.codMed = m.codMed
WHERE e.nome = 'PEDIATRA' and c.data BETWEEN '2026/04/01' AND '2026/04/30';


select * from especialidades;
select * from medicos;
select * from consultas;
select * from pacientes;