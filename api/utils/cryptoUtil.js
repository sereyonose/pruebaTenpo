const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const password = 'password';

let tokenWhiteList = [];


const encrypt = (text) => {
    return crypto.createHash("sha256").update(text, "binary").digest("base64");
};

const createToken = (data) => {
    const token = jwt.sign(data, password, {
        expiresIn: "300000" // 5 minutos de vida del token
    });
    tokenWhiteList.push(token);
    return token;
}

const validateToken = (token) => {
    try {
        if (isInWhiteList(token)) {
            jwt.verify(token, password);
            return true;
        }
        return false;
    } catch (err) {
        removeFromWhiteList(token);
        return false;
    }
}

const removeFromWhiteList = (token) => {
    return tokenWhiteList.filter((el) => el != token);
};

const isInWhiteList = (token) => {
    return tokenWhiteList.find((el) => ele === token)
}

const getEmailFromToken = (token) => {

    try {
        const decoded = jwt.decode(token);
        return decoded.email;
    }
    catch (e) {
        throw e;
    }
}

module.exports = { encrypt, createToken, validateToken, deleteToken: removeFromWhiteList, getEmailFromToken }