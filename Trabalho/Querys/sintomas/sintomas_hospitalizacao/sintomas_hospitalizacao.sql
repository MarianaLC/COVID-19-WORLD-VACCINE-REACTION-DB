-- Sintomas
-- Relação sintomas - hospitalizacao
DELIMITER $$
CREATE PROCEDURE SINTOMAS_HOSPITALIZACAO(urgencias VARCHAR (45), medico VARCHAR (45))
BEGIN

	SELECT s.idsintoma AS idsintoma, s.designacao AS designacao, (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers)
	FROM sintomas s, paciente p, hospitalizacao h, paciente_e_hospitalizado hp, vacina v, vacinar vr, vacina_causa_sintomas vcs
	WHERE s.idsintoma = vcs.idsintoma AND v.idvacina = vcs.idvacina
	AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers
	AND p.id_vaers = hp.id_vaers AND hp.idhospitalizacao = h.idhospitalizacao
	AND h.er_ed_visit = urgencias AND h.ofc_visit = medico))*100 AS percentagem_pacientes
	FROM sintomas s, paciente p, hospitalizacao h, paciente_e_hospitalizado hp, vacina v, vacinar vr, vacina_causa_sintomas vcs
	WHERE s.idsintoma = vcs.idsintoma AND v.idvacina = vcs.idvacina AND v.idvacina = vr.idvacina AND vr.id_vaers = p.id_vaers 
    AND p.id_vaers = hp.id_vaers AND hp.idhospitalizacao = h.idhospitalizacao
    AND h.er_ed_visit = urgencias AND h.ofc_visit = medico
	GROUP BY s.designacao ORDER BY percentagem_pacientes DESC LIMIT 10;

END $$
DELIMITER ;

drop PROCEDURE SINTOMAS_HOSPITALIZACAO;

-- 1. Quais os sintomas que as pessoas que foram às urgências e receberam visita do médico tinham?
CALL SINTOMAS_HOSPITALIZACAO ('Yes', 'Yes');

-- 2. Quais os sintomas que as pessoas que foram às urgências mas não receberam visita do médico tinham?
CALL SINTOMAS_HOSPITALIZACAO ('Yes', 'No');

-- 3. Quais os sintomas que as pessoas que não foram às urgências mas receberam visita do médico tinham?
CALL SINTOMAS_HOSPITALIZACAO ('No', 'Yes');

-- 4. Quais os sintomas que as pessoas que não foram às urgências nem receberam visita do médico tinham?
CALL SINTOMAS_HOSPITALIZACAO ('No', 'No');

-- 5. Quais os sintomas que as pessoas que ficaram mais tempo hospitalizadas tinham?
SELECT s.idsintoma, s.designacao
FROM sintomas s, paciente p, hospitalizacao h, paciente_e_hospitalizado hp,
vacina v, vacinar vr, vacina_causa_sintomas vcs
WHERE s.idsintoma = vcs.idsintoma
AND v.idvacina = vcs.idvacina
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.id_vaers = hp.id_vaers
AND hp.idhospitalizacao = h.idhospitalizacao
AND (hp.hospdays = 39 OR hp.hospdays = 38 OR hp.hospdays = 37);