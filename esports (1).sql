CREATE DATABASE esports CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE esports;

CREATE TABLE users (
    user_id INT(11) AUTO_INCREMENT,
    role VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE audit_log (
    audit_id INT(11) AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    action_type VARCHAR(100) NOT NULL,
    entity_id INT(11) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    PRIMARY KEY (audit_id)
);

CREATE TABLE organizations (
    org_id INT(11) AUTO_INCREMENT,
    org_name VARCHAR(255) NOT NULL UNIQUE,
    ceo VARCHAR(255) NOT NULL,
    logo_url VARCHAR(500),
    PRIMARY KEY (org_id)
);

CREATE TABLE org_sponsors (
    org_id INT(11) NOT NULL,
    sponsor_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (org_id, sponsor_name)
);

CREATE TABLE games (
    game_id INT(11) AUTO_INCREMENT,
    game_name VARCHAR(255) NOT NULL UNIQUE,
    genre VARCHAR(100) NOT NULL,
    developer VARCHAR(255) NOT NULL,
    PRIMARY KEY (game_id)
);

CREATE TABLE characters (
    character_id INT(11) AUTO_INCREMENT,
    character_name VARCHAR(255) NOT NULL,
    game_id INT(11) NOT NULL,
    PRIMARY KEY (character_id)
);

CREATE TABLE teams (
    team_id INT(11) AUTO_INCREMENT,
    team_name VARCHAR(255) NOT NULL,
    org_id INT(11) NOT NULL,
    game_id INT(11) NOT NULL,
    PRIMARY KEY (team_id)
);

CREATE TABLE persons (
    person_id INT(11) AUTO_INCREMENT,
    nickname VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) DEFAULT NULL,
    birth_date DATE NOT NULL,
    country VARCHAR(100) NOT NULL,
    photo_url VARCHAR(500) DEFAULT NULL,
    current_status VARCHAR(50) DEFAULT 'Active',
    PRIMARY KEY (person_id)
);

CREATE TABLE person_socials (
    person_id INT(11) NOT NULL,
    social_link VARCHAR(500) NOT NULL,
    PRIMARY KEY (person_id, social_link)
);

CREATE TABLE team_members (
    person_id INT(11) NOT NULL,
    team_id INT(11) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    role VARCHAR(100) NOT NULL,
    PRIMARY KEY (person_id, team_id, start_date)
);

CREATE TABLE tournaments (
    tournament_id INT(11) AUTO_INCREMENT,
    tournament_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    prize_pool DECIMAL(15,2) DEFAULT 0.00,
    format VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (tournament_id)
);

CREATE TABLE tournament_results (
    tournament_id INT(11) NOT NULL,
    team_id INT(11) NOT NULL,
    place INT(11) NOT NULL,
    prize_money DECIMAL(15,2) DEFAULT 0.00,
    PRIMARY KEY (tournament_id, team_id)
);

CREATE TABLE matches (
    match_id INT(11) AUTO_INCREMENT,
    tournament_id INT(11) NOT NULL,
    team1_id INT(11) NOT NULL,
    team2_id INT(11) NOT NULL,
    stage VARCHAR(100) NOT NULL,
    match_datetime DATETIME NOT NULL,
    match_format VARCHAR(50) NOT NULL,
    PRIMARY KEY (match_id)
);

CREATE TABLE maps (
    map_id INT(11) AUTO_INCREMENT,
    map_name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (map_id)
);

CREATE TABLE map_results (
    match_id INT(11) NOT NULL,
    map_id INT(11) NOT NULL,
    map_number INT(11) NOT NULL,
    score1 INT(11) NOT NULL DEFAULT 0,
    score2 INT(11) NOT NULL DEFAULT 0,
    duration INT(11) NOT NULL,
    PRIMARY KEY (match_id, map_id)
);

CREATE TABLE draft_actions (
    match_id INT(11) NOT NULL,
    map_id INT(11) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    team_id INT(11) NOT NULL,
    character_id INT(11) NOT NULL,
    PRIMARY KEY (match_id, map_id, action_type, team_id, character_id)
);

ALTER TABLE audit_log 
    ADD CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

ALTER TABLE org_sponsors 
    ADD CONSTRAINT fk_sponsor_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE;

ALTER TABLE characters 
    ADD CONSTRAINT fk_character_game FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE;

