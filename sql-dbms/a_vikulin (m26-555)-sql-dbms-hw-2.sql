/*
    Викулин А. Группа М26-555
    ДЗ №2 / Вариант 12.


    1) Подготовлены скрипты начального заполнения таблиц.

    2) Разработаны запросы по п.1 и п.2

    3) Разработаны и протестированы индексы для корректной работы запросов.

    4) Протестировано на версии СУБД: PostgreSQL 18.6 on x86_64-pc-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit

*/

-----------------------------------------------------------------------
--- ПОДГОТОВКА НАЧАЛЬНЫХ ДАННЫХ
-----------------------------------------------------------------------
BEGIN;
-- ПРЕДПОЛАГАЕТСЯ, ЧТО В БД ЕСТЬ РЕЗУЛЬТАТЫ ДЗ-1
SET search_path TO AVIKULIN_М26_555_HW1;

INSERT INTO dict_departments (code, name) VALUES
('ОТД-ТЕРАП', 'Терапевтическое отделение'),
('ОТД-ХИР', 'Хирургическое отделение'),
('ОТД-НЕВРО', 'Неврологическое отделение'),
('ОТД-КАРД', 'Кардиологическое отделение'),
('ОТД-ПЕД', 'Педиатрическое отделение'),
('ОТД-ОНКО', 'Онкологическое отделение'),
('ОТД-ГИНЕК', 'Гинекологическое отделение'),
('ОТД-ТРАВМ', 'Травматологическое отделение'),
('ОТД-ИНФЕК', 'Инфекционное отделение'),
('ОТД-ПУЛЬМ', 'Пульмонологическое отделение'),
('ОТД-ЭНДОК', 'Эндокринологическое отделение'),
('ОТД-НЕФРО', 'Нефрологическое отделение'),
('ОТД-ДЕРМ', 'Дерматологическое отделение'),
('ОТД-ОФТАЛЬМ', 'Офтальмологическое отделение'),
('ОТД-ЛОР', 'Отоларингологическое отделение'),
('ОТД-СТОМ', 'Стоматологическое отделение'),
('ОТД-РЕАБ', 'Отделение реабилитации'),
('ОТД-ДИАГН', 'Диагностическое отделение'),
('ОТД-ЛАБ', 'Лабораторное отделение'),
('ОТД-РЕНТГ', 'Рентгенологическое отделение');

INSERT INTO dict_wards (ward_number, floor, department_id, capacity) VALUES
('П-101', 1, (SELECT id FROM dict_departments WHERE code = 'ОТД-ТЕРАП'), 6),
('П-102', 1, (SELECT id FROM dict_departments WHERE code = 'ОТД-ТЕРАП'), 8),
('П-201', 2, (SELECT id FROM dict_departments WHERE code = 'ОТД-ТЕРАП'), 4),
('П-202', 2, (SELECT id FROM dict_departments WHERE code = 'ОТД-ХИР'), 6),
('П-203', 2, (SELECT id FROM dict_departments WHERE code = 'ОТД-ХИР'), 8),
('П-301', 3, (SELECT id FROM dict_departments WHERE code = 'ОТД-НЕВРО'), 6),
('П-302', 3, (SELECT id FROM dict_departments WHERE code = 'ОТД-КАРД'), 8),
('П-401', 4, (SELECT id FROM dict_departments WHERE code = 'ОТД-ПЕД'), 4),
('П-402', 4, (SELECT id FROM dict_departments WHERE code = 'ОТД-ОНКО'), 6),
('П-501', 5, (SELECT id FROM dict_departments WHERE code = 'ОТД-ГИНЕК'), 8),
('П-502', 5, (SELECT id FROM dict_departments WHERE code = 'ОТД-ТРАВМ'), 6),
('П-601', 1, (SELECT id FROM dict_departments WHERE code = 'ОТД-ИНФЕК'), 4),
('П-602', 1, (SELECT id FROM dict_departments WHERE code = 'ОТД-ПУЛЬМ'), 8),
('П-701', 2, (SELECT id FROM dict_departments WHERE code = 'ОТД-ЭНДОК'), 6),
('П-702', 2, (SELECT id FROM dict_departments WHERE code = 'ОТД-НЕФРО'), 8),
('П-801', 3, (SELECT id FROM dict_departments WHERE code = 'ОТД-ДЕРМ'), 4),
('П-802', 3, (SELECT id FROM dict_departments WHERE code = 'ОТД-ОФТАЛЬМ'), 6),
('П-901', 4, (SELECT id FROM dict_departments WHERE code = 'ОТД-ЛОР'), 8),
('П-902', 4, (SELECT id FROM dict_departments WHERE code = 'ОТД-СТОМ'), 6),
('П-1001', 5, (SELECT id FROM dict_departments WHERE code = 'ОТД-РЕАБ'), 4);

