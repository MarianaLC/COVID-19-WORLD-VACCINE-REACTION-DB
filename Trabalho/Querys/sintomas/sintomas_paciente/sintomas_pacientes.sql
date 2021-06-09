-- Sintomas
-- Relação sintomas - paciente
-- 1. Tempo médio que decorreu entre início sintomas e data de vacinação
SELECT AVG(inicio_sintomas) AS tempo_medio_inicio_sintomas
FROM (SELECT DISTINCT p.id_vaers, Diferenca(vr.vax_date, sa.onset_date) AS inicio_sintomas
FROM paciente p, sintomas_afeta_paciente sa, vacinar vr
WHERE p.id_vaers = sa.id_vaers
AND vr.id_vaers = p.id_vaers
ORDER BY inicio_sintomas DESC) a1;

-- 2. Número médio de dias que os sintomas persistiram
SELECT AVG(duracao_sintomas) AS tempo_medio_duracao_sintomas 
FROM (SELECT DISTINCT p.id_vaers, sa.numdays AS duracao_sintomas
FROM paciente p, sintomas_afeta_paciente sa
WHERE p.id_vaers = sa.id_vaers
AND sa.numdays IS NOT NULL
ORDER BY duracao_sintomas DESC) a1;

-- 3. Percentagem de pacientes que recuperaram completamente dos sintomas
SELECT (COUNT(DISTINCT(sa.id_vaers))/(SELECT COUNT(*) FROM paciente p))*100 AS percentagem_recuperados
FROM sintomas_afeta_paciente sa
WHERE sa.recovd = 'Y';
