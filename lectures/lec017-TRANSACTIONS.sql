/*
================================================================================
GUIA COMPLETO: TRANSAÇÕES (TRANSACTIONS) NO MICROSOFT SQL SERVER (T-SQL)
================================================================================

O que é uma Transação?
Uma transação é uma unidade lógica de trabalho. Ela agrupa múltiplos comandos SQL
para garantir que o banco de dados passe de um estado válido para outro. Ou tudo
é executado com sucesso (**COMMIT**), ou o banco volta ao estado original (**ROLLBACK**).

As transações são fundamentais para evitar dados corrompidos ou inconsistentes.

As Propriedades ACID (O Coração das Transações):
- [A]tomicidade : Princípio do "tudo ou nada". Se uma única linha falhar dentro da
                  transação, todas as alterações anteriores dela serão desfeitas.
- [C]onsistência: Garante que todas as regras de integridade (chaves primárias,
                  estrangeiras, checagens) sejam validadas ao salvar os dados.
- [I]solamento  : Uma transação em execução fica invisível para outras consultas 
                  concorrentes até ser finalizada, evitando leituras de dados parciais.
- [D]urabilidade: Uma vez salva (Commit), a alteração é gravada permanentemente no
                  disco e não será perdida mesmo se o servidor cair logo em seguida.


================================================================================
SINTAXE ESPECÍFICA DO SQL SERVER (MSSQL):
================================================================================
- BEGIN TRAN -> Inicia transação explícita
- COMMIT ->	Confirma a transação
- ROLLBACK ->	Desfaz a transação
- SAVE TRAN -> Cria ponto de salvamento
- SET IMPLICIT_TRANSACTIONS ON ->	Ativa transações implícitas
- @@TRANCOUNT -> Conta níveis de transações abertas
- XACT_STATE() ->	Verifica o estado da transação
- BEGIN TRY -> Inicia tratamento de erros
- BEGIN CATCH -> Captura erros
- ERROR_NUMBER() ->	Número do erro
- ERROR_LINE() ->	Linha do erro
- ERROR_MESSAGE() ->	Mensagem do erro
- DECLARE -> Cria variável
- SCOPE_IDENTITY() ->	Recupera o último ID gerado no escopo


================================================================================
PADRÅO MAIS UTILIZADO PARA TRANSACTIONS
================================================================================
BEGIN TRY
  BEGIN TRANSACTION;
    -- 1. Operação principal 
    INSERT INTO Tabela1 (...)
    VALUES (...);

    -- 2. Operação relacionada
    UPDATE Tabela2
    SET campo = valor
    WHERE id = 1;

    -- 3. Confirma se tudo deu certo
  COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- 4. Exibe o erro
    SELECT
        ERROR_NUMBER() AS NumeroErro,
        ERROR_LINE() AS LinhaErro,
        ERROR_MESSAGE() AS MensagemErro;

    -- 5. Desfaz as operações
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
END CATCH;
*/


-- referente ao pdf (10 - TRANSAÇÕES - Exercícios - 1) - EXERCÍCIO – BANCO DE DADOS VESTIBULAR 
  
-- 1. Crie o banco de dados BdVestibular, implementando as tabelas com seus respectivos atributos, chaves primárias e estrangeiras. 
-- 2. Implemente as seguintes regras de negócio utilizando constraints: 
-- a) Os cursos devem possuir carga horária de 2800 ou 3600 horas. 
-- b) Um candidato pode apresentar apenas uma das seguintes situações: Aprovado, Reprovado ou Aprovado em 2ª chamada. 
-- c) Uma inscrição pode apresentar apenas uma das seguintes situações: Aguardando pagamento, Cancelado, Encerrado ou Pago. 
-- d) A data de vencimento do boleto deve ser gerada automaticamente para 10 dias após a data de lançamento. 
-- e) Cada candidato pode realizar apenas uma inscrição por ano. 
-- f) A Primeira e a segunda opção de cursos não pode ser igual. 
-- g) A data de cadastro do candidato é inserida automaticamente com a data do sistema. 

