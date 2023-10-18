const Level = require("../database/models/level_model");
const { formatHelper } = require('../helper/format_helper');


module.exports.add = async (serviceData) => {
    try {
        let level = new Level({...serviceData});
        let result = await level.save();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, add service ${e}`);
        throw new Error(e);
    }
}

module.exports.update = async (id, serviceData) => {
    try {
        const level = await Level.findOneAndUpdate({_id: id}, {...serviceData}, { new: true });
        if (level) {
            return formatHelper(level);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, update service ${e}`);
        throw new Error(e);
    }
}

module.exports.delete = async (id) => {
    try {
        const level = await Level.findOneAndDelete({_id: id});
        if (level) {
            return formatHelper(level);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, delete service ${e}`);
        throw new Error(e);
    }
}

module.exports.getLevel = async (id) => {
    try {
        const level = await Level.findOne({_id: id});
        if (level) {
            return formatHelper(level);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getLevel service ${e}`);
        throw new Error(e);
    }
}

module.exports.getAll = async () => {
    try {
        const levels = await Level.find({});
        if (levels) {
            return formatHelper(levels);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getAll service ${e}`);
        throw new Error(e);
    }
}