-- dict_med_action_types: типы медицинских действий
INSERT INTO dict_med_action_types (code, name) VALUES
('ПР-ОСМОТР', 'Первичный осмотр врача'),
('ПР-КОНСУЛЬТ', 'Консультация специалиста'),
('ПР-ДИАГН', 'Постановка диагноза'),
('ПР-НАЗНАЧ', 'Назначение лечения'),
('ПР-ПРОЦЕД', 'Лечебная процедура'),
('ПР-ОПЕРАЦ', 'Хирургическая операция'),
('ПР-ПЕРЕВЯЗ', 'Перевязка'),
('ПР-ИНЪЕКЦ', 'Инъекция'),
('ПР-ЗАБОР', 'Забор биоматериала'),
('ПР-ИССЛ', 'Лабораторное исследование'),
('ПР-МРТ', 'Магнитно-резонансная томография'),
('ПР-КТ', 'Компьютерная томография'),
('ПР-УЗИ', 'Ультразвуковое исследование'),
('ПР-ЭКГ', 'Электрокардиография'),
('ПР-РЕНТГ', 'Рентгенография'),
('ПР-ВАКЦ', 'Вакцинация'),
('ПР-РЕАБ', 'Реабилитационная процедура'),
('ПР-ФИЗ', 'Физиотерапия'),
('ПР-МАССАЖ', 'Массаж'),
('ПР-СТОМ', 'Стоматологическая манипуляция');

