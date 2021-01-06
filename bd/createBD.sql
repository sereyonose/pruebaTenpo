DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS actions;
DROP TABLE IF EXISTS user_history;

CREATE TABLE users (
    id SERIAL CONSTRAINT pkey PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    password TEXT NOT NULL,
    name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL);
    
CREATE TABLE actions (
    id SERIAL CONSTRAINT pkey_actions PRIMARY KEY,
    description VARCHAR(100) NOT NULL);

INSERT INTO actions(description) VALUES('REGISTER');
INSERT INTO actions(description) VALUES('LOGIN');
INSERT INTO actions(description) VALUES('SUMA');
INSERT INTO actions(description) VALUES('HISTORIAL');
INSERT INTO actions(description) VALUES('LOGOUT');

CREATE TABLE user_history (
    id SERIAL CONSTRAINT pkey_user_history PRIMARY KEY,
    id_user INTEGER NOT NULL,
    id_action INTEGER NOT NULL,
    datetime timestamp);