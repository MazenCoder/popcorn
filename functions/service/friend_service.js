const Friend = require('../database/models/friend_model');
const User = require("../database/models/user_model");
const { formatHelper, selectUser} = require('../helper/format_helper');



module.exports.create = async (serviceData) => {
    try {
        let friend = new Friend({...serviceData});
        let result = await friend.save();
        const resultUser = await Friend.findOne({_id: result._id}).populate({
            path: 'requester recipient',
            select: selectUser
        }).exec();

        /*
        let result= await Comment.findOne({_id: comment._id}).populate({
            path: 'author',
            select: selectUser,
        }).populate({
            path: 'postId',
        }).exec();
        return formatHelper(result);
         */
        
        if (result) {
            const updateMyUser = await User.findOneAndUpdate(
                { _id: result.requester },
                { $addToSet: { friends: result._id }},
                { new: true }
            );

            const updateUFriend = await User.findOneAndUpdate(
                { _id: result.recipient },
                { $addToSet: { friends: result._id }},
                { new: true },
            );

            return formatHelper(resultUser);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, createPost service ${e}`);
        throw new Error(e);
    }
}


module.exports.update = async (id, serviceData) => {
    try {
        let result = await Friend.findOneAndUpdate({_id: id}, {...serviceData}, { new: true }).populate({
            path: 'requester recipient',
            select: selectUser
        }).exec();
        if (result) {
            console.error(`result: ${result}`);
            return result;
            // return formatHelper(result);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, createPost service ${e}`);
        throw new Error(e);
    }
}


module.exports.addOrUpdate = async (requester, recipient, status) => {
    try {
        const docUser= await Friend.findOneAndUpdate(
            {
                requester: requester,
                recipient: recipient
            },
            {
                requester: requester,
                recipient: recipient,
                status: status,
            },
            { upsert: true, new: true },
        );
        console.log(`addOrUpdate service ${docUser}`);
        return formatHelper(docUser);
    } catch (e) {
        console.error(`Error, addOrUpdate service ${e}`);
        throw new Error(e);
    }
}


module.exports.checkStatus = async (currentId, friendId) => {
    try {
        const result = await Friend.findOne(
            {
                "$or": [{
                    "requester": currentId,
                    "recipient": friendId,
                }, {
                    "requester": friendId,
                    "recipient": currentId,
                }]
            },
        );

        if (result) {
            return formatHelper(result);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, checkStatus service ${e}`);
        throw new Error(e);
    }
}


module.exports.cancelRequest = async (currentId, friendId) => {
    try {
        const result = await Friend.findOneAndRemove(
            {
                "$or": [{
                    "requester": currentId,
                    "recipient": friendId,
                }, {
                    "requester": friendId,
                    "recipient": currentId,
                }]
            },
        );

        if (result) {

            await User.findOneAndUpdate(
                { _id: result.recipient },
                { $pull: { friends: result._id }}
            );

            await User.findOneAndUpdate(
                { _id: result.requester },
                { $pull: { friends: result._id }}
            );

            return formatHelper(result);

        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, checkStatus service ${e}`);
        throw new Error(e);
    }
}


module.exports.rejected = async (id) => {
    try {
        const result= await Friend.findOneAndRemove({_id: id});
        if (result) {

            await User.findOneAndUpdate(
                { _id: result.recipient },
                { $pull: { friends: result._id }}
            );

            await User.findOneAndUpdate(
                { _id: result.requester },
                { $pull: { friends: result._id }}
            );

            return result;
            // return formatHelper(result);

        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, checkStatus service ${e}`);
        throw new Error(e);
    }
}
