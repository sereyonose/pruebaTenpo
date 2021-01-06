const pool = require('./pool');

const registerUser = async (data) => {
    let connection;
    try {
        connection = await pool.getConnection();
        await connection.query('INSERT INTO users(email, password, name, last_name) VALUES($1, $2, $3, $4)', data)
    }
    catch (e) {
        throw "Error al insertar nuevo usuario";
    }
    finally {
        connection.release();
    }
};

const userDoesNotExist = async (email) => {
    let connection;
    try {
        connection = await pool.getConnection();
        const res = await connection.query('SELECT id from users WHERE email = $1', [email])
        if (res.rows.length > 0) {
            throw "Ya existe el usuario"
        }
    }
    catch (e) {
        throw "Error al validar existencia de usuario";
    }
    finally {
        connection.release();
    }
};

const login = async (email, password) => {
    let connection;
    try {
        connection = await pool.getConnection();
        const res = await connection.query('SELECT name, last_name from users WHERE email = $1 AND password=$2', [email, password])
        if (res.rows.length <= 0) {
            throw "Usuario no registrado en BD"
        }
        return res.rows[0];
    }
    catch (e) {
        throw "Error al obtener datos de usuario";
    }
    finally {
        connection.release();
    }
};

const getHistoryByEmail = async (email) => {
    let connection;
    try {
        connection = await pool.getConnection();
        let res = await connection.query('SELECT id from users WHERE email = $1', [email])
        if (res.rows.length > 0) {
            res = await connection.query('SELECT a.description, uh.datetime from user_history as uh, actions as a WHERE uh.id_user = $1 AND uh.id_action = a.id ORDER BY uh.datetime DESC', [res.rows[0].id])
            return res.rows;
        }
        return [];
    }
    catch (e) {
        throw "Error al obtener historial de usuario";
    }
    finally {
        connection.release();
    }
};

const insertAction = async (email, action) => {
    let connection;
    try {
        connection = await pool.getConnection();
        let res = await connection.query('SELECT id from users WHERE email = $1', [email])
        if (res.rows.length > 0) {
            await connection.query('INSERT INTO user_history(id_user, id_action, datetime) VALUES($1, $2, NOW())', [res.rows[0].id, action])
        }
    }
    catch (e) {
        throw "Error insertando nueva accion";
    }
    finally {
        connection.release();
    }
};


module.exports = { registerUser, userDoesNotExist, login, getHistoryByEmail, insertAction }