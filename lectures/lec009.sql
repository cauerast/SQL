-- create database lec9
-- GO
-- Use lec9;


-- 1. Observe o DER apresentado e crie o banco de dados correspondente. As chaves primárias de todas as tabelas deverão ter numeração automática.
create table Hospedes (
  codHospede int PRIMARY KEY IDENTITY(1,1),
  nome varchar(80),
  idade date,
  sexo varchar(80),
)
create table Quartos (
  codQuarto int PRIMARY KEY IDENTITY(1,1),
  tipo VARCHAR(80),
  numero int,
  andar int,
)
create table Reservas (
  codReserva int PRIMARY KEY IDENTITY(1,1),
  dtEntrada date,
  dtSaida date,
  codHospede int FOREIGN KEY REFERENCES Hospedes(codHospede),
  codQuarto int FOREIGN KEY REFERENCES Quartos(codQuarto),
)
create table Pagamentos (
  codPagto int PRIMARY KEY IDENTITY(1,1),
  valor money,
  dtPagto date,
  codReserva int FOREIGN KEY references Reservas(codReserva),
)
create table Refeicoes (
  codConsumo int PRIMARY KEY IDENTITY(1,1),
  descRefeicao VARCHAR(80),
  valor money,
  codReserva int FOREIGN KEY references Reservas(codReserva),
)

-- 2. Cadastre 5 quartos, 4 hóspedes, 4 reservas e 6 refeições.
insert into Quartos
values ('casal', 1, 1),
       ('solteiro', 2, 1),
       ('casal', 3, 2),
       ('casal', 4, 2),
       ('solteiro', 5, 3)

insert into Hospedes
values ('caue', '2006/08/30', 'masc'),
       ('laura', '2008/04/04', 'fem'),
       ('bownie', '2020/11/23', 'masc'),
       ('lya', '2022/12/20', 'fem')
      
insert into Reservas
values ('2026/02/08', '2026/02/15', 1, 1),
       ('2026/03/08', '2026/04/15', 2, 3),
       ('2026/05/08', '2026/05/12', 1, 3),
       ('2026/01/02', '2026/08/30', 3, 4)

insert into Refeicoes
values ('cookie', 12.00, 1),
       ('brownie', 8.00, 2),
       ('almoco', 22.00, 3),
       ('janta', 23.00, 4),
       ('cocada', 5.00, 1),
       ('suco', 8.00, 2)

-- 3. Qual a quantidade de quartos do tipo 'casal' existe neste hotel?
select count(codQuarto) as qtdQuartosCasal
from Quartos
where tipo = 'casal';

-- 4. Qual o valor médio pago por uma refeição?
select AVG(valor) as ValorMedioRefeicoes from Refeicoes;

-- 5. Exclua o campo Idade e crie um campo para guardar a data de nascimento dos hóspedes.
alter table Hospedes
drop column idade;

alter table Hospedes
add idade date;

-- 6. Quantos hóspedes fizeram reserva neste hotel?
select count(codHospede) as qtdHospedes from Hospedes;

-- 7. Selecione os nomes dos hóspedes e as datas de entradas das suas reservas.
select H.nome as nome, R.dtEntrada as dataEntrada 
from Hospedes as H INNER JOIN Reservas as R
ON H.codHospede = R.codHospede

-- 8. Atualize as datas de nascimentos de cada hóspede.
update Hospedes 
set idade = CASE codHospede
  when 1 then '2006/08/30'
  when 2 then '2008/04/04'
  when 3 then '2020/11/23'
  when 4 then '2022/12/20'
end

-- 9. Selecione os nomes dos hóspedes, juntamente com as datas de entrada das hospedagens que aconteceram antes do dia 01/01/2025. Faça esta lista mostrando os hóspedes em ordem alfabética.
select H.nome as nome, R.dtEntrada as dataEntrada 
from Hospedes as H INNER JOIN Reservas as R
ON H.codHospede = R.codHospede
where R.dtEntrada < '01/01/2025'
ORDER BY H.nome asc

-- 10. Selecione os nomes das mulheres que já se hospedaram no 4º andar.
select nome as NomeMulheres4Andar
from Hospedes as H INNER JOIN Reservas as R
ON h.codHospede = R.codHospede
INNER JOIN Quartos as Q
On Q.codQuarto = R.codQuarto
where H.sexo = 'fem'
  and Q.andar = 4;

-- 11. Selecione os números e tipos dos quartos que ainda não tiveram reservas.
SELECT Q.numero, Q.tipo 
FROM Quartos AS Q LEFT JOIN Reservas AS R 
ON Q.codQuarto = R.codQuarto 
WHERE R.codReserva IS NULL;

-- 12. O hóspede ‘caue' pagou quanto por suas hospedagens?
select SUM(P.valor) as PagamentosCaue
from Pagamentos as P INNER JOIN Reservas as R
on P.codReserva = R.codReserva
INNER JOIN Hospedes as H
on H.codHospede = R.codHospede
where H.nome = 'caue';

-- 13. Quantos hóspedes ficaram hospedados mais de 5 dias durantes o mês de fevereiro deste ano?
SELECT COUNT(DISTINCT R.codHospede) AS QtdHospedesFevereiro
FROM Reservas AS R
WHERE R.dtEntrada >= '2026-02-01' 
  AND R.dtEntrada <= '2026-02-28'
  AND DATEDIFF(day, R.dtEntrada, R.dtSaida) > 5;
