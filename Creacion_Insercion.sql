CREATE DATABASE IF NOT EXISTS g4_conservacion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE g4_conservacion;

-- Eliminar tablas en caso de existir
DROP TABLE IF EXISTS Especie_Estado;
DROP TABLE IF EXISTS Especie_Ubicacion;
DROP TABLE IF EXISTS Especies_Amenazas;
DROP TABLE IF EXISTS Especies_Amenazas_Registro;
DROP TABLE IF EXISTS Avistamiento;
DROP TABLE IF EXISTS Amenaza;
DROP TABLE IF EXISTS Observador;
DROP TABLE IF EXISTS Ubicacion;
DROP TABLE IF EXISTS Especie;
DROP TABLE IF EXISTS EstadoConservacion;

-- Tabla EstadoConservacion
CREATE TABLE EstadoConservacion (
    estado_codigo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla Especie
CREATE TABLE Especie (
    especie_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cientifico VARCHAR(150) UNIQUE NOT NULL,
    nombre_comun VARCHAR(150)
);

-- Relación Especie - EstadoConservacion 
CREATE TABLE Especie_Estado (
    especie_id INT NOT NULL,
    estado_codigo VARCHAR(10) NOT NULL,
    region VARCHAR(150), 
    PRIMARY KEY (especie_id, estado_codigo, region),
    FOREIGN KEY (especie_id) REFERENCES Especie(especie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (estado_codigo) REFERENCES EstadoConservacion(estado_codigo)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla Ubicacion
CREATE TABLE Ubicacion (
    ubicacion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    latitud DECIMAL(9,6) NOT NULL,
    longitud DECIMAL(9,6) NOT NULL
);

-- Relación Especie - Ubicacion 
CREATE TABLE Especie_Ubicacion (
    especie_id INT NOT NULL,
    ubicacion_id INT NOT NULL,
    region VARCHAR(150), -- Ejemplo: Amazonía ecuatoriana, Andes, Caribe
    PRIMARY KEY (especie_id, ubicacion_id, region),
    FOREIGN KEY (especie_id) REFERENCES Especie(especie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ubicacion_id) REFERENCES Ubicacion(ubicacion_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla Observador
CREATE TABLE Observador (
    observador_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

-- Tabla Amenaza
CREATE TABLE Amenaza (
    amenaza_id INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100) NOT NULL
);

-- Tabla Avistamiento
CREATE TABLE Avistamiento (
    avistamiento_id INT AUTO_INCREMENT PRIMARY KEY,
    especie_id INT NOT NULL,
    ubicacion_id INT NOT NULL,
    observador_id INT,
    fecha_hora DATETIME NOT NULL,

    FOREIGN KEY (especie_id) REFERENCES Especie(especie_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (ubicacion_id) REFERENCES Ubicacion(ubicacion_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (observador_id) REFERENCES Observador(observador_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Tabla Especies_Amenazas
CREATE TABLE Especies_Amenazas (
    especie_id INT NOT NULL,
    amenaza_id INT NOT NULL,
    impacto ENUM('Alto','Medio','Bajo') NOT NULL,
    PRIMARY KEY (especie_id, amenaza_id),
    FOREIGN KEY (especie_id) REFERENCES Especie(especie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (amenaza_id) REFERENCES Amenaza(amenaza_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Especies - Amenazas 
CREATE TABLE Especies_Amenazas_Registro (
    registro_id INT AUTO_INCREMENT PRIMARY KEY,
    especie_id INT NOT NULL,
    amenaza_id INT NOT NULL,
    fecha_registro DATE NOT NULL,
    observador_id INT,
    FOREIGN KEY (especie_id) REFERENCES Especie(especie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (amenaza_id) REFERENCES Amenaza(amenaza_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (observador_id) REFERENCES Observador(observador_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);


-- -----------------------------
-- Estados de conservación
-- -----------------------------
INSERT INTO EstadoConservacion (estado_codigo, nombre, descripcion)
VALUES 
('NP', 'No Peligro', 'Tiene una amplia población sin amenazas directas'),
('EP', 'En Peligro', 'Su población ha disminuido drásticamente y presenta 1 amenaza directa o más'),
('CA', 'Casi Amenazado', 'Podría estar en riesgo en un futuro cercano');

-- -----------------------------
-- Especies
-- -----------------------------
INSERT INTO Especie (nombre_cientifico, nombre_comun)
VALUES
('Rhinoceros sondaicus', 'Rinoceronte de Java'),
('Gorilla beringei beringei', 'Gorila de Montaña'),
('Phocoena sinus', 'Vaquita Marina'),
('Panthera tigris sumatrae', 'Tigre de Sumatra'),
('Pongo pygmaeus', 'Orangután de Borneo'),
('Elephas maximus', 'Elefante Asiático'),
('Loxodonta africana', 'Elefante Africano'),
('Ailuropoda melanoleuca', 'Panda Gigante'),
('Acinonyx jubatus', 'Guepardo'),
('Chelonia mydas', 'Tortuga Verde');

-- -----------------------------
-- Especie - EstadoConservacion
-- -----------------------------
INSERT INTO Especie_Estado (especie_id, estado_codigo, region)
VALUES
(1, 'EP', 'Global'), (1, 'NP', 'Indonesia'), (1, 'CA', 'Sumatra'),
(2, 'EP', 'Global'), (2, 'CA', 'Ruanda'), (2, 'CA', 'Kenia'),
(3, 'EP', 'Global'), (3, 'CA', 'México'), (3, 'CA', 'California'),
(4, 'EP', 'Global'), (4, 'CA', 'Sumatra'), (4, 'CA', 'Indonesia'),
(5, 'EP', 'Global'), (5, 'CA', 'Borneo'), (5, 'CA', 'Indonesia'),
(6, 'EP', 'Asia'), (6, 'CA', 'Sri Lanka'), (6, 'CA', 'India'),
(7, 'EP', 'África'), (7, 'CA', 'Kenia'), (7, 'CA', 'Botswana'),
(8, 'CA', 'China'), (8, 'NP', 'Sichuan'),
(9, 'EP', 'África'), (9, 'CA', 'Botswana'), (9, 'CA', 'Kenia'),
(10, 'EP', 'Océano Pacífico'), (10, 'CA', 'Caribe');

-- -----------------------------
-- Ubicaciones
-- -----------------------------
INSERT INTO Ubicacion (nombre, latitud, longitud)
VALUES
('Isla De Java, Indonesia', -6.595275, 107.556447),
('Montañas Virunga, Ruanda', -1.429596, 29.547217),
('Golfo De California, México', 26.874306, -112.407191),
('Isla De Sumatra, Indonesia', -0.076812, 101.376294),
('Isla de Borneo, Indonesia', 0.950946, 114.983948),
('Parque Nacional Yala, Sri Lanka', 6.3597, 81.4402),
('Sabana Africana, Kenia', -1.2921, 36.8219),
('Reserva de Wolong, China', 31.0333, 103.0667),
('Desierto del Kalahari, Botswana', -24.5, 23.9),
('Océano Pacífico', 0, -160);

-- -----------------------------
-- Especie - Ubicacion
-- -----------------------------
INSERT INTO Especie_Ubicacion (especie_id, ubicacion_id, region)
VALUES
(1, 1, 'Indonesia'), (1, 4, 'Sumatra'),
(2, 2, 'Ruanda'), (2, 7, 'Kenia'), (2, 9, 'Botswana'),
(3, 3, 'México - Golfo de California'),
(4, 4, 'Sumatra'), (4, 1, 'Indonesia'),
(5, 5, 'Borneo'), (5, 4, 'Indonesia'),
(6, 6, 'Sri Lanka'), (6, 1, 'Indonesia'), (6, 4, 'Sumatra'),
(7, 7, 'Kenia'), (7, 9, 'Botswana'),
(8, 8, 'China - Wolong'), (8, 8, 'Sichuan'),
(9, 9, 'Botswana'), (9, 7, 'Kenia'),
(10, 10, 'Océano Pacífico'), (10, 3, 'México - Caribe');

-- -----------------------------
-- Observadores
-- -----------------------------
INSERT INTO Observador (nombre, email)
VALUES
('Lionel Messi', 'lionelmessi@gmail.com'),
('Moises Caicedo', 'moisescaicedo@gmail.com'),
('Taylor Swift', 'taylorswift@gmail.la'),
('Charlie Yamal', 'charlieyamal@gmail.com'),
('William Martin', 'williammartin@gmail.com'),
('David Attenborough', 'david.attenborough@gmail.com'),
('Jane Goodall', 'jane.goodall@gmail.com'),
('Steve Irwin', 'steve.irwin@gmail.com'),
('Sylvia Earle', 'sylvia.earle@gmail.com'),
('Chris Packham', 'chris.packham@gmail.com');

-- -----------------------------
-- Amenazas
-- -----------------------------
INSERT INTO Amenaza (categoria)
VALUES
('Pérdida de hábitat'), ('Pesca Ilegal'), ('Caza furtiva'), 
('Deforestación'), ('Cambio Climático');

-- -----------------------------
-- Avistamientos
-- -----------------------------
INSERT INTO Avistamiento (especie_id, ubicacion_id, observador_id, fecha_hora)
VALUES
(1, 1, 1, '2024-01-01 10:00:00'), (1, 4, 2, '2024-01-15 11:00:00'), (1, 1, 6, '2024-02-12 12:30:00'),
(2, 2, 2, '2024-01-05 14:00:00'), (2, 7, 7, '2024-03-15 10:00:00'), (2, 9, 3, '2024-04-01 09:30:00'),
(3, 3, 3, '2024-01-10 13:00:00'), (3, 3, 8, '2024-02-20 16:00:00'), (3, 3, 4, '2024-03-05 15:15:00'),
(4, 4, 4, '2024-01-12 12:00:00'), (4, 4, 9, '2024-03-18 11:30:00'), (4, 1, 1, '2024-04-22 10:45:00'),
(5, 5, 5, '2024-01-15 15:00:00'), (5, 4, 6, '2024-04-01 14:00:00'), (5, 5, 10, '2024-05-05 13:20:00'),
(6, 6, 6, '2024-02-01 09:00:00'), (6, 1, 1, '2024-02-15 10:30:00'), (6, 4, 2, '2024-03-01 11:00:00'),
(7, 7, 7, '2024-03-05 11:00:00'), (7, 9, 2, '2024-03-20 12:15:00'), (7, 7, 3, '2024-04-10 13:00:00'),
(8, 8, 8, '2024-04-10 09:00:00'), (8, 8, 3, '2024-04-20 10:00:00'), (8, 8, 4, '2024-05-01 11:30:00'),
(9, 9, 9, '2024-05-15 14:00:00'), (9, 7, 4, '2024-05-30 15:30:00'), (9, 9, 5, '2024-06-10 16:00:00'),
(10, 10, 10, '2024-06-20 16:00:00'), (10, 3, 5, '2024-07-05 12:45:00'), (10, 10, 1, '2024-07-20 13:30:00');

-- -----------------------------
-- Especies - Amenazas 
-- -----------------------------
INSERT INTO Especies_Amenazas (especie_id, amenaza_id, impacto)
VALUES
(1, 1, 'Alto'),  
(1, 4, 'Medio'), 
(2, 1, 'Alto'),  
(2, 3, 'Alto'),  
(3, 2, 'Alto'),  
(3, 5, 'Alto'),  
(4, 1, 'Medio'),
(4, 3, 'Alto'),
(5, 4, 'Alto'),
(6, 4, 'Medio'),
(6, 5, 'Alto'),
(7, 1, 'Alto'),
(7, 5, 'Alto'),
(8, 4, 'Medio'),
(9, 5, 'Alto'),
(10, 2, 'Alto'),
(10, 5, 'Medio');

INSERT INTO Especies_Amenazas_Registro (especie_id, amenaza_id, fecha_registro, observador_id)
VALUES
(1, 1, '2024-01-01', 1),
(1, 1, '2024-01-05', 2),
(1, 4, '2024-02-20', 2),
(2, 1, '2024-03-15', 4),
(2, 3, '2024-03-20', 5),
(3, 2, '2024-04-01', 1),
(3, 2, '2024-04-05', 2);

