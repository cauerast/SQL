create database restaurante;
use restaurante;

create table mesas (
    nroMesa int PRIMARY KEY IDENTITY(1,1),
    setor varchar(30),
    capacidade int,
    situacao varchar(30)
);

create table garcons (
    codGarcom int PRIMARY KEY IDENTITY(1,1),
    nome varchar(30),
    calcularComissao money
);

create table produtos (
    codPro int PRIMARY KEY IDENTITY(1,1),
    descricao varchar(30),
    preco money
);

create table atendimentos (
    codAtendimento int PRIMARY KEY IDENTITY(1,1),
    situacao varchar(30),
    dtHrChagada datetime, -- 
    nroPessoas int,
    nroMesa int FOREIGN KEY REFERENCES mesas(nroMesa),
    codGarcom int FOREIGN KEY REFERENCES garcons(codGarcom)
);

create table consumos (
    codCom int PRIMARY KEY IDENTITY(1,1),
    qtde int,
    vlUnit money,
    codPro int FOREIGN KEY REFERENCES produtos(codPro),
    codAtendimento int FOREIGN KEY REFERENCES atendimentos(codAtendimento)
);

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
values ('ATENDENDO', '2026/04/01 21:45:32', 7),
       ('ATENDIDO', '2026/04/03 17:42:21', 2),
       ('NAO ATENDIDO', '2026/04/07 23:42:21', 3),
       ('ATENDIDO', '2026/04/09 29:42:21', 4),
       ('NAO ATENDIDO', '2026/04/11 01:21:11', 5),
       ('ATENDIDO', '2026/04/13 12:42:21', 6),
       ('NAO ATENDIDO', '2026/04/17 11:42:21', 7),
       ('ATENDIDO', '2026/04/21 17:42:21', 8),
       ('ATENDIDO', '2026/04/25 14:42:21', 11),
       ('NAO ATENDIDO', '2026/04/29 22:45:32', 9)

-- 2. Atualize o nome do garçom que possui o maior código para o seu nome.


-- 3. Crie um campo para guardar o salário dos garçons.


-- 4. Liste os produtos e seus preços em ordem do mais caro para o mais barato.


-- 5. Liste o número e o setor das mesas que estão em atendimentos (atendimentos cuja situação seja ‘ATENDENDO’). Esta situação significa que os clientes ainda estão consumindo produtos.


-- 6. Atualize os salários de cada garçom.


-- 7. Liste o seu salário caso você tivesse um aumento de salário de 15%. Não atualize seu novo salário, apenas o exiba com o possível aumento.


-- 8. Cadastre uma nova mesa e 2 novos atendimentos para esta mesa. Você é o garçom que está atendendo estes clientes e eles já consumiram 3 produtos diferentes.


-- 9. Liste os produtos que nunca foram consumidos.


-- 10. Liste os atendimentos já realizados no dia de hoje. Considere apenas atendimentos que já estão com situação de ‘FINALIZADO’, juntamente com os nomes dos garçons que fizeram tais atendimentos.


select * from mesas;
select * from garcons;
select * from produtos;
select * from atendimentos;
select * from consumos;