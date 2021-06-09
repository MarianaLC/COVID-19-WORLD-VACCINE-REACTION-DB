-- Indicadores de saúde da amostra
-- 1. Percentagem de pacientes que tiveram sintomas
SELECT ((SELECT COUNT(DISTINCT(id_vaers)) FROM sintomas_afeta_paciente)/COUNT(*))*100 AS percentagem_sintomas FROM paciente p;

-- 3. 10 Sintomas mais frequentes associados à vacinação
SELECT s.idsintoma, s.designacao, (COUNT(vr.id_vaers)/(SELECT COUNT(vr.id_vaers) FROM vacinar vr, paciente p
WHERE p.id_vaers = vr.id_vaers))*100 AS percentagem_pacientes
FROM vacina v, vacinar vr, vacina_causa_sintomas vcs, sintomas s
WHERE v.idvacina = vr.idvacina
AND v.idvacina = vcs.idvacina
AND s.idsintoma = vcs.idsintoma
GROUP BY s.designacao
ORDER BY percentagem_pacientes DESC
LIMIT 10;

-- 4. Percentagem de pacientes que ficaram hospitalizados
SELECT ((SELECT COUNT(DISTINCT(p.id_vaers)) FROM  paciente p, paciente_e_hospitalizado ph, hospitalizacao h
WHERE p.id_vaers = ph.id_vaers
AND h.idhospitalizacao = ph.idhospitalizacao
AND ph.hospdays IS NOT NULL)/count(*))*100 AS percentagem_hospitalizacoes FROM paciente p;

-- 5. Top 10 dos dias que as pessoas ficaram hospitalizadas
SELECT hp.hospdays
FROM paciente p, hospitalizacao h, paciente_e_hospitalizado hp
WHERE p.id_vaers = hp.id_Vaers
AND hp.idhospitalizacao = h.idhospitalizacao
ORDER BY hp.hospdays DESC
LIMIT 10;

-- 6. Percentagem de pacientes que faleceram
SELECT ((SELECT COUNT(*) FROM paciente WHERE data_died IS NOT NULL)/COUNT(*))*100 AS percentagem_mortes FROM paciente;

-- 7. Top 3 das patologias mais frequentes
SELECT DISTINCT h.designacao, (COUNT(p.id_vaers)/(SELECT COUNT(vr.id_vaers) FROM vacinar vr, paciente p
WHERE p.id_vaers = vr.id_vaers))*100 AS percentagem_pacientes
FROM paciente p, historico_clinico h, doenca_afeta_paciente d
WHERE p.id_vaers = d.id_vaers
AND d.iddoenca = h.iddoenca
GROUP BY h.designacao
ORDER BY percentagem_pacientes DESC
LIMIT 3;

-- 8. Percentagem de pacientes que têm doenças
SELECT ((SELECT COUNT(DISTINCT(d.id_vaers)) FROM  paciente p, doenca_afeta_paciente d, historico_clinico h
WHERE p.id_vaers = d.id_vaers AND h.iddoenca = d.iddoenca)/COUNT(*))*100 AS percentagem_doencas FROM paciente p;