INSERT INTO dict_med_action_reasons (code, name, action_type_id) VALUES
('ПРЧ-ЖАЛОБА', 'По жалобе пациента', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР')),
('ПРЧ-ПЛАН', 'Плановый осмотр', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР')),
('ПРЧ-ЭКСТР', 'Экстренное состояние', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР')),
('ПРЧ-КОНСУЛЬТ', 'Для консультации специалиста', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-КОНСУЛЬТ')),
('ПРЧ-УТОЧН', 'Для уточнения диагноза', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ДИАГН')),
('ПРЧ-ЛЕЧЕНИЕ', 'В рамках назначенного лечения', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-НАЗНАЧ')),
('ПРЧ-ПРОЦЕД', 'По протоколу лечебной процедуры', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ПРОЦЕД')),
('ПРЧ-ОПЕР', 'Подготовка к операции', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОПЕРАЦ')),
('ПРЧ-ПОСЛЕОП', 'Послеоперационный контроль', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОПЕРАЦ')),
('ПРЧ-ПЕРЕВЯЗ', 'Смена повязки', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ПЕРЕВЯЗ')),
('ПРЧ-ИНЪЕК', 'По назначению врача', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ИНЪЕКЦ')),
('ПРЧ-АНАЛИЗ', 'Для лабораторного анализа', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ЗАБОР')),
('ПРЧ-ИССЛ', 'Для подтверждения диагноза', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ИССЛ')),
('ПРЧ-МРТ', 'Подозрение на патологию', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-МРТ')),
('ПРЧ-КТ', 'Контроль динамики заболевания', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-КТ')),
('ПРЧ-УЗИ', 'Скрининговое обследование', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-УЗИ')),
('ПРЧ-ЭКГ', 'Боли в груди', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ЭКГ')),
('ПРЧ-РЕНТГ', 'Травма конечности', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-РЕНТГ')),
('ПРЧ-ВАКЦ', 'Календарная вакцинация', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ВАКЦ')),
('ПРЧ-РЕАБ', 'Восстановление после травмы', (SELECT id FROM dict_med_action_types WHERE code = 'ПР-РЕАБ'));

INSERT INTO reg_patients (card_number, last_name, first_name, middle_name, insurance_policy, is_paid, zip_code, city, street, house, building, apartment, phones, passport_series, passport_number, passport_issued_by, passport_issue_date, allergies) VALUES
('АВ-100001', 'Иванов', 'Иван', 'Иванович', '1234567890123456', TRUE, '385000', 'Майкоп', 'Ленина', '1', NULL, '10', '+79001112233', '7901', '123456', 'УМВД по Республике Адыгея', '2018-05-10', 'Аллергия на пенициллин'),
('ВГ-100002', 'Петрова', 'Анна', 'Сергеевна', NULL, FALSE, '350000', 'Краснодар', 'Красная', '2', NULL, '5', '+79002223344', '4501', '654321', 'ОВД г. Краснодара', '2019-03-15', NULL),
('ДЕ-100003', 'Сидоров', 'Петр', 'Петрович', '1122334455667788', TRUE, '369000', 'Черкесск', 'Советская', '3', NULL, '7', '+79003334455', '0701', '987654', 'МВД по КЧР', '2020-07-20', 'Нет'),
('ЖЗ-100004', 'Кузнецова', 'Елена', 'Владимировна', '9988776655443322', TRUE, '344000', 'Ростов-на-Дону', 'Пушкинская', '4', NULL, '2', '+79004445566', '6101', '332211', 'ГУ МВД по Ростовской области', '2017-11-05', 'Пыльцевая аллергия'),
('ИК-100005', 'Смирнов', 'Алексей', 'Дмитриевич', NULL, FALSE, '443000', 'Самара', 'Гагарина', '5', NULL, '12', '+79005556677', '6301', '776655', 'УМВД по Самарской области', '2021-02-28', NULL),
('КЛ-100006', 'Васильева', 'Ольга', 'Николаевна', '1111222233334444', TRUE, '620000', 'Екатеринбург', 'Ленина', '6', NULL, '8', '+79006667788', '6601', '445566', 'ГУ МВД по Свердловской области', '2016-09-10', 'Аллергия на аспирин'),
('МН-100007', 'Михайлов', 'Дмитрий', 'Андреевич', '5566778899001122', TRUE, '190000', 'Санкт-Петербург', 'Невский', '7', NULL, '3', '+79007778899', '7801', '223344', 'УМВД по г. Санкт-Петербургу', '2015-04-20', NULL),
('ОП-100008', 'Соколова', 'Мария', 'Павловна', NULL, FALSE, '101000', 'Москва', 'Тверская', '8', NULL, '15', '+79008889900', '7701', '554433', 'ГУ МВД по г. Москве', '2014-08-12', 'Аллергия на цитрусовые'),
('РС-100009', 'Новиков', 'Сергей', 'Викторович', '3344556677889900', TRUE, '420000', 'Казань', 'Баумана', '9', NULL, '4', '+79009990011', '1601', '887766', 'МВД по Республике Татарстан', '2013-06-30', NULL),
('ТУ-100010', 'Федорова', 'Наталья', 'Игоревна', '7788990011223344', TRUE, '630000', 'Новосибирск', 'Красный проспект', '10', NULL, '9', '+79000001122', '5401', '112233', 'ГУ МВД по Новосибирской области', '2012-10-15', 'Аллергия на шерсть'),
('ФХ-100011', 'Морозов', 'Андрей', 'Юрьевич', NULL, FALSE, '308000', 'Белгород', 'Победы', '11', NULL, '6', '+79001112233', '3101', '445566', 'УМВД по Белгородской области', '2011-12-01', NULL),
('ЦЧ-100012', 'Алексеева', 'Ирина', 'Константиновна', '2233445566778899', TRUE, '454000', 'Челябинск', 'Кирова', '12', NULL, '11', '+79002223344', '7401', '778899', 'ГУ МВД по Челябинской области', '2010-03-25', 'Аллергия на лактозу'),
('ШЩ-100013', 'Лебедев', 'Максим', 'Олегович', '8899001122334455', TRUE, '394000', 'Воронеж', 'Плехановская', '13', NULL, '1', '+79003334455', '3601', '221100', 'ГУ МВД по Воронежской области', '2009-07-18', NULL),
('ЪЫ-100014', 'Козлова', 'Юлия', 'Михайловна', NULL, FALSE, '603000', 'Нижний Новгород', 'Большая Покровская', '14', NULL, '13', '+79004445566', '5201', '334455', 'ГУ МВД по Нижегородской области', '2008-11-09', 'Аллергия на орехи'),
('ЬЭ-100015', 'Павлов', 'Роман', 'Сергеевич', '4455667788990011', TRUE, '410000', 'Саратов', 'Московская', '15', NULL, '7', '+79005556677', '6401', '667788', 'ГУ МВД по Саратовской области', '2007-02-14', NULL),
('ЮЯ-100016', 'Семенова', 'Виктория', 'Александровна', '6677889900112233', TRUE, '236000', 'Калининград', 'Ленинский проспект', '16', NULL, '5', '+79006667788', '3901', '990011', 'УМВД по Калининградской области', '2006-05-20', 'Аллергия на рыбу'),
('АА-100017', 'Егоров', 'Константин', 'Львович', NULL, FALSE, '305000', 'Курск', 'Ленина', '17', NULL, '14', '+79007778899', '4601', '110022', 'УМВД по Курской области', '2005-08-25', NULL),
('ББ-100018', 'Жукова', 'Светлана', 'Романовна', '7788990011223344', TRUE, '355000', 'Ставрополь', 'Октябрьская', '18', NULL, '3', '+79008889900', '2601', '223344', 'ГУ МВД по Ставропольскому краю', '2004-11-10', 'Аллергия на пыльцу'),
('ВВ-100019', 'Титов', 'Игорь', 'Валентинович', '8899001122334455', TRUE, '364000', 'Владикавказ', 'Мира', '19', NULL, '8', '+79009990011', '1501', '556677', 'МВД по РСО-Алания', '2003-02-05', NULL),
('ГГ-100020', 'Чернова', 'Татьяна', 'Евгеньевна', NULL, FALSE, '385100', 'Адыгейск', 'Шоссейная', '20', NULL, '2', '+79000001122', '7902', '443322', 'УМВД по Республике Адыгея', '2002-06-15', 'Аллергия на мёд');

INSERT INTO reg_admission_periods (patient_id, admission_date, reason_text, discharge_date, epikrisis, ward_id)
VALUES
-- Палата П-101 (загруженная): 4 пациента / никто не выписан
((SELECT id FROM reg_patients WHERE card_number = 'АВ-100001'), '2024-01-10 08:30:00+03', 'Плановое обследование', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-101')),
((SELECT id FROM reg_patients WHERE card_number = 'ВГ-100002'), '2024-01-11 09:15:00+03', 'Боль в спине', NULL, 'Улучшение состояния, рекомендовано ЛФК', (SELECT id FROM dict_wards WHERE ward_number = 'П-101')),
((SELECT id FROM reg_patients WHERE card_number = 'ДЕ-100003'), '2024-01-12 10:45:00+03', 'Повышенное давление', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-101')),
((SELECT id FROM reg_patients WHERE card_number = 'ЖЗ-100004'), '2024-01-13 11:20:00+03', 'Головокружение', NULL, 'Диагноз: вегетососудистая дистония', (SELECT id FROM dict_wards WHERE ward_number = 'П-101')),

-- Палата П-202 (загруженная): 3 пациента
((SELECT id FROM reg_patients WHERE card_number = 'ИК-100005'), '2024-01-14 12:10:00+03', 'Температура, кашель', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-202')),
((SELECT id FROM reg_patients WHERE card_number = 'КЛ-100006'), '2024-01-15 08:50:00+03', 'Боли в животе', '2024-01-20 10:15:00+03', 'Острый гастрит, назначено лечение', (SELECT id FROM dict_wards WHERE ward_number = 'П-202')),
((SELECT id FROM reg_patients WHERE card_number = 'МН-100007'), '2024-01-16 09:30:00+03', 'Травма руки', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-202')),

-- Палата П-301 (загруженная): 3 пациента
((SELECT id FROM reg_patients WHERE card_number = 'ОП-100008'), '2024-01-17 10:20:00+03', 'Головная боль', '2024-01-19 13:45:00+03', 'Мигрень, даны рекомендации', (SELECT id FROM dict_wards WHERE ward_number = 'П-301')),
((SELECT id FROM reg_patients WHERE card_number = 'РС-100009'), '2024-01-18 11:10:00+03', 'Слабость, утомляемость', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-301')),
((SELECT id FROM reg_patients WHERE card_number = 'ТУ-100010'), '2024-01-19 12:05:00+03', 'Боль в колене', '2024-01-25 15:20:00+03', 'Артроз, назначена физиотерапия', (SELECT id FROM dict_wards WHERE ward_number = 'П-301')),

-- Палата П-402 (загруженная): 4 пациента / никто не выписан
((SELECT id FROM reg_patients WHERE card_number = 'ФХ-100011'), '2024-01-20 08:40:00+03', 'Насморк, заложенность', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-402')),
((SELECT id FROM reg_patients WHERE card_number = 'ЦЧ-100012'), '2024-01-21 09:25:00+03', 'Кожные высыпания', NULL, 'Аллергическая реакция, антигистаминные', (SELECT id FROM dict_wards WHERE ward_number = 'П-402')),
((SELECT id FROM reg_patients WHERE card_number = 'ШЩ-100013'), '2024-01-22 10:10:00+03', 'Боль в груди', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-402')),
((SELECT id FROM reg_patients WHERE card_number = 'ЪЫ-100014'), '2024-01-23 11:55:00+03', 'Тошнота, рвота', NULL, 'Гастроэнтерит, регидратация', (SELECT id FROM dict_wards WHERE ward_number = 'П-402')),

-- Палата П-501 (загруженная): 2 пациента
((SELECT id FROM reg_patients WHERE card_number = 'ЬЭ-100015'), '2024-01-24 12:40:00+03', 'Одышка', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-501')),
((SELECT id FROM reg_patients WHERE card_number = 'ЮЯ-100016'), '2024-01-25 08:20:00+03', 'Боль в пояснице', '2024-01-30 10:50:00+03', 'Радикулит, курс массажа', (SELECT id FROM dict_wards WHERE ward_number = 'П-501')),

-- Остальные палаты (по 1–2 пациента)
((SELECT id FROM reg_patients WHERE card_number = 'АА-100017'), '2024-01-26 09:05:00+03', 'Повышение сахара в крови', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-601')),
((SELECT id FROM reg_patients WHERE card_number = 'ББ-100018'), '2024-01-27 10:30:00+03', 'Кровотечение из носа', '2024-01-28 13:20:00+03', 'Носовое кровотечение остановлено', (SELECT id FROM dict_wards WHERE ward_number = 'П-701')),
((SELECT id FROM reg_patients WHERE card_number = 'ВВ-100019'), '2024-01-28 11:45:00+03', 'Боль в горле', NULL, NULL, (SELECT id FROM dict_wards WHERE ward_number = 'П-801')),
((SELECT id FROM reg_patients WHERE card_number = 'ГГ-100020'), '2024-01-29 12:35:00+03', 'Общее недомогание', '2024-02-03 14:10:00+03', 'ОРВИ, симптоматическое лечение', (SELECT id FROM dict_wards WHERE ward_number = 'П-901'));

-- reg_med_actions: лечебные действия
INSERT INTO reg_med_actions (action_date, action_type_id, action_reason_id, initial_exam_text, result_text, prescriptions_text, conclusion_text)
VALUES
    (
        '2024-01-10 09:15:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ЖАЛОБА'),
        'Пациент жалуется на слабость, АД 130/85, пульс 78',
        'Патологии не выявлено, рекомендовано наблюдение',
        'Диета, контроль давления',
        'Состояние удовлетворительное'
    ),
    (
        '2024-01-11 10:00:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-КОНСУЛЬТ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-КОНСУЛЬТ'),
        'Жалобы на боль в пояснице, ограничение подвижности',
        'Консультация невролога: остеохондроз поясничного отдела',
        'НПВС, ЛФК, ограничение нагрузок',
        'Требуется повторный осмотр через 2 недели'
    ),
    (
        '2024-01-12 11:30:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ДИАГН'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-УТОЧН'),
        'АД 160/100, головная боль, тошнота',
        'Подтверждён гипертонический криз',
        'Капотен под язык, госпитализация',
        'Криз купирован, требуется контроль терапии'
    ),
    (
        '2024-01-13 12:20:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-УЗИ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-УЗИ'),
        'Головокружение, шум в ушах',
        'УЗИ сосудов шеи: умеренные изменения',
        'Витамины группы B, контроль АД',
        'Рекомендован повторный осмотр'
    ),
    (
        '2024-01-14 13:10:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ЗАБОР'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-АНАЛИЗ'),
        'Кашель, температура 38.2°C',
        'Забор мазка на ОРВИ, общий анализ крови',
        'Подозрение на вирусную инфекцию',
        'Парацетамол, обильное питьё, изоляция'
    ),
    (
        '2024-01-15 09:00:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ИССЛ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ИССЛ'),
        'Боли в эпигастрии, тошнота',
        'Анализ крови: лейкоциты 12.5, СОЭ 18',
        'Омепразол, диета, контрольный анализ',
        'Подозрение на гастрит'
    ),
    (
        '2024-01-16 10:15:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ПЕРЕВЯЗ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ПЕРЕВЯЗ'),
        'Травма кисти, отёк, болезненность',
        'Перевязка, обработка раны, наложение повязки',
        'Рана чистая, без признаков воспаления',
        'Ежедневная перевязка, контроль температуры'
    ),
    (
        '2024-01-17 11:25:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ЭКГ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ЭКГ'),
        'Жалобы на боли в груди, одышку',
        'ЭКГ: синусовый ритм, ЧСС 88, без острых изменений',
        'Наблюдение, консультация кардиолога',
        'Острой патологии не выявлено'
    ),
    (
        '2024-01-18 12:30:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ЖАЛОБА'),
        'Слабость, сонливость, снижение аппетита',
        'При осмотре: кожные покровы бледные, пульс 92',
        'Общий анализ крови, ферритин',
        'Подозрение на анемию'
    ),
    (
        '2024-01-19 09:45:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-КТ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-КТ'),
        'Боль в коленном суставе, хромота',
        'КТ: дегенеративные изменения, умеренный артроз',
        'Хондропротекторы, физиотерапия',
        'Рекомендовано снижение нагрузки'
    ),
    (
        '2024-01-20 10:55:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ЗАБОР'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-АНАЛИЗ'),
        'Насморк, температура 37.8°C',
        'Мазок на грипп/COVID-19, общий анализ крови',
        'Вирусная инфекция, лёгкое течение',
        'Симптоматическая терапия, изоляция'
    ),
    (
        '2024-01-21 11:40:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ФИЗ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-РЕАБ'),
        'Высыпания на коже, зуд',
        'Осмотр дерматолога: аллергическая сыпь',
        'Антигистаминные, гипоаллергенная диета',
        'Реакция на пищевой аллерген'
    ),
    (
        '2024-01-22 12:50:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-МРТ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-МРТ'),
        'Боль за грудиной, иррадиация в левую руку',
        'МРТ грудного отдела: грыжа диска Th6-Th7',
        'Миорелаксанты, физиотерапия',
        'Болевой синдром обусловлен грыжей'
    ),
    (
        '2024-01-23 09:20:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ИССЛ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ИССЛ'),
        'Тошнота, многократная рвота, жидкий стул',
        'Анализ кала: признаки кишечной инфекции',
        'Регидратация, сорбенты, диета',
        'Инфекционный гастроэнтерит'
    ),
    (
        '2024-01-24 10:30:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ЭКГ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ЭКГ'),
        'Одышка, учащённое сердцебиение',
        'ЭКГ: тахикардия, ЧСС 110',
        'Кислородотерапия, наблюдение',
        'Требуется консультация пульмонолога'
    ),
    (
        '2024-01-25 11:40:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ФИЗ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-РЕАБ'),
        'Боль в пояснице, ограничение движений',
        'Физиотерапия: электрофорез с новокаином',
        'Уменьшение болевого синдрома на 40%',
        'Курс из 10 процедур'
    ),
    (
        '2024-01-26 12:50:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ЭКСТР'),
        'Сахар крови 9.8 ммоль/л, жажда, полиурия',
        'Первичный осмотр: подозрение на СД 2 типа',
        'Гликированный гемоглобин, консультация эндокринолога',
        'Требуется подтверждение диагноза'
    ),
    (
        '2024-01-27 09:10:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ПЕРЕВЯЗ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ПЕРЕВЯЗ'),
        'Носовое кровотечение, слабость',
        'Передняя тампонада, остановка кровотечения',
        'Кровотечение остановлено, АД стабилизировано',
        'Контроль АД, исключение травм'
    ),
    (
        '2024-01-28 10:20:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ОСМОТР'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ЖАЛОБА'),
        'Боль в горле, першение, температура 37.5°C',
        'Фарингоскопия: гиперемия слизистой',
        'Полоскания, местные антисептики',
        'Острый фарингит'
    ),
    (
        '2024-01-29 11:30:00+03',
        (SELECT id FROM dict_med_action_types WHERE code = 'ПР-ИССЛ'),
        (SELECT id FROM dict_med_action_reasons WHERE code = 'ПРЧ-ИССЛ'),
        'Общее недомогание, слабость, ломота в теле',
        'Анализ крови: умеренный лейкоцитоз',
        'Противовирусные, постельный режим',
        'Вероятна вирусная инфекция'
    );

INSERT INTO lnk_amb_periods_to_med_actions (admission_period_id, action_id)
VALUES
    (
         (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
         (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    ),
    (
        (SELECT a.id FROM reg_admission_periods a ORDER BY RANDOM() LIMIT 1),
        (SELECT a.id FROM reg_med_actions a ORDER BY RANDOM() LIMIT 1)
    );

COMMIT;

---------------------------------------------------------------------------------------------------
--- ИНДЕКСЫ
---------------------------------------------------------------------------------------------------

-- для первого запроса: btree для "LIKE '79%'"
-- Данный паттерн доступа к кортежам имеет свои особенности: https://www.postgresql.org/docs/9.5/indexes-opclass.html
CREATE INDEX idx_reg_patients_passport_series ON reg_patients(passport_series varchar_pattern_ops);
VACUUM ANALYSE;

-- для второго запроса достаточно встроенных PK-индексов

---------------------------------------------------------------------------------------------------
--- ЗАПРОСЫ
---------------------------------------------------------------------------------------------------

--1

SELECT *
FROM
    reg_patients
WHERE
    passport_series LIKE '79%'
ORDER BY
    last_name DESC,
    first_name DESC,
    middle_name DESC;

/*
  !!! Чтобы индекс начал работать - сгенерировать больше данных.
  Например вот так:

    INSERT INTO reg_patients (
        card_number,
        last_name,
        first_name,
        middle_name,
        insurance_policy,
        is_paid,
        zip_code,
        city,
        street,
        house,
        building,
        apartment,
        phones,
        passport_series,
        passport_number,
        passport_issued_by,
        passport_issue_date,
        allergies
    )
    SELECT
        'ЯЯЯЯ-' || lpad((g.n + 100000)::text, 6, '0') AS card_number,

        -- Фамилии из твоего образца + добавляем вариативность
        CASE g.n % 20
            WHEN 0 THEN 'Иванов'   WHEN 1 THEN 'Петрова'   WHEN 2 THEN 'Сидоров'   WHEN 3 THEN 'Кузнецова'
            WHEN 4 THEN 'Смирнов'  WHEN 5 THEN 'Васильева' WHEN 6 THEN 'Михайлов'  WHEN 7 THEN 'Соколова'
            WHEN 8 THEN 'Новиков'   WHEN 9 THEN 'Федорова'  WHEN 10 THEN 'Морозов'  WHEN 11 THEN 'Алексеева'
            WHEN 12 THEN 'Лебедев'  WHEN 13 THEN 'Козлова'  WHEN 14 THEN 'Павлов'   WHEN 15 THEN 'Семенова'
            WHEN 16 THEN 'Егоров'   WHEN 17 THEN 'Жукова'   WHEN 18 THEN 'Титов'    WHEN 19 THEN 'Чернова'
            END AS last_name,

        -- Имена
        CASE (g.n / 20) % 10
            WHEN 0 THEN 'Иван'     WHEN 1 THEN 'Анна'     WHEN 2 THEN 'Петр'     WHEN 3 THEN 'Елена'
            WHEN 4 THEN 'Алексей'  WHEN 5 THEN 'Ольга'    WHEN 6 THEN 'Дмитрий'  WHEN 7 THEN 'Мария'
            WHEN 8 THEN 'Сергей'   WHEN 9 THEN 'Наталья'
            END AS first_name,

        -- Отчества
        CASE (g.n / 200) % 5
            WHEN 0 THEN 'Иванович'   WHEN 1 THEN 'Сергеевна'   WHEN 2 THEN 'Петрович'   WHEN 3 THEN 'Владимировна'   WHEN 4 THEN 'Дмитриевич'
            END AS middle_name,

        -- Страховой полис: 16 цифр, иногда NULL
        lpad(((g.n * 123456789::bigint + 987654321::bigint) % 1000000000000000::bigint)::text, 16, '0') AS insurance_policy,

        (g.n % 2 = 0) AS is_paid, -- чередуем TRUE/FALSE

        -- Индекс: берём из списка крупных городов + рандом по диапазону
        CASE g.n % 10
            WHEN 0 THEN '101000' WHEN 1 THEN '190000' WHEN 2 THEN '305000' WHEN 3 THEN '344000'
            WHEN 4 THEN '350000' WHEN 5 THEN '385000' WHEN 6 THEN '410000' WHEN 7 THEN '420000'
            WHEN 8 THEN '443000' WHEN 9 THEN '620000'
            END || lpad(((g.n % 100) + 1)::text, 3, '0') AS zip_code,

        -- Город
        CASE g.n % 10
            WHEN 0 THEN 'Москва'       WHEN 1 THEN 'Санкт-Петербург' WHEN 2 THEN 'Майкоп'         WHEN 3 THEN 'Краснодар'
            WHEN 4 THEN 'Ростов-на-Дону' WHEN 5 THEN 'Самара'        WHEN 6 THEN 'Екатеринбург' WHEN 7 THEN 'Казань'
            WHEN 8 THEN 'Новосибирск'    WHEN 9 THEN 'Челябинск'
            END AS city,

        'Улица-' || ((g.n % 50) + 1) AS street,
        ((g.n % 50) + 1)::text AS house,
        NULL AS building,
        ((g.n % 20) + 1)::text AS apartment,

        '+7900' || lpad(((g.n * 13 + 7) % 9999)::text, 4, '0') || lpad(((g.n * 23 + 17) % 9999)::text, 4, '0') AS phones,

        -- Паспорт: серия 4 цифры, номер 6 цифр
        lpad(((g.n % 9000 + 1000))::text, 4, '0') AS passport_series,
        lpad(((g.n % 900000 + 100000))::text, 6, '0') AS passport_number,

        'УМВД по региону-' || ((g.n % 50) + 1) AS passport_issued_by,

        (NOW() - (random() * 365 * 10) * INTERVAL '1 day')::date AS passport_issue_date,

        CASE
            WHEN g.n % 7 = 0 THEN 'Аллергия на пенициллин'
            WHEN g.n % 7 = 1 THEN 'Пыльцевая аллергия'
            WHEN g.n % 7 = 2 THEN 'Аллергия на аспирин'
            WHEN g.n % 7 = 3 THEN 'Аллергия на цитрусовые'
            WHEN g.n % 7 = 4 THEN 'Аллергия на шерсть'
            WHEN g.n % 7 = 5 THEN 'Аллергия на лактозу'
            ELSE NULL
            END AS allergies
    FROM generate_series(0, 10999) AS g(n);


  ПЛАН ЗАПРОСА БУДЕТ ТАКИМ:
  Sort  (cost=247.07..247.34 rows=109 width=291) (actual time=0.152..0.157 rows=102.00 loops=1)
  Sort Key: last_name DESC, first_name DESC, middle_name DESC"
  Sort Method: quicksort  Memory: 51kB
  Buffers: shared hit=8
  ->  Bitmap Heap Scan on reg_patients  (cost=5.38..243.38 rows=109 width=291) (actual time=0.036..0.059 rows=102.00 loops=1)
        Filter: ((passport_series)::text ~~ '79%'::text)
        Heap Blocks: exact=5
        Buffers: shared hit=8
        ->  Bitmap Index Scan on idx_reg_patients_passport_series  (cost=0.00..5.36 rows=107 width=0) (actual time=0.021..0.022 rows=102.00 loops=1)
              Index Cond: (((passport_series)::text ~>=~ '79'::text) AND ((passport_series)::text ~<~ '7:'::text))
              Index Searches: 1
              Buffers: shared hit=3
  Planning:
    Buffers: shared hit=111 dirtied=1
  Planning Time: 1.062 ms
  Execution Time: 0.252 ms
 */

--2
SELECT
    w.ward_number,
    COUNT(p.id) AS patients_count
FROM dict_wards AS w
         JOIN reg_admission_periods AS ap
              ON ap.ward_id = w.id
                  AND ap.discharge_date IS NULL
         JOIN reg_patients AS p
              ON p.id = ap.patient_id
GROUP BY
    w.id, w.ward_number
HAVING
    COUNT(p.id) > 3
ORDER BY
    patients_count DESC;

/*
  ПЛАН ЗАПРОСА БУДЕТ ТАКИМ:
  Sort  (cost=38.87..38.88 rows=1 width=70) (actual time=0.166..0.168 rows=2.00 loops=1)
  Sort Key: (count(p.id)) DESC
  Sort Method: quicksort  Memory: 25kB
  Buffers: shared hit=30
  ->  GroupAggregate  (cost=38.80..38.86 rows=1 width=70) (actual time=0.128..0.133 rows=2.00 loops=1)
        Group Key: w.ward_number
        Filter: (count(p.id) > 3)
        Rows Removed by Filter: 5
        Buffers: shared hit=30
        ->  Sort  (cost=38.80..38.81 rows=3 width=66) (actual time=0.123..0.125 rows=14.00 loops=1)
              Sort Key: w.ward_number
              Sort Method: quicksort  Memory: 25kB
              Buffers: shared hit=30
              ->  Hash Join  (cost=1.60..38.78 rows=3 width=66) (actual time=0.085..0.107 rows=14.00 loops=1)
                    Hash Cond: (ap.patient_id = p.id)
                    Buffers: shared hit=30
                    ->  Nested Loop  (cost=0.15..37.32 rows=3 width=66) (actual time=0.033..0.051 rows=14.00 loops=1)
                          Buffers: shared hit=29
                          ->  Seq Scan on reg_admission_periods ap  (cost=0.00..16.80 rows=3 width=8) (actual time=0.017..0.020 rows=14.00 loops=1)
                                Filter: (discharge_date IS NULL)
                                Rows Removed by Filter: 6
                                Buffers: shared hit=1
                          ->  Index Scan using dict_wards_pkey on dict_wards w  (cost=0.15..6.83 rows=1 width=62) (actual time=0.002..0.002 rows=1.00 loops=14)
                                Index Cond: (id = ap.ward_id)
                                Index Searches: 14
                                Buffers: shared hit=28
                    ->  Hash  (cost=1.20..1.20 rows=20 width=4) (actual time=0.019..0.020 rows=20.00 loops=1)
                          Buckets: 1024  Batches: 1  Memory Usage: 9kB
                          Buffers: shared hit=1
                          ->  Seq Scan on reg_patients p  (cost=0.00..1.20 rows=20 width=4) (actual time=0.007..0.009 rows=20.00 loops=1)
                                Buffers: shared hit=1
  Planning:
    Buffers: shared hit=3
  Planning Time: 0.425 ms
  Execution Time: 0.325 ms
 */
