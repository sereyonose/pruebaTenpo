const db = require('../db/db');
const validator = require('../utils/validator');
const cryptoUtil = require('../utils/cryptoUtil');

const logout = async (req, res) => {
    const data = req.body;

    // Valida data de entrada
    if (!validator.logoutData(data)) {
        res.status(400).send();
        return;
    }
    try {
        const email = cryptoUtil.getEmailFromToken(data.token);
        cryptoUtil.deleteToken(data.token)
        await db.insertAction(email, 5);
        res.status(200).send();
    }
    catch (e) {
        res.status(403).send();
    }
    return;
}

module.exports = { logout };