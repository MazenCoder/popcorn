const Type = require("../database/models/type_model");
const { formatHelper } = require('../helper/format_helper');


module.exports.add = async (serviceData) => {
    try {
        let type = new Type({...serviceData});
        let result = await type.save();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, add service ${e}`);
        throw new Error(e);
    }
}

module.exports.update = async (id, serviceData) => {
    try {
        const type = await Type.findOneAndUpdate({_id: id}, {...serviceData}, { new: true });
        if (type) {
            return formatHelper(type);
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
        const type = await Type.findOneAndDelete({_id: id});
        if (type) {
            return formatHelper(type);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, delete service ${e}`);
        throw new Error(e);
    }
}

module.exports.getType = async (id) => {
    try {
        const type = await Type.findOne({_id: id});
        if (type) {
            return formatHelper(type);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getType service ${e}`);
        throw new Error(e);
    }
}

module.exports.getAll = async () => {
    try {
        const types = await Type.find({});
        if (types) {
            return formatHelper(types);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getAll service ${e}`);
        throw new Error(e);
    }
}