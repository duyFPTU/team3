-- MySQL 8.4
SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS library_db CHARACTER SET utf8mb4;
USE library_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('member','librarian','admin') NOT NULL DEFAULT 'member',
    status ENUM('active','locked') NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    publisher VARCHAR(100),
    publish_year INT,
    description TEXT,
    cover_url VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS book_copies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('available','borrowed','damaged','lost') NOT NULL DEFAULT 'available',
    condition_note VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (book_id, id),
    FOREIGN KEY (book_id) REFERENCES books(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    copy_id INT,
    status ENUM('pending','borrowing','returned','rejected','cancelled') NOT NULL DEFAULT 'pending',
    request_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    approved_date DATETIME,
    due_date DATE,
    return_date DATETIME,
    reject_reason VARCHAR(255),
    processed_by INT,
    -- Completed loans release the copy and the member/title pair for future loans.
    active_copy_id INT GENERATED ALWAYS AS
        (CASE WHEN status = 'borrowing' THEN copy_id END) STORED,
    active_book_id INT GENERATED ALWAYS AS
        (CASE WHEN status IN ('pending','borrowing') THEN book_id END) STORED,
    UNIQUE (active_copy_id),
    UNIQUE (user_id, active_book_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (book_id, copy_id) REFERENCES book_copies(book_id, id),
    FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE SET NULL,
    CHECK (
        (status IN ('borrowing','returned') AND copy_id IS NOT NULL
            AND approved_date IS NOT NULL AND due_date IS NOT NULL)
        OR (status IN ('pending','rejected','cancelled') AND copy_id IS NULL
            AND approved_date IS NULL AND due_date IS NULL)
    ),
    CHECK ((status = 'returned') = (return_date IS NOT NULL)),
    CHECK (status <> 'rejected' OR (reject_reason IS NOT NULL AND CHAR_LENGTH(TRIM(reject_reason)) > 0)),
    CHECK (approved_date >= request_date),
    CHECK (due_date >= DATE(approved_date)),
    CHECK (return_date >= approved_date)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    status ENUM('visible','hidden') NOT NULL DEFAULT 'visible',
    moderated_by INT,
    moderation_reason VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (moderated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
