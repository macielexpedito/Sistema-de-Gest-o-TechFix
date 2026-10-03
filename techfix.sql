PRAGMA foreign_keys = ON;

PRAGMA foreign_keys;	

CREATE TABLE cargo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cargo TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1
) STRICT;

CREATE TABLE funcionario(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_funcionario TEXT NOT NULL COLLATE NOCASE,
	id_cargo INTEGER NOT NULL,
	status INTEGER NOT NULL DEFAULT 1,
	data_cadastro TEXT NOT NULL DEFAULT (DATE('now', 'localtime')),
	FOREIGN KEY(id_cargo) REFERENCES cargo (id) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (id,id_cargo)
)STRICT;

INSERT INTO CARGO (nome_cargo) VALUES ('Gerente'),('Atendente'),('Técnico');
INSERT INTO funcionario (nome_funcionario, id_cargo)
VALUES
('Carlos Silva', 1),
('Fernanda Oliveira', 1),

('Joao Santos', 2),
('Maria Souza', 2),
('Pedro Almeida', 2),
('Juliana Costa', 2),
('Rafael Pereira', 2),

('Lucas Rodrigues', 3),
('Camila Martins', 3),
('Andre Ferreira', 3);

CREATE TABLE cliente (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cliente TEXT NOT NULL COLLATE NOCASE,
	email TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1 OR  id_funcionario_cargo = 2),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

drop TABLE cliente;

CREATE TABLE cliente (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cliente TEXT NOT NULL COLLATE NOCASE,
	email TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1 OR  id_funcionario_cargo = 2),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;


INSERT INTO cliente 
(nome_cliente, email, id_funcionario, id_funcionario_cargo)

VALUES (
    'Joao Santos',
    'joao@email.com',
    6,
    (SELECT id_cargo 
     FROM funcionario 
     WHERE id = 6)
);