ALTER TABLE teams 
    ADD CONSTRAINT fk_team_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_team_game FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE;

ALTER TABLE person_socials 
    ADD CONSTRAINT fk_social_person FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE;

ALTER TABLE team_members 
    ADD CONSTRAINT fk_member_person FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_member_team FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE CASCADE;

ALTER TABLE tournament_results 
    ADD CONSTRAINT fk_tres_tournament FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_tres_team FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE CASCADE;

ALTER TABLE matches 
    ADD CONSTRAINT fk_match_tournament FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_match_team1 FOREIGN KEY (team1_id) REFERENCES teams(team_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_match_team2 FOREIGN KEY (team2_id) REFERENCES teams(team_id) ON DELETE CASCADE;

ALTER TABLE map_results 
    ADD CONSTRAINT fk_mres_match FOREIGN KEY (match_id) REFERENCES matches(match_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_mres_map FOREIGN KEY (map_id) REFERENCES maps(map_id) ON DELETE CASCADE;

ALTER TABLE draft_actions 
    ADD CONSTRAINT fk_draft_match FOREIGN KEY (match_id) REFERENCES matches(match_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_draft_map FOREIGN KEY (map_id) REFERENCES maps(map_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_draft_team FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_draft_character FOREIGN KEY (character_id) REFERENCES characters(character_id) ON DELETE CASCADE;

INSERT INTO users (role) VALUES 
('Главный администратор'), 
('Редактор портала'), 
('Гость (Читатель)');

INSERT INTO games (game_name, genre, developer) VALUES 
('Counter-Strike 2', 'FPS', 'Valve'),
('Dota 2', 'MOBA', 'Valve');

INSERT INTO characters (character_name, game_id) VALUES 
('Pudge', 2), 
('Invoker', 2), 
('Mirage', 1), 
('Inferno', 1);

INSERT INTO organizations (org_name, ceo, logo_url) VALUES 
('Team Spirit', 'Nikita Chukalin', 'http://liquipedia.net'),
('Natus Vincere', 'Yevhen Zolotarov', 'http://liquipedia.net');

INSERT INTO org_sponsors (org_id, sponsor_name) VALUES 
(1, 'Red Bull'), 
(1, 'BetBoom'), 
(2, 'Logitech'), 
(2, '1XBET');

INSERT INTO teams (team_name, org_id, game_id) VALUES 
('Team Spirit Dota2', 1, 2),
('Team Spirit CS2', 1, 1),
('Navi CS2', 2, 1),
('Navi Dota2', 2, 2);

INSERT INTO persons (nickname, first_name, last_name, birth_date, country, current_status) VALUES 
('Miposhka', 'Yaroslav', 'Naidenov', '1997-11-30', 'Russia', 'Active'),
('Yatoro', 'Illiya', 'Mulyarchuk', '2003-03-12', 'Ukraine', 'Active'),
('s1mple', 'Oleksandr', 'Kostyliev', '1997-10-02', 'Ukraine', 'In-active'),
('b1ad3', 'Andrii', 'Horodenskyi', '1986-10-14', 'Ukraine', 'Active');

INSERT INTO person_socials (person_id, social_link) VALUES 
(1, 'https://twitter.com'),
(2, 'https://twitch.tv'),
(3, 'https://twitch.tv');

INSERT INTO team_members (person_id, team_id, start_date, end_date, role) VALUES 
(1, 1, '2020-12-19', NULL, 'Активный игрок'),
(2, 1, '2020-12-19', '2024-09-18', 'Бывший игрок'),
(3, 3, '2016-08-04', '2023-10-26', 'В запасе'),
(4, 3, '2019-03-17', NULL, 'Тренер');

INSERT INTO tournaments (tournament_name, start_date, end_date, prize_pool, format, location) VALUES 
('The International 2023', '2023-10-12', '2023-10-29', 3350000.00, 'LAN', 'Seattle, USA'),
('PGL Major Copenhagen 2024', '2024-03-17', '2024-03-31', 1250000.00, 'LAN', 'Copenhagen, Denmark'),
('Weekly Online Cup #12', '2026-11-01', '2026-11-05', 5000.00, 'Online', 'Europe Server');

INSERT INTO tournament_results (tournament_id, team_id, place, prize_money) VALUES 
(1, 1, 1, 1400000.00), 
(2, 3, 1, 500000.00);

INSERT INTO matches (tournament_id, team1_id, team2_id, stage, match_datetime, match_format) VALUES 
(1, 1, 4, 'Grand Final', '2023-10-29 18:00:00', 'Bo3'),
(2, 3, 2, 'Semi-Final', '2024-03-30 15:30:00', 'Bo3');

INSERT INTO maps (map_name) VALUES 
('Default Dota Map'), 
('de_mirage'), 
('de_inferno'), 
('de_nuke');

INSERT INTO map_results (match_id, map_id, map_number, score1, score2, duration) VALUES 
(1, 1, 1, 45, 22, 2430), 
(2, 2, 1, 13, 9, 3120),  
(2, 3, 2, 11, 13, 2980);

INSERT INTO draft_actions (match_id, map_id, action_type, team_id, character_id) VALUES 
(1, 1, 'Pick', 1, 1), 
(1, 1, 'Ban', 4, 2);

INSERT INTO audit_log (user_id, action_type, entity_id, old_value, new_value) VALUES 
(2, 'Создание карточки турнира', 1, NULL, 'The International 2023');

UPDATE organizations 
SET ceo = 'Nikita "Cheshir" Chukalin' 
WHERE org_name = 'Team Spirit';

UPDATE persons 
SET current_status = 'Active' 
WHERE nickname = 's1mple';

DELETE FROM tournaments 
WHERE tournament_name = 'Weekly Online Cup #12';

CREATE USER IF NOT EXISTS 'esports_reader'@'localhost' IDENTIFIED BY 'Read_Only_Pass_2026!';
GRANT SELECT ON esports.* TO 'esports_reader'@'localhost';

CREATE USER IF NOT EXISTS 'esports_editor'@'localhost' IDENTIFIED BY 'Edit_Crypto_Pass_2026!';
GRANT SELECT, INSERT, UPDATE ON esports.* TO 'esports_editor'@'localhost';

CREATE USER IF NOT EXISTS 'esports_admin'@'localhost' IDENTIFIED BY 'Admin_Ultimate_Pass_2026!';
GRANT ALL PRIVILEGES ON esports.* TO 'esports_admin'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

DESCRIBE organizations;
DESCRIBE teams;
DESCRIBE persons;
DESCRIBE tournaments;
DESCRIBE matches;


-- 1. Неявное соединение таблиц с фильтром и сортировкой
SELECT t.team_name, o.org_name, g.game_name
FROM teams t, organizations o, games g
WHERE t.org_id = o.org_id
  AND t.game_id = g.game_id
  AND g.game_name = 'Dota 2'
ORDER BY t.team_name;

-- 2. Явное соединение таблиц (JOIN)
SELECT 
    tr.tournament_name,
    t1.team_name AS team1,
    t2.team_name AS team2,
    m.stage,
    m.match_datetime,
    m.match_format
FROM matches m
JOIN tournaments tr ON m.tournament_id = tr.tournament_id
JOIN teams t1 ON m.team1_id = t1.team_id
JOIN teams t2 ON m.team2_id = t2.team_id
ORDER BY m.match_datetime;


-- 3. Агрегирующие операции (SUM, AVG, COUNT, MAX, MIN)
SELECT 
    tr.tournament_name,
    tr.prize_pool,
    COUNT(trs.team_id) AS teams_count,
    AVG(trs.place) AS avg_place,
    MAX(trs.prize_money) AS max_prize,
    MIN(trs.prize_money) AS min_prize
FROM tournaments tr
LEFT JOIN tournament_results trs ON tr.tournament_id = trs.tournament_id
GROUP BY tr.tournament_id, tr.tournament_name, tr.prize_pool;

-- 4. Группировка GROUP BY и фильтрация HAVING
SELECT 
    o.org_name,
    COUNT(t.team_id) AS team_count
FROM organizations o
JOIN teams t ON o.org_id = t.org_id
GROUP BY o.org_id, o.org_name
HAVING COUNT(t.team_id) > 1;


-- 5. Вложенные подзапросы (IN, ALL)
SELECT team_name
FROM teams
WHERE team_id IN (
    SELECT team_id
    FROM tournament_results
    WHERE place = 1
);

SELECT t.team_name, SUM(trs.prize_money) AS total_prize
FROM teams t
JOIN tournament_results trs ON t.team_id = trs.team_id
GROUP BY t.team_id, t.team_name
HAVING SUM(trs.prize_money) > ALL (
    SELECT SUM(trs2.prize_money)
    FROM teams t2
    JOIN tournament_results trs2 ON t2.team_id = trs2.team_id
    JOIN organizations o2 ON t2.org_id = o2.org_id
    WHERE o2.org_name = 'Natus Vincere'
    GROUP BY t2.team_id
);


-- 6. Функции управления потоком (IF, CASE)
SELECT 
    tournament_name,
    prize_pool,
    CASE
        WHEN prize_pool > 1000000 THEN 'High'
        WHEN prize_pool > 100000 THEN 'Medium'
        ELSE 'Low'
    END AS prize_category
FROM tournaments;

SELECT 
    nickname,
    current_status,
    IF(current_status = 'Active', 'Играет', 'Не играет') AS status_ru
FROM persons;


-- 7. Создание представления (VIEW) на наиболее популярный запрос
CREATE OR REPLACE VIEW v_team_standings AS
SELECT 
    t.team_name,
    o.org_name,
    COUNT(trs.tournament_id) AS tournaments_played,
    SUM(CASE WHEN trs.place = 1 THEN 1 ELSE 0 END) AS wins,
    COALESCE(SUM(trs.prize_money), 0) AS total_prize
FROM teams t
JOIN organizations o ON t.org_id = o.org_id
LEFT JOIN tournament_results trs ON t.team_id = trs.team_id
GROUP BY t.team_id, t.team_name, o.org_name;

-- Пример использования представления:
SELECT * FROM v_team_standings ORDER BY total_prize DESC;


-- 8. Временное представление — оператор WITH (CTE)
WITH team_prizes AS (
    SELECT 
        t.team_id,
        t.team_name,
        COALESCE(SUM(trs.prize_money), 0) AS total_prize
    FROM teams t
    LEFT JOIN tournament_results trs ON t.team_id = trs.team_id
    GROUP BY t.team_id, t.team_name
)
SELECT team_name, total_prize
FROM team_prizes
WHERE total_prize > (SELECT AVG(total_prize) FROM team_prizes)
ORDER BY total_prize DESC;


-- 9. Анализ и оптимизация запросов (EXPLAIN и CREATE INDEX)
EXPLAIN
SELECT 
    tr.tournament_name,
    t1.team_name AS team1,
    t2.team_name AS team2,
    m.stage,
    m.match_datetime,
    m.match_format
FROM matches m
JOIN tournaments tr ON m.tournament_id = tr.tournament_id
JOIN teams t1 ON m.team1_id = t1.team_id
JOIN teams t2 ON m.team2_id = t2.team_id;

CREATE INDEX idx_matches_tournament ON matches(tournament_id);
CREATE INDEX idx_matches_team1 ON matches(team1_id);
CREATE INDEX idx_matches_team2 ON matches(team2_id);
CREATE INDEX idx_tournament_results_team ON tournament_results(team_id);

-- 10. Механизм транзакций (START TRANSACTION)

START TRANSACTION;

UPDATE team_members
SET end_date = '2025-01-01'
WHERE person_id = 2 AND team_id = 1 AND end_date IS NULL;

INSERT INTO team_members (person_id, team_id, start_date, end_date, role)
VALUES (2, 4, '2025-01-02', NULL, 'Активный игрок');

INSERT INTO audit_log (user_id, action_type, entity_id, old_value, new_value)
VALUES (2, 'Трансфер игрока', 2, 'team_id=1', 'team_id=4');

COMMIT;


-- 11. Подготовленные запросы (PREPARE, EXECUTE, DEALLOCATE)
PREPARE stmt_teams_by_game FROM
'SELECT t.team_name, g.game_name
 FROM teams t
 JOIN games g ON t.game_id = g.game_id
 WHERE g.game_name = ?';

SET @game_name = 'Dota 2';
EXECUTE stmt_teams_by_game USING @game_name;

SET @game_name = 'Counter-Strike 2';
EXECUTE stmt_teams_by_game USING @game_name;

DEALLOCATE PREPARE stmt_teams_by_game;
