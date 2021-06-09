-- Indicadores das vacinas
-- 1. 3 marcas de vacina mais inoculadas
SELECT f.vax_manu, (COUNT(vr.idvacina)/(SELECT COUNT(vr.idvacina) 
FROM fornecedor f, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina))*100 AS percentagem_vacinas_inoculadas
FROM fornecedor f, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
GROUP BY f.vax_manu
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;

-- 2. 3 lotes de vacinas mais frequentes e respetivos fornecedores desses lotes
SELECT f.vax_manu, v.vax_lot, (COUNT(vr.idvacina)/(SELECT COUNT(vr.idvacina) 
FROM fornecedor f, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina))*100 AS percentagem_vacinas_inoculadas
FROM fornecedor f, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND v.vax_lot IS NOT NULL
GROUP BY v.vax_lot
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;

-- -----------------------------------------------------------------------------------------------------------------------
-- Indicadores da vacinação
-- 1. Número de doses de vacinas mais frequente e de que vacina
SELECT f.vax_manu, vr.vax_dose_series, (COUNT(vr.idvacina)/(SELECT COUNT(vr.idvacina)
FROM fornecedor f, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND vr.vax_dose_series IS NOT NULL))*100 AS percentagem_vacinas_inoculadas
FROM fornecedor f, vacina v, vacinar vr
WHERE f.idfornecedor = v.idfornecedor
AND v.idvacina = vr.idvacina
AND vr.vax_dose_series IS NOT NULL
GROUP BY vr.vax_dose_series
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;

-- 2. 3 formas mais comuns de aplicar a vacina
SELECT vr.vax_route, (COUNT(vr.idvacina)/(SELECT COUNT(vr.idvacina)
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
AND vr.vax_route IS NOT NULL))*100 AS percentagem_vacinas_inoculadas
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
AND vr.vax_route IS NOT NULL
GROUP BY vr.vax_route
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;

-- 3. 3 locais mais comuns onde foram aplicadas as vacinas no corpo
SELECT vr.vax_site,(COUNT(vr.idvacina) /(SELECT COUNT(vr.idvacina)
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
AND vr.vax_site IS NOT NULL))*100 AS percentagem_vacinas_inoculadas
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
AND vr.vax_site IS NOT NULL
GROUP BY vr.vax_site
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;

-- 4. 3 locais mais comuns onde foram aplicadas as vacinas (instituições)
SELECT vr.v_adminby,(COUNT(vr.idvacina)/(SELECT COUNT(vr.idvacina)
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
AND vr.v_adminby IS NOT NULL))*100 AS percentagem_vacinas_inoculadas
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
AND vr.v_adminby IS NOT NULL
GROUP BY vr.v_adminby
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;

-- 5. 3 meses em que ocorreram mais vacinações
SELECT MONTH(vr.vax_date) AS mes,(COUNT(vr.idvacina)/(SELECT COUNT(vr.idvacina)
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina))*100 AS percentagem_vacinas_inoculadas
FROM vacina v, vacinar vr
WHERE v.idvacina = vr.idvacina
GROUP BY mes
ORDER BY percentagem_vacinas_inoculadas DESC
LIMIT 3;