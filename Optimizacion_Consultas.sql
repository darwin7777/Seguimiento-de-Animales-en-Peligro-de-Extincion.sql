USE g4_conservacion;

-- OPTIMIZACIÓN DE CONSULTAS
-- ¿Qué especies tienen mayor declive poblacional? 
EXPLAIN
SELECT 
    e.nombre_cientifico,
    e.nombre_comun,
    ee.region,
    ec.nombre AS estado
FROM Especie e
JOIN Especie_Estado ee 
	ON e.especie_id = ee.especie_id
JOIN EstadoConservacion ec 
	ON ee.estado_codigo = ec.estado_codigo
WHERE ec.estado_codigo = 'EP' and ee.region = "Global";
-- Crear índice para optimizar la búsqueda
CREATE INDEX idx_estado_region ON Especie_Estado (estado_codigo, region);

-- ¿Qué regiones tienen mayor biodiversidad? 
EXPLAIN
SELECT eu.region, COUNT(DISTINCT e.especie_id) AS total_especies
FROM Especie_Ubicacion eu
JOIN Especie e 
	ON eu.especie_id = e.especie_id
GROUP BY eu.region
ORDER BY total_especies DESC;
-- Crear índice para optimizar la búsqueda
CREATE INDEX idx_region ON Especie_Ubicacion (region);


-- ¿Qué amenazas son más comunes para cada especie? 
EXPLAIN
SELECT 
    e.nombre_cientifico,
    e.nombre_comun,
    a.categoria AS amenaza,
    ea.impacto,
    COUNT(*) AS veces
FROM Especie e
JOIN Especies_Amenazas_Registro ear 
    ON e.especie_id = ear.especie_id
JOIN Amenaza a 
    ON ear.amenaza_id = a.amenaza_id
JOIN Especies_Amenazas ea 
    ON e.especie_id = ea.especie_id 
   AND a.amenaza_id = ea.amenaza_id
GROUP BY e.especie_id, ear.amenaza_id, ea.impacto
ORDER BY e.especie_id, veces DESC;
-- Crear índice para optimizar la búsqueda
CREATE INDEX idx_especie_amenaza 
ON Especies_Amenazas_Registro (especie_id, amenaza_id);


