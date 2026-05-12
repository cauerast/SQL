-- Active: 1778113673688@@127.0.0.1@3306
CREATE TABLE Alunos(
  RA int,
  nome varchar(80),
  fone varchar(30),
  pai varchar(80),
  mae varchar(80),
  data_nasc date
);
  
-- Insert command
INSERT INTO Alunos
VALUES (102030, 'ANA', '16999450078', 'JOSE', 'MARIA', '2002-10-18'),
       (268975, 'PEDRO', '1699678595', 'PAULO', 'RAFAELA', '2000-09-28'),
       (596835, 'IVAN', '16999450256', 'AUGUSTO', 'PATRICIA', '2019-04-20');

-- Select command (show)
SELECT * FROM Alunos;

-- Alter table -> ADD - add a collumn:
ALTER TABLE Alunos
ADD email varchar(50);

-- Command to delete a column
ALTER TABLE Alunos
DROP COLUMN pai;
  
-- Command to update a column; 
-- Warning - This command had to implements a filter, in this case WHERE.
UPDATE Alunos SET email = 'contato@Alunos.com.br'
WHERE RA = 102030;
  
-- WHERE command can be used to filter a set of data
SELECT * from Alunos
WHERE RA > 150000;

SELECT * from Alunos
WHERE mae <> 'ANA';
  
-- Command to delete a row
DELETE FROM Alunos WHERE mae = 'PATRICIA';
 
-- Order result by data_nasc in DECRESCENT way
ORDER BY data_nasc DESC;


SELECT * from Alunos;


drop table Alunos;