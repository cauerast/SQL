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
ADD CONSTRAINT chk_codCat CHECK(codCat >= 100);
