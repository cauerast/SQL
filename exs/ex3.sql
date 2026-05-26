CREATE DATABASE vendas2026;

USE vendas2026;

-- create a table w pk
CREATE TABLE marca (
    idMarca int PRIMARY KEY, -- pk
    nome varchar(80),
    situacao char(1)
)

-- create a table with product and pk but without fk
CREATE TABLE produto (
    idPro int PRIMARY KEY,
    nome varchar(80),
    preco money,
    cor varchar(40)
)

-- add brands one by one
INSERT INTO marca
VALUES (1, 'COCA-COLA', 'A')
INSERT INTO marca
VALUES (2, 'PEPSI', 'A')

-- add brands one by one
INSERT INTO marca VALUES
(3, 'ANTARTICA', 'I'),
(4, 'FORS', 'A'),
(5, 'SKOL', 'I');

-- Testing not-null pk propriety -----> error
INSERT INTO marca (nome, situacao)
VALUES ('teste', 'A')

-- Testing UNIQUE pk propriety ------> error
INSERT INTO marca (nome, situacao)
VALUES (1, 'teste', 'A')

-- drop table product
DROP TABLE produto;

-- CREATE PRODUCT TABLE w/ pk, fk referencing marca and auto numeration
CREATE TABLE produto(
    idPro int PRIMARY KEY IDENTITY(1, 1), -- start in 1 and count by 1
    nome varchar(80),
    preco money,
    cor varchar(80),
    idMarca int FOREIGN KEY REFERENCES marca(idMarca)
)

-- ADD PRODUCTS TO TEST ENUMERATIONS
INSERT INTO produto (nome, preco)
VALUES ('COCA LATA 340ml', 8.94)

-- Test fk reference integrity with update
UPDATE produto
SET idMarca = 20 -- that doesnt exist -----> error
WHERE idPro = 1;


-- CREAET A NEW TABLE TO REGISTER SUPPLIERS
CREATE TABLE fornecedor (
    idFor int PRIMARY KEY IDENTITY(1, 1),
    razaoSocial varchar(50),
    cnpj varchar(20)
)

-- Alter the product table structure to add a new fk linked to a supplier
ALTER TABLE produto 
ADD idFor int FOREIGN KEY REFERENCES fornecedor(idFor)

---- Fix Tests ----
-- 1. Cadastre 3 produtos informando somente o nome e o preço
-- 2. Cadastre 4 fornecedores preenchendo todos os campos 
-- 3. Altere o nome da marca 'SKOL' para 'LEVÍSSIMA'
-- 4. Cadastre 2 produtos informando todos os campos da tabela
-- 5. Atualize o CNPJ do fornecedor cujo idFor é 3 para ter valor '123456789'
-- 6. Atualize todos os produtos que não têm marca para terem algum idmarca
-- 7. Exclua o produto de codigo = 2
-- 8. Exclua a marca de codigo = 4
-- 9. Acrescente 10% a mais no preço dos produtos que tem preço maior que zero
-- 10. Exclua (apague) a tabela fornecedor


SELECT * FROM marca;
SELECT * FROM produto;