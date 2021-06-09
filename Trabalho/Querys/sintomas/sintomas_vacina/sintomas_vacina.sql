-- Sintomas
-- Relação sintomas - vacinas
DELIMITER $$
CREATE PROCEDURE SINTOMAS_VACINA(vacina VARCHAR (45))
BEGIN
	SELECT s.idsintoma, s.designacao, (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) 
	FROM sintomas s, paciente p, doenca_afeta_paciente d, historico_clinico h, vacina v, 
    vacinar vr, vacina_causa_sintomas vcs, fornecedor f
	WHERE s.idsintoma = vcs.idsintoma AND v.idvacina = vcs.idvacina
	AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers
	AND p.id_vaers = d.id_vaers AND d.iddoenca = h.iddoenca
	AND f.idfornecedor = v.idfornecedor AND f.vax_manu = vacina))*100 AS percentagem_pacientes
	FROM sintomas s, paciente p, doenca_afeta_paciente d, historico_clinico h,
	vacina v, vacinar vr, vacina_causa_sintomas vcs, fornecedor f
	WHERE s.idsintoma = vcs.idsintoma AND v.idvacina = vcs.idvacina
	AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers
	AND p.id_vaers = d.id_vaers AND d.iddoenca = h.iddoenca
	AND f.idfornecedor = v.idfornecedor AND f.vax_manu = vacina
	GROUP BY s.designacao ORDER BY percentagem_pacientes DESC LIMIT 10;

END $$
DELIMITER ;

-- 1. Quais os sintomas mais frequentes nas pessoas que tomaram vacina da MODERNA?
CALL SINTOMAS_VACINA ('MODERA');

-- 2. Quais os sintomas mais frequentes nas pessoas que tomaram vacina da PFIZER\\BIOTECH?
CALL SINTOMAS_VACINA ('PFIZER\\BIOTECH');

-- 3. Quais os sintomas mais frequentes nas pessoas que tomaram vacina da JASSE?
CALL SINTOMAS_VACINA ('JASSE');

-- 4. Lote de vacina que provocou mais sintomas e de que marca é
SELECT v.vax_lot, f.vax_manu, (COUNT(vc.idsintoma)/(SELECT COUNT(vc.idsintoma)
FROM vacina v, fornecedor f, vacina_causa_sintomas vc
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vc.idvacina
AND vax_lot IS NOT NULL))*100 AS percentagem_sintomas
FROM vacina v, fornecedor f, vacina_causa_sintomas vc
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vc.idvacina
AND vax_lot IS NOT NULL
GROUP BY v.vax_lot
ORDER BY percentagem_sintomas DESC
LIMIT 10;