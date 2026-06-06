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



select * from especialidades;
select * from medicos;

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
    fone varchat(30)
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
    medico AS m INNER JOIN consulta AS c
        ON m.codMed = c.codMed
    INNER JOIN paciente AS p
        ON p.codPac = c.codPac
    INNER JOIN especialidades as e
        ON e.codEsp = m.codEsp
WHERE c.data >= '2026/05/20' AND c.data <= '2026/05/31' 
    AND e.nome = 'PEDIATRA';

-- Fix exercises
-- 1) Cadastre 6 pacientes
-- 2) Cadastre 10 consultas para medicos e pacientes diversos
-- 3) Atualize o nome do médico 'JOAO' para 'JOÃO DA SILVA'
-- 4) A data da consulta numero 3 é 15/maio/2025 (atualize essa info)
-- 5) Exclua a primeira consulta cadastrada
-- 6) Liste os nomes dos médicos e a especialidade de cada um
-- 7) Liste os médicos que nao têm especialidades
-- 8) liste as consultas feitas pelo convenio UNIMED no mes de abril
-- 9) liste os nomes dos pacientes e os convenios que usaram nas suas consultas
-- 10) Liste os telefones dos pacientes que nunca consultaram
-- 11) Liste os convênios das consultas feitas por ORTOPEDISTAS
-- 12) Liste os nomes e fones dos pacientes atendidos por PEDIATRAS ou DERMATOLOGISTAS em abril/2026
-- 13) Cadastre a especialidade 'NEUROLOGISTA' e atualize as especialidades de 2 médicos para esta nova
-- 14) Crie 3 consultas para médicos NEUROLOGISTAS no mes de maio/2026
-- 15) As consultas feitas pelos PEDIATRAS em abril/2026 devem se somente do convenio 'SUS'. Atualize essa info