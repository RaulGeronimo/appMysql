DROP DATABASE IF EXISTS MySQL_app;
CREATE DATABASE MySQL_app;

USE MySQL_app;

CREATE TABLE users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(45),
    username VARCHAR(45),
    password TEXT,
    fullname TEXT
);
ALTER TABLE users AUTO_INCREMENT=2;

CREATE TABLE links(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title TEXT,
    url TEXT,
    description TEXT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);
ALTER TABLE links AUTO_INCREMENT=2;

CREATE TABLE contacts(
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname TEXT,
    phone BIGINT,
    email VARCHAR(70),
    birth DATE,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_contact FOREIGN KEY (user_id) REFERENCES users(id)
);
ALTER TABLE contacts AUTO_INCREMENT=2;

CREATE OR REPLACE VIEW
Vista_Usuarios AS
SELECT
c.id,
c.fullname,
c.phone,
c.email,
c.birth,
c.user_id,
c.created_at,
c.years,
IF(c.days = 366, 'Hoy es su Compleaños', CONCAT_WS(' ', 'Faltan', c.days, 'dias para su cumpleaños')) AS days
FROM(
    SELECT
    id,
    fullname,
    CONCAT("(", LEFT(phone, 3), ") ", MID(phone, 4, 3), "-", MID(phone, 7, 4)) AS phone,
    email,
    DATE_FORMAT(birth, "%d / %M / %Y") AS birth,
    user_id,
    created_at,
    TIMESTAMPDIFF(Year, birth, NOW()) AS years,
    IF((CONCAT_WS('-', YEAR(NOW()), MONTH(birth), DAY(birth))) > NOW(),
    (DATEDIFF((CONVERT((CONCAT_WS('-', YEAR(NOW()), MONTH(birth), DAY(birth))), DATE)), NOW())),
    (DATEDIFF((CONVERT((CONCAT_WS('-', YEAR(ADDDATE(CURDATE(), INTERVAL 1 YEAR)), MONTH(birth), DAY(birth))), DATE)), NOW()))) AS days
FROM contacts
) AS c
ORDER BY c.fullname;