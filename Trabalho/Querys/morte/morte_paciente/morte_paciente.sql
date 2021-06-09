-- Morte e pacientes
DELIMITER $$
CREATE PROCEDURE MORTE_PACIENTES_SEXO(sexo VARCHAR (45))
BEGIN
	SELECT (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers)
	FROM vacinar vr, paciente p
	WHERE vr.id_vaers = p.id_vaers AND p.sex = sexo))*100 AS percentagem_mortes
	FROM vacinar vr, paciente p WHERE vr.id_vaers = p.id_vaers
	AND p.sex = sexo AND p.data_died IS NOT NULL;
	
END $$
DELIMITER ;

-- 1. Percentagem de mulheres que morrerem
CALL MORTE_PACIENTES_SEXO ('F');

-- 2. Percentagem de homens que morrerem
CALL MORTE_PACIENTES_SEXO ('M');

DELIMITER $$
CREATE PROCEDURE MORTE_PACIENTES_IDADE(menor INT, maior INT)
BEGIN
	DECLARE percentagem_mortes FLOAT DEFAULT NULL;

	IF (menor IS NOT NULL AND maior IS NULL)
		THEN SET percentagem_mortes = (SELECT (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) FROM vacinar vr, paciente p
		WHERE vr.id_vaers = p.id_vaers AND  age_yrs <= menor))*100 AS percentagem_mortes
		FROM vacinar vr, paciente p WHERE vr.id_vaers = p.id_vaers AND age_yrs <= menor AND p.data_died IS NOT NULL);
    
	ELSEIF (menor IS NOT NULL AND maior IS NOT NULL)
		THEN SET percentagem_mortes = (SELECT (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) FROM vacinar vr, paciente p
		WHERE vr.id_vaers = p.id_vaers AND age_yrs > menor AND age_yrs <= maior))*100 AS percentagem_mortes FROM vacinar vr, paciente p
		WHERE vr.id_vaers = p.id_vaers AND age_yrs > menor AND age_yrs <= maior AND p.data_died IS NOT NULL);
			
	ELSEIF (menor IS NULL AND maior IS NOT NULL)
		THEN SET percentagem_mortes = (SELECT (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) FROM vacinar vr, paciente p
		WHERE vr.id_vaers = p.id_vaers AND  age_yrs > maior))*100 AS percentagem_mortes
		FROM vacinar vr, paciente p WHERE vr.id_vaers = p.id_vaers AND age_yrs <> maior AND p.data_died IS NOT NULL);
    END IF;
SELECT percentagem_mortes;
	
END $$
DELIMITER ;

-- 3. Percentagem de bebés que morreram
CALL MORTE_PACIENTES_IDADE (1,NULL);

-- 4. Percentagem de crianças que morreram
CALL MORTE_PACIENTES_IDADE (1,12);

-- 5. Percentagem de adolescentes que morreram
CALL MORTE_PACIENTES_IDADE (12,16);

-- 6. Percentagem de jovens que morreram
CALL MORTE_PACIENTES_IDADE (16,25);

-- 7. Percentagem de adultos que morreram
CALL MORTE_PACIENTES_IDADE (25,65);

-- 8. Percentagem de idosos que morreram
CALL MORTE_PACIENTES_IDADE (NULL,65);