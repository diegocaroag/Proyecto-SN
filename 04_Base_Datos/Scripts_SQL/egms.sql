-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-09-2026 a las 01:39:59
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `egms`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actu_racha` (IN `p_id_estudiante` INT, IN `p_nueva_racha` INT)   begin 
update progreso
set racha_dias = p_nueva_racha
where id_estudiante = p_id_estudiante;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `suma_puntos` (IN `p_id_estudiante` INT, OUT `p_puntos_totales` INT)   begin 
select sum(puntos_acumulados) into p_puntos_totales
from progreso 
where id_estudiante = p_id_estudiante;
if p_puntos_totales is null then 
set p_puntos_totales = 0;
end if;
end$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calificacion_promes` (`p_id_estudiante` INT) RETURNS DECIMAL(4,2) READS SQL DATA begin
declare v_promedio decimal(4,2);
select avg(nota) into v_promedio
from calificacion
where id_estudiante = p_id_estudiante;
if v_promedio is null then 
set v_promedio = 0.00;
end if;
   return v_promedio;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `calificaion_promes` (`p_id_estudiante` INT) RETURNS DECIMAL(4,2) READS SQL DATA BEGIN
declare v_promedio decimal(4,2);
select avg(nota) into v_promedio
from calificacion
where id_estudiante = p_id_estudiante;
if v_promedio is null then 
set v_promedio = 0.00;
end if;
    RETURN v_promedio;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `rango_gm` (`p_id_estudiante` INT) RETURNS VARCHAR(30) CHARSET utf8mb4 COLLATE utf8mb4_general_ci READS SQL DATA begin
declare v_puntos int;
select puntos_acumulados into v_puntos
from progreso
where id_estudiante = p_id_estudiante;
    if v_puntos >= 500 then
        RETURN 'Leyenda';
    elseif v_puntos >= 200 then
        return 'Avanzado';
    elseif v_puntos >= 100 then
        return 'Intermedio';
    else
        return 'Novato';
    end if;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actividad_evaluativa`
--

CREATE TABLE `actividad_evaluativa` (
  `codigo_actividad` int(11) NOT NULL,
  `nombre_actividad` varchar(50) NOT NULL,
  `tipo_actividad` varchar(50) NOT NULL,
  `codigo_asignatura` int(11) NOT NULL,
  `id_docente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `actividad_evaluativa`
--

