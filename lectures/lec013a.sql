CREATE TABLE Fabricante (
  codFabr int CONSTRAINT pk_codFabr PRIMARY KEY IDENTITY(1,1),
  razaoSocial varchar(80),
  cidade TEXT,
  uf varchar(2)
)
CREATE TABLE Categoria (
  codCat int CONSTRAINT pk_codCat PRIMARY KEY IDENTITY(1,1),
  descricao TEXT,
  statusCat TEXT
)
CREATE TABLE Produto (
  codProd int CONSTRAINT pk_codProd PRIMARY KEY IDENTITY(1,1),
  descricao TEXT,
  preco money
)

-- a) cidade do Fabricante tem valor padrão como sendo 'FRANCA'
ALTER TABLE Fabricante
ADD CONSTRAINT df_cidade DEFAULT('franca') for cidade

-- b) Campo Razão Social é um campo obrigatório.
ALTER TABLE Fabricante 
ALTER COLUMN razaoSocial varchar(80) NOT NULL;

-- c) Só poderão ser cadastrados fabricantes de SP, MG ou RJ.
-- d) Descrição do produto é obrigatório.
-- e) Status da categoria poderá ser ATIVO ou INATIVO.
-- f) Crie um campo para guardar o estoque dos produtos. Este campo deverá ser sempre um -- número positivo
-- g) Preço do produto deverá ser sempre maior que 0 (zero).
-- h) Observe as restrições impostas pelas cardinalidades.
-- i) Código da categoria deverá ser um número inteiro de 3 dígitos.