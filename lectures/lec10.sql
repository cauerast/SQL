-- constraint em nivel de coluna
create table Professores (
  codprof int CONSTRAINT pk_codProg PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(80) NOT NULL,
  RG NUMERIC(12) UNIQUE,
  sexo char(1) check(sexo in ('M', 'F')),
  idade int check(idade BETWEEN 21 and 80),
  cidade VARCHAR(50) CONSTRAINT df_prof_cidade DEFAULT('FRANCA'),
  titulacao varchar(15) CONSTRAINT chk_tit check(titulacao in ('graduado', 'especialista', 'mestre', 'doutor')),
  categoria varchar(15) check(categoria in ('auxiliar', 'assistente', 'adjunto', 'titular')),
  salario money check(salario >= 500)
)

select * from Professores;
insert into Professores (RG, sexo, idade, titulacao, categoria, salario, nome) 
values (12345, 'M', 30, 'graduado', 'auxiliar', 2500, 'JOAO');

select * from Professores;


-- contraint em nivel de tabela
alter table Professores 
add
  CONSTRAINT ch_titulacao_salacio_check CHECK
  (
    (titulacao = 'graduado' and salario < 1000)
    OR
    (titulacao <> 'graduado')
  )