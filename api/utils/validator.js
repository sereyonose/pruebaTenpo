const Joi = require('@hapi/joi');

const registerData = (data) => {
    const schema = Joi.object({
        name: Joi.string()
            .alphanum()
            .min(3)
            .max(30)
            .required(),
        last_name: Joi.string()
            .alphanum()
            .min(3)
            .max(30)
            .required(),     
        password: Joi.string()
            .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')),
    
        email: Joi.string().email().max(256).required()
    });
    const result = schema.validate(data);
    if(('error' in result) ) {
        return false;
    }
    return true;
}

const loginData = (data) => {
    const schema = Joi.object({
        password: Joi.string()
            .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')),    
        email: Joi.string().email().max(256).required()
    });

    const result = schema.validate(data);
    if(('error' in result) ) {
        return false;
    }
    return true;
};

const logoutData = (data) => {
    const schema = Joi.object({ 
        token: Joi.string().required()
    });

    const result = schema.validate(data);
    if(('error' in result) ) {
        return false;
    }
    return true;
};

const historyData = (data) => {
    const schema = Joi.object({ 
        email: Joi.string().email().max(256).required()
    });

    const result = schema.validate(data);
    if(('error' in result) ) {
        return false;
    }
    return true;
};
module.exports = {registerData, loginData, logoutData, historyData};