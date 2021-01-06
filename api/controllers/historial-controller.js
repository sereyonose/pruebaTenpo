const db = require('../db/db');
const validator = require('../utils/validator');

const history = async (req, res) => {
    const email = req.query.email;

    // Valida data de entrada
    if (!validator.historyData({ email })) {
        res.status(400).send();
        return;
    }
    try {
        const history = await db.getHistoryByEmail(email);
        await db.insertAction(email, 4);
        res.status(200).send({ history });
    }
    catch (e) {
        res.status(403).send();
    }
    return;
}

module.exports = { history };