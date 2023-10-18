const Joi = require('joi');


module.exports.create = Joi.object().keys({
    _id: Joi.string().required(),
    email: Joi.string().required(),
    displayName: Joi.string().required(),
    password: Joi.string().allow(null),
    genderId: Joi.number().allow(null),
    token: Joi.string().allow(null),
    createdAt: Joi.date().required(),
    lastSeen: Joi.date().required(),
    photoProfile: Joi.string().allow(null),
    role: Joi.string().required(),
    dateBirth: Joi.date().allow(null),
    phone: Joi.string().allow(null),
    countryCode: Joi.string().allow(null),
    countryName: Joi.string().allow(null),
    dialingCode: Joi.string().allow(null),
    isVerified: Joi.boolean().required(),
    isBanned: Joi.boolean().required(),
    hideIntro: Joi.boolean().required(),
    bio: Joi.string().allow(null),
    blocks: Joi.array().items(Joi.string()).allow(null),
    runtimeType: Joi.string().allow(null),
});

module.exports.update = Joi.object().keys({
    _id: Joi.string().required(),
    email: Joi.string().required(),
    displayName: Joi.string().required(),
    password: Joi.string().allow(null),
    genderId: Joi.number().allow(null),
    token: Joi.string().allow(null),
    createdAt: Joi.date().required(),
    lastSeen: Joi.date().required(),
    photoProfile: Joi.string().allow(null),
    role: Joi.string().required(),
    dateBirth: Joi.date().allow(null),
    phone: Joi.string().allow(null),
    countryCode: Joi.string().allow(null),
    countryName: Joi.string().allow(null),
    dialingCode: Joi.string().allow(null),
    isVerified: Joi.boolean().required(),
    isBanned: Joi.boolean().required(),
    hideIntro: Joi.boolean().required(),
    bio: Joi.string().allow(null),
    blocks: Joi.array().items(Joi.string()).allow(null),
    runtimeType: Joi.string().allow(null),
});

module.exports.updateToken = Joi.object().keys({
    uid: Joi.string().required(),
    lastSeen: Joi.date().required(),
    token: Joi.string().allow(null)
});

module.exports.search = Joi.object().keys({
    uid: Joi.string().required(),
    name: Joi.string().required(),
    isBanned: Joi.boolean().required(),
    limit: Joi.number().allow(null),
});