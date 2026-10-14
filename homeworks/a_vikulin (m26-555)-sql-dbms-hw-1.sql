/*
    Викулин А. Группа М26-555
    ДЗ №1 2 / Вариант 12.

    ФОРМАЛЬНАЯ ПОСТАНОВКА ЗАДАЧИ:

    Предметная область: "Описание пациентов больницы".

    Включает в себя:
        - карты пациентов;
        - больничные палаты;
        - список амбулаторных периодов пребывания пациентов в больнице;
        - результаты обследований, операций и других лечебных или диагностических действий.

    Карты пациентов состоят из:
     - номера карты,
     - даты создания карты,
     - фамилии,
     - имени,
     - отчества,
     - номера страхового полиса (если есть),
     - указания, платно лечится больной или нет (логический тип),
     - адреса пациента (включая индекс, город, улицу, дом, корпус, квартиру, телефоны),
     - паспортных данных пациента в виде 4-х составляющих,
     - информации о наличии у пациента аллергии на лекарственные препараты (в виде одного большого текста).

    Больничные палаты состоят из:
     - номера палаты,
     - этажа,
     - отделения,
     - вмещаемого количества больных.

    Список амбулаторных периодов пребывания пациентов в больнице состоит из:
     - ИД периода
     - указания пациента,
     - даты поступления,
     - причин поступления,
     - даты выписки,
     - выписного эпикриза,
     - указания палаты в которой пациент был размещён.

    Результаты обследований, операций и других лечебных или диагностических действий состоят из:
     - ИД действия
     - даты действия,
     - названия действия,
     - причин действия,
     - результатов первичного осмотра больного (текст),
     - результатов действия  (текст),
     - назначений для последующего лечения  (текст),
     - заключения  (текст).

    ОСОБЕННОСТИ ВЫПОЛНЕНИЯ:

    1) Модель данных состоит из:
        - Справочников (статическая информация). Имеют префикс "DICT_".
        - Регистров (таблицы учета фактов). Имеют префикс "REG_".
        - Служебных таблиц связи сущностей (содержит пары ключей для связей "многие-ко-многим").
          Имеют префикк "LNK_?_TO_?".
        - Номерных серий (последовательностей). Имеют префикс "SEC_".

    2) Все сушности имеют совмещенную кодификацию:
        - code. Бизнес-код позиции справочника, отражающий ее назначение и легкий для запоминания пользователем.
                Уникален в рамках таблицы. Не участвует в ссылках (foreign key constraint).
                Может быть изменен в рамках жизненного цикла записи. Не применим к записям регистров и таблиц связей.

        - id. Синтетический ИД, являющиющийся техническим идентификатором записи.
              Формируется автоматически из целочисленной последовательности (sequence). Является первичным ключом записи.
              Не может меняться в процессе жтхненного цикла записи. Является объектом ссылок (foreign key constraint).
              Применяется во всех тапах сущностей.

    3) В моделе данных реализованы только базовые бизнес-правила контроля качества данных: т.е. тем,
       которым достаточно контекста текущей записи.  Кросс-валидация записей должна выполняиться на уровне приложения,
       а не модели данных.

    4) Индексы не создавались намеренно: нет понимания характера запросов к данным.
       Будут разрабатаны при подготовке ДЗ по DQL.

    5) Порядок разработки схемы:
        - правила миграции схемы: CINE (CREATE IF NOT EXISTS).
        - Поля даты должны быть TIMESTAMP WITH TIME ZONE - чтобы поддерживать кросс-региональную
          работу с единой инсталляцией.

    6) Порядок инициализации схемы:
        dict_departments
        dict_wards
        dict_med_action_types
        dict_med_action_reasons
        reg_patients
        reg_med_actions
        reg_admission_periods
        lnk_amb_periods_to_med_actions

    7) Создается уникальная схема AVIKULIN_М26_555_HW1, чтобы избежать конфликта имен с ДЗ других студентов.

    8) Протестировано на версии СУБД: PostgreSQL 18.6 on x86_64-pc-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit

*/

-------------------------------------------------------------------
-- СПРАВОЧНИКИ
-------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS AVIKULIN_М26_555_HW1;

SET search_path TO AVIKULIN_М26_555_HW1;

-- Справочник "Отделения"
CREATE SEQUENCE IF NOT EXISTS seq_departments;
CREATE TABLE IF NOT EXISTS dict_departments (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_departments'),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL
);

-- Справочник "Палаты"
CREATE SEQUENCE IF NOT EXISTS seq_wards;
CREATE TABLE IF NOT EXISTS dict_wards (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_wards'),
    ward_number VARCHAR(20) NOT NULL UNIQUE,
    floor INTEGER NOT NULL,
    department_id INTEGER NOT NULL, -- (N-to-1): у отделения много палат
    capacity INTEGER NOT NULL,

    -- Контроль целостности ссылки на справочник отделений
    CONSTRAINT fk_wards_department FOREIGN KEY (department_id)
        REFERENCES dict_departments(id),

    -- Номер этажа: от 1 до 20
    CONSTRAINT chk_ward_floor CHECK (floor >= 1 AND floor <= 20),

    -- Количество коек: от 1 до 20
    CONSTRAINT chk_ward_capacity CHECK (capacity >= 1 AND capacity <= 20)
);

-- Справочник "Типы медицинских действий"
CREATE SEQUENCE IF NOT EXISTS seq_med_action_types;
CREATE TABLE IF NOT EXISTS dict_med_action_types (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_med_action_types'),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL
);

