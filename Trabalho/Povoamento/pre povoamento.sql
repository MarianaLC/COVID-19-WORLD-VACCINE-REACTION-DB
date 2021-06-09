-- Preparação do povoamento
-- --------------------------------------------------------------------------------------------------------------------
-- Tabela temp_vacinar
-- 1. Eliminar as linhas em que não existe VAERS_ID ou VAX_DATE, agora não existem valores nulos!
DELETE FROM temp_vacinar WHERE VAERS_ID = '' OR VAX_DATE = '';

-- 2. Converter VAX_DATE em date
ALTER TABLE temp_vacinar MODIFY COLUMN VAX_DATE DATE;
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_vacinar';

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela temp_vacina
-- 1. Eliminar as linhas que não possuem pacientes que tomaram vacinas da covid
DELETE FROM temp_vacina WHERE VAX_TYPE != 'COVID19';

-- 2. Converter strings vazias em valores nulos
UPDATE temp_vacina SET VAX_DOSE_SERIES = NULL WHERE VAX_DOSE_SERIES = '';
UPDATE temp_vacina SET VAX_TYPE = NULL WHERE VAX_TYPE = '';
UPDATE temp_vacina SET VAX_LOT = NULL WHERE VAX_LOT = '';
UPDATE temp_vacina SET VAX_ROUTE = NULL WHERE VAX_ROUTE = '';
UPDATE temp_vacina SET VAX_SITE = NULL WHERE VAX_SITE = '';

-- 3. Criar tabela temp_das_vacinas cujos pacientes são iguais aos do temp_vacinar e com atributo idvacina 
-- (para facilitar povoamento tabela vacinar)
CREATE TABLE temp_das_vacinas (VAERS_ID INT, VAX_LOT TEXT , VAX_DOSE_SERIES INT, VAX_ROUTE TEXT, VAX_SITE TEXT, 
idvacina INT NOT NULL AUTO_INCREMENT, PRIMARY KEY (idvacina));

INSERT INTO temp_das_vacinas (VAERS_ID, VAX_LOT, VAX_DOSE_SERIES , VAX_ROUTE , VAX_SITE)
SELECT v.VAERS_ID, v.VAX_LOT, v.VAX_DOSE_SERIES , v.VAX_ROUTE , v.VAX_SITE
FROM temp_vacina v, temp_vacinar vr
WHERE v.VAERS_ID = vr.VAERS_ID;

-- 4. Converter VAX_DOSE_SERIES em INT
ALTER TABLE temp_das_vacinas MODIFY COLUMN VAX_DOSE_SERIES INT;

-- 5. Converter VAX_LOT, VAX_ROUTE, VAX_SITE em VARCHAR(45)
ALTER TABLE temp_das_vacinas MODIFY COLUMN VAX_LOT VARCHAR(45);
ALTER TABLE temp_das_vacinas MODIFY COLUMN VAX_ROUTE VARCHAR(45);
ALTER TABLE temp_das_vacinas MODIFY COLUMN VAX_SITE VARCHAR(45);
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_das_vacinas';

-- ---------------------------------------------------------------------------------------------------------------------- 
-- Tabela temp_sintomas2
-- 1. Converter strings vazias em valores nulos
UPDATE temp_sintomas2 SET ONSET_DATE = NULL WHERE ONSET_DATE = '';
UPDATE temp_sintomas2 SET NMDAYS = NULL WHERE NMDAYS = '';

-- 2. Criar tabela temp_dos_sintomas2 cujos pacientes são iguais aos do temp_vacinar
CREATE TABLE temp_dos_sintomas2 (VAERS_ID INT, ONSET_DATE DATE, NUMDAYS INT);

INSERT INTO temp_dos_sintomas2 (VAERS_ID, ONSET_DATE, NUMDAYS)
SELECT si.VAERS_ID, si.ONSET_dATE, si.NMDAYS
FROM temp_sintomas2 si, temp_vacinar vr
WHERE si.VAERS_ID = vr.VAERS_ID;

-- 3. Converter ONSET_DATE em DATE
ALTER TABLE temp_dos_sintomas2 MODIFY COLUMN ONSET_DATE DATE;

-- 4. Converter NMDAYS em INT
ALTER TABLE temp_dos_sintomas2 MODIFY COLUMN NMDAYS INT;
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_dos_sintomas2';

-- ---------------------------------------------------------------------------------------------------------------------
-- Tabela temp_sintomas
-- 1. Converter strings vazias em valores nulos
UPDATE temp_sintomas SET SYMPTOM1 = NULL WHERE SYMPTOM1 = '';
UPDATE temp_sintomas SET SYMPTOM2 = NULL WHERE SYMPTOM2 = '';
UPDATE temp_sintomas SET SYMPTOM3 = NULL WHERE SYMPTOM3 = '';
UPDATE temp_sintomas SET SYMPTOM4 = NULL WHERE SYMPTOM4 = '';
UPDATE temp_sintomas SET SYMPTOM5 = NULL WHERE SYMPTOM5 = '';

