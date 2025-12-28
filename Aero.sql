-- Usar o banco
CREATE DATABASE IF NOT EXISTS aero;
USE aero;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    senha VARCHAR(50) NOT NULL DEFAULT '0',
    email VARCHAR(100) NOT NULL,
    cpf VARCHAR(50) NOT NULL,
    telefone VARCHAR(50) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    rg VARCHAR(50) NOT NULL,
    foto VARCHAR(250) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Tabela de voos
CREATE TABLE IF NOT EXISTS voos (
    id_voo INT AUTO_INCREMENT PRIMARY KEY,
    numero_voo VARCHAR(30),
    origem VARCHAR(50),
    destino VARCHAR(50),
    data_voo DATE,
    hora_voo TIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tabela de passagens
CREATE TABLE IF NOT EXISTS passagens (
    id_passagem INT AUTO_INCREMENT PRIMARY KEY,
    id INT NOT NULL,
    id_voo INT NOT NULL,
    confirmado TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_voo) REFERENCES voos(id_voo) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tabela de bagagens
CREATE TABLE IF NOT EXISTS bagagens (
    id_bagagem INT AUTO_INCREMENT PRIMARY KEY,
    id_passagem INT NOT NULL,
    codigo_rastreio VARCHAR(60) NOT NULL,
    status_bagagem VARCHAR(60) NOT NULL DEFAULT 'Despachada',
    ultima_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_passagem) REFERENCES passagens(id_passagem) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tabela de aeroportos
CREATE TABLE IF NOT EXISTS aeroportos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cidade VARCHAR(100) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    wifi VARCHAR(150) NOT NULL,
    transporte VARCHAR(200) NOT NULL,
    duty_free VARCHAR(150) NOT NULL,
    restaurantes VARCHAR(200) NOT NULL,
    aviso_terminal VARCHAR(255) NOT NULL,
    aviso_checkin VARCHAR(255) NOT NULL,
    aviso_seguranca VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tabela de inbox
CREATE TABLE IF NOT EXISTS inbox (
    id_inbox INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    mensagem TEXT NOT NULL,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lida TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Inserir usuários
INSERT INTO usuarios (senha, email, cpf, telefone, nome, rg, foto) VALUES
('123456', 'heitor@email.com', '12345678900', '11999999999', 'Heitor Silva', 'MG1234567', 'perfil1.jpg'),
('abcdef', 'maria@email.com', '98765432100', '11988888888', 'Maria Souza', 'SP7654321', 'perfil2.jpg'),
('qwerty', 'joao@email.com', '11122233344', '11977777777', 'João Pereira', 'RJ1112223', 'perfil3.jpg');

-- Inserir voos
INSERT INTO voos (numero_voo, origem, destino, data_voo, hora_voo) VALUES
('A100', 'São Paulo', 'Rio de Janeiro', '2025-12-01', '14:30:00'),
('B230', 'Brasília', 'Salvador', '2025-12-02', '09:45:00'),
('C450', 'Curitiba', 'Fortaleza', '2025-12-03', '18:10:00'),
('SP101', 'São Paulo', 'Natal', '2025-12-04', '10:00:00'),
('RJ202', 'Rio de Janeiro', 'São Paulo', '2025-12-05', '15:30:00'),
('BS300', 'Brasília', 'Salvador', '2025-12-06', '12:10:00');

-- Inserir passagens
INSERT INTO passagens (id, id_voo, confirmado) VALUES
(1, 1, 1),
(1, 2, 0),
(2, 3, 1),
(2, 4, 0),
(3, 5, 0),
(3, 6, 1);

-- Inserir bagagens
INSERT INTO bagagens (id_passagem, codigo_rastreio, status_bagagem) VALUES
(1, 'AERO100001', 'Despachada'),
(1, 'AERO100002', 'No porão da aeronave'),
(2, 'AERO200001', 'Em trânsito'),
(3, 'AERO300001', 'Despachada'),
(4, 'AERO400001', 'Na esteira'),
(5, 'AERO500001', 'Pronta para retirada'),
(6, 'AERO600001', 'Despachada');

-- Inserir aeroportos
INSERT INTO aeroportos (cidade, nome, wifi, transporte, duty_free, restaurantes, aviso_terminal, aviso_checkin, aviso_seguranca) VALUES
('São Paulo', 'Aeroporto Internacional de Guarulhos (GRU)', 'Wi-Fi gratuito por 1h', 'Ônibus, táxi, Uber e Metrô próximo', 'Lojas abertas 24h', 'Mais de 50 opções de alimentação', 'Chegue ao terminal com 3h de antecedência', 'Check-in fecha 1h antes do voo', 'Evite líquidos acima de 100ml na bagagem de mão'),
('Rio de Janeiro', 'Aeroporto Internacional do Galeão (GIG)', 'Wi-Fi gratuito ilimitado', 'BRT, táxi, Uber e ônibus executivo', 'Duty Free com preços variados', 'Restaurantes 24h no terminal 2', 'Terminal 1 está parcialmente fechado', 'Check-in recomendado 2h antes', 'Revise itens proibidos antes de embarcar'),
('Belo Horizonte', 'Aeroporto Internacional de Confins (CNF)', 'Wi-Fi gratuito', 'Ônibus Conexão Aeroporto, Uber e táxi', 'Duty Free apenas em voos internacionais', 'Praça de alimentação completa', 'Obras no estacionamento — atenção às sinalizações', 'Check-in abre 3h antes do voo', 'Raio-X pode ter filas nos horários de pico');

-- Inserir inbox (mensagens)
INSERT INTO inbox (id_usuario, titulo, mensagem) VALUES
(1, 'Bem-vindo!', 'Olá Heitor, sua conta foi criada com sucesso!'),
(2, 'Atualização de voo', 'Maria, seu voo B230 foi confirmado.'),
(3, 'Notificação', 'João, sua bagagem AERO600001 está pronta para retirada.');

-- Evento para excluir voos vencidos
SET GLOBAL event_scheduler = ON;
CREATE EVENT IF NOT EXISTS excluir_voos_vencidos
ON SCHEDULE EVERY 1 MINUTE
DO
    DELETE FROM voos WHERE CONCAT(data_voo, ' ', hora_voo) < NOW();
