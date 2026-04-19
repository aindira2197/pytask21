CREATE TABLE SingletonPattern (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO SingletonPattern (id, name) VALUES (1, 'SingletonPattern');

CREATE TABLE Client (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    singleton_id INT,
    FOREIGN KEY (singleton_id) REFERENCES SingletonPattern(id)
);

CREATE TABLE Logger (
    id INT PRIMARY KEY,
    message VARCHAR(255) NOT NULL
);

CREATE PROCEDURE getInstance()
BEGIN
    DECLARE instance_id INT;
    SET instance_id = (SELECT id FROM SingletonPattern WHERE id = 1);
    IF instance_id IS NULL THEN
        INSERT INTO SingletonPattern (id, name) VALUES (1, 'SingletonPattern');
        SET instance_id = (SELECT id FROM SingletonPattern WHERE id = 1);
    END IF;
    SELECT instance_id;
END;

CREATE TRIGGER trg_Client_insert BEFORE INSERT ON Client
FOR EACH ROW
BEGIN
    CALL getInstance();
    IF (SELECT COUNT(*) FROM Client WHERE singleton_id = 1) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Singleton pattern violation';
    END IF;
END;

CREATE TRIGGER trg_SingletonPattern_insert BEFORE INSERT ON SingletonPattern
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM SingletonPattern) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Singleton pattern violation';
    END IF;
END;

DELIMITER //

CREATE PROCEDURE logMessage(message VARCHAR(255))
BEGIN
    INSERT INTO Logger (id, message) VALUES (NULL, message);
END //

DELIMITER ;

CREATE TRIGGER trg_SingletonPattern_update AFTER UPDATE ON SingletonPattern
FOR EACH ROW
BEGIN
    CALL logMessage(CONCAT('Singleton pattern updated: ', NEW.name));
END;

CREATE TRIGGER trg_SingletonPattern_delete AFTER DELETE ON SingletonPattern
FOR EACH ROW
BEGIN
    CALL logMessage(CONCAT('Singleton pattern deleted: ', OLD.name));
END;