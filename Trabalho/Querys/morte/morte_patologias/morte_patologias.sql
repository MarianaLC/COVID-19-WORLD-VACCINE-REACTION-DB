-- Morte e patologias
-- 1. Percentagem de pessoas que morreram com as patologias mais frequentes 
SELECT h.iddoenca, h.designacao, (COUNT(d.iddoenca)/(SELECT COUNT(d.iddoenca)
FROM historico_clinico h, paciente p, doenca_afeta_paciente d
WHERE h.iddoenca = d.iddoenca
AND p.id_vaers = d.id_vaers
AND p.data_died IS NOT NULL))*100 AS percentagem_patologias
FROM historico_clinico h, paciente p, doenca_afeta_paciente d
WHERE h.iddoenca = d.iddoenca
AND p.id_vaers = d.id_vaers
AND p.data_died IS NOT NULL
GROUP BY h.designacao
ORDER BY percentagem_patologias DESC
LIMIT 10;
