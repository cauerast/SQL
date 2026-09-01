create database restaurante;
use restaurante;

create table mesas (
    nroMesa int PRIMARY KEY IDENTITY(1,1),
    setor varchar(80),
    capacidade int,
    situacao varchar(80)
)

create table garcons (
    codGarcom int PRIMARY KEY IDENTITY(1,1),
    nome varchar(80),
    calcularComissao money
)

create table atendimentos (
    codAtendimento int PRIMARY KEY IDENTITY(1,1),
    situacao varchar(80),
    dtHrChegada datetime,
    nroPessoas int,
    nroMesa int FOREIGN KEY REFERENCES mesas(nroMesa),
    codGarcom int FOREIGN KEY REFERENCES garcons(codGarcom)
)

create table produtos (
    codProd int PRIMARY KEY IDENTITY(1,1),
    descricao VARCHAR(80),
    preco money
)

create table consumos (
    codConsumo int PRIMARY KEY IDENTITY(1,1),
    qtd int,
    vlUnit money,
    codProd int FOREIGN KEY REFERENCES produtos(codProd),
    codAtendimento int FOREIGN KEY REFERENCES atendimentos(codAtendimento)
)
---- Diga os comandos SQL corretos para executar as seguintes ações: ----
-- 1. Cadastrar 5 mesas, 10 produtos, 5 garçons, 10 atendimentos e 15 produtos consumidos nesses atendimentos (com dados diferentes).
insert into mesas
values ('BAR', 3, 'RESERVADA'),
       ('SALAO', 23, 'RESERVADA'),
       ('VARANDA', 2, 'LIVRE'),
       ('SALAO', 7, 'LIVRE'),
       ('ZONA VIP', 12, 'RESERVADA')

insert into produtos
values ('GUARANA', 7.00),
       ('COCA-COLA', 9.00),
       ('GALINHADA', 26.00),
       ('TEMAKI', 35.00),
       ('DORITOS', 9.00),
       ('CHORIPAN', 7.00),
       ('CHURRASCO', 60.00),
       ('FRANGO ASSADO', 46.00),
       ('LASANHA', 40.00),
       ('ROCAMBOLE', 58.00)

insert into garcons 
values ('IGOR', 540.00),
       ('LUCA', 12000.00),
       ('ROSA', 500.00),
       ('GLAUBER', 9.00),
       ('CLAUDIO', 20000.00)

insert into atendimentos
values ('ATENDENDO', '2026/04/01 21:45:32', 7, 1, 1),
       ('ATENDIDO', '2026/04/03 17:42:21', 2, 4, 2),
       ('NAO ATENDIDO', '2026/04/07 23:42:21', 3, 2, 3),
       ('ATENDENDO', '2026/04/09 22:42:21', 4, 2, 1),
       ('NAO ATENDIDO', '2026/04/11 01:21:11', 5, 5, 5),
       ('ATENDIDO', '2026/04/13 12:42:21', 6, 1, 4),
       ('ATENDENDO', '2026/04/17 11:42:21', 7, 2, 1),
       ('ATENDIDO', '2026/04/21 17:42:21', 8, 4, 3),
       ('ATENDIDO', '2026/04/25 14:42:21', 11, 3, 2),
       ('NAO ATENDIDO', '2026/04/29 22:45:32', 9, 2, 1)

insert into consumos
values (2, 7.00, 9, 1),
       (2, 9.00, 7, 2),
       (3, 9.00, 5, 3),
       (4, 9.00, 3, 4),
       (2, 9.00, 8, 5),
       (4, 9.00, 1, 6),
       (2, 9.00, 9, 7),
       (3, 9.00, 8, 8),
       (3, 9.00, 7, 9),
       (2, 9.00, 6, 9),
       (4, 9.00, 5, 1),
       (3, 9.00, 4, 8),
       (2, 9.00, 3, 3),
       (4, 9.00, 2, 5),
       (2, 9.00, 1, 7)

-- 2. Atualize o nome do garçom que possui o maior código para o seu nome.
update garcons
set nome = 'CAUE'
WHERE codGarcom = (select max(codGarcom) from garcons);

-- 3. Crie um campo para guardar o salário dos garçons.
alter table garcons
add salario money

-- 4. Liste os produtos e seus preços em ordem do mais caro para o mais barato.
select p.descricao as descricao, p.preco as preco from produtos as p
ORDER BY p.preco desc

-- 5. Liste o número e o setor das mesas que estão em atendimentos (atendimentos cuja situação seja ‘ATENDENDO’). Esta situação significa que os clientes ainda estão consumindo produtos.
select m.nroMesa as mesa, m.setor as setor
from mesas as m inner join atendimentos as a
on a.nroMesa = m.nroMesa
where a.situacao = 'ATENDENDO';

-- 6. Atualize os salários de cada garçom.
update garcons
set salario = CASE codGarcom
    WHEN 1 THEN 2300
    WHEN 2 THEN 3500
    WHEN 3 THEN 1800
    WHEN 4 THEN 2500
    WHEN 5 THEN 4000
END

-- 7. Liste o seu salário caso você tivesse um aumento de salário de 15%. Não atualize seu novo salário, apenas o exiba com o possível aumento.
select (g.salario * 1.15) as salario from garcons as g
where nome = 'CAUE';

-- 8. Cadastre uma nova mesa e 2 novos atendimentos para esta mesa. Você é o garçom que está atendendo estes clientes e eles já consumiram 3 produtos diferentes.
insert into mesas
values ('RUA', 2, 'RESERVADA')

insert into atendimentos
values ('ATENDENDO', '2026/04/13 12:42:21', 2, 6, 5),
       ('ATENDENDO', '2026/04/13 12:43:38', 2, 6, 5)

insert into consumos 
values (1, 7.00, 1, 11),
       (1, 9.00, 2, 11),
       (1, 26.00, 3, 12)

-- 9. Liste os produtos que nunca foram consumidos.
select p.descricao
from produtos as p LEFT JOIN consumos as c
on c.codProd = p.codProd
where c.codProd IS NULL;


-- 10. Liste os atendimentos realizados no dia 13/04. Considere apenas atendimentos que estão com situação de 'ATENDIDO', juntamente com os nomes dos garçons que fizeram tais atendimentos.
select a.*, g.nome
from atendimentos as a INNER JOIN garcons as g
    on g.codGarcom = a.codGarcom
where(dtHrChegada BETWEEN '2026/04/13 00:00:00' and '2026/04/13 23:59:59') AND a.situacao = 'ATENDIDO';



select * from mesas;
select * from garcons;
select * from atendimentos;
select * from produtos;
select * from consumos;