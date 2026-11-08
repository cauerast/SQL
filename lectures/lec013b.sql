-- 1. CREATE TABLES
CREATE TABLE fabricantes (
   codFabr int CONSTRAINT pk_codFabr PRIMARY KEY IDENTITY(1,1),
   razaoSocial varchar(80),
   cidade varchar(50),
   uf varchar(2)
)

CREATE TABLE categorias (
   codCat int CONSTRAINT pk_codCat PRIMARY KEY IDENTITY(1,1),
   descricao TEXT,
   statusCat varchar(40)
)

CREATE TABLE produtos (
   codPro int CONSTRAINT pk_codPro PRIMARY KEY IDENTITY(1,1),
   descricao TEXT,
   preco money,
   codFabr int CONSTRAINT fk_codFabr REFERENCES fabricantes(codFabr),
   codCat int CONSTRAINT fk_codCat REFERENCES categorias(codCat)
)

-- a) cidade do Fabricante tem valor padrão como sendo 'FRANCA'
ALTER TABLE fabricantes ADD CONSTRAINT dft_cidade_franca DEFAULT('FRANCA') for cidade

-- b) Campo Razão Social é um campo obrigatório.
ALTER TABLE fabricantes ALTER COLUMN razaoSocial varchar(80) NOT NULL

-- c) Só poderão ser cadastrados fabricantes de SP, MG ou RJ.
ALTER TABLE fabricantes ADD CONSTRAINT chk_uf CHECK(uf in ('SP', 'MG', 'RJ'))

-- d) Descrição do produto é obrigatório.
ALTER TABLE produtos ALTER COLUMN descricao varchar(80) NOT NULL;

-- e) Status da categoria poderá ser ATIVO ou INATIVO.
ALTER TABLE categorias ADD CONSTRAINT chk_statusCat CHECK(statusCat in ('ATIVO', 'INATIVO'));

-- f) Crie um campo para guardar o estoque dos produtos. Este campo deverá ser sempre um número positivo
ALTER TABLE produtos ADD estoque int CONSTRAINT estoque_rule CHECK(estoque >= 0);

-- g) Preço do produto deverá ser sempre maior que 0 (zero).
ALTER TABLE produtos ADD CONSTRAINT preco_rule CHECK(preco > 0)

-- h) Observe as restrições impostas pelas cardinalidades.
ALTER TABLE Produtos ALTER COLUMN codFabr int NOT NULL;
ALTER TABLE Produtos ALTER COLUMN codCat int NOT NULL;

-- i) Código da categoria deverá ser um número inteiro de 3 dígitos.
ALTER TABLE categorias ADD CONSTRAINT codCat_100_init_999_final CHECK(codCat >= 100 and codCat <= 999);


-- 2. Crie as seguintes views para:
-- a. Listar o código do produto, sua descrição e preço, a categoria, o nome e a cidade do fabricante.
GO
CREATE VIEW viewA as 
SELECT p.codPro, p.descricao, p.preco, c.descricao as categoria, f.razaoSocial, f.cidade 
FROM produtos as p 
INNER JOIN fabricantes as f ON p.codFabr = f.codFabr 
INNER JOIN categorias as c ON p.codCat = c.codCat
GO

-- b. Listar os produtos dos fabricantes do RJ.
CREATE VIEW viewB as
SELECT p.codPro, p.descricao, p.preco, p.estoque, f.razaoSocial, f.uf
FROM produtos as p
INNER JOIN fabricantes as f ON p.codFabr = f.codFabr
WHERE f.uf = 'RJ';
GO

-- c. Selecionar de forma exclusiva as categorias que possuem produtos fornecidos para o estado de SP e que estão em categorias inativas.
CREATE VIEW view3 as 
SELECT DISTINCT c.descricao 
FROM categorias as c 
INNER JOIN produtos as p ON c.codCat = p.codCat 
INNER JOIN fabricantes as f ON f.codFabr = p.codFabr 
WHERE f.uf = 'SP' AND c.statusCat = 'INATIVO';
GO   

-- c.1 view p/ produtos sem categoria 
CREATE VIEW viewC1 as 
SELECT p.codCat, p.codFabr, p.codPro, p.descricao, p.preco 
FROM produtos as p 
LEFT JOIN categorias as c ON p.codCat = c.codCat 
WHERE p.codCat IS NULL; 
GO  

-- d. Listar os nomes dos produtos, o preço total dos seus estoques (considerando o preço de venda) e o nome das categorias que eles pertencem. Somente de produtos fabricados em SP.
CREATE VIEW viewD as
SELECT p.descricao as produto, (p.preco * p.estoque) as precoTotalEstoque, c.descricao as categoria
FROM produtos as p
INNER JOIN categorias as c ON p.codCat = c.codCat
INNER JOIN fabricantes as f ON p.codFabr = f.codFabr
WHERE f.uf = 'SP';
GO


-- 3. Crie uma nova tabela para cadastro de Marcas com os campos CodMarca e NomeMarca. 
CREATE TABLE marcas (
    codMarca int CONSTRAINT pk_codMarca PRIMARY KEY IDENTITY(5000,1),
    nomeMarca varchar(50) CONSTRAINT unq_nomeMarca UNIQUE NOT NULL
);


-- 4. Cada produto poderá ter apenas uma marca.
-- (Para resolver isso, adicionamos a chave estrangeira codMarca na tabela produtos)
ALTER TABLE produtos ADD codMarca int CONSTRAINT fk_codMarca REFERENCES marcas(codMarca);


-- 5. Cadastre 5 marcas.
INSERT INTO Marcas (nomeMarca) VALUES 
('ADIDAS'),
('NIKE'),
('PUMA'),
('NB'),
('TS');


-- 6. Crie uma view que informe quais são os fabricantes e as marcas dos produtos que estão nas categorias Inativas.
GO
CREATE VIEW viewFabricantesMarcasInativas as
SELECT DISTINCT f.razaoSocial as fabricante, m.nomeMarca as marca
FROM produtos as p
INNER JOIN fabricantes as f ON p.codFabr = f.codFabr
INNER JOIN marcas as m ON p.codMarca = m.codMarca
INNER JOIN categorias as c ON p.codCat = c.codCat
WHERE c.statusCat = 'INATIVO';
GO


-- 7. Crie uma nova view para mostrar a descrição e os preços dos produtos e suas respectivas marcas, ordenado por produto.
CREATE VIEW viewProdutosMarcas as
SELECT TOP 100 PERCENT p.descricao as produto, p.preco, m.nomeMarca as marca
FROM produtos as p
INNER JOIN marcas as m 
ON p.codMarca = m.codMarca
ORDER BY p.descricao;
GO
