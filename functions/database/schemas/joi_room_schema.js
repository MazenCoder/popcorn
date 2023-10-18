const Joi = require('joi');


module.exports.create = Joi.object().keys({
    _id: Joi.string().required(),
    author: Joi.string().required(),
    name: Joi.string().required(),
    description: Joi.string().required(),
    bio: Joi.string().allow(null),
    status: Joi.number().required(),
    token: Joi.string().allow(null),
    roomImage: Joi.string().allow(null),
    backgroundImage: Joi.string().allow(null),
    toastMessage: Joi.string().allow(null),
    members: Joi.array().items(Joi.string()).allow(null),
    banned: Joi.array().items(Joi.string()).allow(null),
    createdAt: Joi.date().required(),
    updatedAt: Joi.date().required(),
    runtimeType: Joi.string().allow(null),
});


module.exports.update = Joi.object().keys({
    _id: Joi.string().required(),
    author: Joi.string().required(),
    name: Joi.string().required(),
    description: Joi.string().required(),
    bio: Joi.string().allow(null),
    status: Joi.number().required(),
    token: Joi.string().allow(null),
    roomImage: Joi.string().allow(null),
    backgroundImage: Joi.string().allow(null),
    toastMessage: Joi.string().allow(null),
    members: Joi.array().items(Joi.string()).allow(null),
    banned: Joi.array().items(Joi.string()).allow(null),
    createdAt: Joi.date().required(),
    updatedAt: Joi.date().required(),
    runtimeType: Joi.string().allow(null),
});


module.exports.updateToken = Joi.object().keys({
    _id: Joi.string().required(),
    token: Joi.string().allow(null)
});


module.exports.search = Joi.object().keys({
    uid: Joi.string().required(),
    status: Joi.number().required(),
    page: Joi.number().required(),
    limit: Joi.number().allow(null),
});


module.exports.fetch = Joi.object().keys({
    uid: Joi.string().required(),
    status: Joi.number().required(),
    page: Joi.number().required(),
    limit: Joi.number().allow(null),
});
