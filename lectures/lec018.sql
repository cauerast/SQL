CREATE DATABASE BdVestibular;
GO
USE BdVestibular;
GO

-- EXERCÍCIO – BANCO DE DADOS VESTIBULAR 
  
-- 1. Crie o banco de dados BdVestibular, implementando as tabelas com seus respectivos atributos, chaves primárias e estrangeiras. 
-- 2. Implemente as seguintes regras de negócio utilizando constraints: 
-- a) Os cursos devem possuir carga horária de 2800 ou 3600 horas. 
-- b) Um candidato pode apresentar apenas uma das seguintes situações: Aprovado, Reprovado ou 
-- Aprovado em 2ª chamada. 
-- c) Uma inscrição pode apresentar apenas uma das seguintes situações: Aguardando pagamento, 
-- Cancelado, Encerrado ou Pago. 
-- d) A data de vencimento do boleto deve ser gerada automaticamente para 10 dias após a data de lançamento. 
-- e) Cada candidato pode realizar apenas uma inscrição por ano. 
-- f) A Primeira e a segunda opção de cursos não pode ser igual. 
-- g) A data de cadastro do candidato é inserida automaticamente com a data do sistema. 
 
CREATE TABLE curso (
  codCur INT CONSTRAINT pk_codCur PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  cargaHoraria INT CONSTRAINT chk_cargaHoraria CHECK(cargaHoraria in (2800, 3600)),
  nroVagas INT
);

CREATE TABLE candidato (
  codCan INT CONSTRAINT pk_codCan PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  endereco VARCHAR(80),
  cpf VARCHAR(40),
  rg VARCHAR(40),
  situacao varchar(80) CONSTRAINT chk_situacao_candidato CHECK(situacao in ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada')),
  dtCadastro DATETIME CONSTRAINT dft_dtCadastro DEFAULT GETDATE()
);

CREATE TABLE inscricao (
  codIns INT CONSTRAINT pk_codIns PRIMARY KEY IDENTITY(1,1),
  nota NUMERIC(4,2),
  anoInscr INT,
  dataInscr DATETIME,
  situacao varchar(80) CONSTRAINT chk_situacao_inscricao CHECK(situacao in ('Aguardando pagamento', 'Cancelado', 'Encerrado', 'Pago')),
  codCan INT CONSTRAINT fk_codCan FOREIGN KEY REFERENCES candidato(codCan),
  codCur1 INT CONSTRAINT fk_codCur_1opcao FOREIGN KEY REFERENCES curso(codCur),
  codCur2 INT CONSTRAINT fk_codCur_2opcao FOREIGN KEY REFERENCES curso(codCur),

  CONSTRAINT uq_candidato_ano UNIQUE(codCan, anoInscr),
  CONSTRAINT chk_cursos CHECK(codCur1 <> codCur2)
);

CREATE TABLE pagamento (
  codPag INT CONSTRAINT pk_codPag PRIMARY KEY IDENTITY(1,1),
  vlPago MONEY,
  VlJurosMulta MONEY,
  dtVencto DATETIME CONSTRAINT dft_timestamp DEFAULT GETDATE() + 10,
  dtPagto DATETIME,
  dtRegistro DATETIME,
  codIns INT CONSTRAINT fk_codIns FOREIGN KEY REFERENCES inscricao(codIns)
);


-- 3. Quando uma nova inscrição for realizada, o sistema deverá registrar a inscrição e gerar automaticamente um boleto de pagamento no banco de dados. 
BEGIN TRANSACTION;

  INSERT INTO inscricao(nota, anoInscr, dataInscr, situacao, codCan, codCur1, codCur2)
  VALUES (NULL, 2026, GETDATE(), 'Aguardando pagamento', 1, 1, 2);

  DECLARE @UltimoCodIns INT;
  SET @UltimoCodIns = SCOPE_IDENTITY();

  INSERT INTO pagamento (vlPago, VlJurosMulta, dtPagto, dtRegistro, codIns)
  VALUES (NULL, NULL, NULL, GETDATE(), @UltimoCodIns);

COMMIT TRANSACTION;


-- 4. Após a realização da prova do vestibular, o sistema deverá registrar a nota obtida pelo candidato na inscrição e atualizar a situação do candidato para um dos valores permitidos. 
BEGIN TRANSACTION;
  UPDATE inscricao
  SET nota = 8.5
  WHERE codIns = 1;

  UPDATE candidato
  SET situacao = 'Aprovado'
  WHERE codCan = (SELECT codCan FROM inscricao WHERE codIns = 1);

COMMIT TRANSACTION;



-- 5. Quando um pagamento for registrado, o sistema deverá atualizar os dados do pagamento e alterar a situação da inscrição correspondente para "Pago".
BEGIN TRANSACTION;

  UPDATE pagamento
  SET vlPago = 150.00,
      VlJurosMulta = 0.00,
      dtPagto = GETDATE()
  WHERE codIns = 1; 

  UPDATE inscricao
  SET situacao = 'Pago'
  WHERE codIns = 1;

COMMIT TRANSACTION;
