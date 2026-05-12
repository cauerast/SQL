create database provaSofrida;

use provaSofrida;

create table produtos(
  codigo int,
  descricao varchar(80),
  preco money
)

-- 1 --
insert into produtos
values (100, 'folha de papel', 37.00);

-- 2 --
alter table produtos
add column codigoCidade int;
alter table produtos
add column nomeCidade varchar(80);
alter table produtos
add column UF varchar(2);

-- 3 --
alter table produtos
add column codigoBarras varchar(80);

-- 4 --
insert into produtos (codigo, descricao, preco, codigoBarras)
values (200, 'pincel para quadro branco', 13.00, 'ABS-1430');

update produtos
set preco = 44
where descricao = 'folha de papel';

drop table produtos;
select * from produtos;