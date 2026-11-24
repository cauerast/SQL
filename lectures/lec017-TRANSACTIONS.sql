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