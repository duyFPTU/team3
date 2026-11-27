-- One transaction: repeat imports skip the fixture once its unique member email exists.
SET NAMES utf8mb4;
USE library_db;

DROP PROCEDURE IF EXISTS seed_library_demo;
DELIMITER //
CREATE PROCEDURE seed_library_demo()
seed: BEGIN
    DECLARE reader_id, staff_id, literature_id, science_id INT;
    DECLARE first_author, second_author, first_book, second_book, loan_copy INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    -- Create the local demo administrator even when an older seed was imported.
    IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@demo.invalid') THEN
        INSERT INTO users (full_name, email, password_hash, role, status)
        VALUES ('Quản trị viên mẫu', 'admin@demo.invalid',
                COALESCE(@demo_admin_hash, '!'), 'admin',
                IF(@demo_admin_hash IS NULL, 'locked', 'active'));
    END IF;

    IF EXISTS (SELECT 1 FROM users WHERE email = 'reader@demo.invalid') THEN
        COMMIT;
        LEAVE seed;
    END IF;

    -- Historical demo accounts are locked. The application creates live accounts.
    INSERT INTO users (full_name, email, password_hash, role, status)
    VALUES ('Bạn đọc mẫu', 'reader@demo.invalid', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'member', 'locked');
    SET reader_id = LAST_INSERT_ID();
    INSERT INTO users (full_name, email, password_hash, role, status)
    VALUES ('Thủ thư mẫu', 'staff@demo.invalid', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'librarian', 'locked');
    SET staff_id = LAST_INSERT_ID();

    INSERT INTO categories (name) VALUES ('Văn học');
    SET literature_id = LAST_INSERT_ID();
    INSERT INTO categories (name) VALUES ('Khoa học');
    SET science_id = LAST_INSERT_ID();

    INSERT INTO authors (name) VALUES ('Tô Hoài');
    SET first_author = LAST_INSERT_ID();
    INSERT INTO authors (name) VALUES ('Stephen Hawking');
    SET second_author = LAST_INSERT_ID();

    INSERT INTO books (title, author_id, category_id) VALUES ('Dế Mèn phiêu lưu ký', first_author, literature_id);
    SET first_book = LAST_INSERT_ID();
    INSERT INTO books (title, author_id, category_id) VALUES ('Lược sử thời gian', second_author, science_id);
    SET second_book = LAST_INSERT_ID();

    INSERT INTO book_copies (book_id, barcode) VALUES (first_book, 'VH-001');
    SET loan_copy = LAST_INSERT_ID();
    INSERT INTO book_copies (book_id, barcode) VALUES (first_book, 'VH-002'), (second_book, 'KH-001');

    INSERT INTO borrow_records (user_id, book_id, copy_id, status, request_date, approved_date, due_date, return_date, processed_by)
    VALUES (reader_id, first_book, loan_copy, 'returned', NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 9 DAY,
            CURRENT_DATE - INTERVAL 2 DAY, NOW() - INTERVAL 3 DAY, staff_id);
    INSERT INTO reviews (user_id, book_id, rating, comment)
    VALUES (reader_id, first_book, 5, 'Câu chuyện dễ đọc và giàu hình ảnh.');
    COMMIT;
END//
DELIMITER ;
CALL seed_library_demo();
DROP PROCEDURE seed_library_demo;
