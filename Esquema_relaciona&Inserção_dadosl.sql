/*Criação do banco de dados para o E-commerce */

create schema if not exists ecommerce;
use ecommerce;

/*Criando tabela Cliente */
create table cliente(
	idCliente int auto_increment primary key,
    Fname varchar(15) not null,
    Minit varchar(3),
    Lname varchar(15),
    CPF char(11) not null unique,
    Address varchar(35),
    Data_nascimento date not null
);

/*Criando tabela pedido */
create table pedido(
	idPedido int auto_increment primary key,
    Status_pedido ENUM('Em andamento', 'Em processando', 'Enviado', 'Entregue') default'Em andamento',
    Pedido_idCliente int,
    Descricao varchar(45),
    Frete float not null,
    constraint fk_pedido_cliente foreign key (Pedido_idCliente) references cliente(idCliente)
);

/*Criando tabela pagamento */
create table pagamento(
	idPagamento int,
    Pagamento_idPedido int,
    Pagamento ENUM('Boleto', 'Catão', 'Pix', 'Dois catões'),
    primary key (idPagamento, Pagamento_idPedido),
    constraint fk_pagamento_pedido foreign key (Pagamento_idPedido) references pedido(idPedido)
);
/*Criando tabela Codigo_pagamento*/
create table codigo_pagamento(
	idCodigoPagamento varchar(35),
    Codigo_idPagamento int,
    primary key (Codigo_idPagamento, idCodigoPagamento),
    constraint fk_codigo_pagamento foreign key (Codigo_idPagamento) references pagamento(idPagamento)
);


/*Criando tabela Produto_Pedido*/
create table Produto_pedido(
	Produto_idProduto int not null,
    Pedido_idPedido int not null,
    Quantidade INT not null,
    status_produto ENUM('Disponivel', 'Sem estoque') default 'Disponivel',
    primary key (Produto_idProduto, Pedido_idPedido),
    constraint fk_produtos_pedido foreign key (Pedido_idPedido) references pedido(idPedido)
);

/*Criando tabela produto */
create table produto(
	idProduto int auto_increment not null primary key,
    Pnome varchar(15) not null,
    Valor float not null,
    Categoria varchar(15) not null,
    Descricao varchar(30)
);

/* Agora com a tabela produto criada, adicionamos uma FK de produto_pedido para produto*/
alter table Produto_pedido add constraint fk_produto_idproduto foreign key (Produto_idProduto) references produto(idProduto);

/*Criando tabela Produto_forncedor */
create table Produto_fornecedor(
	ProdutoFornecedor_idProduto int not null,
    idFornecdor int not null,
    primary key (ProdutoFornecedor_idProduto, idFornecdor),
    constraint fk_PrdoutoFornecdor_idProduto foreign key (ProdutoFornecedor_idProduto) references produto(idProduto)
);


/*Criando tabela fornecdor */
create table Fornecedor(
	idFornecedor int primary key,
    Razão_social varchar(45),
    CNPJ char(15),
    Contato varchar(25)
);

/* Agora com a tabela fornecedor criada, adicionamos uma FK de Produto_fornecedor para Fornecedor*/
alter table Produto_fornecedor add constraint fk_ProdutoFornecedor_Fornecedor foreign key (idFornecdor) references fornecedor(idFornecedor);

/* Criand tabela produto_vendedor_terceiro*/
create table produto_vendedor_terceiro(
	idVendedor int,
    Produto_idProduto int,
    Quantidade int not null,
    primary key (Produto_idProduto, idVendedor),
    constraint fk_terceiro_produto foreign key (Produto_idProduto) references Produto(idProduto)
);

/* Criando tabela vendedor_terceiro*/
create table vendedor_terceiro(
	idTerceiro int primary key,
    Razão_social varchar(35),
    CNPJ char(15),
    Localização varchar(45),
    Nome_vendedor varchar(35),
    CPF CHAR(9)
);
/* Agora com a tabela Vendedor_terceiro criada, adicionamos uma FK de produto_vendedor_terceiro para Vendedor_terceiro*/
alter table produto_vendedor_terceiro add constraint fk_ProdutoTerceiro_VendedorTerceiro foreign key (idVendedor) references vendedor_terceiro(idTerceiro);

/* criando tabela Estoque*/
create table Estoque(
	idEstoque int primary key,
    Estoque_local varchar(45) not null,
    quantidade int not null
);

/* criando tabela Produto_estoque*/
create table Produto_estoque(
	Estoque_idEstoque int,
    Produto_idProduto int,
    localização varchar(45) not null,
    primary key (Estoque_idEstoque, Produto_idProduto),
    constraint fk_Estoque_idEstoque foreign key (Estoque_idEstoque) references Estoque(idEstoque)
);
alter table produto_estoque add constraint fk_ProdutoEstoque_idProduto foreign key (Produto_idProduto) references produto(idProduto);

