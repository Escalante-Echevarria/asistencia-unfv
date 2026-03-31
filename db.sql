-- Crear base de datos
CREATE DATABASE asistencia_unfv;
USE asistencia_unfv;

-- Tabla Usuarios (Docentes y Administradores)
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('docente', 'admin') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Escuelas
CREATE TABLE escuelas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL
);

-- Tabla Docentes
CREATE TABLE docentes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    escuela_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (escuela_id) REFERENCES escuelas(id)
);

-- Tabla Cursos
CREATE TABLE cursos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    escuela_id INT,
    docente_id INT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (escuela_id) REFERENCES escuelas(id),
    FOREIGN KEY (docente_id) REFERENCES docentes(id)
);

-- Tabla Alumnos
CREATE TABLE alumnos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    curso_id INT,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Tabla Asistencias
CREATE TABLE asistencias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    curso_id INT,
    alumno_id INT,
    fecha DATE NOT NULL,
    estado ENUM('presente', 'tardanza', 'ausente') NOT NULL,
    registrado_por INT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (curso_id) REFERENCES cursos(id),
    FOREIGN KEY (alumno_id) REFERENCES alumnos(id),
    FOREIGN KEY (registrado_por) REFERENCES usuarios(id),
    UNIQUE KEY unique_asistencia (curso_id, alumno_id, fecha)
);

-- Tabla Auditoría (LOG completo)
CREATE TABLE auditoria (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    accion VARCHAR(100) NOT NULL,
    tabla VARCHAR(50) NOT NULL,
    registro_id INT,
    detalle JSON,
    documento_fut VARCHAR(100),
    docente_solicitante VARCHAR(100),
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla Super Admin Key (ÚNICAMENTE TÚ)
CREATE TABLE superadmin_keys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    clave_hash VARCHAR(255) NOT NULL,
    activa BOOLEAN DEFAULT TRUE
);

-- DATOS INICIALES
INSERT INTO escuelas (nombre, codigo) VALUES 
('Electrónica', 'ELE'),
('Telecomunicaciones', 'TEL'),
('Mecatrónica', 'MEC'),
('Informática', 'INF');

-- Usuario Admin por defecto
INSERT INTO usuarios (usuario, password, nombre, tipo) VALUES 
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrador Principal', 'admin'),
('docente1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Docente Prueba', 'docente');

-- Super Admin Key (CAMBIAR INMEDIATAMENTE)
INSERT INTO superadmin_keys (clave_hash) VALUES ('$2y$10$tu_clave_super_secreta_aqui_hash');
