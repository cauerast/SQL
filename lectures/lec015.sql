create table Func (
  CodFunc int constraint pk_func primary key, 
  PrimeiroNome varchar(50), 
  SegundoNome varchar(50), 
  UltimoNome varchar(50), 
  DataNasci datetime, 
  CPF   varchar(20), 
  RG varchar(20), 
  Endereco varchar(50), 
  CEP varchar(15), 
  Cidade varchar(50), 
  Fone varchar(20), 
  CodDepto int, 
  Funcao varchar(50), 
  Salario money
)

create table Depto (
  CodDepto int constraint pk_deto primary key, 
  Nome varchar(50), 
  Localizacao varchar(50), 
  CodigoFuncionarioGerente int
)

alter table Func
add constraint fk_depto_func foreign key (CodDepto) references Depto(CodDepto)

alter table Depto
add constraint fk_func_gerente foreign key (CodigoFuncionarioGerente) references Func(CodFunc)


INSERT INTO DEPTO 
values
  (1, 'RH', 'SUL', NULL),
  (2, 'COMPRAS', 'SUL', NULL),
  (3, 'VENDAS', NULL,  NULL),
  (4, 'FINANCEIRO', 'NORTE', NULL),
  (5, 'MARKETING', 'NORTE', NULL),
  (6, 'DESENVOLVIMENTO', NULL, NULL),
  (7, 'CONTABILIDADE', NULL, NULL)


INSERT INTO Func (CodFunc, PrimeiroNome, SegundoNome, UltimoNome, DataNasci, Cidade, Funcao, Salario)
values (1, 'JOSE', 'MANOEL', 'DA SILVA', '1980/01/01','FRANCA', 'CONTADOR', 1200.00)

update func set salario = 1700
where codFunc = 5

-- 1. Listar todos os campos de funcionarios ordenados por cidade.
SELECT *
FROM Func
ORDER BY cidade ASC;

-- 2. Obter nomes dos funcionarios nascidos entre as datas 1950-01-01 e 1970-01-01.
SELECT CONCAT(f.PrimeiroNome, ' ', f.SegundoNome, ' ', f.UltimoNome) as NomeCompleto
FROM Func as f
WHERE DataNasci BETWEEN '1950-01-01' and '1970-01-01'

-- 3. Lista os funcionarios que tem salario superior a R$1000 ordenados pelo nome completo
SELECT CONCAT(f.PrimeiroNome, ' ', f.SegundoNome, ' ', f.UltimoNome) as nome, f.salario
FROM Func as f
WHERE Salario > 1000
ORDER BY CONCAT(f.PrimeiroNome, ' ', f.SegundoNome, ' ', f.UltimoNome)

-- or

SELECT f.PrimeiroNome + ' ' + f.SegundoNome + ' ' + f.UltimoNome as nome, f.salario
FROM Func as f
WHERE Salario > 1000
ORDER BY f.PrimeiroNome, f.SegundoNome, f.UltimoNome;

-- 4. liste a data de nasciento e o primeiro nome dos funcionarios ordenados do mais novo para o mais velho
SELECT f.DataNasci, f.PrimeiroNome
FROM Func as f
ORDER By DataNasci DESC

-- 5. liste o total da folha de pagamento
SELECT SUM(f.salario) as totalFolhaDePagamento
FROM Func as f

-- 6. liste o nome, o nome do departamento e a funcao de todos os funcionarios
SELECT CONCAT(f.PrimeiroNome, ' ', f.SegundoNome, ' ', f.UltimoNome) as nomeCompleto, d.nome as departamento, f.Funcao as funcao
FROM Func as f
INNER JOIN Depto as d
ON d.CodDepto = f.CodDepto

-- 7. Liste todos os departamentos com seus respectivos gerentes;
SELECT d.Nome, f.PrimeiroNome as gerente 
FROM Depto as d
INNER JOIN Func AS f
ON d.CodDepto = f.CodDepto
WHERE d.CodigoFuncionarioGerente = f.CodFunc

-- 8. Liste o valor da folha de pagamento de cada departamento (nome);
SELECT d.Nome as departamento, SUM(f.salario) as totalFolhaDePagamento 
FROM Depto as d
INNER JOIN Func as f
ON d.CodDepto = f.CodDepto
GROUP BY d.Nome

-- 9. Liste os departamentos dos funcionarios que tem a funcao de 'supervisor';
SELECT f.PrimeiroNome, d.Nome
FROM

-- 10. liste a qtd de funcionarios desta empresa;