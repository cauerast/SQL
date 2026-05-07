-- Active: 1778165136825@@127.0.0.1@3306

-- 1.
CREATE TABLE Alunos(
  RA int,
  nome varchar(80),
  fone varchar(30),
  pai varchar(80),
  mae varchar(80),
  data_nasc date
);
INSERT INTO Alunos
VALUES (862, 'MATEUS', '11990000000', 'Daniel', 'Clara', 2002-05-06),
        (1002, 'MARCOS', '169923443243', 'Fernando', 'Ana', 2008-12-25),
        (103, 'LUCAS', '5498237746', 'Luis', 'Maria', 2006-07-12);



-- 2.
SELECT * FROM Alunos;



-- 3.
ALTER TABLE Alunos ADD COLUMN 'CPF';

UPDATE Alunos SET CPF = '12345'
WHERE RA = 862;
UPDATE Alunos SET CPF = '6789'
WHERE RA = 1002;
UPDATE Alunos SET CPF = '10111213'
WHERE RA = 103;


-- 4.
SELECT CPF, nome FROM Alunos
WHERE mae = 'Ana';

SELECT * FROM Alunos;