CREATE TABLE candidato (
  codCan int CONSTRAINT pk_codCan PRIMARY KEY IDENTITY(1,1),
  rg VARCHAR(80),
  cpf VARCHAR(80),
  situacao varchar(80) CONSTRAINT chk_candidato CHECK(situacao in ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada')),
  endereco varchar(80),
  nome varchar(80),
  dtCadastro DATE CONSTRAINT dft_dtCadastro DEFAULT GETDATE()
)

CREATE TABLE curso (
  codCur int CONSTRAINT pk_codCur PRIMARY KEY IDENTITY(1,1),
  nome varchar(80),
  cargaHoraria int CONSTRAINT chk_ch CHECK(cargaHoraria in (2800, 3600)),
  nroVagas int
)

CREATE TABLE inscricao (
  codIns int CONSTRAINT pk_codIns PRIMARY KEY IDENTITY(1,1),
  nota int,
  situacao varchar(80) CONSTRAINT chk_situacao_inscricao CHECK(situacao in ('Aguardando Pagamento', 'Cancelado', 'Encerrado', 'Pago')),
  anoInscricao int,
  dataInscricao DATE,
  codCan int CONSTRAINT fk_codCan FOREIGN KEY REFERENCES candidato(codCan),
  codCur1 int CONSTRAINT fk_codCur1 FOREIGN KEY REFERENCES curso(codCur),
  codCur2 int CONSTRAINT fk_codCur2 FOREIGN KEY REFERENCES curso(codCur),

  CONSTRAINT inscricao_rule UNIQUE (codCan, anoInscricao),
  CONSTRAINT cursos_diferentes_rule CHECK(codCur1 <> codCur2)
)

CREATE TABLE pagamento (
  codPag int CONSTRAINT pk_codPag PRIMARY KEY IDENTITY(1,1),
  vlPago money,
  vlJurosMulta money,
  dtVencto DATE CONSTRAINT dft_vencto DEFAULT GETDATE() + 10,
  dtPagto DATE,
  dtRegistro DATE,
  codIns int CONSTRAINT fk_cod_insc FOREIGN KEY REFERENCES inscricao(codIns)
)

-- 3. Quando uma nova inscrição for realizada, o sistema deverá registrar a inscrição e gerar automaticamente um boleto de pagamento no banco de dados. 
BEGIN TRY
  BEGIN TRANSACTION tran3;

    INSERT INTO inscricao 
    values (10, 'Pago', '2026', '2026-04-02', 1, 1, 2)

    DECLARE @id_inscricao int = SCOPE_IDENTITY()

    INSERT INTO pagamento (codIns, vlPago)
    values (@id_inscricao, 200)

  COMMIT TRANSACTION tran3
END TRY
BEGIN CATCH

  SELECT 
    ERROR_NUMBER() as errorNumber,
    ERROR_LINE() as errorLine,
    ERROR_MESSAGE() as errorMessage

  IF XACT_STATE() <> 0
    ROLLBACK TRANSACTION tran3
END CATCH;


-- 4. Após a realização da prova do vestibular, o sistema deverá registrar a nota obtida pelo candidato na inscrição e atualizar a situação do candidato para um dos valores permitidos. 
BEGIN TRY
  BEGIN TRAN tran4

  UPDATE inscricao
  SET nota = 10
  where codCan = 1

  UPDATE candidato
  SET situacao = 'Aprovado'
  WHERE codCan = (
    select i.codCan
    from inscricao as i
    where codIns = 1
  )

  COMMIT TRAN tran4
END TRY
BEGIN CATCH

  SELECT
    ERROR_MESSAGE(),
    ERROR_LINE(),
    ERROR_NUMBER()

  IF XACT_STATE() <> 0
  ROLLBACK TRAN tran4

END CATCH

-- 5. Quando um pagamento for registrado, o sistema deverá atualizar os dados do pagamento e alterar a situação da inscrição correspondente para "Pago".
BEGIN TRY
  BEGIN TRAN tran5;

    UPDATE pagamento
    SET vlPago = 150.00,
      VlJurosMulta = 0.00,
      dtPagto = GETDATE()
    WHERE codIns = 1; 

    UPDATE inscricao
    SET situacao = 'Pago'
    WHERE codIns = 1;
  COMMIT TRAN tran5;
END TRY
BEGIN CATCH

  SELECT
    ERROR_MESSAGE(),
    ERROR_NUMBER(),
    ERROR_LINE()

  IF XACT_STATE() <> 0
    ROLLBACK TRAN tran5

END CATCH;


-- referente ao pdf - 10 - TRANSAÇÕES - Exercícios - 2

-- 1.  Analise o modelo conceitual apresentado, se encontrar erros, corrija-os. 
-- 2.  Complete  com  as  cardinalidades  de  cada  relacionamento  (você  vai  precisar  simular  algumas  regras  de negócio, como por exemplo: um cliente poderá ter somente um endereço ou terá mais de um endereço?). 
-- 3.  A  partir  do modelo  conceitual, aplique  as regras  de  transformações  de modelos  e  crie as  tabelas  (modelo físico). 
-- 4.  Analise e crie corretamente as chaves primárias das tabelas. 
-- 5.  Crie as restrições de integridade: 
--   a.  Nome do cliente é um campo obrigatório. 
--   b.  Data da venda tem valor padrão como sendo a data atual do sistema. 
--   c.  Valor da comissão deve ser sempre maior que zero. 
--   d.  Função do vendedor só pode ser ‘Balcão’, ‘Externo’, ‘Aprendiz’, ‘Supervisor’. 
--   e.  Para os produtos vendidos com unidade ‘PÇ’ o estoque não poderá ser negativo. 
--   f. Quando o salário fixo for maior que R$ 2.000,00 a comissão não poderá ser maior que R$ 1.800,00.
--   g.  A data de vencimento do financeiro não pode ser menor que a data de lançamento. 


CREATE TABLE Cliente (
  cod_cliente INT CONSTRAINT pk_cod_cliente PRIMARY KEY IDENTITY(1, 1),
  nome VARCHAR(80) NOT NULL, 
  fone VARCHAR(80),
  limite_credito MONEY
);

CREATE TABLE Endereco (
  cod_endereco INT CONSTRAINT pk_cod_endereco PRIMARY KEY IDENTITY(1, 1),
  rua VARCHAR(80),
  nro INT,
  bairro VARCHAR(80),
  cep VARCHAR(80),
  cod_cliente INT CONSTRAINT fk_endereco_cliente REFERENCES Cliente(cod_cliente)
);

CREATE TABLE Vendedor (
  cod_vendedor INT CONSTRAINT pk_cod_vendedor PRIMARY KEY IDENTITY(1, 1),
  nome VARCHAR(80) NOT NULL,
  fone VARCHAR(80),
  funcao VARCHAR(80) CONSTRAINT chk_funcao CHECK (funcao IN ('Balcão', 'Externo', 'Aprendiz', 'Supervisor'))
);

CREATE TABLE Venda (
  cod_venda INT CONSTRAINT pk_cod_venda PRIMARY KEY IDENTITY(1, 1),
  vl_frete MONEY,
  dt_venda DATETIME CONSTRAINT dft_dt_venda DEFAULT GETDATE(),
  situacao VARCHAR(80),
  cod_cliente INT CONSTRAINT fk_venda_cliente REFERENCES Cliente(cod_cliente),
  cod_vendedor INT CONSTRAINT fk_venda_vendedor REFERENCES Vendedor(cod_vendedor)
);

CREATE TABLE Financeiro (
  cod_financeiro INT CONSTRAINT pk_cod_financeiro PRIMARY KEY IDENTITY(1, 1),
  dt_lancto DATETIME NOT NULL,
  valor MONEY,
  dt_vencto DATETIME NOT NULL,
  dt_liq DATETIME,
  cod_venda INT CONSTRAINT fk_financeiro_venda REFERENCES Venda(cod_venda),
  CONSTRAINT chk_date_startend CHECK (dt_vencto >= dt_lancto)
);

CREATE TABLE Produto (
  cod_produto INT CONSTRAINT pk_cod_produto PRIMARY KEY IDENTITY(1, 1),
  nome VARCHAR(80) NOT NULL,
  unidade VARCHAR(10),
  estoque INT,
  CONSTRAINT chk_estoque CHECK (unidade <> 'PÇ' OR estoque >= 0) 
);

CREATE TABLE VendaProduto (
  cod_venda_produto INT CONSTRAINT pk_venda_produto PRIMARY KEY IDENTITY(1,1),
  qtde INT NOT NULL CONSTRAINT chk_qtde CHECK (qtde > 0),
  vl_unit MONEY NOT NULL CONSTRAINT chk_vl_unit CHECK (vl_unit > 0),
  cod_venda INT CONSTRAINT fk_vp_venda REFERENCES Venda(cod_venda),
  cod_produto INT CONSTRAINT fk_vp_produto REFERENCES Produto(cod_produto)
);

CREATE TABLE Salario (
  cod_salario INT CONSTRAINT pk_cod_salario PRIMARY KEY IDENTITY(1, 1),
  cod_vendedor INT CONSTRAINT fk_salario_vendedor REFERENCES Vendedor(cod_vendedor),
  dt_salario DATETIME NOT NULL,
  vl_fixo MONEY NOT NULL,
  vl_comissao MONEY NOT NULL,
  CONSTRAINT chk_vlcomissao CHECK (vl_fixo <= 2000.00 OR vl_comissao <= 1800.00)
);

CREATE TABLE Comissao (
  cod_comissao INT CONSTRAINT pk_cod_comissao PRIMARY KEY IDENTITY(1, 1),
  cod_venda INT CONSTRAINT fk_comissao_venda REFERENCES Venda(cod_venda),
  cod_vendedor INT CONSTRAINT fk_comissao_vendedor REFERENCES Vendedor(cod_vendedor),
  valor MONEY CONSTRAINT chk_valor_comissao CHECK (valor > 0)
);


-- 6.  Crie comandos para simular transações explícitas nas tabelas para os casos: 
--   a.  Os registros de financeiro só poderão ser inseridos no momento em que um registro de venda for atualizado para ‘REGISTRADO’ (um campo venda.situacao for atualizado para ‘REGISTRADO’, por exemplo). 
BEGIN TRY
  BEGIN TRAN tranA;

  UPDATE Venda
  SET situacao = 'REGISTRADO'
  WHERE cod_venda = 1

  INSERT INTO Financeiro 
  VALUES (1, '2021-05-21', 100, '2022-03-01', '2022-09-13', 1)

  COMMIT TRAN tranA
END TRY
BEGIN CATCH

  SELECT 
    ERROR_LINE(),
    ERROR_MESSAGE(),
    ERROR_NUMBER()

  IF XACT_STATE() <> 0
    ROLLBACK TRAN tranA

END CATCH;



--   b.  Após a inserção de cada item da venda, os estoques dos produtos deverão ser atualizados. 
BEGIN TRY
  BEGIN TRANSACTION tran_b;

    INSERT INTO VendaProduto (qtde, vl_unit, cod_venda, cod_produto)
    VALUES (5, 25.50, 1, 3)

    UPDATE Produto
    SET estoque = estoque - 5
    WHERE cod_produto = 3

  COMMIT TRANSACTION tran_b;
END TRY
BEGIN CATCH

  SELECT
    ERROR_NUMBER() as NumeroErro, 
    ERROR_LINE() as LinhaErro, 
    ERROR_MESSAGE() as MensagemErro

  IF XACT_STATE() <> 0
    ROLLBACK TRANSACTION tran_b;

END CATCH

--   c.  Quando uma venda for inserida, sua comissão pode ser inserida. 
BEGIN TRY
  BEGIN TRAN tran_c

  INSERT INTO Venda (vl_frete, dt_venda, situacao, cod_cliente, cod_vendedor)
  VALUES (45.00, GETDATE(), 'EM_ABERTO', 1, 2)

  DECLARE @cod_venda int = SCOPE_IDENTITY()

  INSERT INTO Comissao (cod_venda, cod_vendedor, valor)
  values (@cod_venda, 1, 20)

  COMMIT TRAN tran_c
END TRY
BEGIN CATCH

  SELECT
    ERROR_NUMBER() as NumeroErro, 
    ERROR_LINE() as LinhaErro, 
    ERROR_MESSAGE() as MensagemErro

  IF XACT_STATE() <> 0
    ROLLBACK TRAN tran_c
END CATCH
