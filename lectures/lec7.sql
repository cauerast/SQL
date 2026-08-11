
-- Data: 04/08/26
-- Nomes: Cauê Silva Rasteiro ; Miguel Henrique Isaac
-- Arq. Banco de Dados II | Ciência da Computação | 4º Semestre

-- 1. Modelagem Relacional (DER)
/*
   [Categoria] (1,1) ------< (0,N) [Produto]
   - codCat                         - codProd
   - nomeCat                        - descricao
                                    - codBarra
                                    - estoque
*/


-- 2. Criação do Banco de Dados e Tabelas
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


-- 3. Inserção de Dados
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


-- 4. Atualizar estoque do produto com codProd = 4
UPDATE Produtos
SET estoque = 350
WHERE codProd = 4;


-- 5. Selecionar descrição, código de barras e estoque dos produtos com estoque maior que 500
SELECT descricao, codBarra, estoque
FROM Produtos
WHERE estoque > 500;


-- 6. Deletar produtos pertencentes à categoria com codCat = 3
DELETE FROM Produtos
WHERE codCat = 3;


-- 7. Inserir um novo produto especificando as colunas
INSERT INTO Produtos (descricao, estoque, codCat)
VALUES ('Feijão', 3, 2);


-- 8. Remover a coluna codBarra da tabela Produtos
ALTER TABLE Produtos
DROP COLUMN codBarra;


-- 9. Selecionar descrição e estoque ordenando pelo estoque em ordem decrescente
SELECT descricao, estoque
FROM Produtos
ORDER BY estoque DESC;


-- 10. Adicionar nova coluna precoUnit na tabela Produtos
ALTER TABLE Produtos
ADD precoUnit MONEY;


-- 11. Deletar produtos de determinadas categorias
DELETE FROM Produtos
WHERE codCat = 1 OR codCat = 3 OR codCat = 5;

-- or

DELETE FROM Produtos
WHERE codCat IN(1, 3, 5);


-- 12. Atualizar o preço unitário (precoUnit) com base no codProd usando CASE
UPDATE Produtos
SET precoUnit = CASE codProd
    WHEN 2 THEN 10.01
    WHEN 4 THEN 9.99
    WHEN 6 THEN 21.19
    WHEN 7 THEN 22.22
    WHEN 8 THEN 44.12
END;


-- 13. Selecionar descrição do produto e nome da categoria com INNER JOIN
SELECT p.descricao, c.nomeCat
FROM Produtos AS p
INNER JOIN Categorias AS c
    ON p.codCat = c.codCat;


-- 14. Selecionar todas as categorias com seus produtos usando LEFT JOIN
SELECT *
FROM Categorias AS c
LEFT JOIN Produtos AS p
    ON p.codCat = c.codCat
WHERE p.codCat IS NULL;


-- 15. Reajustar o preço unitário dos produtos com estoque menor que 400
UPDATE Produtos
SET precoUnit = precoUnit + precoUnit * 0.05
WHERE estoque < 400;


-- Funcoes em SQL

-- Max = retorna o valor maximo
SELECT MAX(estoque) as maiorEstoque FROM Produtos;

-- MIN = retorna o valor minimo
SELECT MIN(estoque) as menorEstoque FROM Produtos;

-- SUM = retorna o valor da coluna somado
SELECT SUM(precoUnit) as precoTotal FROM Produtos;

-- campo calculado
select descricao, estoque, precoUnit, estoque * precoUnit as ValorEstoque
FROM Produtos;

-- SUM - Calcula a soma
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

select * from Produtos;
select * from Categorias;