const User = require('../database/models/user_model');
const { formatHelper, selectUser} = require('../helper/format_helper');
const utils = require("./../utils");



module.exports.sendFocusNotifications = async  (post) => {
    try {
        const { _id, genderId, geo, area, content } = post;
        const targetedNotifications = '83aa57c4-e89c-4f14-82a2-1ce250678f49';
        console.log(`sendFocusNotifications: ${genderId} ${geo} ${area}`);

        if (genderId !== 2 && geo === false && area === false) {
            const users = await User.find({genderId: genderId, token: {$ne: null}, skills: targetedNotifications});
            console.log(`users: ${users}`);
            if (users) {
                let tokens = [];
                for (let i = 0; i < users.length; i++) {
                    const token = users[i].token;
                    if (token) {
                        tokens.push(token);
                    }
                }
                const message = {
                    data: {
                        title: `Nouveau poste!`,
                        body: `${content}`,
                        action: "postTargeting",
                        id_action: _id,
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                    }
                };
                await  utils.sendNotify(message, tokens);
            }
        }
    } catch (e) {
        console.error(`Error, sendFocusNotifications service: ${e}`);
        throw new Error(e);
    }
}

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
        const user = await User.findOneAndUpdate({_id: uid}, {...serviceData}, { new: true })
            .select(selectUser);
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
        let user = await User.findOne({_id: uid}).select(selectUser);
        if (user.friends.length >= 10 && user.targetFriends === false) {
            user = await User.findOneAndUpdate({_id: uid}, {targetFriends:  true}, {new: true}).select(selectUser);
        } else if (user.friends.length < 10 && user.targetFriends === true) {
            user = await User.findOneAndUpdate({_id: uid}, {targetFriends:  false}, {new: true}).select(selectUser);
        }
        console.info(`user: ${user}`);
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

module.exports.getUserFriends = async (uid, status, limit, page) => {
    try {
        const user = await User.findOne({_id: uid})
            .populate({
                path: 'friends',
                // match: { status: status },
                match: { status: { "$in":[status, 0] }},
                options: {
                    limit: limit,
                    // sort: { created: -1},
                    skip: (page - 1) * limit,
                },
                populate: {
                    path: 'requester recipient',
                    select: selectUser
                },
            }).exec();
        console.error(`===> , user ${user}`);
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


/*
module.exports.getRequestFriends = async (uid, status, limit, page) => {
    try {
        const user = await User.findOne({_id: uid})
            .populate({
                path: 'friends',
                match: { status: status, recipient: uid},
                options: {
                    limit: limit,
                    // sort: { created: -1},
                    skip: (page - 1) * limit,
                },
                populate: {
                    path: 'requester recipient',
                    select: selectUser
                },
            }).exec();
        console.error(`===> , user ${user}`);
        if (user) {
            return formatHelper(user);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getUser service ${e}`);
        throw new Error(e);
    }
}
*/


module.exports.getFriendsIDs = async (uid) => {
    try {
        const user = await User.findOne({_id: uid})
            .populate({
                path: 'friends',
                match: { status: 2 },
                select: '_id recipient requester status',
            });//.select(selectUser);
        console.log(`getFriendsId, ${user}`);
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

module.exports.getTestFriends = async (uid) => {
    const users = await User.aggregate([
        { "$lookup": {
                from: "friends",
                // "let": { "friends": "$friends" },
                // localField: "_id",
                // foreignField
                as: "users",
                // "as": "friends",
                "pipeline": [
                    { "$match": {
                            // "recipient": uid,
                            // "$expr": { "$in": [ "$_id", "$$friends" ] }
                            "$or": [{
                                requester: uid,
                                status: 2,
                            }, {
                                recipient: uid,
                                status: 2,
                            }],
                        }},
                ],
            }},
        { "$addFields": {
                "friendsStatus": {
                    "$ifNull": [ { "$min": "$friends.status" }, 0 ]
                }
            }}
    ]);
    console.log(`====== users ======: ${users._id}`);
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

module.exports.decrementCoins = async (uid, coins = -1) => {
    try {
        let user = await User.findOneAndUpdate({_id: uid}, { $inc: {'coins': coins}}, {new: true}).select(selectUser);
        return formatHelper(user);
    } catch (e) {
        console.error(`Error, decrementCoins service: ${e}`);
        throw new Error(e);
    }
}

module.exports.incrementXps = async (uid, xp = 1) => {
    try {
        let user = await User.findOneAndUpdate({_id: uid}, { $inc: {'xp': xp}}, {new: true}).select(selectUser);
        return formatHelper(user);
    } catch (e) {
        console.error(`Error, incrementXps service: ${e}`);
        throw new Error(e);
    }
}

module.exports.addSkill = async (id, uid) => {
    try {
        const user = await User.findOneAndUpdate(
            { _id: uid },
            { $addToSet: { skills: id }},
            { new: true }
        ).select(selectUser);
        if (user) {
            return formatHelper(user);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, addSkill service: ${e}`);
        throw new Error(e);
    }
}