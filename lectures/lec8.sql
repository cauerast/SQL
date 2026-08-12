create table Veterinarios (
    codVet int PRIMARY KEY IDENTITY(1,1),
    nome varchar(100),
    dataNasc DATE
)
create table Animais (
    codAni int PRIMARY KEY IDENTITY(1,1),
    nome varchar(80),
    especie varchar(80)
)
create table Consultas (
    codCons int PRIMARY KEY IDENTITY(1,1),
    dataCons DATE,
    valor money,
    codAni int FOREIGN KEY REFERENCES Animais(codAni),
    codVet int FOREIGN KEY REFERENCES Veterinarios(codVet)
)

---- Diga os comandos SQL corretos para executar as seguintes ações:
-- 1a. Cadastrar 5 médicos (veterinários) para esta clínica
insert into Veterinarios
values ('Dr. Laura', '1995/04/04'),
       ('Dr. Igor', '1995/06/12'),
       ('Dr. Hugo', '1992/11/12'),
       ('Dr. Gui', '1991/10/12'),
       ('Dr. Oto', '1985/05/19')

-- 2a. Cadastrar 10 pacientes (animais) para a clínica de pelo menos 3 espécies diferentes
insert into Animais
values ('billy', 'tigre'),
       ('azevedo', 'panda'),
       ('osvaldo', 'lobo'),
       ('Leandro', 'tigre'),
       ('Eduardo', 'panda'),
       ('Joaquim', 'lobo'),
       ('Astolfo', 'tigre'),
       ('Benet', 'panda'),
       ('Yumi', 'lobo'),
       ('Okkotsu', 'tigre')

-- 3a. Cadastre 20 consultas para estes médicos e pacientes com datas e valores -- diferentes
insert into Consultas
values ('2026/05/01', 100, 1, 5),
       ('2026/05/02', 500, 2, 4),
       ('2026/05/03', 200, 3, 3),
       ('2026/05/04', 2300, 4, 2),
       ('2026/05/05', 1340, 5, 1),
       ('2026/05/06', 1020, 6, 5),
       ('2026/05/07', 700, 7, 4),
       ('2026/05/08', 150, 8, 3),
       ('2026/05/09', 1200, 9, 2),
       ('2026/05/10', 700, 10, 1),
       ('2026/05/11', 150, 1, 5),
       ('2026/05/12', 100, 2, 4),
       ('2026/05/13', 950, 3, 3),
       ('2026/05/14', 800, 4, 2),
       ('2026/05/15', 750, 5, 1),
       ('2026/05/16', 600, 6, 5),
       ('2026/05/17', 550, 7, 4),
       ('2026/05/18', 400, 8, 3),
       ('2026/05/19', 1350, 9, 2),
       ('2026/05/20', 250, 10, 1)


-- 1. Selecione o maior valor pago por uma consulta
select max(valor) as maiorValorPagoCOnsulta
from Consultas;

-- 2. Selecione o valor médio, maior valor e menor valor das consultas realizadas no mês passado
SELECT avg(valor) as valorMedio 
from Consultas
where dataCons > '2026/04/01' and dataCons < '2026/06/01';

SELECT max(valor) as valorMax 
from Consultas
where dataCons > '2026/04/01' and dataCons < '2026/06/01';

SELECT min(valor) as valorMin 
from Consultas
where dataCons > '2026/04/01' and dataCons < '2026/06/01';

-- 3. Cadastre uma nova consulta para um paciente que já está cadastrado
insert into Consultas
values ('2026/05/02', 1240, 3, 4)

-- 4. Atualize o nome do médico cujo código é 3 para o seu nome
update Veterinarios
set nome = 'Caue'
where codVet = 3;

-- 5. Selecione as espécies de animais que estão cadastrados.
select DISTINCT(especie) as especiesCadastradas
from Animais

-- 6. Quantas consultas você já realizou nesta clínica?
select COUNT(codVet) as qtdConsultasCaue
from Consultas
where codVet = (select codVet from Veterinarios where nome = 'Caue');

-- 7. Quantas consultas foram feitas por todos os médicos?
select COUNT(codCons) as qtdConsultasTotal from Consultas
where codVet is NOT NULL;

-- 8. Selecione, de forma exclusiva, as espécies de pacientes que estão cadastrados.
select DISTINCT(especie) as especiesCadastradas
from Animais

-- 9. Liste os nomes dos pacientes em ordem alfabética.
select nome from Animais 
order by nome asc;

-- 10. Qual o valor total de todas as consultas feitas por você?
select SUM(valor) as valorTotalConsultasCaue
from Consultas
where codVet = (select codVet from Veterinarios where nome = 'Caue')

-- 11. Qual a quantidade de médicos que esta clínica possui?
select count(codVet) as QtdVeterinarios from Veterinarios;

-- 12. Quanto seria o total das consultas que você realizou se estas consultas tivessem um aumento de 10%?
select SUM(valor * 1.1) as valorTotalConsultasCaue
from Consultas
where codVet = (select codVet from Veterinarios where nome = 'Caue')

-- 13. Quantas consultas foram feitas por você entre os dias 01/01/2026 e 31/03/2026?
select COUNT(codVet) as qtdConsultasCaueEntreJaneiroEMarco from Consultas
where codVet = (select codVet from Veterinarios where nome = 'Caue')
and dataCons > '01/01/2026' and dataCons < '1/03/2026';



select * from Consultas;
select * from Animais;
select * from Veterinarios;