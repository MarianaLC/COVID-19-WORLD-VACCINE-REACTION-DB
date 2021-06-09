-- Povoamento
-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela fornecedor
INSERT INTO fornecedor (vax_manu)
SELECT DISTINCT VAX_MANU FROM trabalho_covid.temp_do_fornecedor WHERE VAX_MANU IS NOT NULL;
SELECT * FROM fornecedor;

-- ---------------------------------------------------------------------------------------------------------------------
-- Tabela paciente
INSERT INTO paciente (id_vaers, state, sex, age_yrs, data_died)
SELECT VAERS_ID, STATE, SEX, AGE_YRS, DATEDIED FROM trabalho_covid.temp_dos_pacientes WHERE VAERS_ID IS NOT NULL;
SELECT * FROM paciente;

-- ---------------------------------------------------------------------------------------------------------------------
-- Tabela vacina
INSERT INTO vacina (vax_lot, idfornecedor)
SELECT v.VAX_LOT, f.idfornecedor
FROM fornecedor f, trabalho_covid.temp_do_fornecedor t, trabalho_covid.temp_das_vacinas v
WHERE v.VAERS_ID = t.VAERS_ID
AND  t.VAX_MANU = f.vax_manu;
SELECT * FROM vacina;

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela vacinar
INSERT INTO vacinar (idvacina, id_vaers, vax_date, vax_dose_series, vax_route, vax_site, v_adminby)
SELECT v.idvacina, p.id_vaers, va.VAX_DATE, vac.VAX_DOSE_SERIES, vac.VAX_ROUTE, vac.VAX_SITE, h.V_ADMINBY
FROM vacina v, paciente p, trabalho_covid.temp_vacinar va, trabalho_covid.temp_das_vacinas vac, 
trabalho_covid.temp_do_historico h
WHERE va.VAERS_ID = p.id_vaers
AND vac.VAERS_ID = p.id_vaers
AND h.VAERS_ID = p.id_vaers
AND v.idvacina = vac.idvacina;
SELECT * FROM vacinar;

-- ---------------------------------------------------------------------------------------------------------------------
--  Tabela histórico clínico
INSERT INTO historico_clinico (designacao) VALUE ('Obesity');
INSERT INTO historico_clinico (designacao) VALUE ('High_Cholesterol');
INSERT INTO historico_clinico (designacao) VALUE ('High_Blood_Pressure');
INSERT INTO historico_clinico (designacao) VALUE ('Migraines');
INSERT INTO historico_clinico (designacao) VALUE ('GERD');
INSERT INTO historico_clinico (designacao) VALUE ('Depression');
INSERT INTO historico_clinico (designacao) VALUE ('Anxiety');
INSERT INTO historico_clinico (designacao) VALUE ('Osteoarthritis');
INSERT INTO historico_clinico (designacao) VALUE ('Hypothyroidism');
INSERT INTO historico_clinico (designacao) VALUE ('Hypertension');
INSERT INTO historico_clinico (designacao) VALUE ('Asthma');
INSERT INTO historico_clinico (designacao) VALUE ('Hyperlipidemia');
INSERT INTO historico_clinico (designacao) VALUE ('L_threat');
INSERT INTO historico_clinico (designacao) VALUE ('COVID-19');
INSERT INTO historico_clinico (designacao) VALUE ('Disable');
SELECT * FROM historico_clinico;

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela doenca_afeta_paciente
INSERT INTO doenca_afeta_paciente (iddoenca, id_vaers)
SELECT h.iddoenca, p.id_vaers
FROM historico_clinico h, paciente p, trabalho_covid.temp_da_doenca d, trabalho_covid.temp_do_historico ho
WHERE p.id_vaers = d.VAERS_ID
AND p.id_vaers = ho.VAERS_ID
AND (h.designacao = 'Obesity' AND ho.Obesity = 'Yes'
OR h.designacao = 'High_Cholesterol' AND ho.High_Cholesterol = 'Yes'
OR h.designacao = 'High_Blood_Pressure' AND ho.High_Blood_Pressure = 'Yes'
OR h.designacao = 'Migraines' AND ho.Migraines = 'Yes'
OR h.designacao = 'GERD' AND ho.GERD = 'Yes'
OR h.designacao = 'Depression' AND ho.Depression= 'Yes'
OR h.designacao = 'Anxiety' AND ho.Anxiety = 'Yes'
OR h.designacao = 'Osteoarthritis' AND ho.Osteoarthritis = 'Yes'
OR h.designacao = 'Hypothyroidism' AND ho.Hypothyroidism = 'Yes'
OR h.designacao = 'Hypertension' AND ho.Hypertension = 'Yes'
OR h.designacao = 'Hyperlipidemia' AND ho.Hypertension = 'Yes'
OR h.designacao = 'Asthma' AND ho.Asthma = 'Yes'
OR h.designacao = 'L_threat' AND ho.L_threat = 'Y'
OR h.designacao = 'Disable' AND d.Disable = 'Y'
OR h.designacao = 'COVID-19' AND ho.COVID19 = 'Yes');
SELECT * FROM doenca_afeta_paciente;

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela hospitalizacao
INSERT INTO hospitalizacao (er_ed_visit, ofc_visit) VALUE ('Yes', 'Yes');
INSERT INTO hospitalizacao (er_ed_visit, ofc_visit) VALUE ('Yes', 'No');
INSERT INTO hospitalizacao (er_ed_visit, ofc_visit) VALUE ('No', 'Yes');
INSERT INTO hospitalizacao (er_ed_visit, ofc_visit) VALUE ('No', 'No');
SELECT * FROM hospitalizacao;

