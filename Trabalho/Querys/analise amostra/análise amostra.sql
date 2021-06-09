-- Análise da amostra
-- Pacientes
-- 1. Número de pacientes da amostra
SELECT COUNT(*) FROM paciente;

-- 2. Sexo predominante
SELECT ((SELECT COUNT(*) FROM paciente WHERE sex = 'F')/COUNT(*))*100 AS percentagem_mulheres FROM paciente;
SELECT ((SELECT COUNT(*) FROM paciente WHERE sex = 'M')/COUNT(*))*100 AS percentagem_homens FROM paciente;

-- 3. Percentagem de bebés, crianças, adolescentes, jovens, adultos e idosos
DELIMITER $$
CREATE PROCEDURE PERCENTAGEM_GRUPO_PACIENTES(menor INT,maior INT)
BEGIN
    DECLARE percentagem FLOAT DEFAULT NULL;

	IF (menor IS NOT NULL AND maior IS NULL)
		THEN SET percentagem = (SELECT ((SELECT COUNT(*) FROM paciente WHERE age_yrs <= menor)/COUNT(*))*100 FROM paciente);
    
	ELSEIF (menor IS NOT NULL AND maior IS NOT NULL)
		THEN SET percentagem = (SELECT ((SELECT COUNT(*) FROM paciente WHERE age_yrs > menor AND age_yrs <= maior)/COUNT(*))*100  
        FROM paciente);
    
	ELSEIF (menor IS NULL AND maior IS NOT NULL)
		THEN SET percentagem = (SELECT ((SELECT COUNT(*) FROM paciente WHERE age_yrs > maior)/COUNT(*))*100  FROM paciente);
    END IF;
SELECT percentagem;
END $$
DELIMITER ;

-- Percentagem de bebés
CALL PERCENTAGEM_GRUPO_PACIENTES(1, NULL);

-- Percentagem de crianças
CALL PERCENTAGEM_GRUPO_PACIENTES(1, 12);

-- Percentagem de adolescentes
CALL PERCENTAGEM_GRUPO_PACIENTES(12, 16);

-- Percentagem de jovens
CALL PERCENTAGEM_GRUPO_PACIENTES(16, 25);

-- Percentagem de adultos
CALL PERCENTAGEM_GRUPO_PACIENTES(25, 65);

-- Percentagem de idosos
CALL PERCENTAGEM_GRUPO_PACIENTES(NULL, 65);

-- 4. 3 estados americanos mais frequentes na amostra
SELECT state, (COUNT(id_vaers)/(SELECT COUNT(id_vaers) FROM paciente))*100 AS percentagem_pacientes FROM paciente 
WHERE state IS NOT NULL
GROUP BY state ORDER BY percentagem_pacientes DESC LIMIT 3;
