--- users
INSERT INTO AppUser (nickname, avatar, created_at)
VALUES ('Emmanuelle Charpentier', 'https://example.com/avatar1.png', '2025-01-27 10:00:00');

INSERT INTO AppUser (nickname, avatar, created_at)
VALUES ('Jennifer Doudna', 'https://example.com/avatar2.png', '2025-02-20 11:00:00');

INSERT INTO AppUser (nickname, avatar, created_at)
VALUES ('Frances Arnold', 'https://example.com/avatar3.png', '2025-02-07 12:00:00');

--- habit
INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Morning Jog', '2025-04-01 06:30:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Drink 8 Glasses of Water', '2025-03-15 08:00:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Meditation', '2025-03-10 07:00:00', FALSE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Read 30 Minutes', '2025-04-10 09:00:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Daily Stretching', '2025-03-05 06:45:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Track Meals in App', '2025-04-12 08:15:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Sleep 8 Hours', '2025-03-20 22:00:00', FALSE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Write in Journal', '2025-04-08 22:00:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Practice Gratitude', '2025-03-25 21:00:00', TRUE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('No Junk Food', '2025-03-30 18:00:00', FALSE, 1);

INSERT INTO Habit (name, created_at, active, user_id)
VALUES ('Creativity exercises', '2025-02-15 13:00:00', TRUE, 1);

-- Habit_Schedule
INSERT INTO Habit_Schedule (frequency_type, day_step, days_of_week, habit_id)
VALUES ('week', NULL, '1,3,5', 1); -- Occurs on Monday, Wednesday, Friday

INSERT INTO Habit_Schedule (frequency_type, day_step, days_of_week, habit_id)
VALUES ('step', 2, NULL, 2); -- Every 2 days

INSERT INTO Habit_Schedule (frequency_type, day_step, days_of_week, habit_id)
VALUES ('week', NULL, '2,4,6', 4); -- Occurs on Tuesday, Thursday, Saturday

INSERT INTO Habit_Schedule (frequency_type, day_step, days_of_week, habit_id)
VALUES ('step', 3, NULL, 6); -- Every 3 days

INSERT INTO Habit_Schedule (frequency_type, day_step, days_of_week, habit_id)
VALUES ('week', NULL, '7', 3); -- Occurs on Sunday

INSERT INTO Habit_Schedule (frequency_type, day_step, days_of_week, habit_id)
VALUES ('step', 1, NULL, 5); -- Every day (steps of 1)

-- Habit log
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-07', 1); -- Monday
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-09', 1); -- Wednesday
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-11', 1); -- Friday

INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-15', 2); -- Start date
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-17', 2); -- 2 days later
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-19', 2); -- 2 days later

INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-12', 6); -- Start date
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-15', 6); -- 3 days later
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-18', 6); -- 3 days later

INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-15', 4); -- Tuesday
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-17', 4); -- Thursday
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-04-19', 4); -- Saturday

INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-05', 5); -- Start date
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-06', 5); -- Next day
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-07', 5); -- Next day
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-08', 5); -- Next day
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-10', 5); -- 09 was missed, the next day
INSERT INTO Habit_Log (date, habit_id) VALUES ('2025-03-11', 5);

-- category
INSERT INTO Category (name, status, image_path, user_id)
VALUES ('Physical Health', TRUE, NULL, 1);

INSERT INTO Category (name, status, image_path, user_id)
VALUES ('Mental Health and Mindfulness', TRUE, NULL, 1);

INSERT INTO Category (name, status, image_path, user_id)
VALUES ('Productivity and Personal Growth', TRUE, NULL, 1);

INSERT INTO Category (name, status, image_path, user_id)
VALUES ('University', TRUE, NULL, 1);

INSERT INTO Category (name, status, image_path, user_id)
VALUES ('Family', TRUE, NULL, 1);

-- Tasks
INSERT INTO Task (name, status, category_FK) VALUES ('Design a 5K route around my favorite park', TRUE, 1);
INSERT INTO Task (name, status, category_FK) VALUES ('Create a hydration plan with app reminders', TRUE, 1);
INSERT INTO Task (name, status, category_FK) VALUES ('Try a new yoga routine for core strength', TRUE, 1);
INSERT INTO Task (name, status, category_FK) VALUES ('Build a meal-tracking photo journal', TRUE, 1);
INSERT INTO Task (name, status, category_FK) VALUES ('Participate in a no-sugar wellness challenge', TRUE, 1);

