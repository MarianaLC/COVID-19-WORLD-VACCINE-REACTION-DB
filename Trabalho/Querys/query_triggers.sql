-- Tabela paciente
-- INSERT na tabela temp_dos_pacientes
DELIMITER $$
CREATE TRIGGER Update_paciente AFTER INSERT ON trabalho_covid.temp_dos_pacientes
FOR EACH ROW
BEGIN
INSERT INTO covid_efeitos.paciente (id_vaers,state,age_yrs,sex,data_died)
VALUES ( NEW.VAERS_ID, NEW.STATE,NEW.AGE_YRS,NEW.SEX, NEW.DATEDIED );
END $$
DELIMITER ;

-- DELETE tabela temp_dos_pacientes
DELIMITER $$
CREATE TRIGGER Update_paciente_delete AFTER DELETE ON trabalho_covid.temp_dos_pacientes
FOR EACH ROW
BEGIN
DELETE FROM covid_efeitos.paciente WHERE id_vaers=OLD.VAERS_ID;
END $$
DELIMITER ;

-- Tabela vacina
-- INSERT na tabela temp_das_vacinas
DELIMITER $$
CREATE TRIGGER Update_vacina AFTER INSERT ON trabalho_covid.temp_das_vacinas
FOR EACH ROW
BEGIN
INSERT INTO covid_efeitos.vacina (vax_lot, idfornecedor)
SELECT NEW.VAX_LOT, f.idfornecedor
FROM covid_efeitos.fornecedor f, trabalho_covid.temp_do_fornecedor t, trabalho_covid.temp_das_vacinas v
WHERE v.VAERS_ID = t.VAERS_ID
AND  t.VAX_MANU = f.vax_manu;

INSERT INTO vacinar (idvacina, id_vaers, vax_dose_series, vax_route, vax_site)
SELECT NEW.idvacina, NEW.vaers_id, NEW.VAX_DOSE_SERIES, NEW.VAX_ROUTE, NEW.VAX_SITE;
END $$
DELIMITER ;
