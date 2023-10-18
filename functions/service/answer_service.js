const Answer = require("../database/models/answer_model");
const { formatHelper, selectUser, idConfig} = require('../helper/format_helper');
const userService = require("../service/user_service");
const configService = require("./config_service");


module.exports.add = async (serviceData) => {
    try {
        let answer = new Answer({...serviceData});
        let result = await answer.save();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, add service ${e}`);
        throw new Error(e);
    }
}

module.exports.update = async (id, serviceData) => {
    try {
        const answer = await Answer.findOneAndUpdate({_id: id}, {...serviceData}, { new: true });
        if (answer) {
            return formatHelper(answer);
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
        const answer = await Answer.findOneAndDelete({_id: id});
        if (answer) {
            const updatePost = await Post.findOneAndUpdate(
                { _id: answer.postId },
                { $pull: { answers: id }},
                { new: true }
            );
            console.log(`updatePost: ${updatePost}`);
            return formatHelper(answer);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, delete service ${e}`);
        throw new Error(e);
    }
}

module.exports.getAnswer = async (id) => {
    try {
        const answer = await Answer.findOne({_id: id});
        if (answer) {
            return formatHelper(answer);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getType service ${e}`);
        throw new Error(e);
    }
}

module.exports.bestAnswer = async (postId, optionId, limit) => {
    try {
        const answers = await Answer.find({postId: postId, optionId: { $ne: optionId }})
            .sort('likes: -1')
            .limit(limit)
            .populate({
                path: 'author',
            }).populate({
                path: 'likes',
                select: selectUser,
            }).exec();

        console.log('answers: ', answers);
        if (answers) {
            return formatHelper(answers);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getType service ${e}`);
        throw new Error(e);
    }
}


module.exports.allAnswer = async (postId) => {
    try {
        const answers = await Answer.find({postId: postId})
            .populate({
                path: 'author',
            }).exec();
        console.log(`answers: ${postId}`, answers);
        if (answers) {
            return formatHelper(answers);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getType service ${e}`);
        throw new Error(e);
    }
}

module.exports.likeUnlike = async (id, uid, authorId) => {
    try {
        const exist = await Answer.findOne({_id: id, likes: {"$in": [uid]}});
        if (exist) {
            //! Unlike post
            const updateAnswer = await Answer.findOneAndUpdate(
                { _id: id },
                { $pull: { likes: uid }},
                { new: true }
            ).populate({
                path: 'author',
            }).populate({
                path: 'likes',
                select: selectUser,
            }).exec();
            return formatHelper(updateAnswer);
        } else {
            //! Like post
            const updateAnswer = await Answer.findOneAndUpdate(
                { _id: id },
                { $addToSet: { likes: uid }},
                { new: true }
            ).populate({
                path: 'author',
            }).populate({
                path: 'likes',
                select: selectUser,
            }).exec();
            const dataConfig = await configService.getConfig(idConfig);
            const currentUser = await userService.decrementCoins(uid, -dataConfig.costLike);
            await userService.incrementXps(authorId, dataConfig.gainXp);
            return [formatHelper(updateAnswer), currentUser];
        }
    } catch (e) {
        console.error(`Error, updatePost service ${e}`);
        throw new Error(e);
    }
}


module.exports.getAllAnswerByUid = async (uid) => {
    try {
        const answers = await Answer.find({author: uid}).select('_id');
        if (answers) {
            return formatHelper(answers);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getType service ${e}`);
        throw new Error(e);
    }
}