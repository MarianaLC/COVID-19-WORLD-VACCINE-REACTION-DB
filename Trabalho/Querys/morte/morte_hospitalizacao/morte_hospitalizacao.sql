-- Morte e hospitalização
-- 1. Percentagem de pessoas que morreram que foram às urgências ou receberam visita do médico
SELECT (COUNT(p.data_died)/(SELECT COUNT(*) FROM paciente WHERE data_died IS NOT NULL))*100 AS percentagem_mortes
FROM  paciente p, hospitalizacao h, paciente_e_hospitalizado hp
WHERE p.id_vaers = hp.id_vaers
AND hp.idhospitalizacao = h.idhospitalizacao
AND (h.er_ed_visit = 'Yes' OR h.ofc_visit = 'Yes')
AND p.data_died IS NOT NULL;

-- 2. Número médio de dias que as pessoas que morreram ficaram hospitalizadas
SELECT AVG(dias_hospitalizacao) AS tempo_medio_hospitalizacao
FROM (SELECT hp.hospdays AS dias_hospitalizacao
FROM  paciente p, hospitalizacao h, paciente_e_hospitalizado hp
WHERE p.id_vaers = hp.id_vaers
AND hp.idhospitalizacao = h.idhospitalizacao
AND p.data_died IS NOT NULL
AND hp.hospdays IS NOT NULL) a1;

-- 3. Número médio de dias que as pessoas que não morreram ficaram hospitalizadas
SELECT AVG(dias_hospitalizacao) AS tempo_medio_hospitalizacao
FROM (SELECT hp.hospdays AS dias_hospitalizacao
FROM  paciente p, hospitalizacao h, paciente_e_hospitalizado hp
WHERE p.id_vaers = hp.id_vaers
AND hp.idhospitalizacao = h.idhospitalizacao
AND p.data_died IS NULL
AND hp.hospdays IS NOT NULL) a1;