-- 2. Criar tabela temp_dos_sintomas cujos pacientes são iguais aos do temp_vacinar 
CREATE TABLE temp_dos_sintomas (VAERS_ID INT, SYMPTOM1 TEXT, SYMPTOM2 TEXT, SYMPTOM3 TEXT, SYMPTOM4 TEXT, SYMPTOM5 TEXT);

INSERT INTO temp_dos_sintomas (VAERS_ID, SYMPTOM1, SYMPTOM2, SYMPTOM3 , SYMPTOM4 , SYMPTOM5)
SELECT s.VAERS_ID, s.SYMPTOM1, s.SYMPTOM2, s.SYMPTOM3, s.SYMPTOM4, s.SYMPTOM5
FROM temp_vacinar vr, temp_sintomas s
WHERE vr.VAERS_ID = s.VAERS_ID;

-- 3. Converter SYMPTOM (1 a 5) em VARCHAR(1000)
ALTER TABLE temp_dos_sintomas MODIFY COLUMN SYMPTOM1 VARCHAR(1000);
ALTER TABLE temp_dos_sintomas MODIFY COLUMN SYMPTOM2 VARCHAR(1000);
ALTER TABLE temp_dos_sintomas MODIFY COLUMN SYMPTOM3 VARCHAR(1000);
ALTER TABLE temp_dos_sintomas MODIFY COLUMN SYMPTOM4 VARCHAR(1000);
ALTER TABLE temp_dos_sintomas MODIFY COLUMN SYMPTOM5 VARCHAR(1000);
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_dos_sintomas';

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela temp_paciente
-- 1. Converter strings vazias em valores nulos
UPDATE temp_paciente SET STATE = NULL WHERE STATE = '';
UPDATE temp_paciente SET AGE_YRS = NULL WHERE AGE_YRS = '';
UPDATE temp_paciente SET SEX = NULL WHERE SEX = '';
UPDATE temp_paciente SET DATEDIED = NULL WHERE DATEDIED = '';

-- 2. Criar tabela temp_dos_pacientes cujos pacientes são iguais aos do temp_vacinar
CREATE TABLE temp_dos_pacientes (VAERS_ID INT, STATE TEXT, AGE_YRS DECIMAL (5,0), SEX TEXT, DATEDIED DATE);

INSERT INTO temp_dos_pacientes (VAERS_ID, STATE, AGE_YRS, SEX, DATEDIED)
SELECT p.VAERS_ID, p.STATE, p.AGE_YRS, p.SEX, p.DATEDIED
FROM temp_vacinar vr, temp_paciente p
WHERE vr.VAERS_ID = p.VAERS_ID;

-- 3. Converter DATEDIED em DATE
ALTER TABLE temp_dos_pacientes MODIFY COLUMN DATEDIED DATE;

-- 4. Converter STATE e SEX em VARCHAR(45)
ALTER TABLE temp_dos_pacientes MODIFY COLUMN STATE VARCHAR(45);
ALTER TABLE temp_dos_pacientes MODIFY COLUMN SEX VARCHAR(45);

-- 5. Converter AGE_YRS em DECIMAL(5,2)
ALTER TABLE temp_dos_pacientes MODIFY COLUMN AGE_YRS DECIMAL(5,2);
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_dos_pacientes';

-- ---------------------------------------------------------------------------------------------------------------------
-- Tabela temp_hospital
-- 1. Converter strings vazias em valores nulos
UPDATE temp_hospital SET HOSPDAYS = NULL WHERE HOSPDAYS = '';
UPDATE temp_hospital SET OFC_VISIT = NULL WHERE OFC_VISIT = '';
UPDATE temp_hospital SET ER_ED_VISIT = NULL WHERE ER_ED_VISIT = '';

-- 2. Criar tabela temp_do_hospital cujos pacientes são iguais aos do temp_vacinar
CREATE TABLE temp_do_hospital (VAERS_ID INT, HOSPDAYS INT, OFC_VISIT TEXT, ER_ED_VISIT TEXT);

INSERT INTO temp_do_hospital (VAERS_ID, HOSPDAYS, OFC_VISIT, ER_ED_VISIT)
SELECT h.VAERS_ID, h.HOSPDAYS, h.OFC_VISIT, h.ER_ED_VISIT
FROM temp_vacinar vr, temp_hospital h
WHERE vr.VAERS_ID = h.VAERS_ID;

-- 3. Verificar se existe mais do que 1 linha por paciente (não existe)
SELECT * FROM temp_do_hospital GROUP BY VAERS_ID HAVING COUNT(VAERS_ID)>1;

