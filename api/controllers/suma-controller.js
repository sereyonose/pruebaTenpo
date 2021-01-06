const db = require('../db/db');
const cryptoUtil = require('../utils/cryptoUtil');

const sum = async (req, res) => {
    const { n1, n2 } = req.body;
    try {
        const email = cryptoUtil.getEmailFromToken(data.token);
        await db.insertAction(email, 3);
        res.status(200).send({ suma: n1 + n2 });
    }
    catch (e) {
        res.status(500).send();
    }

}

module.exports = { sum };