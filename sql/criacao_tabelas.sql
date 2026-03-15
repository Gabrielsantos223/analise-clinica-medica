CREATE TABLE pacientes (
	id INT PRIMARY  KEY AUTO_INCREMENT,
    nome  VARCHAR(100) NOT NULL,
    cpf  CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo ENUM('masculino',  'feminino') NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);
----------------------------------------------------

CREATE TABLE enderecos (
	id INT PRIMARY  KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    cidade VARCHAR(50)  NOT NULL,
    estado VARCHAR(2) NOT  NULL,
    bairro VARCHAR(50) NOT NULL,
    rua VARCHAR(200)  NOT NULL,
    numero VARCHAR(100) NOT NULL,
    cep CHAR(8) NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) 
);
------------------------------------------------------
CREATE TABLE medicos (
	id INT PRIMARY  KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
	cpf  CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo ENUM('masculino',  'feminino') NOT NULL,
    especialidade VARCHAR(100)  NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);
------------------------------------------------------

CREATE TABLE consultas (
	id INT PRIMARY  KEY AUTO_INCREMENT,
	paciente_id INT NOT NULL,
    medico_id  INT  NOT NULL,
    data_consulta DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status_consulta ENUM('agendada','realizada','cancelada','não compareceu') DEFAULT 'agendada' NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (medico_id) REFERENCES medicos(id)
);

------------------------------------------------------------------------------------
CREATE TABLE exames (
	id INT PRIMARY  KEY AUTO_INCREMENT,
	consulta_id INT NOT NULL,
    tipo_exame VARCHAR(100) NOT NULL,
    valor DECIMAL (10,2) NOT NULL,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id)
);
===============================================================================================

--inserts--

INSERT INTO pacientes (nome, cpf, data_nascimento, sexo, email) VALUES
('Ricardo Anthony', '12345678909', '1996-03-15', 'masculino', 'ricardo.anthony@email.com'),
('Livia Graciani', '98765432100', '1998-07-22', 'feminino', 'livia.graciani@email.com'),
('Luciana Yamaguchi', '74185296320', '1994-11-03', 'feminino', 'luciana.y@email.com'),
('Luiza Carvalho', '36925814711', '1999-01-19', 'feminino', 'luiza.carvalho@email.com'),
('Matheus Garcia', '85274196344', '1995-09-12', 'masculino', 'matheus.garcia@email.com'),
('Guilherme Patez', '15935748622', '1997-05-28', 'masculino', 'guilherme.p@email.com'),
('Kaiqui Azevedo', '95175385266', '2000-02-10', 'masculino', 'kaiqui.azevedo@email.com'),
('Gabriel Santos', '75315945688', '1998-12-05', 'masculino', 'gabriel.santos@email.com');
-----------------------------------------------------------------------------------------

INSERT INTO enderecos (paciente_id, cidade, estado, bairro, rua, numero, cep) VALUES
(1,'São Paulo','SP','Centro','Rua Augusta','100','01000000'),
(2,'São Paulo','SP','Mooca','Rua da Mooca','200','03100000'),
(3,'Campinas','SP','Cambuí','Rua Barreto Leme','300','13000000'),
(4,'Rio de Janeiro','RJ','Copacabana','Av. Atlântica','400','22000000'),
(5,'Belo Horizonte','MG','Savassi','Rua Pernambuco','500','30130000'),
(6,'Curitiba','PR','Centro','Rua XV de Novembro','600','80020000'),
(7,'Porto Alegre','RS','Moinhos','Rua Padre Chagas','700','90570000'),
(8,'Salvador','BA','Barra','Av. Oceânica','800','40140000');
-----------------------------------------------------------------------------------------

INSERT INTO medicos (nome, cpf, data_nascimento, sexo, especialidade, email) VALUES
('Dr. João Silva','32165498700','1975-05-10','masculino','Cardiologia','joao.cardio@email.com'),
('Dra. Fernanda Rocha','65498732111','1980-03-18','feminino','Dermatologia','fernanda.derma@email.com'),
('Dr. Marcos Oliveira','14725836999','1983-08-22','masculino','Ortopedia','marcos.orto@email.com'),
('Dra. Camila Torres','25836914755','1990-12-14','feminino','Clínico Geral','camila.clinico@email.com');
-------------------------------------------------------------------------------------------------

INSERT INTO consultas (paciente_id, medico_id, data_consulta, valor, status_consulta) VALUES
(1,1,'2026-02-01',350.00,'realizada'),
(2,2,'2026-02-02',250.00,'realizada'),
(3,4,'2026-02-03',200.00,'realizada'),
(4,3,'2026-02-04',400.00,'realizada'),
(5,1,'2026-02-05',350.00,'cancelada'),
(6,2,'2026-02-06',250.00,'realizada'),
(7,4,'2026-02-07',200.00,'não compareceu'),
(8,3,'2026-02-08',400.00,'realizada'),
(1,4,'2026-02-09',200.00,'realizada'),
(2,1,'2026-02-10',350.00,'realizada'),
(3,2,'2026-02-11',250.00,'agendada'),
(4,4,'2026-02-12',200.00,'realizada'),
(5,3,'2026-02-13',400.00,'realizada'),
(6,1,'2026-02-14',350.00,'realizada'),
(7,2,'2026-02-15',250.00,'realizada');
--------------------------------------------------------------------------------------------------

INSERT INTO exames (consulta_id, tipo_exame, valor) VALUES
(1,'Eletrocardiograma',150.00),
(2,'Exame de Pele',120.00),
(4,'Raio-X',180.00),
(6,'Exame Dermatológico',130.00),
(8,'Ressonância',500.00),
(9,'Hemograma',90.00),
(10,'Teste Ergométrico',200.00),
(12,'Check-up Geral',110.00),
(13,'Ultrassom',220.00),
(14,'Eletrocardiograma',150.00),
(15,'Exame de Pele',120.00);