-- 4. Converter OFC_VISIT e ER_ED_VISIT em VARCHAR(45)
ALTER TABLE temp_do_hospital MODIFY COLUMN OFC_VISIT VARCHAR(45);
ALTER TABLE temp_do_hospital MODIFY COLUMN ER_ED_VISIT VARCHAR(45);

-- 5. Converter HOSPDAYS em INT
ALTER TABLE temp_do_hospital MODIFY COLUMN HOSPDAYS INT;
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_do_hospital';

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela temp_fornecedor
-- 1. Converter strings vazias em valores nulos
UPDATE temp_fornecedor SET VAX_MANU = NULL WHERE VAX_MANU = '';

-- 2. Criar tabela temp_do_fornecedor cujos pacientes são iguais aos do temp_vacinar
CREATE TABLE temp_do_fornecedor (VAERS_ID INT, VAX_MANU TEXT);

INSERT INTO temp_do_fornecedor (VAERS_ID, VAX_MANU)
SELECT f.VAERS_ID, f.VAX_MANU
FROM temp_vacinar vr, temp_fornecedor f
WHERE vr.VAERS_ID = f.VAERS_ID;

-- 3. Converter VAX_MANU em VARCHAR(45)
ALTER TABLE temp_do_fornecedor MODIFY COLUMN VAX_MANU VARCHAR(45);
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_do_fornecedor';

-- ----------------------------------------------------------------------------------------------------------------------
-- Tabela temp_doenca
-- 1. Converter strings vazias em valores nulos
UPDATE temp_doenca SET RECOVD = NULL WHERE RECOVD = '';
UPDATE temp_doenca SET DISABLE = NULL WHERE DISABLE = '';

-- 2. Criar tabela temp_da_doenca cujos pacientes são iguais aos do temp_vacinar
CREATE TABLE temp_da_doenca (VAERS_ID INT, RECOVD TEXT, DISABLE TEXT);

INSERT INTO temp_da_doenca (VAERS_ID, RECOVD, DISABLE)
SELECT d.VAERS_ID, d.RECOVD, d.DISABLE
FROM temp_vacinar vr, temp_doenca d
WHERE vr.VAERS_ID = d.VAERS_ID;

-- 3. Verificar se existe mais do que 1 linha por paciente (não existe)
SELECT * FROM temp_da_doenca GROUP BY VAERS_ID HAVING COUNT(VAERS_ID)>1;

-- 4. Converter RECOVD em VARCHAR(45)
ALTER TABLE temp_da_doenca MODIFY COLUMN RECOVD VARCHAR(45);
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_da_doenca';

-- -----------------------------------------------------------------------------------------------------------------------
-- Tabela temp_historico
-- 1. Converter strings vazias ou com UNK ou OTH em valores nulos
UPDATE temp_historico SET L_THREAT = NULL WHERE L_THREAT = '';
UPDATE temp_historico SET V_ADMINBY = NULL WHERE V_ADMINBY = '' OR V_ADMINBY = 'UNK' OR V_ADMINBY = 'OTH';

-- 2. Criar tabela temp_do_historico cujos pacientes são iguais aos do temp_vacinar
CREATE TABLE temp_do_historico (VAERS_ID INT, OBESITY TEXT,HIGH_CHOLESTEROL TEXT, HIGH_BLOOD_PRESSURE TEXT, 
MIGRAINES TEXT, GERD TEXT, DEPRESSION TEXT, ANXIETY TEXT,
OSTEOARTHRITIS TEXT, HYPOTHYROIDISM TEXT, HYPERTENSION TEXT, ASTHMA TEXT, HYPERLIPIDEMIA TEXT, COVID19 TEXT, L_THREAT TEXT,
V_ADMINBY TEXT);

INSERT INTO temp_do_historico (VAERS_ID, OBESITY ,HIGH_CHOLESTEROL, HIGH_BLOOD_PRESSURE, MIGRAINES , GERD , DEPRESSION , 
ANXIETY, OSTEOARTHRITIS, HYPOTHYROIDISM, HYPERTENSION , ASTHMA , HYPERLIPIDEMIA, COVID19, L_THREAT, V_ADMINBY)
SELECT h.VAERS_ID, h.OBESITY, h.`HIGH CHOLESTEROL`, h.`HIGH BLOOD PRESSURE`, h.MIGRAINES, h.GERD, h.DEPRESSION, h.ANXIETY,
h.OSTEOARTHRITIS, h.HYPOTHYROIDISM, h.HYPERTENSION, h.ASTHMA, h.HYPERLIPIDEMIA, h.`Covid 19`, h.L_THREAT, h.V_ADMINBY
FROM temp_vacinar vr, temp_historico h
WHERE vr.VAERS_ID = h.VAERS_ID;

-- 3. Converter V_ADMINBY em VARCHAR(10)
ALTER TABLE temp_do_historico MODIFY COLUMN V_ADMINBY VARCHAR(10);
SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'trabalho_covid' 
AND TABLE_NAME = 'temp_do_historico';


