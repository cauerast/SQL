CREATE TABLE Fabricantes (
  codFabr int CONSTRAINT pk_codFabr PRIMARY KEY IDENTITY(1,1),
  razaoSocial varchar(80),
  cidade TEXT,
  uf varchar(2)
)
CREATE TABLE Categorias (
  codCat int CONSTRAINT pk_codCat PRIMARY KEY IDENTITY(100,1),
  descricao TEXT,
  statusCat varchar(10)
)
CREATE TABLE Produtos (
  codProd int CONSTRAINT pk_codProd PRIMARY KEY IDENTITY(1,1),
  descricao TEXT,
  preco money,
  codFabr int CONSTRAINT fk_codFabr FOREIGN KEY REFERENCES Fabricantes(codFabr),
  codCat int CONSTRAINT fk_codCat FOREIGN KEY REFERENCES Categorias(codCat)
)

-- a) cidade do Fabricante tem valor padrão como sendo 'FRANCA'
ALTER TABLE Fabricantes
ADD CONSTRAINT df_cidade DEFAULT('franca') for cidade

-- b) Campo Razão Social é um campo obrigatório.
ALTER TABLE Fabricantes
ALTER COLUMN razaoSocial varchar(80) NOT NULL;

-- c) Só poderão ser cadastrados fabricantes de SP, MG ou RJ.
ALTER TABLE Fabricantes
ADD CONSTRAINT chk_uf CHECK(uf in ('SP', 'MG', 'RJ'));

-- d) Descrição do produto é obrigatório.
ALTER TABLE Produtos 
ALTER COLUMN descricao varchar(80) NOT NULL;

-- e) Status da categoria poderá ser ATIVO ou INATIVO.
ALTER TABLE Categorias
ADD CONSTRAINT chk_status CHECK(statusCat in ('ATIVO', 'INATIVO'));

-- f) Crie um campo para guardar o estoque dos produtos. Este campo deverá ser sempre um número positivo
ALTER TABLE Produtos
ADD estoque int CONSTRAINT chk_estoque CHECK(estoque >= 0);

-- g) Preço do produto deverá ser sempre maior que 0 (zero).
ALTER TABLE Produtos
ADD CONSTRAINT ck_preco CHECK(preco > 0);

-- h) Observe as restrições impostas pelas cardinalidades.
ALTER TABLE Produtos 
ALTER COLUMN codFabr int NOT NULL;

ALTER TABLE Produtos 
ALTER COLUMN codCat int NOT NULL;

-- i) Código da categoria deverá ser um número inteiro de 3 dígitos.
ALTER TABLE Categorias
ADD CONSTRAINT chk_codCat CHECK(codCat >= 100 and codCat <= 999);

-- 2. Crie as seguintes views para:
-- a. Listar o código do produto, sua descrição e preço, a categoria, o nome e a cidade do fabricante.
GO
CREATE VIEW view1 as
SELECT p.codProd, p.descricao, p.preco, c.descricao as categoria, f.razaoSocial, f.cidade
FROM Produtos as p
INNER JOIN Fabricantes as f
ON p.codFabr = f.codFabr
INNER JOIN Categorias as c
ON c.codCat = p.codCat
GO

SELECT * FROM view1;


-- b. Listar os produtos dos fabricantes do RJ.
GO
CREATE VIEW view2 AS
SELECT p.codCat, p.codFabr, p.codProd, p.descricao, p.preco from Produtos as p
INNER JOIN Fabricantes as f
ON p.codFabr = f.codFabr
WHERE f.uf = 'RJ';
GO

SELECT * FROM view2

-- c. Selecionar de forma exclusiva as categorias que possuem produtos fornecidos para o estado de SP e que estão em categorias inativas.
GO
CREATE VIEW view3 as 
SELECT DISTINCT c.descricao from Categorias as c
INNER JOIN Produtos as p
ON c.codCat = p.codCat
INNER JOIN Fabricantes as f
ON f.codFabr = p.codFabr
WHERE f.uf = 'SP';
GO

-- c.1 produtos sem categoria ->
GO
CREATE VIEW ProdWithNoCat as 
SELECT p.codCat, p.codFabr, p.codProd, p.descricao, p.preco
FROM Produtos as p
LEFT JOIN Categorias as c
ON p.codCat = c.codCat
WHERE c.codCat IS NULL
GO

SELECT * FROM ProdWithNoCat;


-- d. Listar os nomes dos produtos, o preço total dos seus estoques (considerando o preço de venda) e o nome das categorias que eles pertencem. Somente de produtos fabricados em SP.
GO
CREATE VIEW viewD AS
SELECT p.descricao as produto, (p.preco * p.estoque) as precoTotal, c.descricao as categoria
FROM Produtos as p
INNER JOIN Categorias as c
ON p.codCat = c.codCat
INNER JOIN Fabricantes as f
ON f.codFabr = p.codFabr
WHERE f.uf = 'SP'
GO

SELECT * FROM viewD;


-- 3. Crie uma nova tabela para cadastro de Marcas com os campos CodMarca e NomeMarca. O código deverá ser chave primária com numeração automática a partir de 5000 e o Nome da marca precisará ser único e de preenchimento obrigatório.
CREATE TABLE Marcas (
  codMarca int CONSTRAINT pk_codMarca PRIMARY KEY IDENTITY(5000,1),
  nome VARCHAR(50) CONSTRAINT uk_nomeMarca UNIQUE NOT NULL
)

-- 4. Cada produto poderá ter apenas uma marca.
ALTER TABLE Produtos
ADD codMarca int CONSTRAINT fk_codMarca FOREIGN KEY REFERENCES Marcas(codMarca)

SELECT * FROM Produtos;

-- 5. Cadastre 5 marcas.
INSERT INTO Marcas
VALUES ('ADIDAS'),
       ('NIKE'),
       ('PUMA'),
       ('NB'),
       ('TS')

-- 6. Crie uma view que informe quais são os fabricantes e as marcas dos produtos que estão nas categorias Inativas.
GO
CREATE VIEW view6 as 
SELECT f.razaoSocial, m.nome
FROM Fabricantes as f
INNER JOIN Produtos as p
ON f.codFabr = p.codFabr
INNER JOIN Marcas as m
ON m.codMarca = p.codMarca
INNER JOIN Categorias as c
ON c.codCat = p.codCat
WHERE c.statusCat = 'INATIVO';
GO

SELECT * FROM view6;

-- 7. Crie uma nova view para mostrar a descrição e os preços dos produtos e suas respectivas marcas, ordenado por produto.
GO
CREATE VIEW view7 AS
SELECT p.descricao, p.preco, m.nome
FROM Produtos AS p
INNER JOIN Marcas AS m
ON M.codMarca = p.codMarca
GO

SELECT * FROM view7
ORDER BY descricao ASC;
