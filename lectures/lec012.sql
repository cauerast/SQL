-- Se precisar verificar o nome de uma constraint em uma tabela, use um dos comandos:

-- a)
SELECT * FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT' AND
OBJECT_NAME(parent_object_id) = 'Funcionario'
ORDER BY create_date DESC;

--b)
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Departamento';

-------------------------------------------------------------
---- questoes de 1 a 4
-- 1. Crie uma tabela para cadastro de Funcionários, obedecendo as seguintes regras: 
-- Um campo para código deverá ser chave primária com numeração automática,
-- Defina as chaves de todas as demais tabelas desta forma.
-- Nome é um atributo obrigatório;
-- CPF e RG são atributos que têm valor único para cada funcionário;
-- Sexo poderá ser: 'M' ou 'F';
-- Categoria deverá ser um dos seguintes valores: Auxiliar, Supervisor, Terceirizado, Contratado, Coordenador.
-- Idade deve estar entre 16 e 65 anos;
-- Código de departamento que este funcionário trabalha.

-- 2. Crie uma tabela para cadastro de Departamentos, com as seguintes restrições:
-- Um campo para código do departamento também com numeração automática
-- Nome do departamento é atributo obrigatório
-- Descrição do departamento
-- Código do funcionário gerente do departamento.

-- 3. Crie uma tabela para cadastro de Projetos
-- Código do projeto é atributo obrigatório com numeração automática a partir de 100
-- Nome é atributo obrigatório
-- Descrição do projeto

-- 4. Crie uma tabela para registrar a participação dos funcionários em projetos
-- Código do funcionário deverá ser obrigatório
-- Código do projeto deverá também ser obrigatório
-- Data de início da participação no projeto
-- Data de fim da participação do projeto
-- A data de início deverá ser menor que a data de fim

---- respostas de 1 a 4
-- 1 
CREATE TABLE Funcionarios (
  cod_func INT CONSTRAINT pk_id_func PRIMARY KEY IDENTITY(1,1),
  nome TEXT NOT NULL,
  cpf VARCHAR(11) UNIQUE,
  rg VARCHAR(9) UNIQUE,
  sexo CHAR(1) CONSTRAINT chk_sexo_is_char CHECK(sexo in ('M', 'F')),
  categoria VARCHAR(80) CONSTRAINT chk_categoria CHECK(categoria in ('Auxiliar', 'Supervisor', 'Terceirizado', 'Contratado', 'Coordenador')),
  idade INT CONSTRAINT chk_idade CHECK(idade >= 16 and idade <= 65),
  cod_dep INT -- ex5 pede -> CONSTRAINT fk_cod_departamento FOREIGN KEY REFERENCES Departamentos(cod_dep)
);
-- 2 
CREATE TABLE Departamentos (
  cod_dep INT CONSTRAINT pk_cod_dep PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  descricao TEXT,
  cod_gerente INT
);
-- 3
CREATE TABLE Projetos (
  cod_proj INT CONSTRAINT pk_cod_proj PRIMARY KEY IDENTITY(100,1),
  nome TEXT NOT NULL,
  descrcicao VARCHAR(80)
);
-- 4
CREATE TABLE Participacao (
  -- ex6 pede pra criar composta - cod_participacao INT CONSTRAINT pk_cod_participacao PRIMARY KEY IDENTITY(1,1),
  cod_func INT CONSTRAINT fk_cod_func FOREIGN KEY REFERENCES Funcionarios(cod_func) NOT NULL,
  cod_proj INT CONSTRAINT fk_cod_proj FOREIGN KEY REFERENCES Projetos(cod_proj) NOT NULL,
  data_inicio DATETIME,
  data_fim DATETIME,

  CONSTRAINT chk_datas CHECK(data_inicio < data_fim)
);


-- 5. Altere a tabela Funcionário criando uma ligação com a tabela de departamentos
ALTER TABLE Funcionarios
ADD CONSTRAINT fk_cod_departamento FOREIGN KEY (cod_dep) REFERENCES Departamentos(cod_dep)

-- 6. Crie uma restrição do tipo Chave Primária composta para a tabela Participação para os campos CodFun e CodProj
ALTER TABLE Participacao
ADD CONSTRAINT pk_participacao PRIMARY KEY (cod_func, cod_proj)

-- 7. Cadastre os seguintes departamentos
-- CONTAS A PAGAR
-- CONTAS A RECEBER
-- FATURAMENTO
-- VENDAS
-- COMPRAS
iNSERT INTO Departamentos VALUES (

)

-- 8. Cadastre 5 projetos


-- 9. Cadastre 10 funcionários


-- 10. Vincule 3 funcionários para cada um dos projetos cadastrados


-- 11. Cadastre os chefes dos departamentos


-- 12. Crie um campo para cidade do funcionário com valor padrão sendo 'Franca'


-- 13. Cadastre um novo funcionário sem preencher a cidade para testar sua constraint


-- 14. Crie um novo projeto e vincule 5 funcionários a este projeto


-- 15. Verifique se existe algum funcionário sem departamento, se houver, vincule os funcionários a algum departamento


-- 16. Crie uma restrição para todos os campos Descrição de todas as tabelas que possuem um campo descrição. Esta restrição deverá inserir um valor padrão para este campo.


-- 17. Exclua as tabelas que você criou.

