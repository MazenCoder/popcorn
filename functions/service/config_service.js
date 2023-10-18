const Config = require("../database/models/config_model");
const { formatHelper, selectUser, selectConfigs} = require('../helper/format_helper');


module.exports.update = async (id, serviceData) => {
    try {
        const config = await Config.findOneAndUpdate({_id: id}, {...serviceData}, { new: true });
        if (config) {
            return formatHelper(config);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, update service ${e}`);
        throw new Error(e);
    }
}

// module.exports.update = async (id, verifyEmail) => {
//     try {
//         const config = await Config.findOneAndUpdate({_id: id}, {verifyEmail: verifyEmail}, { new: true });
//         if (config) {
//             return formatHelper(config);
//         } else {
//             return null;
//         }
//     } catch (e) {
//         console.error(`Error, update service ${e}`);
//         throw new Error(e);
//     }
// }


module.exports.getConfig = async (id) => {
    try {
        const config = await Config.findOne({_id: id}).select(selectConfigs);
        if (config) {
            return formatHelper(config);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getConfig service ${e}`);
        throw new Error(e);
    }
}