
-- TẠO DATABASE
CREATE DATABASE IF NOT EXISTS social_network;
USE social_network;


-- XÓA BẢNG NẾU ĐÃ TỒN TẠI

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS likes_table;
DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;


-- TABLE USERS

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE POSTS

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);


-- INDEX
CREATE INDEX idx_posts_created_at
ON posts(created_at);

-- TABLE LIKES
CREATE TABLE likes_table (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_likes_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

-- TABLE COMMENTS
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

-- TABLE FRIENDS
CREATE TABLE friends (
    friend_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,
    friend_user_id INT NOT NULL,

    status ENUM('pending', 'accepted', 'blocked')
        DEFAULT 'pending',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_friends_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_friends_friend_user
        FOREIGN KEY (friend_user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- MOCK DATA USERS
INSERT INTO users(username, password, email)
VALUES
('khang', '123456', 'khang@gmail.com'),
('an', '123456', 'an@gmail.com'),
('minh', '123456', 'minh@gmail.com');

-- MOCK DATA POSTS
INSERT INTO posts(user_id, content)
VALUES
(1, 'Xin chào mọi người'),
(2, 'Hôm nay trời đẹp'),
(3, 'Đang học MySQL');

-- MOCK DATA LIKES
INSERT INTO likes_table(user_id, post_id)
VALUES
(2, 1),
(3, 1),
(1, 2);

-- MOCK DATA COMMENTS
INSERT INTO comments(user_id, post_id, comment_text)
VALUES
(2, 1, 'Bài viết hay'),
(3, 1, 'Chào bạn'),
(1, 3, 'Cố lên');

-- MOCK DATA FRIENDS
INSERT INTO friends(user_id, friend_user_id, status)
VALUES
(1, 2, 'accepted'),
(1, 3, 'accepted'),
(2, 3, 'pending');

-- VIEW 1: THÔNG TIN USER AN TOÀN
CREATE VIEW view_user_info AS
SELECT
    user_id,
    username,
    email,
    created_at
FROM users;

-- VIEW 2: THỐNG KÊ BÀI VIẾT
CREATE VIEW view_post_statistics AS
SELECT
    p.post_id,
    u.username,
    p.content,

    COUNT(DISTINCT l.like_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments,

    p.created_at

FROM posts p

INNER JOIN users u
    ON p.user_id = u.user_id

LEFT JOIN likes_table l
    ON p.post_id = l.post_id

LEFT JOIN comments c
    ON p.post_id = c.post_id

WHERE p.is_deleted = FALSE

GROUP BY
    p.post_id,
    u.username,
    p.content,
    p.created_at;
    
-- STORED PROCEDURE:
-- ĐĂNG KÝ USER
DELIMITER //

CREATE PROCEDURE sp_add_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN

    DECLARE v_count INT;

    SELECT COUNT(*)
    INTO v_count
    FROM users
    WHERE email = p_email;

    IF v_count > 0 THEN

        SELECT 'Email đã được sử dụng' AS message;

    ELSE

        INSERT INTO users(username, password, email)
        VALUES(p_username, p_password, p_email);

        SELECT 'Đăng ký thành công' AS message;

    END IF;

END //

DELIMITER ;

-- STORED PROCEDURE:
-- TẠO BÀI VIẾT
DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT p_new_post_id INT
)
BEGIN

    INSERT INTO posts(user_id, content)
    VALUES(p_user_id, p_content);

    SET p_new_post_id = LAST_INSERT_ID();

END //

DELIMITER ;

-- STORED PROCEDURE:
-- LẤY DANH SÁCH BẠN BÈ PHÂN TRANG
DELIMITER //

CREATE PROCEDURE sp_get_friends(
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN

    SELECT
        u.user_id,
        u.username,
        u.email
    FROM friends f

    INNER JOIN users u
        ON f.friend_user_id = u.user_id

    WHERE
        f.user_id = p_user_id
        AND f.status = 'accepted'

    LIMIT p_limit
    OFFSET p_offset;

END //

DELIMITER ;

-- TEST VIEW USER
SELECT * FROM view_user_info;

-- TEST VIEW STATISTICS
SELECT * FROM view_post_statistics;

-- TEST PROCEDURE
CALL sp_add_user(
    'newuser',
    '123456',
    'newuser@gmail.com'
);

-- TEST PROCEDURE CREATE POST
SET @new_post_id = 0;

CALL sp_create_post(
    1,
    'Bài viết mới',
    @new_post_id
);

SELECT @new_post_id AS new_post_id;
-- TEST PROCEDURE GET FRIENDS
CALL sp_get_friends(
    1,
    10,
    0
);