/*-------------------------------- INSERÇÃO DE DADOS  ------------------------------------------------- */

DESC cliente;
select * from cliente;
insert into Cliente (Fname, Minit, Lname, CPF, Address, Data_nascimento) 
	   values('Maria','M','Silva', 12346789, 'R silva prata 29, Cidade das flores', '1967-05-29'),
		     ('Matheus','O','Pimentel', 987654321,'R alemeda 289, Cidade das flores', '1963-02-19'),
			 ('Ricardo','F','Silva', 45678913,'avenida alemeda vinha 1009, Cidade das flores', '1989-12-21'),
			 ('Julia','S','França', 789123456,'R lareijras 861, Cidade das flores','1997-08-01' ),
			 ('Roberta','G','Assis', 98745631,'AV koller 19, Cidade das flores', '1985-03-09'),
			 ('Isabela','M','Cruz', 654789123,'R alemeda das flores 28, Cidade das flores', '1979-01-12');

select * from produto;
insert into produto (Pnome, valor, categoria, descricao) values
							  ('Fone de ouvido', 15,'Eletrônico',null),
                              ('Barbie Elsa', 150,'Brinquedos',null),
                              ('Body Carters', 1000,'Vestimenta',null),
                              ('Microfone Vedo - Youtuber', 750,'Eletrônico',null),
                              ('Sofá retrátil', 3900,'Móveis','size: 3x57x80'),
                              ('Farinha de arroz', 10,'Alimentos', null),
                              ('Fire Stick Amazon', 150,'Eletrônico',null);

select * from pedido;
desc pedido;
insert into pedido (Pedido_idCliente, Status_pedido, Descricao, frete) values 
							 (13, default,'compra via aplicativo',10),
                             (16,default,'compra via aplicativo',50),
                             (15,'Enviado',null, 15),
                             (17,default,'compra via web site',150);
		

select * from Produto_estoque;
desc Produto_estoque;
insert into Produto_estoque (localização, Estoque_idEstoque, produto_idProduto) values 
							('Rio de Janeiro',1, 1),
                            ('Rio de Janeiro',2, 2),
                            ('São Paulo',3, 3),
                            ('São Paulo', 3, 4);
select * from estoque;
insert into Estoque (idEstoque, Quantidade, estoque_local) values
						 (1,10,'RJ'),
                         (3,20,'RJ'),
                         (2,60,'GO');
show tables;
select * from fornecedor;
desc fornecedor;
insert into fornecedor (idFornecedor, Razão_social, CNPJ, contato) values 
							(1, 'Almeida e filhos', 123456789123456,'21985474'),
                            (2, 'Eletrônicos Silva',854519649143457,'21985484'),
                            (3, 'Eletrônicos Valma', 934567893934695,'21975474');

show tables;
desc Produto_fornecedor;
insert into Produto_fornecedor (idFornecdor, ProdutoFornecedor_idProduto) values
						 (1,1),
                         (1,2),
                         (2,4),
                         (3,3),
                         (2,5);
desc vendedor_terceiro;

insert into vendedor_terceiro (idTerceiro, Nome_vendedor, Razão_social, CNPJ, CPF, Localização) values 
						(1, 'Tech eletronics', null, 123456789456321, 123456789, 'Rio de Janeiro'),
					    (2, 'Botique Durgas',null,123456783, 523706783, 'Rio de Janeiro'),
						(3, 'Kids World',null,456789123654485, 523200678,'São Paulo');
                        
desc Produto_vendedor_terceiro;
insert into Produto_vendedor_terceiro (idVendedor, Produto_idProduto, Quantidade) values 
						 (1,6,80),
                         (2,7,10);
select * from Produto_vendedor_terceiro;
select * from pedido;
select concat(Fname,' ',Lname) as Cliente, idPedido as Requisição, Status_pedido as Status_do_pedido from cliente c, pedido o where c.idCliente = Pedido_idCliente;

select count(*) from cliente c, pedido o 
			where c.idCliente = Pedido_idCliente;
show tables;
desc produto_pedido;
select * from cliente c 
				inner join pedido o ON c.idCliente = o.Pedido_idCliente
                inner join produto_pedido p on p.Produto_idProduto = o.idPedido
		group by idCliente; 
desc cliente;
desc pedido;
Select concat(Fname,' ', Lname) nome, count(*) Quantidade_de_pedido from cliente, pedido where idCliente=Pedido_idCliente
			group by idCliente having count(*) < 3;