-- Morte e vacinação
-- 1. Tempo médio que decorreu entre a vacinação e a morte
SELECT AVG(tempo_ate_morte) AS tempo_medio_ate_morrer
FROM (SELECT DISTINCT p.id_vaers, Diferenca(vr.vax_date, p.data_died) AS tempo_ate_morte
FROM paciente p, vacinar vr
WHERE p.data_died IS NOT NULL 
AND p.id_vaers = vr.id_vaers
ORDER BY tempo_ate_morte DESC) a1;

-- Percentagem dos doentes que morreram por nº de doses de vacinas que tomaram
SELECT vr.vax_dose_series, (COUNT(p.id_vaers)/(SELECT COUNT(p.id_vaers)
FROM paciente p, vacinar vr
WHERE vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL AND vr.vax_dose_series IS NOT NULL))*100 AS percentagem_pacientes
FROM paciente p, vacinar vr
WHERE vr.id_vaers = p.id_vaers
AND p.data_died IS NOT NULL AND vr.vax_dose_series IS NOT NULL
GROUP BY vr.vax_dose_series
ORDER BY percentagem_pacientes;