-- Active: 1778165136825@@127.0.0.1@3306

CREATE TABLE Alunos(
  RA int,
  nome varchar(80),
  fone varchar(30),
  pai varchar(80),
  mae varchar(80),
  data_nasc date
);
INSERT INTO Alunos
VALUES (123, 'MATEUS', '11990000000', 'Daniel', 'Clara', 2002-05-06),
        (124, 'MARCOS', '169923443243', 'Fernando', 'Luisa'),
        (125, 'LUCAS', '5498237746', 'Luis', '');