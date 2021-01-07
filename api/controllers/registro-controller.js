const db = require('../db/db');
const validator = require('../utils/validator');
const cryptoUtil = require('../utils/cryptoUtil');

const register = async (req, res) => {
    const data = req.body;

    // Valida data de entrada
    if (!validator.registerData(data)) {
        res.status(400).send();
        return;
    }

    const email = data.email;
    try {
        // Valida que usuario no exista
        await db.userDoesNotExist(email)
    }
    catch (e) {
        res.status(409).send();
        return;
    }

    try {
        // Registra nuevo usuario
        await db.registerUser([data.email, cryptoUtil.encrypt(data.password), data.name, data.last_name]);
        await db.insertAction(email, 1);
        res.status(201).send();
    }
    catch (e) {
        res.status(500).send();
    }
    return;
};


module.exports = { register };