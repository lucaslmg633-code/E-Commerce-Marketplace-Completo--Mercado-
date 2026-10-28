DROP DATABASE IF EXISTS db_ecommerce;

CREATE DATABASE db_ecommerce;
USE db_ecommerce;

CREATE TABLE categoria (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Descricao VARCHAR(255)
);

CREATE TABLE fornecedor (
    ID_Fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Razao_social VARCHAR(150) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    Telefone VARCHAR(15),
    Email VARCHAR(100),
    Endereco VARCHAR(200)
);

CREATE TABLE cliente (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF_CNPJ VARCHAR(14) NOT NULL,
    Telefone VARCHAR(15),
    Email VARCHAR(100),
    Endereco VARCHAR(200)
);

CREATE TABLE funcionario (
    ID_Funcionario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Data_Admissao DATE NOT NULL
);

CREATE TABLE produto (
    ID_Produto INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao VARCHAR(255),
    Preco_Venda DECIMAL(10,2) NOT NULL,
    Estoque INT NOT NULL,
    ID_Categoria INT NOT NULL,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (ID_Categoria) REFERENCES categoria(ID_Categoria)
);

CREATE TABLE venda (
    ID_Venda INT AUTO_INCREMENT PRIMARY KEY,
    Data_Venda DATETIME NOT NULL,
    Valor_Total DECIMAL(12,2) NOT NULL,
    Forma_Pagamento VARCHAR(30) NOT NULL,
    ID_Funcionario INT NOT NULL,
    ID_Cliente INT NOT NULL,
    CONSTRAINT fk_venda_funcionario FOREIGN KEY (ID_Funcionario) REFERENCES funcionario(ID_Funcionario),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (ID_Cliente) REFERENCES cliente(ID_Cliente)
);

CREATE TABLE item_venda (
    ID_Venda INT NOT NULL,
    ID_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Preco_Unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ID_Venda, ID_Produto),
    CONSTRAINT fk_item_venda FOREIGN KEY (ID_Venda) REFERENCES venda(ID_Venda),
    CONSTRAINT fk_item_produto FOREIGN KEY (ID_Produto) REFERENCES produto(ID_Produto)
);

INSERT INTO categoria (Nome, Descricao) VALUES 
('Eletrônicos', 'Smartphones, notebooks e acessórios de informática'),
('Moda', 'Roupas, calçados e acessórios masculinos e femininos'),
('Casa e Cozinha', 'Eletroportáteis, utensílios e decorações');

INSERT INTO fornecedor (Razao_social, CNPJ, Telefone, Email, Endereco) VALUES 
('Tech Distribuidora S/A', '12345678000199', '11988887777', 'contato@techdist.com', 'Av. Paulista, 1000 - São Paulo, SP'),
('Modas Brasil Ltda', '98765432000188', '11977776666', 'vendas@modasbrasil.com', 'Rua Direita, 500 - São Paulo, SP');

INSERT INTO cliente (Nome, CPF_CNPJ, Telefone, Email, Endereco) VALUES 
('Carlos Silva', '11122233344', '11999991111', 'carlos@email.com', 'Rua das Flores, 123 - São Paulo, SP'),
('Ana Souza', '22233344455', '11988882222', 'ana@email.com', 'Av. Brasil, 456 - São Paulo, SP');

INSERT INTO funcionario (Nome, CPF, Cargo, Data_Admissao) VALUES 
('Lucas Mendes', '33344455666', 'Atendente de E-commerce', '2025-01-15'),
('Mariana Lima', '44455667788', 'Gerente de Vendas', '2024-06-10');

INSERT INTO produto (Nome, Descricao, Preco_Venda, Estoque, ID_Categoria) VALUES 
('Smartphone X', '128GB, Tela 6.5 polegadas', 1500.00, 20, 1),
('Fone Bluetooth', 'Sem fio com cancelamento de ruído', 250.00, 50, 1),
('Camiseta Básica', 'Algodão 100%', 59.90, 100, 2);

INSERT INTO venda (Data_Venda, Valor_Total, Forma_Pagamento, ID_Funcionario, ID_Cliente) VALUES 
('2026-10-20 14:30:00', 1750.00, 'Cartão de Crédito', 1, 1),
('2026-10-21 16:00:00', 59.90, 'Pix', 1, 2);

INSERT INTO item_venda (ID_Venda, ID_Produto, Quantidade, Preco_Unitario) VALUES 
(1, 1, 1, 1500.00),
(1, 2, 1, 250.00),
(2, 3, 1, 59.90);

SELECT p.ID_Produto, p.Nome AS Produto, p.Preco_Venda, c.Nome AS Categoria 
FROM produto p 
INNER JOIN categoria c ON p.ID_Categoria = c.ID_Categoria;

SELECT v.ID_Venda, v.Data_Venda, v.Valor_Total, c.Nome AS Cliente, f.Nome AS Funcionario 
FROM venda v
INNER JOIN cliente c ON v.ID_Cliente = c.ID_Cliente
INNER JOIN funcionario f ON v.ID_Funcionario = f.ID_Funcionario;

SELECT Nome, Preco_Venda, Estoque 
FROM produto 
WHERE Preco_Venda BETWEEN 50.00 AND 2000.00 
ORDER BY Preco_Venda DESC;

SELECT ID_Cliente, Nome, Email, Telefone 
FROM cliente 
WHERE Nome LIKE 'C%';

SELECT c.Nome AS Categoria, COUNT(p.ID_Produto) AS Total_Produtos 
FROM categoria c
LEFT JOIN produto p ON c.ID_Categoria = p.ID_Categoria 
GROUP BY c.ID_Categoria, c.Nome;

SELECT SUM(Valor_Total) AS Faturamento_Total, AVG(Valor_Total) AS Media_Vendas 
FROM venda;

SELECT c.Nome AS Categoria, COUNT(p.ID_Produto) AS Qtd 
FROM categoria c
INNER JOIN produto p ON c.ID_Categoria = p.ID_Categoria 
GROUP BY c.ID_Categoria, c.Nome 
HAVING COUNT(p.ID_Produto) > 0;

SELECT iv.ID_Venda, p.Nome AS Produto, iv.Quantidade, iv.Preco_Unitario, (iv.Quantidade * iv.Preco_Unitario) AS Subtotal 
FROM item_venda iv
INNER JOIN produto p ON iv.ID_Produto = p.ID_Produto;

UPDATE produto 
SET Preco_Venda = 1600.00 
WHERE ID_Produto = 1;

DELETE FROM item_venda WHERE ID_Venda = 2 AND ID_Produto = 3;

CREATE OR REPLACE VIEW vw_relatorio_vendas AS
SELECT 
    v.ID_Venda,
    v.Data_Venda,
    c.Nome AS Nome_Cliente,
    f.Nome AS Nome_Funcionario,
    v.Forma_Pagamento,
    v.Valor_Total
FROM venda v
INNER JOIN cliente c ON v.ID_Cliente = c.ID_Cliente
INNER JOIN funcionario f ON v.ID_Funcionario = f.ID_Funcionario;

SELECT * FROM vw_relatorio_vendas;