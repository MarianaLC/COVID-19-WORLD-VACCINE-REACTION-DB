-- Sintomas
-- Relação sintomas - patologias
DELIMITER $$
CREATE PROCEDURE SINTOMAS_PATOLOGIAS(doenca VARCHAR (45))
BEGIN
	SELECT s.idsintoma, s.designacao, (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) 
	FROM sintomas s, paciente p, doenca_afeta_paciente d, historico_clinico h, vacina v, vacinar vr, vacina_causa_sintomas vcs
	WHERE s.idsintoma = vcs.idsintoma AND v.idvacina = vcs.idvacina
	AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers
	AND p.id_vaers = d.id_vaers AND d.iddoenca = h.iddoenca
	AND h.designacao = doenca))*100 AS percentagem_pacientes
	FROM sintomas s, paciente p, doenca_afeta_paciente d, historico_clinico h, vacina v, vacinar vr, vacina_causa_sintomas vcs
	WHERE s.idsintoma = vcs.idsintoma AND v.idvacina = vcs.idvacina 
    AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers
	AND p.id_vaers = d.id_vaers AND d.iddoenca = h.iddoenca AND h.designacao = doenca
	GROUP BY s.designacao ORDER BY percentagem_pacientes DESC LIMIT 10;

END $$
DELIMITER ;

-- 1. Quais os sintomas mais frequentes que pessoas que já tiveram COVID-19 tiveram?
CALL SINTOMAS_PATOLOGIAS ('COVID-19');

-- 2. Quais os sintomas mais frequentes que pessoas com obesidade tiveram?
CALL SINTOMAS_PATOLOGIAS ('Obesity');

-- 3. Quais os sintomas mais frequentes que pessoas com colesterol elevado tiveram?
CALL SINTOMAS_PATOLOGIAS ('High_Cholesterol');

-- 4. Quais os sintomas mais frequentes que pessoas com pressão alta tiveram?
CALL SINTOMAS_PATOLOGIAS ('High_Blood_Pressure');

-- 5. Quais os sintomas mais frequentes que pessoas com MIGRAINES tiveram?
CALL SINTOMAS_PATOLOGIAS ('MIGRAINES');

-- 6. Quais os sintomas mais frequentes que pessoas com GERD tiveram?
CALL SINTOMAS_PATOLOGIAS ('GERD');

-- 7. Quais os sintomas mais frequentes que pessoas com depressão tiveram?
CALL SINTOMAS_PATOLOGIAS ('Depression');

-- 8. Quais os sintomas mais frequentes que pessoas com ansiedade tiveram?
CALL SINTOMAS_PATOLOGIAS ('Anxiety');

-- 9. Quais os sintomas mais frequentes que pessoas com osteoartrite tiveram?
CALL SINTOMAS_PATOLOGIAS ('Osteoarthritis');

-- 10. Quais os sintomas mais frequentes que pessoas com hipotireoidismo tiveram?
CALL SINTOMAS_PATOLOGIAS ('Hypothyroidism');

-- 11. Quais os sintomas mais frequentes que pessoas com hipertensão tiveram?
CALL SINTOMAS_PATOLOGIAS ('Hypertension');

-- 12. Quais os sintomas mais frequentes que pessoas com asma tiveram?
CALL SINTOMAS_PATOLOGIAS ('Asthma');

-- 13. Quais os sintomas mais frequentes que pessoas com hiperlipidemia tiveram?
CALL SINTOMAS_PATOLOGIAS ('Hyperlipidemia');

-- 14. Quais os sintomas mais frequentes que pessoas com doença de risco tiveram?
CALL SINTOMAS_PATOLOGIAS ('L_threat');

-- 15. Quais os sintomas mais frequentes que pessoas com deficiência tiveram?
CALL SINTOMAS_PATOLOGIAS ('Disable');
