-- CONNECTION: name=techfix.sqlite
-- Ativa as chaves estrangeiras do SQLite
PRAGMA foreign_keys = 1;
-- Verifica se as chaves estrangeiras estão ativas
PRAGMA foreign_keys;
-- ==========================================
-- 1. ESTRUTURA DAS TABELAS (DDL)
-- ==========================================
CREATE TABLE cargo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cargo TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1
) STRICT;

CREATE TABLE funcionario (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_funcionario TEXT NOT NULL COLLATE NOCASE,
	id_cargo INTEGER NOT NULL,
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY(id_cargo) REFERENCES cargo(id) ON
UPDATE
	CASCADE ON
	DELETE
		CASCADE,
		UNIQUE(id, id_cargo)
) STRICT;

CREATE TABLE categoria (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_categoria TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE cliente (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cliente TEXT NOT NULL COLLATE NOCASE,
	email TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (
		id_funcionario_cargo = 1
	OR id_funcionario_cargo = 2
	),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE marca (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_marca TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (
		id_funcionario_cargo = 1
	OR id_funcionario_cargo = 2
	),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE modelo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_modelo TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (
		id_funcionario_cargo = 1
	OR id_funcionario_cargo = 2
	),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE tipo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_tipo TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (
		id_funcionario_cargo = 1
	OR id_funcionario_cargo = 2
	),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE equipamento(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_marca INTEGER NOT NULL,
	id_modelo INTEGER NOT NULL,
	id_tipo INTEGER NOT NULL,
	id_cliente INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (
		id_funcionario_cargo = 1
		OR id_funcionario_cargo = 2
	),
	numero_serie TEXT DEFAULT(NULL) COLLATE NOCASE,
	imei TEXT DEFAULT(NULL) COLLATE NOCASE UNIQUE,
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_marca) REFERENCES marca(id),
	FOREIGN KEY (id_modelo) REFERENCES modelo(id),
	FOREIGN KEY (id_tipo) REFERENCES tipo(id),
	FOREIGN KEY (id_cliente) REFERENCES cliente(id),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE peca (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_peca TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_categoria INTEGER NOT NULL,
	preco_venda INTEGER NOT NULL,
	estoque_atual INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
	FOREIGN KEY (id_categoria) REFERENCES categoria(id)
) STRICT;

CREATE TABLE situacao (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_situacao TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1
) STRICT;

CREATE TABLE entrada_peca(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_peca INTEGER NOT NULL,
	preco_compra INTEGER NOT NULL,
	quantidade INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_peca) REFERENCES peca(id),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE saida_peca(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_peca INTEGER NOT NULL,
	preco_venda INTEGER NOT NULL,
	quantidade INTEGER NOT NULL,
	id_situacao INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_peca) REFERENCES peca(id),
	FOREIGN KEY (id_situacao) REFERENCES situacao(id),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE forma_pagamento(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_forma_pagamento TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE servico (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_servico TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_categoria INTEGER NOT NULL,
	preco INTEGER NOT NULL,
	horas_trabalho REAL NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
	FOREIGN KEY (id_categoria) REFERENCES categoria(id)
) STRICT;

CREATE TABLE ordem(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_equipamento INTEGER NOT NULL,
	defeito_relatado TEXT NOT NULL COLLATE NOCASE,
	defeito_constatado TEXT DEFAULT('') COLLATE NOCASE,
	data_abertura TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	data_fechamento TEXT,
	valor_total INTEGER,
	id_forma_pagamento INTEGER NOT NULL,
	id_funcionario_abertura INTEGER NOT NULL,
	id_funcionario_cargo_abertura INTEGER NOT NULL CHECK (
		id_funcionario_cargo_abertura = 1
		OR id_funcionario_cargo_abertura = 2
	),
	id_tecnico INTEGER NOT NULL,
	id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
	FOREIGN KEY (id_equipamento) REFERENCES equipamento(id),
	FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id),
	FOREIGN KEY (
		id_funcionario_abertura,
		id_funcionario_cargo_abertura
	) REFERENCES funcionario(id, id_cargo),
	FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE ordem_situacao(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_ordem INTEGER NOT NULL,
	id_nova_situacao INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	data_situacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_ordem) REFERENCES ordem(id),
	FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
	FOREIGN KEY (id_nova_situacao) REFERENCES situacao(id)
) STRICT;

CREATE TABLE ordem_peca(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_ordem INTEGER NOT NULL,
	id_peca INTEGER NOT NULL,
	preco INTEGER NOT NULL,
	quantidade INTEGER NOT NULL,
	data_saida TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_ordem) REFERENCES ordem(id),
	FOREIGN KEY (id_peca) REFERENCES peca(id)
) STRICT;

CREATE TABLE ordem_servico(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_ordem INTEGER NOT NULL,
	id_servico INTEGER NOT NULL,
	preco_praticado INTEGER NOT NULL,
	quantidade INTEGER NOT NULL,
	data_execucao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_ordem) REFERENCES ordem(id),
	FOREIGN KEY (id_servico) REFERENCES servico(id)
) STRICT;
-- ==========================================
-- 2. POPULAÇÃO DE DADOS (DML)
-- ==========================================
-- 2.1. Cargos e Funcionários (Necessários para chave estrangeira das demais tabelas)
INSERT
	INTO
	cargo (nome_cargo)
VALUES
	('Gerente'),
('Atendente'),
('Técnico');
-- Inserindo 1 Gerente (id_cargo = 1)
INSERT
	INTO
	funcionario (nome_funcionario,
	id_cargo)
VALUES
	('Carlos Eduardo Silva',
1);
-- Inserindo 3 Atendentes (id_cargo = 2)
INSERT
	INTO
	funcionario (nome_funcionario,
	id_cargo)
VALUES
	('Ana Beatriz Rocha',
2),
('Lucas Fernando Santos',
2),
('Mariana Costa Lima',
2);
-- Inserindo 2 Técnicos (id_cargo = 3)
INSERT
	INTO
	funcionario (nome_funcionario,
	id_cargo)
VALUES
	('Gabriel Alves Pereira',
3),
('Juliana Rodrigues Mendes',
3);
-- 2.2. Categorias
INSERT
	INTO
	categoria (
		nome_categoria,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	(
		'acessórios',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'áudio',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'baterias',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'carcaças',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'celulares',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'componentes',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'computadores',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'eletrônica avançada',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'informática',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'insumos',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'recuperação de dados',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'redes',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'smart tvs',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'telas',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'tvs',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	),
(
		'videogames',
		1,
(
SELECT
				id_cargo
FROM
				funcionario
WHERE
				id = 1
		)
	);
-- 2.3. Serviços
INSERT
	INTO
	servico (
		nome_servico,
		id_categoria,
		preco,
		horas_trabalho,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	(
		'Formatação e Instalação de Sistema Operacional',
		1,
		12000,
		2.0,
		1,
		1
	),
(
		'Limpeza Interna e Troca de Pasta Térmica',
		1,
		15000,
		1.5,
		1,
		1
	),
(
		'Upgrade de Hardware (RAM/SSD)',
		1,
		8000,
		1.0,
		1,
		1
	),
(
		'Remoção de Vírus e Malwares',
		1,
		10000,
		1.5,
		1,
		1
	),
('Troca de Tela de Notebook',
1,
18000,
1.5,
1,
1),
(
		'Troca de Display/Frontal de Celular',
		2,
		15000,
		1.0,
		1,
		1
	),
(
		'Troca de Bateria de Smartphone',
		2,
		9000,
		0.5,
		1,
		1
	),
(
		'Desoxidação após Contato com Líquido',
		2,
		20000,
		3.0,
		1,
		1
	),
(
		'Reparo em Conector de Carga (Micro USB / Type-C)',
		2,
		11000,
		1.5,
		1,
		1
	),
(
		'Troca de Barra de LED de Smart TV',
		13,
		35000,
		3.0,
		1,
		1
	),
(
		'Reparo na Placa Principal de Smart TV',
		13,
		28000,
		2.5,
		1,
		1
	),
(
		'Conserto de Fonte de Alimentação Interna (TV)',
		13,
		22000,
		2.0,
		1,
		1
	),
(
		'Configuração de Rede e Roteador Wi-Fi',
		12,
		9000,
		1.0,
		1,
		1
	),
(
		'Higienização e Troca de Metal Líquido / Pasta Térmica (Console)',
		16,
		22000,
		2.0,
		1,
		1
	),
(
		'Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)',
		16,
		8000,
		1.0,
		1,
		1
	),
(
		'Substituição de HDMI / Conector de Vídeo (Console)',
		16,
		25000,
		2.5,
		1,
		1
	),
(
		'Troca de Bateria de Caixa de Som Portátil (Bluetooth)',
		4,
		12000,
		1.5,
		1,
		1
	),
(
		'Troca de Almofadas / Reparo de Cabo de Headset Gamer',
		4,
		7000,
		1.0,
		1,
		1
	),
(
		'Recuperação de Dados de HD / SSD / Pendrive Danificado',
		11,
		30000,
		4.0,
		1,
		1
	),
(
		'Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo',
		8,
		45000,
		5.0,
		1,
		1
	),
(
		'Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)',
		8,
		16000,
		2.0,
		1,
		1
	),
(
		'Troca de Vidro Traseiro de Smartphone a Laser / Manual',
		2,
		18000,
		2.5,
		1,
		1
	),
(
		'Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador',
		4,
		9500,
		1.0,
		1,
		1
	);
-- 2.4. Peças
INSERT
	INTO
	peca (
		nome_peca,
		id_categoria,
		preco_venda,
		estoque_atual,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
-- Informática / Computadores
	('SSD NVMe 512GB M.2',
9,
26000,
15,
1,
1),
('SSD SATA III 480GB 2.5"',
9,
21000,
20,
1,
1),
(
		'Memória RAM DDR4 8GB 2666MHz (Notebook)',
		9,
		17000,
		12,
		1,
		1
	),
(
		'Memória RAM DDR4 16GB 3200MHz (Desktop)',
		9,
		32000,
		8,
		1,
		1
	),
(
		'Pasta Térmica de Alta Performance (Bisnaga 4g)',
		10,
		6000,
		25,
		1,
		1
	),
(
		'Fonte ATX 500W 80 Plus Bronze',
		9,
		34000,
		6,
		1,
		1
	),
(
		'Bateria Célula Moeda CR2032 (Cartela c/ 5)',
		10,
		2500,
		30,
		1,
		1
	),
(
		'Cooler para Processador Socket Universal',
		9,
		9500,
		10,
		1,
		1
	),
('Cabo SATA III 6Gbps 50cm',
3,
1500,
50,
1,
1),
(
		'Tela LED 15.6" Slim 30 Pinos Full HD',
		14,
		48000,
		5,
		1,
		1
	),
-- Smartphones / Celulares
	(
		'Display Frontal Completo iPhone 11',
		14,
		35000,
		4,
		1,
		1
	),
(
		'Display Frontal Completo Samsung Galaxy A54',
		14,
		31000,
		6,
		1,
		1
	),
(
		'Display Frontal Completo Motorola Moto G84',
		14,
		28000,
		5,
		1,
		1
	),
(
		'Bateria Compatível iPhone 11 (3110mAh)',
		5,
		16000,
		8,
		1,
		1
	),
(
		'Bateria Compatível Samsung Galaxy A32',
		5,
		13000,
		7,
		1,
		1
	),
('Bateria Compatível Moto G30',
5,
12000,
6,
1,
1),
(
		'Conector de Carga Type-C Universal (Unidade)',
		7,
		2000,
		100,
		1,
		1
	),
(
		'Conector de Carga Micro USB V8',
		7,
		1500,
		100,
		1,
		1
	),
(
		'Flex de Carga e Microfone Moto G9 Play',
		7,
		5500,
		10,
		1,
		1
	),
(
		'Tampa Traseira de Vidro iPhone 12',
		6,
		11000,
		4,
		1,
		1
	),
(
		'Câmera Traseira Principal Redmi Note 11',
		7,
		14000,
		3,
		1,
		1
	),
(
		'Alto-Falante Auricular Universal',
		7,
		2500,
		40,
		1,
		1
	),
-- Smart TVs
	(
		'Barra de LED TV Samsung 50" (Kit com 3 barras)',
		15,
		23000,
		4,
		1,
		1
	),
(
		'Barra de LED TV LG 43" (Kit com 3 barras)',
		15,
		19500,
		5,
		1,
		1
	),
(
		'Placa Fonte TV Samsung UN50TU8000',
		15,
		31000,
		2,
		1,
		1
	),
(
		'Placa Principal TV LG 43UP7500',
		15,
		42000,
		2,
		1,
		1
	),
(
		'Cabo Flat T-Con para Display TV 55"',
		15,
		6500,
		8,
		1,
		1
	),
(
		'Receptor Infravermelho para Controle Remoto TV',
		7,
		2000,
		15,
		1,
		1
	),
-- Insumos e Componentes Genéricos
	(
		'Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)',
		10,
		15000,
		3,
		1,
		1
	),
(
		'Álcool Isopropílico 99.8% 1 Litro',
		10,
		4500,
		12,
		1,
		1
	),
(
		'Fita Kapton Térmica 10mm x 33m',
		10,
		3000,
		15,
		1,
		1
	),
(
		'Fita Dupla Face Fixação de Telas (3mm x 50m)',
		10,
		3500,
		10,
		1,
		1
	),
(
		'Fusível de Louça 5A 250V (Pacote c/ 10)',
		7,
		1800,
		20,
		1,
		1
	),
(
		'Capacitor Eletrolítico 1000uF x 25V',
		7,
		500,
		150,
		1,
		1
	);
-- ============================================
-- ==========================================
-- 2. POPULAÇÃO DE DADOS (DML)
-- ==========================================
-- 2.1. Situações da Ordem de Serviço e Saída de Peças
-- (RF07: Aberto, Em Diagnóstico, Orçamento Aprovado, Em Reparo, Pronto, Entregue, Cancelado)
INSERT
	INTO
	situacao (nome_situacao)
VALUES
	('Aberto'),
('Em Diagnóstico'),
('Orçamento Aprovado'),
('Em Reparo'),
('Pronto'),
('Entregue'),
('Cancelado'),
('Descarte por Defeito/Avaria');
-- 2.2. Formas de Pagamento (Cadastradas por Gerente - Cargo ID 1)
INSERT
	INTO
	forma_pagamento (
		nome_forma_pagamento,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	('Dinheiro',
1,
1),
('PIX',
1,
1),
('Cartão de Débito',
1,
1),
('Cartão de Crédito - À Vista',
1,
1),
('Cartão de Crédito - Parcelado',
1,
1),
('Boleto Bancário',
1,
1);
-- 2.3. Clientes (RF02: Cadastrados por Atendentes [Cargo 2] ou Gerente [Cargo 1])
INSERT
	INTO
	cliente (
		nome_cliente,
		email,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	(
		'Marcos Vinicius Souza',
		'marcos.souza@email.com',
		2,
		2
	),
(
		'Fernanda Maria Oliveira',
		'fernanda.oliveira@email.com',
		2,
		2
	),
(
		'Roberto Carlos Andrade',
		'roberto.andrade@email.com',
		3,
		2
	),
(
		'Camila de Cassia Martins',
		'camila.martins@email.com',
		3,
		2
	),
(
		'Patricia Ferreira Lima',
		'patricia.lima@email.com',
		4,
		2
	),
(
		'Lucas Gabriel Barbosa',
		'lucas.barbosa@email.com',
		1,
		1
	);
-- 2.4. Marcas (Cadastradas por Atendentes ou Gerente)
INSERT
	INTO
	marca (nome_marca,
	id_funcionario,
	id_funcionario_cargo)
VALUES
	('Apple',
1,
1),
('Samsung',
1,
1),
('Motorola',
2,
2),
('Xiaomi',
2,
2),
('Dell',
3,
2),
('Lenovo',
3,
2),
('LG',
1,
1),
('Sony',
4,
2);
-- 2.5. Modelos (Cadastrados por Atendentes ou Gerente)
INSERT
	INTO
	modelo (
		nome_modelo,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	('iPhone 11',
2,
2),
('iPhone 12',
2,
2),
('Galaxy A54',
2,
2),
('Galaxy A32',
3,
2),
('Moto G84',
3,
2),
('Moto G30',
3,
2),
('Redmi Note 11',
4,
2),
('Inspiron 15 3000',
1,
1),
('IdeaPad 3',
2,
2),
('Smart TV 50 UN50TU8000',
3,
2),
('Smart TV 43 43UP7500',
4,
2),
('PlayStation 5',
1,
1);
-- 2.6. Tipos de Equipamento (Cadastrados por Atendentes ou Gerente)
INSERT
	INTO
	tipo (nome_tipo,
	id_funcionario,
	id_funcionario_cargo)
VALUES
	('Smartphone',
1,
1),
('Notebook',
1,
1),
('Desktop',
2,
2),
('Smart TV',
2,
2),
('Console de Videogame',
3,
2),
('Caixa de Som Bluetooth',
4,
2);
-- 2.7. Equipamentos (RF03: Cadastrados por Atendentes ou Gerentes)
INSERT
	INTO
	equipamento (
		id_marca,
		id_modelo,
		id_tipo,
		id_cliente,
		id_funcionario,
		id_funcionario_cargo,
		numero_serie,
		imei
	)
VALUES
	(1,
1,
1,
1,
2,
2,
NULL,
'356789012345671'),
(2,
3,
1,
2,
2,
2,
NULL,
'356789012345672'),
(5,
8,
2,
3,
3,
2,
'DELL-INSP-2023-998',
NULL),
(7,
10,
4,
4,
3,
2,
'LG-TV43-77612',
NULL),
(8,
12,
5,
5,
4,
2,
'PS5-SONY-009182',
NULL),
(3,
5,
1,
6,
1,
1,
NULL,
'356789012345673');
-- 2.8. Entradas de Peças (RF09: Compra/Reposição realizada por Gerente [Cargo ID 1])
-- Preços gravados em centavos (ex: R$ 180,00 -> 18000)
INSERT
	INTO
	entrada_peca (
		id_peca,
		preco_compra,
		quantidade,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	(1,
18000,
20,
1,
1),
-- SSD NVMe
	(3,
11000,
15,
1,
1),
-- RAM DDR4
	(11,
22000,
10,
1,
1),
-- Tela iPhone 11
	(14,
9000,
12,
1,
1),
-- Bateria iPhone 11
	(23,
14000,
8,
1,
1);
-- Barra LED TV Samsung
-- 2.9. Ordens de Serviço (RF04 & RF06)
-- Abertura realizada por Atendente/Gerente (id_funcionario_cargo_abertura IN (1, 2))
-- Técnico responsável designado deve ser id_cargo = 3 (Técnicos: IDs 5 ou 6)
INSERT
	INTO
	ordem (
		id_equipamento,
		defeito_relatado,
		defeito_constatado,
		data_abertura,
		data_fechamento,
		valor_total,
		id_forma_pagamento,
		id_funcionario_abertura,
		id_funcionario_cargo_abertura,
		id_tecnico,
		id_tecnico_cargo
	)
VALUES
-- OS 1: Troca de tela do iPhone 11 (Entregue)
	(
		1,
		'Tela quebrada após queda.',
		'Display frontal danificado, toque não responde.',
		'2026-09-01 09:30:00',
		'2026-09-02 16:00:00',
		50000,
		2,
		2,
		2,
		5,
		3
	),
-- OS 2: Upgrade de SSD em Notebook Dell (Pronto)
	(
		3,
		'Notebook muito lento para ligar.',
		'Lentidão provocada por HD mecânico antigo.',
		'2026-09-10 10:15:00',
		'2026-09-11 14:30:00',
		38000,
		1,
		3,
		2,
		6,
		3
	),
-- OS 3: Smart TV em diagnóstico
	(
		4,
		'TV com som, mas imagem não aparece.',
		'Barra de LED queimada.',
		'2026-09-15 11:00:00',
		NULL,
		NULL,
		1,
		2,
		2,
		5,
		3
	),
-- OS 4: Console PS5 (Em Reparo)
	(
		5,
		'Desligando por aquecimento.',
		'Acúmulo severo de poeira e necessidade de troca de pasta térmica.',
		'2026-09-20 14:20:00',
		NULL,
		NULL,
		4,
		4,
		2,
		6,
		3
	);
-- 2.10. Histórico de Mudanças de Status da OS (RF07)
INSERT
	INTO
	ordem_situacao (id_ordem,
	id_nova_situacao,
	data_situacao)
VALUES
-- OS 1 (Aberto -> Em Diagnóstico -> Orçamento Aprovado -> Em Reparo -> Pronto -> Entregue)
	(1,
1,
'2026-09-01 09:30:00'),
(1,
2,
'2026-09-01 10:00:00'),
(1,
3,
'2026-09-01 11:30:00'),
(1,
4,
'2026-09-01 14:00:00'),
(1,
5,
'2026-09-02 15:30:00'),
(1,
6,
'2026-09-02 16:00:00'),
-- OS 2 (Aberto -> Orçamento Aprovado -> Em Reparo -> Pronto)
	(2,
1,
'2026-09-10 10:15:00'),
(2,
3,
'2026-09-10 10:45:00'),
(2,
4,
'2026-09-10 11:00:00'),
(2,
5,
'2026-09-11 14:30:00'),
-- OS 3 (Aberto -> Em Diagnóstico)
	(3,
1,
'2026-09-15 11:00:00'),
(3,
2,
'2026-09-15 15:00:00'),
-- OS 4 (Aberto -> Orçamento Aprovado -> Em Reparo)
	(4,
1,
'2026-09-20 14:20:00'),
(4,
3,
'2026-09-20 15:00:00'),
(4,
4,
'2026-09-20 16:00:00');
-- 2.11. Peças Utilizadas nas Ordens de Serviço (RF11 / RN01 / RN02)
-- Valores de venda congelados na data do vínculo
INSERT
	INTO
	ordem_peca (id_ordem,
	id_peca,
	preco,
	quantidade,
	data_saida)
VALUES
	(1,
11,
35000,
1,
'2026-09-01 14:30:00'),
-- Tela iPhone 11 para OS 1
	(2,
1,
26000,
1,
'2026-09-10 11:30:00');
-- SSD NVMe 512GB para OS 2
-- 2.12. Serviços Executados nas Ordens de Serviço (RF06 / RN02)
-- Valores dos serviços congelados na data da execução
INSERT
	INTO
	ordem_servico (
		id_ordem,
		id_servico,
		preco,
		quantidade,
		data_execucao
	)
VALUES
	(1,
6,
15000,
1,
'2026-09-01 15:00:00'),
-- Troca de Display Frontal
	(2,
1,
12000,
1,
'2026-09-10 13:00:00'),
-- Formatação e Instalação
	(3,
10,
35000,
1,
'2026-09-15 16:00:00'),
-- Troca Barra de LED TV
	(4,
14,
22000,
1,
'2026-09-20 16:30:00');
-- Higienização PS5
-- 2.13. Baixa/Saída de Peças (RF10)
-- Motivos: Uso em Reparo (Situação ID 4 - Em Reparo) ou Descarte (Situação ID 8)
INSERT
	INTO
	saida_peca (
		id_peca,
		preco_venda,
		quantidade,
		id_situacao,
		id_funcionario,
		id_funcionario_cargo
	)
VALUES
	(11,
35000,
1,
4,
1,
1),
-- Peça baixada para uso na OS 1
	(1,
26000,
1,
4,
1,
1),
-- Peça baixada para uso na OS 2
	(5,
6000,
1,
8,
1,
1);
-- Peça baixada por Descarte por Defeito/Avaria
-- ==========================================
-- 3. VIEWS E CONSULTAS DE TESTE
-- ==========================================
CREATE VIEW vw_preco_venda_maior_100 AS
SELECT
	id,
	nome_peca,
	preco_venda AS 'preço',
	estoque_atual
FROM
	peca
WHERE
	preco_venda >= 10000;

CREATE VIEW vw_estoque_baixo AS
SELECT
	id,
	nome_peca,
	estoque_atual
FROM
	peca
WHERE
	estoque_atual <= 20
ORDER BY
	estoque_atual DESC;
-- Execução das consultas
SELECT
	*
FROM
	peca
WHERE
	preco_venda <= 10000;

SELECT
	*
FROM
	vw_preco_venda_maior_100;

SELECT
	*
FROM
	vw_estoque_baixo;

SELECT
	f.nome_funcionario AS 'nome',
	c.nome_cargo AS 'cargo'
FROM
	funcionario f
JOIN cargo c ON
	f.id_cargo = c.id;

SELECT
	*
FROM
	ordem;
-- Informação consolidada das OS abertas
SELECT
	o.id AS 'ordem_serviço',
	m.nome_modelo AS 'modelo',
	o.defeito_constatado,
	o.defeito_relatado,
	fp.nome_forma_pagamento 'forma_pagto',
	f.nome_funcionario 'aberto_por',
	f2.nome_funcionario 'atendido_por'
FROM
	ordem o
JOIN equipamento e ON
	o.id_equipamento = e.id
JOIN modelo m ON
	e.id = m.id
JOIN forma_pagamento fp ON
	o.id_forma_pagamento = fp.id
JOIN funcionario f ON
	o.id_funcionario_abertura = f.id
JOIN funcionario f2 ON
	o.id_tecnico = f2.id;
-- SELECT E JOIN PARA VERIFICAR O STATUS DE REPARO DE UM EQUIPAMENTO, COM FILTRO POR OS
SELECT
	os.id_ordem AS 'OS',
	m.nome_modelo AS 'Modelo',
	s.nome_situacao AS "Situação",
	os.data_situacao AS 'Data'
FROM
	ordem_situacao os
JOIN ordem o ON
	os.id_ordem = o.id
JOIN situacao s ON
	os.id_nova_situacao = s.id
JOIN equipamento e ON
	o.id_equipamento = e.id
JOIN modelo m ON
	e.id_modelo = m.id
WHERE
	os.id_ordem = 1;





