INSERT INTO Task (name, status, category_FK) VALUES ('Write a reflective letter to your future self', TRUE, 2);
INSERT INTO Task (name, status, category_FK) VALUES ('Find a guided meditation app', TRUE, 2);
INSERT INTO Task (name, status, category_FK) VALUES ('Create a peaceful relaxation corner at home', TRUE, 2);
INSERT INTO Task (name, status, category_FK) VALUES ('Take a 24-hour digital detox challenge', TRUE, 2);

INSERT INTO Task (name, status, category_FK) VALUES ('Read a book from a new genre', TRUE, 3);
INSERT INTO Task (name, status, category_FK) VALUES ('Join an online workshop for a new skill', TRUE, 3);
INSERT INTO Task (name, status, category_FK) VALUES ('Create a vision board for the year', TRUE, 3);
INSERT INTO Task (name, status, category_FK) VALUES ('Organize your work desk for better focus', TRUE, 3);

INSERT INTO Task (name, status, category_FK) VALUES ('Attend a conference', TRUE, 4);
INSERT INTO Task (name, status, category_FK) VALUES ('Volunteer at Mlodzi w Lodzi', TRUE, 4);
INSERT INTO Task (name, status, category_FK) VALUES ('Prepare for Biology Exam', TRUE, 4);
INSERT INTO Task (name, status, category_FK) VALUES ('Presentation for Biotechnology', TRUE, 4);
INSERT INTO Task (name, status, category_FK) VALUES ('Organize Notes', TRUE, 4);

INSERT INTO Task (name, status, category_FK) VALUES ('Family activity every thursday', TRUE, 5);
INSERT INTO Task (name, status, category_FK) VALUES ('Plan Family Outing', TRUE, 5);
INSERT INTO Task (name, status, category_FK) VALUES ('Help with Chores', TRUE, 5);
INSERT INTO Task (name, status, category_FK) VALUES ('Cook a Meal Together', TRUE, 5);
INSERT INTO Task (name, status, category_FK) VALUES ('Celebrate Milestones', TRUE, 5);

--
INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Weekly Anatomy Study Group', '2025-04-01 17:00:00', '2025-04-01 19:00:00', 'WEEKLY', NULL, NULL, '2025-06-01', 'Blue', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Monthly Patient Observation Rounds', '2025-04-05 09:00:00', '2025-04-05 17:00:00', 'MONTHLY', NULL, NULL, '2025-10-05', 'Purple', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Olivers B-day', '2025-10-15 09:00:00', NULL, 'YEARLY', NULL, NULL, NULL, 'Gold', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Lower Back Routine', '2025-04-01 19:00:00', '2025-04-01 19:15:00', 'DAYS', '5', NULL, NULL, 'Red', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Medical Notes Review', '2025-04-03 20:00:00', '2025-04-03 21:30:00', 'DAYS', '3', NULL, '2025-09-03', 'Blue', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Advanced Suturing Techniques Workshop', '2025-04-15 14:00:00', '2025-04-15 17:00:00', 'NONE', NULL, NULL, NULL, 'Blue', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Meeting with Mentor (Career Guidance)', '2025-04-20 16:00:00', '2025-04-20 17:30:00', 'NONE', NULL, NULL, NULL, 'Green', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Peer Networking Brunch', '2025-07-01 10:00:00', '2025-07-01 12:00:00', 'NONE', NULL, NULL, NULL, 'Purple', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Intensive Exam Preparation Session', '2025-06-10 10:00:00', '2025-06-10 18:00:00', 'NONE', NULL, NULL, NULL, 'Orange', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Emergency Response Training', '2025-05-05 09:00:00', '2025-05-05 17:00:00', 'NONE', NULL, NULL, NULL, 'Red', 1);

INSERT INTO Event (name, start_timestamp, end_timestamp, recurrence_type, recurrence_step, recurrence_days, recurrence_finish, tag_color, user_id)
VALUES ('Full-Day Study at Library', '2025-04-18 08:00:00', '2025-04-18 20:00:00', 'NONE', NULL, NULL, NULL, 'Yellow', 1);





