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
--   a.  Os registros de financeiro só poderão ser inseridos registro de venda for atualizado para ‘REGISTRADO’ (um campo venda.situacao for atualizado para ‘REGISTRADO’, por exemplo). 
BEGIN TRANSACTION tran6
  BEGIN TRY

    UPDATE Venda
    SET situacao = 'REGISTRADO'
    WHERE cod_venda = 1

    INSERT INTO Financeiro 
    VALUES (1, '2021-05-21', 100, '2022-03-01', '2022-09-13', 1)
    COMMIT TRANSACTION tran6;

  END TRY
  BEGIN CATCH

    SELECT ERROR_NUMBER() as NumeroErro, ERROR_LINE() as LinhaComErro, ERROR_MESSAGE() as MensagemErro
    ROLLBACK TRANSACTION tran6;

  END CATCH;

--   b.  Após a inserção de cada item da venda, os estoques dos produtos deverão ser atualizados. 
BEGIN TRANSACTION
  BEGIN TRY
    INSERT INTO VendaProduto (qtde, vl_unit, cod_venda, cod_produto)
    VALUES (5, 25.50, 1, 3)

    UPDATE Produto
    SET estoque = estoque - 5
    WHERE cod_produto = 3

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH

    SELECT ERROR_NUMBER() as NumeroErro, ERROR_LINE() as LinhaComErro, ERROR_MESSAGE() as MensagemErro
    ROLLBACK TRANSACTION

  END CATCH;

--   c.  Quando uma venda for inserida, sua comissão pode ser inserida. 
BEGIN TRANSACTION
  BEGIN TRY
    INSERT INTO Venda (vl_frete, dt_venda, situacao, cod_cliente, cod_vendedor)
    VALUES (45.00, GETDATE(), 'EM_ABERTO', 1, 2)

    DECLARE @NovoCodVenda INT = SCOPE_IDENTITY()

    INSERT INTO Comissao (cod_venda, cod_vendedor, valor)
    VALUES (@NovoCodVenda, 2, 120.00)

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH

    SELECT ERROR_NUMBER() as NumeroErro, ERROR_LINE() as LinhaComErro, ERROR_MESSAGE() as MensagemErro
    ROLLBACK TRANSACTION;
  END CATCH;
