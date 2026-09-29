
CREATE TABLE Time (
  idTime INT CONSTRAINT PK_TIME PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(50) NOT NULL,
  cidade VARCHAR(50),
  estado VARCHAR(2),
  anoFundacao INT
);

CREATE TABLE Jogador (
  idJogador INT CONSTRAINT PK_JOGADOR PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  apelido VARCHAR(40),
  posicao VARCHAR(30),
  salario DECIMAL(10,2),
  dataNascimento DATE,
  numeroCamisa INT,
  idTime INT,

  CONSTRAINT FK_TIME_JOGADOR FOREIGN KEY (idTime) REFERENCES Time(idTime)
);


-- ============================================================
-- 2. INSERÇÃO DOS DADOS
-- ============================================================

INSERT INTO Time (nome, cidade, estado, anoFundacao)
VALUES
('Flamengo', 'Rio de Janeiro', 'RJ', 1895),
('Palmeiras', 'São Paulo', 'SP', 1914),
('Corinthians', 'São Paulo', 'SP', 1910),
('São Paulo', 'São Paulo', 'SP', 1930),
('Cruzeiro', 'Belo Horizonte', 'MG', 1921),
('Grêmio', 'Porto Alegre', 'RS', 1903);


INSERT INTO Jogador
(nome, apelido, posicao, salario, dataNascimento, numeroCamisa, idTime)
VALUES
('Marcelo Santos', 'Marcelinho', 'Atacante', 85000, '1998-05-12', 9, 1),
('Bruno Oliveira', NULL, 'Goleiro', 55000, '1995-08-20', 1, 1),
('Lucas Almeida', 'Luquinha', 'Meia', 72000, '2000-03-15', 10, 1),
('Matheus Silva', NULL, 'Zagueiro', 60000, '1997-11-02', 4, 1),

('Gabriel Souza', 'Biel', 'Atacante', 92000, '1999-01-25', 11, 2),
('Pedro Martins', 'Pedrinho', 'Meia', 78000, '2001-06-17', 8, 2),
('Rafael Costa', NULL, 'Zagueiro', 63000, '1996-09-08', 3, 2),
('Carlos Mendes', NULL, 'Goleiro', 58000, '1994-12-11', 1, 2),

('Marcos Ferreira', 'Marcão', 'Zagueiro', 67000, '1995-04-30', 4, 3),
('Felipe Rocha', NULL, 'Atacante', 88000, '2000-07-21', 9, 3),
('André Lima', 'Dedé', 'Meia', 74000, '1998-02-14', 10, 3),

('Rodrigo Alves', NULL, 'Goleiro', 52000, '1993-10-05', 1, 4),
('Miguel Ribeiro', 'Migué', 'Atacante', 95000, '2002-05-19', 7, 4),
('Daniel Barbosa', NULL, 'Meia', 76000, '1999-08-09', 8, 4),

('Eduardo Lopes', 'Dudu', 'Atacante', 81000, '1997-03-22', 11, 5),
('Henrique Gomes', NULL, 'Zagueiro', 59000, '1996-01-18', 3, 5),
('Gustavo Moraes', 'Guga', 'Meia', 70000, '2001-09-27', 10, 5),

('Leonardo Nunes', 'Leo', 'Goleiro', 50000, '1995-06-16', 1, 6),
('Thiago Cardoso', NULL, 'Atacante', 83000, '1998-12-03', 9, 6),
('Murilo Teixeira', 'Muri', 'Meia', 69000, '2000-10-10', 8, 6);

---- GROUP BY
SELECT COUNT(*) as qtdTotal, posicao
FROM Jogador
GROUP BY posicao; -- todos os campos que nao forem funcao precisam esta no group by

SELECT AVG(salario) as mediaSalarial, posicao
FROM Jogador
GROUP BY posicao

---- LIKE
SELECT *
FROM Jogador
WHERE nome LIKE 'M%' -- começa com M

SELECT *
FROM Jogador
WHERE nome LIKE '%silva' -- termina com silva

SELECT *
FROM Jogador
WHERE nome LIKE '%el%' -- contem 'el

