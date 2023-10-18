const User = require('../database/models/user_model');
const { formatHelper, selectUser} = require('../helper/format_helper');



module.exports.createUser = async (serviceData) => {
    try {
        let user = new User({...serviceData});
        let result = await user.save();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, createUser service: ${e}`);
        throw new Error(e);
    }
}

module.exports.updateUser = async (uid, serviceData) => {
    try {
        const user = await User.findOneAndUpdate({_id: uid}, {...serviceData}, { new: true });//.select(selectUser);
        if (user) {
            return formatHelper(user);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, updateUser service: ${e}`);
        throw new Error(e);
    }
}

module.exports.getUser = async (uid) => {
    try {
        let user = await User.findOne({_id: uid});//.select(selectUser);
        if (user) {
            return formatHelper(user);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getUser service: ${e}`);
        throw new Error(e);
    }
}

module.exports.checkExists = async (uid) => {
    try {
        let checkUser = await User.exists({_id: uid});
        console.log(`checkUser, checkExists service ${checkUser}`);
        return checkUser;
    } catch (e) {
        console.error(`Error, checkExists service: ${e}`);
        throw new Error(e);
    }
}

module.exports.checkCreate = async (uid, serviceData) => {
    try {
        const userExist = await User.findOne({_id: uid});
        if (userExist) {
            return formatHelper(userExist);
        } else {
            let user = new User({...serviceData});
            let result = await user.save();
            return formatHelper(result);
        }
    } catch (e) {
        console.error(`Error, checkCreate service: ${e}`);
        throw new Error(e);
    }
}

module.exports.updateToken = async (uid, token, lastSeen) => {
    try {
        let user = await User.findOneAndUpdate({_id: uid}, {token: token, lastSeen: lastSeen}, {new: true});
        return formatHelper(user);
    } catch (e) {
        console.error(`Error, updateToken service: ${e}`);
        throw new Error(e);
    }
}

module.exports.search = async (query, limit) => {
    try {
        const users = await User.find(query).limit(limit)
        if (users) {
            return formatHelper(users);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, search service: ${e}`);
        throw new Error(e);
    }
}

