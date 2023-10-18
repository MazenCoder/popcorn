const Comment = require("../database/models/comment_model");
const { formatHelper, selectUser} = require('../helper/format_helper');


module.exports.add = async (serviceData) => {
    try {
        const comment = new Comment({...serviceData});
        await comment.save();
        let result= await Comment.findOne({_id: comment._id}).populate({
            path: 'author',
            select: selectUser,
        }).populate({
            path: 'postId',
        }).exec();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, add comment ${e}`);
        throw new Error(e);
    }
}

module.exports.update = async (id, serviceData) => {
    try {
        const comment = await Comment.findOneAndUpdate({_id: id}, {...serviceData}, { new: true });
        if (comment) {
            return formatHelper(comment);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, update comment ${e}`);
        throw new Error(e);
    }
}

module.exports.delete = async (id) => {
    try {
        const comment = await Comment.findOneAndDelete({_id: id});
        if (comment) {
            return formatHelper(comment);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, delete comment ${e}`);
        throw new Error(e);
    }
}

module.exports.getComment = async (id) => {
    try {
        const comment = await Comment.findOne({_id: id});
        if (comment) {
            return formatHelper(comment);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getComment comment ${e}`);
        throw new Error(e);
    }
}

module.exports.getAllByAnswerId = async (answerId) => {
    try {
        const comments = await Comment.find({answerId: answerId})
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'postId',
            }).exec();
        if (comments) {
            return formatHelper(comments);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getAll comment ${e}`);
        throw new Error(e);
    }
}