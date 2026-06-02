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