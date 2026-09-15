-- VIEW
-- A View is a virtual table in SQL Server whose contents are defined by a query. It does not store physical data or consume storage memory (unlike a standard table). Instead, it dynamically runs the underlying query code every time you look at it. 
-- Couldn't use ORDER BY in views

--> to see all views
select * from sys.objects 
where type_desc = 'view';

--> to create a view 
CREATE VIEW vFunc as
SELECT idFun as cod, nome as NomeEMpregado, cpf, dtNasc as Nascimento
from funcionario

--> to select a view
SELECT * FROM vFunc

--> to drop view
DROP VIEW vFunc