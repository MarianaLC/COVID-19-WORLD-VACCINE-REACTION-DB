-- Morte
-- Análise da morte com os sintomas
-- 1. Quais os sintomas mais frequentes comuns às pessoas que morreram?
SELECT s.idsintoma, s.designacao, (COUNT(p.data_died)/(SELECT COUNT(p.data_died)
FROM sintomas s, paciente p, vacina v, vacinar vr, vacina_causa_sintomas vcs
WHERE s.idsintoma = vcs.idsintoma
AND v.idvacina = vcs.idvacina
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL))*100 AS percentagem_mortes
FROM sintomas s, paciente p, vacina v, vacinar vr, vacina_causa_sintomas vcs
WHERE s.idsintoma = vcs.idsintoma
AND v.idvacina = vcs.idvacina
AND v.idvacina = vr.idvacina
AND vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL
GROUP BY s.designacao
ORDER BY percentagem_mortes DESC
LIMIT 11;

-- Função Diferença
DELIMITER $$
CREATE FUNCTION Diferenca (data_o date, data_m date)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN TIMESTAMPDIFF(DAY, data_o, data_m);
END $$ 
DELIMITER ;


