const Joi = require('joi');

module.exports.validateBody = (schema) => {
    return (req, res, next) => {
        const error = validateObject(req.body, schema);
        if (error) {
            return res.status(400).json({
                status: 400,
                message: error,
                body: {}
            });
        }
        return next();
    }
}



const validateObject = (data, schema) => {
    const { error } = schema.validate(data);
    if (error) {
        console.error(`Schema validation result ==== ${error}`);
        return `${error}`;
    }
    return null;
}