CREATE TABLE categoria (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_categoria TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	status INTEGER NOT NULL DEFAULT 1,
	data_cadastro TEXT NOT NULL DEFAULT (DATE ('now','localtime')),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

INSERT INTO categoria
(nome_categoria, id_funcionario, id_funcionario_cargo)

VALUES ('Computadores', 1, (SELECT id_cargo FROM funcionario WHERE id = 1)
);

CREATE TABLE servicos (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_servico INTEGER NOT NULL COLLATE NOCASE UNIQUE,
	id_categoria INTEGER NOT NULL,
	preco INTEGER NOT NULL,
	horas_trabalho REAL NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo=1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_categoria) REFERENCES categoria (id),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('áudio', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('celulares', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('computadores', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('eletrônica avançada', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('recuperação de dados', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('redes', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('smart tvs', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES ('videogames', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

DROP TABLE IF EXISTS servicos;

CREATE TABLE servicos (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_servico TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_categoria INTEGER NOT NULL,
	preco INTEGER NOT NULL,
	horas_trabalho REAL NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_categoria) REFERENCES categoria (id),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

INSERT INTO servicos (nome_servico, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_cargo)
VALUES 
('Formatação e Instalação de Sistema Operacional', (SELECT id FROM categoria WHERE nome_categoria = 'computadores'), 12000, 2.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Limpeza Interna e Troca de Pasta Térmica', (SELECT id FROM categoria WHERE nome_categoria = 'computadores'), 15000, 1.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Upgrade de Hardware (RAM/SSD)', (SELECT id FROM categoria WHERE nome_categoria = 'computadores'), 8000, 1.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Remoção de Vírus e Malwares', (SELECT id FROM categoria WHERE nome_categoria = 'computadores'), 10000, 1.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Tela de Notebook', (SELECT id FROM categoria WHERE nome_categoria = 'computadores'), 18000, 1.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Display/Frontal de Celular', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 15000, 1.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Bateria de Smartphone', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 9000, 0.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Desoxidação após Contato com Líquido', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 20000, 3.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Reparo em Conector de Carga (Micro USB / Type-C)', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 11000, 1.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Barra de LED de Smart TV', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 35000, 3.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Reparo na Placa Principal de Smart TV', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 28000, 2.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Conserto de Fonte de Alimentação Interna (TV)', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 22000, 2.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Configuração de Rede e Roteador Wi-Fi', (SELECT id FROM categoria WHERE nome_categoria = 'redes'), 9000, 1.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', (SELECT id FROM categoria WHERE nome_categoria = 'videogames'), 22000, 2.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', (SELECT id FROM categoria WHERE nome_categoria = 'videogames'), 8000, 1.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Substituição de HDMI / Conector de Vídeo (Console)', (SELECT id FROM categoria WHERE nome_categoria = 'videogames'), 25000, 2.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', (SELECT id FROM categoria WHERE nome_categoria = 'áudio'), 12000, 1.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Almofadas / Reparo de Cabo de Headset Gamer', (SELECT id FROM categoria WHERE nome_categoria = 'áudio'), 7000, 1.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Recuperação de Dados de HD / SSD / Pendrive Danificado', (SELECT id FROM categoria WHERE nome_categoria = 'recuperação de dados'), 30000, 4.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'), 45000, 5.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'), 16000, 2.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Troca de Vidro Traseiro de Smartphone a Laser / Manual', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 18000, 2.5, 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', (SELECT id FROM categoria WHERE nome_categoria = 'áudio'), 9500, 1.0, 1, (SELECT id_cargo FROM funcionario WHERE id = 1));

CREATE TABLE peca (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    nome_peca TEXT NOT NULL COLLATE NOCASE UNIQUE,

    id_categoria INTEGER NOT NULL,

    preco_venda INTEGER NOT NULL,

    horas_trabalho REAL NOT NULL,

    id_funcionario INTEGER NOT NULL,

    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),

    id_servicos INTEGER NOT NULL,

    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),

    status INTEGER NOT NULL DEFAULT 1,

    FOREIGN KEY (id_categoria) REFERENCES categoria (id),

    FOREIGN KEY (id_servicos) REFERENCES servicos (id),

    FOREIGN KEY (id_funcionario, id_funcionario_cargo) 
        REFERENCES funcionario (id, id_cargo)

) STRICT;



SELECT * FROM peca WHERE preco_venda >= 1;

drop TABLE peca;

CREATE TABLE peca (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    nome_peca TEXT NOT NULL COLLATE NOCASE UNIQUE,

    id_categoria INTEGER NOT NULL,

    preco_compra INTEGER NOT NULL,

    preco_venda INTEGER NOT NULL,

    estoque_atual INTEGER NOT NULL DEFAULT 0,

    id_funcionario INTEGER NOT NULL,

    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),

    id_servicos INTEGER,

    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),

    status INTEGER NOT NULL DEFAULT 1,

    FOREIGN KEY (id_categoria) REFERENCES categoria (id),

    FOREIGN KEY (id_servicos) REFERENCES servicos (id),

    FOREIGN KEY (id_funcionario, id_funcionario_cargo)
        REFERENCES funcionario (id, id_cargo)

) STRICT;

SELECT * FROM peca WHERE preco_venda >= 1;

INSERT INTO peca
(nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_cargo, id_servicos)
VALUES

-- Informática / Computadores
(
    'SSD NVMe 512GB M.2',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    14000, 26000, 15,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'SSD SATA III 480GB 2.5"',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    11000, 21000, 20,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Memória RAM DDR4 8GB 2666MHz (Notebook)',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    9000, 17000, 12,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Memória RAM DDR4 16GB 3200MHz (Desktop)',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    18000, 32000, 8,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Pasta Térmica de Alta Performance (Bisnaga 4g)',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    2500, 6000, 25,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Fonte ATX 500W 80 Plus Bronze',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    19000, 34000, 6,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Bateria Célula Moeda CR2032 (Cartela c/ 5)',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    800, 2500, 30,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Cooler para Processador Socket Universal',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    4500, 9500, 10,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Cabo SATA III 6Gbps 50cm',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    300, 1500, 50,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Tela LED 15.6" Slim 30 Pinos Full HD',
    (SELECT id FROM categoria WHERE nome_categoria = 'computadores'),
    28000, 48000, 5,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

-- Smartphones / Celulares
(
    'Display Frontal Completo iPhone 11',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    18000, 35000, 4,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Display Frontal Completo Samsung Galaxy A54',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    16000, 31000, 6,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Display Frontal Completo Motorola Moto G84',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    14000, 28000, 5,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Bateria Compatível iPhone 11 (3110mAh)',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    7500, 16000, 8,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Bateria Compatível Samsung Galaxy A32',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    6000, 13000, 7,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Bateria Compatível Moto G30',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    5500, 12000, 6,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Conector de Carga Type-C Universal (Unidade)',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    250, 2000, 100,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Conector de Carga Micro USB V8',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    150, 1500, 100,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Flex de Carga e Microfone Moto G9 Play',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    1800, 5500, 10,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Tampa Traseira de Vidro iPhone 12',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    4000, 11000, 4,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Câmera Traseira Principal Redmi Note 11',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    6500, 14000, 3,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Alto-Falante Auricular Universal',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    500, 2500, 40,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

-- Smart TVs
(
    'Barra de LED TV Samsung 50" (Kit com 3 barras)',
    (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'),
    11000, 23000, 4,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Barra de LED TV LG 43" (Kit com 3 barras)',
    (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'),
    9500, 19500, 5,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Placa Fonte TV Samsung UN50TU8000',
    (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'),
    16000, 31000, 2,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Placa Principal TV LG 43UP7500',
    (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'),
    21000, 42000, 2,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Cabo Flat T-Con para Display TV 55"',
    (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'),
    2200, 6500, 8,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Receptor Infravermelho para Controle Remoto TV',
    (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'),
    400, 2000, 15,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

-- Insumos e Componentes Genéricos
(
    'Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    8500, 15000, 3,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Álcool Isopropílico 99.8% 1 Litro',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    2200, 4500, 12,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Fita Kapton Térmica 10mm x 33m',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    1200, 3000, 15,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Fita Dupla Face Fixação de Telas (3mm x 50m)',
    (SELECT id FROM categoria WHERE nome_categoria = 'celulares'),
    1500, 3500, 10,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Fusível de Louça 5A 250V (Pacote c/ 10)',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    500, 1800, 20,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
),

(
    'Capacitor Eletrolítico 1000uF x 25V',
    (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'),
    80, 500, 150,
    1,
    (SELECT id_cargo FROM funcionario WHERE id = 1),
    1
);

CREATE TABLE marca (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_marca TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1 OR id_funcionario_cargo = 2),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE modelo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_modelo TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1 OR id_funcionario_cargo = 2),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE tipo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_tipo TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1 OR id_funcionario_cargo = 2),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE equipamento (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_equipamento TEXT NOT NULL,
	id_marca INTEGER NOT NULL,
	id_modelo INTEGER NOT NULL,
	id_tipo INTEGER NOT NULL,
	id_situacao INTEGER NOT NULL,
	id_cliente INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1 OR id_funcionario_cargo = 2),
	serial_number TEXT NOT NULL COLLATE NOCASE UNIQUE,
	imei TEXT COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1,
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_marca) REFERENCES marca (id),
	FOREIGN KEY (id_modelo) REFERENCES modelo (id),
	FOREIGN KEY (id_tipo) REFERENCES tipo (id),
	FOREIGN KEY (id_situacao) REFERENCES situacao (id),
	FOREIGN KEY (id_cliente) REFERENCES cliente (id),
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo),
	UNIQUE (id, id_cliente)
) STRICT;

CREATE TABLE forma_pagamento(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_forma_pagamento TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'));
	status INTEGER NOT NULL DEFAULT 1
) strict;

CREATE TABLE forma_pagamento(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_forma_pagamento TEXT NOT NULL COLLATE NOCASE UNIQUE,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
	data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	status INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

INSERT INTO forma_pagamento (nome_forma_pagamento, id_funcionario, id_funcionario_cargo)
VALUES
('Dinheiro', 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('PIX', 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Cartão de Débito', 1, (SELECT id_cargo FROM funcionario WHERE id = 1)),
('Cartão de Crédito', 1, (SELECT id_cargo FROM funcionario WHERE id = 1));


CREATE TABLE ordem (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_equipamento INTEGER NOT NULL,
	id_cliente INTEGER NOT NULL,
	id_funcionario_abertura INTEGER NOT NULL,
	id_funcionario_cargo_abertura INTEGER NOT NULL CHECK (id_funcionario_cargo_abertura = 1 OR id_funcionario_cargo_abertura = 2),
	data_abertura TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	data_fechamento TEXT,
	defeito_relatado TEXT NOT NULL,
	defeito_constatado TEXT COLLATE NOCASE,
	valor_total INTEGER,
	id_situacao_atual INTEGER NOT NULL DEFAULT 1,
	id_forma_pagamento INTEGER,
	id_tecnico INTEGER NOT NULL,
	id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
	FOREIGN KEY (id_equipamento, id_cliente) REFERENCES equipamento (id, id_cliente),
	FOREIGN KEY (id_funcionario_abertura, id_funcionario_cargo_abertura) REFERENCES funcionario (id, id_cargo),
	FOREIGN KEY (id_situacao_atual) REFERENCES situacao (id),
	FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento (id),
	FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo),
	UNIQUE (id, id_tecnico)
) STRICT;


CREATE TABLE ordem_servico (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_ordem INTEGER NOT NULL,
	id_servico INTEGER NOT NULL,
	preco_aplicado INTEGER NOT NULL,
	data_execucao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	id_tecnico INTEGER NOT NULL,
	id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
	FOREIGN KEY (id_ordem, id_tecnico) REFERENCES ordem (id, id_tecnico),
	FOREIGN KEY (id_servico) REFERENCES servicos (id),
	FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo),
	UNIQUE (id_ordem, id_servico)
) STRICT;


CREATE TABLE ordem_situacao (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_ordem INTEGER NOT NULL,
	id_situacao INTEGER NOT NULL,
	id_tecnico INTEGER NOT NULL,
	id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
	data_situacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_ordem, id_tecnico) REFERENCES ordem (id, id_tecnico),
	FOREIGN KEY (id_situacao) REFERENCES situacao (id),
	FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE ordem_peca (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_ordem INTEGER NOT NULL,
	id_peca INTEGER NOT NULL,
	quantidade INTEGER NOT NULL CHECK (quantidade > 0),
	preco_aplicado INTEGER NOT NULL,
	id_tecnico INTEGER NOT NULL,
	id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
	data_utilizacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_ordem, id_tecnico) REFERENCES ordem (id, id_tecnico),
	FOREIGN KEY (id_peca) REFERENCES peca (id),
	FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo),
	UNIQUE (id_ordem, id_peca)
) STRICT;

