CREATE DATABASE exAula
GO
USE exAula;

CREATE TABLE Categorias (
    codCat INT PRIMARY KEY IDENTITY(1,1),
    nomeCat VARCHAR(80)
);

CREATE TABLE Produtos (
    codProd INT PRIMARY KEY IDENTITY(1,1),
    descricao VARCHAR(60),
    codBarra VARCHAR(100),
    estoque INT,
    codCat INT FOREIGN KEY REFERENCES Categorias(codCat)
);

drop table Produtos;
drop table Categorias;

INSERT INTO Categorias VALUES
    ('Limpeza'),
    ('Comida'),
    ('Higiene'),
    ('Pets');

INSERT INTO Produtos VALUES
    ('Veja', '1', 0, 1),
    ('Arroz', '2', 3, 2),
    ('Farofa', '3', 4, 2),
    ('Macon', '4', 5, 2),
    ('Ração gato', '5', 7, 4),
    ('Papel hig.', '6', 11, 3),
    ('Pasta de dentes', '7', 10, 3),
    ('Sabão', '8', 23, 3);


ALTER TABLE Produtos
ADD precoUnit MONEY;

UPDATE Produtos
SET precoUnit = CASE codProd
    WHEN 2 THEN 10.01
    WHEN 4 THEN 9.99
    WHEN 6 THEN 21.19
    WHEN 7 THEN 22.22
    WHEN 8 THEN 44.12
END;


-- Funcoes em SQL

-- campo calculado
select descricao, estoque, precoUnit, estoque * precoUnit as ValorEstoque
FROM Produtos;

select descricao, precoUnit, (precoUnit * 1.10) as precoReajustado
from Produtos;
-- Max = retorna o valor maximo
SELECT MAX(estoque) as maiorEstoque FROM Produtos;

-- MIN = retorna o valor minimo
SELECT MIN(estoque) as menorEstoque FROM Produtos;

-- SUM = retorna o valor da coluna somado
SELECT SUM(precoUnit) as precoTotal FROM Produtos;

select SUM(estoque * precoUnit) as ValorTotalEstoque
FROM Produtos

-- AVG - Calcula a media
select AVG(precoUnit) as PrecoMedio
FROM Produtos;

-- ROUND = Funcao de arredondamento. ROUND(num, numero da casa depois da virgula que vai começar a arredondar dela para a direita). Se colocar 0 no segundo parametro ele arredonda o numero todo.
select ROUND(1235.532, 1) as precoMedio;

select ROUND(AVG(precoUnit), 2) as precoMedio
from Produtos;

-- COUNT = conta o numero de ocorrencias
select COUNT(descricao)
from Produtos;

-- qtd de produtos sem categoria
select COUNT(*) - COUNT(codCat)
from Produtos as QtdProdutosSemCategoria;

-- DISTINCT = selecionar linhas exclusivas
SELECT DISTINCT(codCat) as categoriasProdutos
FROM Produtos;


select * from Produtos;
select * from Categorias;