-- Справочник "Типы причин медицинских действий"

CREATE SEQUENCE IF NOT EXISTS seq_med_action_reasons;
CREATE TABLE IF NOT EXISTS dict_med_action_reasons (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_med_action_reasons'),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    action_type_id INTEGER, -- (N-to-1): у действия может быть более одной причины

    CONSTRAINT fk_dict_med_action_types FOREIGN KEY (action_type_id)
        REFERENCES dict_med_action_types(id)
);

-------------------------------------------------------------------------------------
--- РЕГИСТРЫ СВЕДЕНИЙ
-------------------------------------------------------------------------------------

-- Регистр пациентов
CREATE SEQUENCE IF NOT EXISTS seq_patients;
CREATE TABLE IF NOT EXISTS reg_patients (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_patients'),
    card_number VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    -- ФИО
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),

    -- Страховка
    insurance_policy VARCHAR(20), -- может быть NULL
    is_paid BOOLEAN NOT NULL,

    -- Адрес
    zip_code VARCHAR(20),
    city VARCHAR(100),
    street VARCHAR(150),
    house VARCHAR(20),
    building VARCHAR(20),
    apartment VARCHAR(20),

    -- Телефонный номер
    phones TEXT, -- список телефонов (можно хранить как JSON, но TEXT допустим для ДЗ)

    -- ДУЛ
    passport_series VARCHAR(4),
    passport_number VARCHAR(6),
    passport_issued_by VARCHAR(255),
    passport_issue_date DATE,

    -- Доп. мед. информация
    allergies TEXT,

    -- Формат страхового полиса (16 цифр)
    CONSTRAINT chk_insurance_policy CHECK (
        insurance_policy IS NULL OR
        (length(insurance_policy) = 16 AND insurance_policy ~ '^\d{16}$')
    ),

    -- Серия паспорта (ровно 4 цифры)
    CONSTRAINT chk_passport_series CHECK (
        passport_series IS NULL OR (length(passport_series) = 4 AND passport_series ~ '^\d{4}$')
    ),

    -- Номер паспорта (ровно 6 цифр)
    CONSTRAINT chk_passport_number CHECK (
        passport_number IS NULL OR (length(passport_number) = 6 AND passport_number ~ '^\d{6}$')
    )
);


-- Регистр амбулаторных периодов
CREATE SEQUENCE IF NOT EXISTS seq_admission_periods;
CREATE TABLE IF NOT EXISTS reg_admission_periods (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_admission_periods'),
    patient_id INTEGER NOT NULL, -- N-to_1: у пациента может быть много амб. периодов.
    admission_date TIMESTAMP WITH TIME ZONE NOT NULL,
    reason_text TEXT NOT NULL,
    discharge_date TIMESTAMP WITH TIME ZONE,
    epikrisis TEXT,
    ward_id INTEGER, -- (1-to-1): один период в одной палате.
                     -- Может быть NULL: если пациент ещё не размещён.

    -- Дата выписки может быть только после даты поступления (если проставлена)
    CONSTRAINT chk_admission_dates CHECK (
        discharge_date IS NULL OR discharge_date >= admission_date),

    -- Контроль целостности ссылки на реестр пациентов
    CONSTRAINT fk_admission_patient FOREIGN KEY (patient_id)
        REFERENCES reg_patients(id),

    -- Контроль целостности ссылки на справочник "Палаты"
    CONSTRAINT fk_admission_ward FOREIGN KEY (ward_id)
        REFERENCES dict_wards (id)
);

-- Регистр лечебных действий
CREATE SEQUENCE IF NOT EXISTS seq_med_actions START 1 INCREMENT 1;
CREATE TABLE IF NOT EXISTS reg_med_actions (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_med_actions'),
    action_date TIMESTAMP WITH TIME ZONE NOT NULL,
    action_type_id INTEGER NOT NULL,
    action_reason_id INTEGER NOT NULL,
    initial_exam_text TEXT,
    result_text TEXT,
    prescriptions_text TEXT,
    conclusion_text TEXT,

    -- Контроль целостности ссылок на справочник "Типы медицинских действий"
    CONSTRAINT fk_actions_type FOREIGN KEY (action_type_id)
        REFERENCES dict_med_action_types(id),

    -- Контроль целостности ссылок на справочник "Типы причие медицинских действий"
    CONSTRAINT fk_actions_reason FOREIGN KEY (action_reason_id)
        REFERENCES dict_med_action_reasons(id)
);

-------------------------------------------------------------------------------------
--- ТАБЛИЦЫ СВЯЗИ
-------------------------------------------------------------------------------------
-- Связь медицинских действий с периодами пребывания (многие-ко-многим)
CREATE SEQUENCE IF NOT EXISTS seq_amb_periods_to_med_actions START 1 INCREMENT 1;
CREATE TABLE IF NOT EXISTS lnk_amb_periods_to_med_actions (
    id INTEGER PRIMARY KEY DEFAULT nextval('seq_amb_periods_to_med_actions'),
    admission_period_id INTEGER NOT NULL,
    action_id INTEGER NOT NULL,

    CONSTRAINT fk_period_actions_period FOREIGN KEY (admission_period_id)
        REFERENCES reg_admission_periods(id),

    CONSTRAINT fk_period_actions_action FOREIGN KEY (action_id)
        REFERENCES reg_med_actions(id)
);


-- ВАЖНО! Тут хорошо бы сделать индексы, но для этого нужно видеть, с какими запросами предстоит работать.
-- Поэтому индексами займемся в следующих ДЗ

