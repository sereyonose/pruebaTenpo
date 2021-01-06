const db = require('../db/db');
const validator = require('../utils/validator');
const cryptoUtil = require('../utils/cryptoUtil');

const login = async (req, res) => {
    const data = req.body;

    // Valida data de entrada
    if (!validator.loginData(data)) {
        res.status(400).send();
        return;
    }
    try {
        const userData = await db.login(data.email, cryptoUtil.encrypt(data.password));
        const token = cryptoUtil.createToken({ email: data.email, name: userData.name, last_name: userData.last_name })
        await db.insertAction(data.email, 2);
        res.status(200).send({ token });
    }
    catch (e) {
        res.status(403).send();
    }
    return;
}

module.exports = { login };