---- UPPER and LOWER

SELECT nome, UPPER(nome) as UpperName, LOWER(nome) as LowerName
FROM Jogador

---- LEFT and RIGHT
-- primeiros 5 caracteres
SELECT nome, LEFT(nome, 5) as firstFiveChars
FROM Jogador;
-- ultimos 5 caracteres
SELECT nome, RIGHT(nome, 5) as lastFiveChars
FROM Jogador;

---- SUBSTRING
SELECT SUBSTRING(nome, 3, 5) as namePart
FROM Jogador;

---- GETDATE
SELECT GETDATE() as dataAtual
FROM Jogador;

---- DATEFORMAT
SET DATEFORMAT DMY;

INSERT INTO Jogador (nome, posicao, salario, dataNascimento, numeroCamisa, idTime)
VALUES ('joao pereira', 'atacante', 65000, '25/08/2000', 17, 1);

---- ISNULL
SELECT nome, ISNULL(apelido, 'SEM APELIDO') as apelido
FROM Jogador;

SELECT *
FROM Jogador
WHERE ISNULL(apelido, 'x') = 'x';

---- TOP
-- 5 maiores salarios
SELECT TOP 5
nome, salario
FROM Jogador
ORDER BY salario DESC

-- 3 menores salarios
SELECT TOP 5
nome, salario
FROM Jogador
ORDER BY salario ASC


---- GROUP BY  -- sempre que formos usar uma funcao no select e outro parametro precisamos de usar o group by para definir pelo que vamos agrupar o resultado

-- qtd de jogadores por posicao
select posicao, COUNT(*) as quantidade
FROM Jogador
GROUP BY posicao;

-- varias funcoes por posicao
SELECT posicao, COUNT(*) as quantidade, MIN(salario) as menorSalario, MAX(salario) as maiorSalario, AVG(salario) as mediaSalarial
FROM Jogador
GROUP BY posicao;

-- qtd jogadores por time
SELECT t.nome as time, COUNT(*) as qtdJogadores
FROM Time as t
INNER JOIN Jogador as j
on t.idTime = j.idTime
GROUP BY t.nome;

-- media salarial por time
SELECT t.nome as time, AVG(j.salario) as mediaSalarial
FROM Time as t
INNER JOIN Jogador as j
on t.idTime = j.idTime
GROUP BY t.nome

-- media salarial por time

---- HAVING -- filtra o group by, 
-- (WHERE filtra registros)
-- (HAVING filtra grupos)

-- posicoes com media salarial acima de 70k
SELECT posicao, AVG(salario) as mediaSalarial
FROM Jogador
GROUP BY posicao
HAVING AVG(salario) > 70000;

-- posicoes de jogadores com salario maior que 50000 que a media resultante é maior que 70000
SELECT posicao, AVG(salario) as mediaSalarial
FROM Jogador
WHERE salario > 50000
GROUP BY posicao
HAVING AVG(salario) > 70000;


---- (SUBSELECT)
-- liste os nomes dos jogadores que tem salario acima da media;
SELECT nome, salario
FROM Jogador
WHERE salario > (select AVG(salario) from Jogador)

---- (SUBSELECT COM IN)

-- id dos times de sp
SELECT idTime
FROM Time
WHERE estado = 'sp';

-- Jogadores de sp, usando subselect
SELECT *
FROM Jogador
WHERE idTime IN (
  SELECT idTime
  FROM Time
  WHERE estado = 'sp'
)

-- Jogadores de sp sem usar subselect
SELECT j.*
FROM Jogador as j
INNER JOIN Time as t
on t.idTime = j.idTime
WHERE t.estado = 'sp'

-- Jogadores que nao sao de sp, usando subselect
SELECT *
FROM Jogador
WHERE idTime NOT IN (
  SELECT idTime
  FROM Time
  WHERE estado = 'sp'
)

-- Jogadores que nao sao de sp, sem usar subselect
SELECT j.*
FROM Jogador as j
INNER JOIN Time as t
on t.idTime = j.idTime
WHERE NOT t.estado = 'sp'