INSERT INTO `actividad_evaluativa` (`codigo_actividad`, `nombre_actividad`, `tipo_actividad`, `codigo_asignatura`, `id_docente`) VALUES
(1, 'Reto de Fracciones', 'Gamificada', 1, 1),
(2, 'Quiz de Ecuaciones', 'Gamificada', 2, 1),
(3, 'Trivia de Edad Media', 'Gamificada', 3, 2),
(4, 'Desafío de Regiones', 'Gamificada', 4, 2),
(5, 'Taller de Triángulos', 'Gamificada', 5, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acudiente`
--

CREATE TABLE `acudiente` (
  `id_acudiente` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `parentesco` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `acudiente`
--

INSERT INTO `acudiente` (`id_acudiente`, `id_persona`, `parentesco`) VALUES
(1, 11, 'Madre'),
(2, 12, 'Padre');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acudiente_estudiante`
--

CREATE TABLE `acudiente_estudiante` (
  `id_acudiente` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `acudiente_estudiante`
--

INSERT INTO `acudiente_estudiante` (`id_acudiente`, `id_estudiante`) VALUES
(1, 1),
(2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignatura`
--

CREATE TABLE `asignatura` (
  `codigo_asignatura` int(11) NOT NULL,
  `nombre_asignatura` varchar(50) NOT NULL,
  `codigo_curso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asignatura`
--

INSERT INTO `asignatura` (`codigo_asignatura`, `nombre_asignatura`, `codigo_curso`) VALUES
(1, 'Matemáticas Básica', 1),
(2, 'Álgebra Inicial', 2),
(3, 'Historia Universal', 1),
(4, 'Geografía de Colombia', 3),
(5, 'Geometría Plana', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacion`
--

CREATE TABLE `calificacion` (
  `id_calificacion` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `codigo_actividad` int(11) NOT NULL,
  `nota` decimal(3,2) NOT NULL,
  `fecha_evaluacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `calificacion`
--

INSERT INTO `calificacion` (`id_calificacion`, `id_estudiante`, `codigo_actividad`, `nota`, `fecha_evaluacion`) VALUES
(1, 1, 1, 4.50, '2026-03-01'),
(2, 1, 2, 3.80, '2026-03-05'),
(3, 2, 1, 5.00, '2026-03-01'),
(4, 2, 2, 2.50, '2026-03-05'),
(5, 1, 2, 3.80, '2026-03-05'),
(6, 1, 3, 4.20, '2026-03-10'),
(7, 2, 1, 5.00, '2026-03-01'),
(8, 2, 2, 2.50, '2026-03-05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `curso`
--

CREATE TABLE `curso` (
  `codigo_curso` int(11) NOT NULL,
  `nombre_curso` varchar(40) NOT NULL,
  `id_nivel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `curso`
--

INSERT INTO `curso` (`codigo_curso`, `nombre_curso`, `id_nivel`) VALUES
(1, 'Sexto Grado A', 3),
(2, 'Séptimo Grado B', 3),
(3, 'Octavo Grado A', 3),
(4, 'Noveno Grado C', 3),
(5, 'Décimo Grado A', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docente`
--

CREATE TABLE `docente` (
  `id_docente` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `especialidad` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `docente`
--

INSERT INTO `docente` (`id_docente`, `id_persona`, `especialidad`) VALUES
(1, 2, 'Matemáticas'),
(2, 5, 'Ciencias Sociales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `id_estudiante` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `codigo_curso` int(11) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id_estudiante`, `id_persona`, `codigo_curso`, `estado`) VALUES
(1, 3, 1, 'ACTIVO'),
(2, 4, 2, 'ACTIVO'),
(3, 6, 1, 'ACTIVO'),
(4, 7, 3, 'ACTIVO'),
(5, 8, 4, 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante_insignia`
--

CREATE TABLE `estudiante_insignia` (
  `id_estudiante` int(11) NOT NULL,
  `id_insignia` int(11) NOT NULL,
  `fecha_obtenido` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiante_insignia`
--

INSERT INTO `estudiante_insignia` (`id_estudiante`, `id_insignia`, `fecha_obtenido`) VALUES
(1, 1, '2026-09-08 09:07:18'),
(2, 1, '2026-09-08 09:07:18'),
(3, 2, '2026-09-08 09:07:18'),
(4, 4, '2026-09-08 09:07:18'),
(5, 3, '2026-09-08 09:07:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_eliminados`
--

CREATE TABLE `historial_eliminados` (
  `id_historial` int(11) NOT NULL,
  `id_estudiante` int(11) DEFAULT NULL,
  `puntos_finales` int(11) DEFAULT NULL,
  `fecha_eliminacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_eliminados`
--

INSERT INTO `historial_eliminados` (`id_historial`, `id_estudiante`, `puntos_finales`, `fecha_eliminacion`) VALUES
(1, 3, 300, '2026-09-08 18:37:14'),
(2, 3, 80, '2026-09-08 18:37:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_pun`
--

CREATE TABLE `historial_pun` (
  `id_historial` int(11) NOT NULL,
  `id_estudiante` int(11) DEFAULT NULL,
  `puntos_anteriores` int(11) DEFAULT NULL,
  `puntos_nuevos` int(11) DEFAULT NULL,
  `fecha_cambio` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_pun`
--

INSERT INTO `historial_pun` (`id_historial`, `id_estudiante`, `puntos_anteriores`, `puntos_nuevos`, `fecha_cambio`) VALUES
(1, 1, 150, 1150, '2026-09-08 18:27:23'),
(2, 1, 120, 1120, '2026-09-08 18:27:23'),
(3, 1, 1150, 2150, '2026-09-08 18:27:26'),
(4, 1, 1120, 2120, '2026-09-08 18:27:26'),
(5, 1, 2150, -97850, '2026-09-08 18:27:57'),
(6, 1, 2120, -97880, '2026-09-08 18:27:57'),
(7, 1, -97850, 2150, '2026-09-08 18:28:13'),
(8, 1, -97880, 2120, '2026-09-08 18:28:13'),
(9, 1, 2150, 30, '2026-09-08 18:28:54'),
(10, 1, 2120, 0, '2026-09-08 18:28:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insignia`
--

CREATE TABLE `insignia` (
  `id_insignia` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(150) NOT NULL,
  `icono_url` varchar(255) DEFAULT NULL,
  `puntos_requeridos` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `insignia`
--

INSERT INTO `insignia` (`id_insignia`, `nombre`, `descripcion`, `icono_url`, `puntos_requeridos`) VALUES
(1, 'Primer Paso', 'Completó su primera actividad de refuerzo', NULL, 10),
(2, 'Constancia de Acero', 'Mantuvo una racha de 5 días seguidos', NULL, 50),
(3, 'Maestro del Saber', 'Alcanzó los 500 puntos de experiencia', NULL, 500),
(4, 'Mente Brillante', 'Obtuvo puntaje perfecto en un reto', NULL, 100),
(5, 'Explorador', 'Completó retos en 3 asignaturas diferentes', NULL, 200);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nivel_educativo`
--

CREATE TABLE `nivel_educativo` (
  `id_nivel` int(11) NOT NULL,
  `nombre_nivel` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `nivel_educativo`
--

INSERT INTO `nivel_educativo` (`id_nivel`, `nombre_nivel`) VALUES
(4, 'Media Académica'),
(5, 'Media Técnica'),
(1, 'Preescolar'),
(2, 'Primaria'),
(3, 'Secundaria');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opcion_respuesta`
--

CREATE TABLE `opcion_respuesta` (
  `codigo_opcion` int(11) NOT NULL,
  `texto_opcion` text NOT NULL,
  `es_correcta` tinyint(1) NOT NULL DEFAULT 0,
  `codigo_pregunta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `opcion_respuesta`
--

INSERT INTO `opcion_respuesta` (`codigo_opcion`, `texto_opcion`, `es_correcta`, `codigo_pregunta`) VALUES
(1, '3/4', 1, 1),
(2, '2/6', 0, 1),
(3, '7', 1, 2),
(4, '5', 0, 2),
(5, '476 d.C.', 1, 3),
(6, '1492 d.C.', 0, 3),
(7, 'Río Magdalena', 1, 4),
(8, 'Río Cauca', 0, 4),
(9, '180 grados', 1, 5),
(10, '360 grados', 0, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_persona` int(11) NOT NULL,
  `num_documento` varchar(15) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `correo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `num_documento`, `nombres`, `apellidos`, `correo`) VALUES
(1, '1277450074', 'Diego Alejandro', 'Herrera Caro', 'diegocruzc@gmail.com'),
(2, '1028943706', 'Daniela', 'Rojas Mancera', 'danialesena@gmail.com'),
(3, '1033456759', 'Alfonso Ian', 'Zapata Torres', 'tzianalfonso@gmail.com'),
(4, '1029288392', 'Jaiber Andres', 'Morales Troya', 'jandresmt@gmail.com'),
(5, '1014253647', 'Carlos Alberto', 'Gómez Ruiz', 'cgomez@gmail.com'),
(6, '1018273645', 'Laura Sofia', 'Mendoza Pérez', 'lmendoza@gmail.com'),
(7, '1027384950', 'Mateo', 'Suárez Castro', 'msuarez@gmail.com'),
(8, '1036475869', 'Valentina', 'López Vargas', 'vlopez@gmail.com'),
(9, '1045566778', 'Santiago', 'Ramírez Hoyos', 'sramirez@gmail.com'),
(10, '1054657687', 'Camila', 'Torres Medina', 'ctorres@gmail.com'),
(11, '1098765432', 'Martha', 'Zapata', 'martha.zapata@gmail.com'),
(12, '1087654321', 'Roberto', 'Morales', 'roberto.morales@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pregunta`
--

CREATE TABLE `pregunta` (
  `codigo_pregunta` int(11) NOT NULL,
  `enunciado` text NOT NULL,
  `tipo_pregunta` varchar(50) NOT NULL DEFAULT 'opcion_multiple',
  `codigo_actividad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pregunta`
--

INSERT INTO `pregunta` (`codigo_pregunta`, `enunciado`, `tipo_pregunta`, `codigo_actividad`) VALUES
(1, '¿Cuánto es 1/2 + 1/4?', 'opcion_multiple', 1),
(2, 'Si X + 5 = 12, ¿cuál es el valor de X?', 'opcion_multiple', 2),
(3, '¿En qué año cayó el Imperio Romano de Occidente?', 'opcion_multiple', 3),
(4, '¿Cuál es el río más largo de Colombia?', 'opcion_multiple', 4),
(5, '¿Cuánto suman los ángulos internos de un triángulo?', 'opcion_multiple', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `progreso`
--

CREATE TABLE `progreso` (
  `id_progreso` int(11) NOT NULL,
  `puntos_acumulados` int(11) NOT NULL DEFAULT 0,
  `nivel_actual` int(11) NOT NULL DEFAULT 1,
  `racha_dias` int(11) NOT NULL DEFAULT 0,
  `id_estudiante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `progreso`
--

INSERT INTO `progreso` (`id_progreso`, `puntos_acumulados`, `nivel_actual`, `racha_dias`, `id_estudiante`) VALUES
(1, 30, 2, 0, 1),
(2, 50, 1, 1, 2),
(4, 120, 2, 2, 4),
(5, 500, 4, 12, 5),
(6, 0, 2, 0, 1),
(7, 450, 4, 12, 2);

--
-- Disparadores `progreso`
--
DELIMITER $$
CREATE TRIGGER `tr_puntos` AFTER UPDATE ON `progreso` FOR EACH ROW begin
if old.puntos_acumulados <> new.puntos_acumulados then
insert into historial_pun (id_estudiante, puntos_anteriores, puntos_nuevos, fecha_cambio)
values (new.id_estudiante,old.puntos_acumulados,new.puntos_acumulados, now());
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_res_progreso` BEFORE DELETE ON `progreso` FOR EACH ROW begin
   
    insert into historial_eliminados (id_estudiante, puntos_finales, fecha_eliminacion)
    values (old.id_estudiante, old.puntos_acumulados, now());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuesta_estudiante`
--

CREATE TABLE `respuesta_estudiante` (
  `id_respuesta` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `codigo_pregunta` int(11) NOT NULL,
  `codigo_opcion` int(11) NOT NULL,
  `es_correcta` tinyint(1) NOT NULL,
  `fecha_respuesta` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `respuesta_estudiante`
--

INSERT INTO `respuesta_estudiante` (`id_respuesta`, `id_estudiante`, `codigo_pregunta`, `codigo_opcion`, `es_correcta`, `fecha_respuesta`) VALUES
(1, 1, 1, 1, 1, '2026-09-08 09:07:18'),
(2, 2, 2, 3, 1, '2026-09-08 09:07:18'),
(3, 3, 3, 5, 1, '2026-09-08 09:07:18'),
(4, 4, 4, 7, 1, '2026-09-08 09:07:18'),
(5, 5, 5, 9, 1, '2026-09-08 09:07:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `nombre_rol`) VALUES
(3, 'Acudiente'),
(4, 'Administrador'),
(5, 'Coordinador'),
(2, 'Docente'),
(1, 'Estudiante');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(250) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `id_persona`, `id_rol`, `nombre_usuario`, `contrasena`, `estado`) VALUES
(1, 1, 4, 'admin_diego', '1234', 'Activo'),
(2, 2, 2, 'prof_daniela', '1234', 'Activo'),
(3, 3, 1, 'ian_z', '1234', 'Activo'),
(4, 4, 1, 'jaiber_m', '1234', 'Activo'),
(5, 5, 2, 'prof_carlos', '1234', 'Activo'),
(6, 6, 1, 'laura_m', '1234', 'Activo'),
(7, 7, 1, 'mateo_s', '1234', 'Activo'),
(8, 8, 1, 'valentina_l', '1234', 'Activo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `actividad_evaluativa`
--
ALTER TABLE `actividad_evaluativa`
  ADD PRIMARY KEY (`codigo_actividad`),
  ADD KEY `fk_actividad_asignatura` (`codigo_asignatura`),
  ADD KEY `fk_actividad_docente` (`id_docente`);

--
-- Indices de la tabla `acudiente`
--
ALTER TABLE `acudiente`
  ADD PRIMARY KEY (`id_acudiente`),
  ADD UNIQUE KEY `id_persona` (`id_persona`);

--
-- Indices de la tabla `acudiente_estudiante`
--
ALTER TABLE `acudiente_estudiante`
  ADD PRIMARY KEY (`id_acudiente`,`id_estudiante`),
  ADD KEY `fk_acuest_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `asignatura`
--
ALTER TABLE `asignatura`
  ADD PRIMARY KEY (`codigo_asignatura`),
  ADD KEY `fk_asignatura_curso` (`codigo_curso`);

--
-- Indices de la tabla `calificacion`
--
ALTER TABLE `calificacion`
  ADD PRIMARY KEY (`id_calificacion`),
  ADD KEY `fk_calificacion_estudiante` (`id_estudiante`),
  ADD KEY `fk_calificacion_actividad` (`codigo_actividad`);

--
-- Indices de la tabla `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`codigo_curso`),
  ADD KEY `fk_curso_nivel` (`id_nivel`);

--
-- Indices de la tabla `docente`
--
ALTER TABLE `docente`
  ADD PRIMARY KEY (`id_docente`),
  ADD UNIQUE KEY `id_persona` (`id_persona`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD UNIQUE KEY `id_persona` (`id_persona`),
  ADD KEY `fk_estudiante_curso` (`codigo_curso`);

--
-- Indices de la tabla `estudiante_insignia`
--
ALTER TABLE `estudiante_insignia`
  ADD PRIMARY KEY (`id_estudiante`,`id_insignia`),
  ADD KEY `fk_estinsig_insignia` (`id_insignia`);

--
-- Indices de la tabla `historial_eliminados`
--
ALTER TABLE `historial_eliminados`
  ADD PRIMARY KEY (`id_historial`);

--
-- Indices de la tabla `historial_pun`
--
ALTER TABLE `historial_pun`
  ADD PRIMARY KEY (`id_historial`);

--
-- Indices de la tabla `insignia`
--
ALTER TABLE `insignia`
  ADD PRIMARY KEY (`id_insignia`);

--
-- Indices de la tabla `nivel_educativo`
--
ALTER TABLE `nivel_educativo`
  ADD PRIMARY KEY (`id_nivel`),
  ADD UNIQUE KEY `nombre_nivel` (`nombre_nivel`);

--
-- Indices de la tabla `opcion_respuesta`
--
ALTER TABLE `opcion_respuesta`
  ADD PRIMARY KEY (`codigo_opcion`),
  ADD KEY `fk_opcion_pregunta` (`codigo_pregunta`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`),
  ADD UNIQUE KEY `num_documento` (`num_documento`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD PRIMARY KEY (`codigo_pregunta`),
  ADD KEY `fk_pregunta_actividad` (`codigo_actividad`);

--
-- Indices de la tabla `progreso`
--
ALTER TABLE `progreso`
  ADD PRIMARY KEY (`id_progreso`),
  ADD KEY `fk_progreso_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `respuesta_estudiante`
--
ALTER TABLE `respuesta_estudiante`
  ADD PRIMARY KEY (`id_respuesta`),
  ADD KEY `fk_resp_estudiante` (`id_estudiante`),
  ADD KEY `fk_resp_pregunta` (`codigo_pregunta`),
  ADD KEY `fk_resp_opcion` (`codigo_opcion`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `id_persona` (`id_persona`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD KEY `fk_usuario_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `actividad_evaluativa`
--
ALTER TABLE `actividad_evaluativa`
  MODIFY `codigo_actividad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `acudiente`
--
ALTER TABLE `acudiente`
  MODIFY `id_acudiente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `asignatura`
--
ALTER TABLE `asignatura`
  MODIFY `codigo_asignatura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `calificacion`
--
ALTER TABLE `calificacion`
  MODIFY `id_calificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `curso`
--
ALTER TABLE `curso`
  MODIFY `codigo_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `docente`
--
ALTER TABLE `docente`
  MODIFY `id_docente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  MODIFY `id_estudiante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `historial_eliminados`
--
ALTER TABLE `historial_eliminados`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `historial_pun`
--
ALTER TABLE `historial_pun`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `insignia`
--
ALTER TABLE `insignia`
  MODIFY `id_insignia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `nivel_educativo`
--
ALTER TABLE `nivel_educativo`
  MODIFY `id_nivel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `opcion_respuesta`
--
ALTER TABLE `opcion_respuesta`
  MODIFY `codigo_opcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `id_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  MODIFY `codigo_pregunta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `progreso`
--
ALTER TABLE `progreso`
  MODIFY `id_progreso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `respuesta_estudiante`
--
ALTER TABLE `respuesta_estudiante`
  MODIFY `id_respuesta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `actividad_evaluativa`
--
ALTER TABLE `actividad_evaluativa`
  ADD CONSTRAINT `fk_actividad_asignatura` FOREIGN KEY (`codigo_asignatura`) REFERENCES `asignatura` (`codigo_asignatura`),
  ADD CONSTRAINT `fk_actividad_docente` FOREIGN KEY (`id_docente`) REFERENCES `docente` (`id_docente`);

--
-- Filtros para la tabla `acudiente`
--
ALTER TABLE `acudiente`
  ADD CONSTRAINT `fk_acudiente_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE CASCADE;

--
-- Filtros para la tabla `acudiente_estudiante`
--
ALTER TABLE `acudiente_estudiante`
  ADD CONSTRAINT `fk_acuest_acudiente` FOREIGN KEY (`id_acudiente`) REFERENCES `acudiente` (`id_acudiente`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_acuest_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`) ON DELETE CASCADE;

--
-- Filtros para la tabla `asignatura`
--
ALTER TABLE `asignatura`
  ADD CONSTRAINT `fk_asignatura_curso` FOREIGN KEY (`codigo_curso`) REFERENCES `curso` (`codigo_curso`);

--
-- Filtros para la tabla `calificacion`
--
ALTER TABLE `calificacion`
  ADD CONSTRAINT `fk_calificacion_actividad` FOREIGN KEY (`codigo_actividad`) REFERENCES `actividad_evaluativa` (`codigo_actividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_calificacion_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `curso`
--
ALTER TABLE `curso`
  ADD CONSTRAINT `fk_curso_nivel` FOREIGN KEY (`id_nivel`) REFERENCES `nivel_educativo` (`id_nivel`);

--
-- Filtros para la tabla `docente`
--
ALTER TABLE `docente`
  ADD CONSTRAINT `fk_docente_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `fk_estudiante_curso` FOREIGN KEY (`codigo_curso`) REFERENCES `curso` (`codigo_curso`),
  ADD CONSTRAINT `fk_estudiante_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `estudiante_insignia`
--
ALTER TABLE `estudiante_insignia`
  ADD CONSTRAINT `fk_estinsig_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_estinsig_insignia` FOREIGN KEY (`id_insignia`) REFERENCES `insignia` (`id_insignia`) ON DELETE CASCADE;

--
-- Filtros para la tabla `opcion_respuesta`
--
ALTER TABLE `opcion_respuesta`
  ADD CONSTRAINT `fk_opcion_pregunta` FOREIGN KEY (`codigo_pregunta`) REFERENCES `pregunta` (`codigo_pregunta`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD CONSTRAINT `fk_pregunta_actividad` FOREIGN KEY (`codigo_actividad`) REFERENCES `actividad_evaluativa` (`codigo_actividad`) ON DELETE CASCADE;

--
-- Filtros para la tabla `progreso`
--
ALTER TABLE `progreso`
  ADD CONSTRAINT `fk_progreso_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`) ON DELETE CASCADE;

--
-- Filtros para la tabla `respuesta_estudiante`
--
ALTER TABLE `respuesta_estudiante`
  ADD CONSTRAINT `fk_resp_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_resp_opcion` FOREIGN KEY (`codigo_opcion`) REFERENCES `opcion_respuesta` (`codigo_opcion`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_resp_pregunta` FOREIGN KEY (`codigo_pregunta`) REFERENCES `pregunta` (`codigo_pregunta`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
