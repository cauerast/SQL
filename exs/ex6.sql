create database ex6;
use ex6;

create table Categorias (
    codCat int PRIMARY KEY IDENTITY(1,1),
    nomeCat varchar(80),
);

create table Fornecedores (
    codFornecedor int PRIMARY KEY IDENTITY(1,1),
    razaoSocial varchar(80),
    CNPJ varchar(80),
    fone varchar(80),
)

create table Marcas (
    codMarca int PRIMARY KEY IDENTITY(1,1),
    nomeMarca varchar(80),
)

create table Produto (
    codPro int PRIMARY KEY IDENTITY(1,1),
    descricao varchar(80),
    codBarras varchar(80),
    estoque int,
    codCat int FOREIGN KEY REFERENCES Categorias(codCat),
    codFornecedor int FOREIGN KEY REFERENCES Fornecedores(codFornecedor),
    codMarca int FOREIGN KEY REFERENCES Marcas(codMarca),
)