-- -----------------------------------------------------------------------------------------------------------------------
-- Tabela paciente_e_hospitalizado
INSERT INTO paciente_e_hospitalizado (idhospitalizacao, id_vaers, hospdays)
SELECT h.idhospitalizacao, p.id_vaers, ho.HOSPDAYS
FROM hospitalizacao h, paciente p, trabalho_covid.temp_do_hospital ho
WHERE p.id_vaers = ho.VAERS_ID
AND ((h.er_ed_visit = 'Yes' AND h.ofc_visit = 'Yes' AND ho.er_ed_visit = 'Y' AND ho.ofc_visit = 'Y')  
OR (h.er_ed_visit = 'Yes' AND h.ofc_visit = 'No' AND ho.er_ed_visit = 'Y' AND ho.ofc_visit IS NULL)  
OR (h.er_ed_visit = 'No' AND h.ofc_visit = 'Yes' AND ho.er_ed_visit IS NULL AND ho.ofc_visit = 'Y')  
OR (h.er_ed_visit = 'No' AND h.ofc_visit = 'No' AND ho.er_ed_visit IS NULL AND ho.ofc_visit IS NULL)); 
SELECT * FROM paciente_e_hospitalizado;

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela sintomas
INSERT INTO sintomas (designacao)
SELECT DISTINCT SYMPTOM1 FROM trabalho_covid.temp_dos_sintomas
WHERE SYMPTOM1 IS NOT NULL;

INSERT INTO sintomas (designacao)
SELECT DISTINCT SYMPTOM2 FROM trabalho_covid.temp_dos_sintomas 
WHERE SYMPTOM2 NOT IN (SELECT designacao FROM sintomas)
AND SYMPTOM2 IS NOT NULL;

INSERT INTO sintomas (designacao)
SELECT DISTINCT SYMPTOM3 FROM trabalho_covid.temp_dos_sintomas 
WHERE SYMPTOM3 NOT IN (SELECT designacao FROM sintomas)
AND SYMPTOM3 IS NOT NULL;

INSERT INTO sintomas (designacao)
SELECT DISTINCT SYMPTOM4 FROM trabalho_covid.temp_dos_sintomas 
WHERE SYMPTOM4 NOT IN (SELECT designacao FROM sintomas)
AND SYMPTOM4 IS NOT NULL;

INSERT INTO sintomas (designacao)
SELECT DISTINCT SYMPTOM5 FROM trabalho_covid.temp_dos_sintomas 
WHERE SYMPTOM5 NOT IN (SELECT designacao FROM sintomas)
AND SYMPTOM5 IS NOT NULL;

-- Confirmação final de que as scripts implementaram corretamente
SELECT COUNT(*) FROM sintomas;
select COUNT(DISTINCT(designacao)) from sintomas;
SELECT * FROM sintomas;

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela sintomas_afeta_paciente
INSERT INTO sintomas_afeta_paciente (idsintoma, id_vaers, onset_date, numdays, recovd)
SELECT s.idsintoma, p.id_vaers, s2.ONSET_DATE, s2.NUMDAYS, d.RECOVD
FROM sintomas s, paciente p, trabalho_covid.temp_dos_sintomas si, trabalho_covid.temp_dos_sintomas2 s2, 
trabalho_covid.temp_da_doenca d
WHERE si.VAERS_ID = p.id_vaers
AND (s.designacao = si.SYMPTOM1
OR s.designacao = si.SYMPTOM2
OR s.designacao = si.SYMPTOM3
OR s.designacao = si.SYMPTOM4
OR s.designacao = si.SYMPTOM5)
AND p.id_vaers = s2.VAERS_ID
AND p.id_vaers = d.VAERS_ID;
SELECT * FROM sintomas_afeta_paciente;

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela vacina_causa_sintomas
INSERT INTO vacina_causa_sintomas (idvacina, idsintoma)
SELECT v.idvacina,sa.idsintoma FROM sintomas_afeta_paciente sa, vacinar v
WHERE v.id_vaers=sa.id_vaers;
SELECT * FROM vacina_causa_sintomas;

