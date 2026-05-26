
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
VALUES (862, 'MATEUS', '11990000000', 'Daniel', 'Clara', '2002-05-06'),
  (1002, 'MARCOS', '169923443243', 'Fernando', 'Ana', '2008-12-25'),
  (103, 'LUCAS', '5498237746', 'Luis', 'Maria', '2006-07-12');


-- 2.
SELECT * FROM Alunos;


-- 3.
ALTER TABLE Alunos ADD CPF varchar(20);
UPDATE Alunos
SET CPF = CASE RA
  WHEN 862 THEN '12345'
  WHEN 1002 THEN '6789'
  WHEN 103 THEN '10111213'
END;


-- 4.
SELECT CPF, nome FROM Alunos
WHERE mae = 'Ana';

-- 5.
DELETE FROM Alunos WHERE RA = 1002;

-- 6.
SELECT * FROM Alunos
ORDER BY nome ASC;