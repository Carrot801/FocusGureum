CREATE TABLE AppUser (
                      id INTEGER NOT NULL AUTO_INCREMENT,
                      nickname VARCHAR(255) NOT NULL,
                      avatar VARCHAR(255),
                      created_at TIMESTAMP NOT NULL,
                      PRIMARY KEY (id)
);
---
CREATE TABLE Habit (
                       id INTEGER NOT NULL AUTO_INCREMENT,
                       name VARCHAR(255) NOT NULL,
                       created_at TIMESTAMP NOT NULL,
                       active BOOLEAN NOT NULL,
                       user_id INTEGER NOT NULL,
                       PRIMARY KEY (id),
                       CONSTRAINT fk_user_hab FOREIGN KEY (user_id) REFERENCES AppUser(id)
);
CREATE TABLE Habit_Schedule (
                                id INTEGER NOT NULL AUTO_INCREMENT,
                                frequency_type CHAR(4) NOT NULL,
                                day_step INTEGER,
                                days_of_week VARCHAR(255),
                                habit_id INTEGER NOT NULL,
                                PRIMARY KEY (id),
    -- Constraint to ensure frequency_type is either 'week' or 'steps'
                                CONSTRAINT chk_frequency_type CHECK (frequency_type IN ('week', 'step')),
    -- Unified constraint to handle both cases
                                CONSTRAINT chk_habit_days CHECK (
                                    (frequency_type = 'week' AND days_of_week IS NOT NULL AND day_step IS NULL) OR
                                    (frequency_type = 'step' AND day_step IS NOT NULL AND days_of_week IS NULL)
                                    ),
    -- Foreign key constraint for habit_id
                                CONSTRAINT fk_habit FOREIGN KEY (habit_id) REFERENCES Habit(id)
);
CREATE TABLE Habit_Log (
                           id INTEGER NOT NULL AUTO_INCREMENT,
                           date DATE NOT NULL,
                           habit_id INTEGER NOT NULL,
                           PRIMARY KEY (id),
                           CONSTRAINT fk_habit_key FOREIGN KEY (habit_id) REFERENCES Habit(id)
);
---
CREATE TABLE Category (
                          id INTEGER NOT NULL AUTO_INCREMENT,
                          name VARCHAR(255) NOT NULL,
                          status BOOLEAN NOT NULL,
                          image_path VARCHAR(255),
                          user_id INTEGER NOT NULL,
                          PRIMARY KEY (id),
                          CONSTRAINT fk_user_cat FOREIGN KEY (user_id) REFERENCES AppUser(id)
);
CREATE TABLE Task (
                      id INTEGER NOT NULL AUTO_INCREMENT,
                      name VARCHAR(255) NOT NULL,
                      status BOOLEAN NOT NULL,
                      category_FK INTEGER NOT NULL,
                      PRIMARY KEY (id),
                      CONSTRAINT fk_category FOREIGN KEY (category_FK) REFERENCES Category(id)
);
CREATE TABLE Event (
                       id INTEGER NOT NULL AUTO_INCREMENT,
                       name VARCHAR(255) NOT NULL,
                       start_timestamp TIMESTAMP NOT NULL,
                       end_timestamp TIMESTAMP,
                       recurrence_type VARCHAR(20) CHECK (recurrence_type IN ('WEEKLY', 'MONTHLY', 'YEARLY', 'DAYS', 'WEEK_DAYS', 'NONE')) NOT NULL,
                       recurrence_step VARCHAR(10),
                       recurrence_days VARCHAR(255),
                       recurrence_finish DATE,
                       tag_color VARCHAR(20),
                       user_id INTEGER NOT NULL,
                       PRIMARY KEY (id),
    -- Constraint to ensure proper values for recurrence_step and recurrence_days
                       CONSTRAINT chk_recurrence CHECK (
                           (recurrence_type = 'DAYS' AND recurrence_step IS NOT NULL AND recurrence_days IS NULL) OR
                           (recurrence_type = 'WEEK_DAYS' AND recurrence_days IS NOT NULL AND recurrence_step IS NULL) OR
                           (recurrence_type IN ('WEEKLY', 'MONTHLY', 'YEARLY', 'NONE') AND recurrence_step IS NULL AND recurrence_days IS NULL)
                           ),
                       CONSTRAINT fk_user_event FOREIGN KEY (user_id) REFERENCES AppUser(id)
);
