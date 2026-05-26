create database EscolaTeste;

use EscolaTeste;

CREATE TABLE alunos(
    RA int,
    nome varchar(80),
    fone varchar(20), -- char: fixed length; varchar: variable length
    mae varchar(50),
    pai varchar(50),
    data_error datetime -- date w/ hours, minuts and seconds -> yyyy/mm/dd HH:MM:ss
)

-- add a new register at the table in selected columns;
INSERT INTO alunos (RA, mae, pai, nome)
VALUES (102030, 'ANA', 'JOSE', 'claudio');

-- adding a column 
ALTER TABLE alunos
ADD naturalidade varchar(80);

-- turning the name column not null
ALTER TABLE alunos
ALTER COLUMN nome varchar(80) NOT NULL;


drop table alunos;

select * from alunos;