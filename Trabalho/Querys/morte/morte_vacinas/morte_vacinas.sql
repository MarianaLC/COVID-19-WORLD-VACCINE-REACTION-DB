-- Morte e vacina
-- 1. Percentagem de mortes associadas a cada marca de vacina
SELECT f.vax_manu, (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) 
FROM fornecedor f, paciente p, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL))*100 AS percentagem_mortes
FROM fornecedor f, paciente p, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL
GROUP BY f.vax_manu
ORDER BY percentagem_mortes DESC;

DELIMITER $$
CREATE PROCEDURE MORTE_VACINAS(vacina VARCHAR (45))
BEGIN
	SELECT (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) FROM vacina v, fornecedor f, vacinar vr, paciente p 
	WHERE f.vax_manu = vacina AND f.idfornecedor = v.idfornecedor
	AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers))*100 AS percentagem_mortes_moderna
	FROM vacina v, fornecedor f, vacinar vr, paciente p 
	WHERE f.vax_manu = vacina AND f.idfornecedor = v.idfornecedor
	AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers  AND p.data_died IS NOT NULL;
	
END $$
DELIMITER ;

-- 2. Percentagem de mortes provocadas pela vacina MODERNA
CALL MORTE_VACINAS ('MODERA');

-- 3. Percentagem de mortes provocadas pela vacina PFIZER\\BIOTECH
CALL MORTE_VACINAS ('PFIZER\\BIOTECH');

-- 4. Percentagem de mortes provocadas pela vacina JASSE
CALL MORTE_VACINAS ('JASSE');

-- 5. Lote de vacina que provocou mais mortes e de que marca é
SELECT v.vax_lot, f.vax_manu, (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers)
FROM vacina v, fornecedor f, vacinar vr, paciente p
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL
AND vax_lot IS NOT NULL))*100 AS percentagem_mortes
FROM vacina v, fornecedor f, vacinar vr, paciente p
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL
AND vax_lot IS NOT NULL
GROUP BY v.vax_lot
ORDER BY percentagem_mortes DESC
LIMIT 10;
