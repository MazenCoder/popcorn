const Post = require('../database/models/post_model');
const Answer = require('../database/models/answer_model');
const Comment = require('../database/models/comment_model');
const { formatHelper, selectUser, idConfig} = require('../helper/format_helper');
const configService = require("./config_service");
const userService = require("./user_service");



module.exports.create = async (serviceData) => {
    try {
        const { _id } = serviceData;
        const userExist = await Post.findOne({_id: _id});
        if (userExist) {
            return null;
        } else {
            let post = new Post({...serviceData});
            await post.save();
            const result = await Post.findOne({_id: post._id}).populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: post.author },
                select: selectUser,
            }).exec();
            return formatHelper(result);
        }
    } catch (e) {
        console.error(`Error, createPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.update = async (id, author, serviceData) => {
    try {
        let post = await Post.findOneAndUpdate({_id: id}, {...serviceData}, { new: true })
            .populate({
            path: 'author',
            select: selectUser,
        }).populate({
            path: 'answers',
            // match: { author: uid },
            sort: { likes: -1 },
            populate : {
                path : 'author',
                select: selectUser,
            }
        }).populate({
            path: 'favorites',
            match: { _id: author },
            select: selectUser,
        }).exec();
        if (post) {
            return formatHelper(post);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, updatePost service ${e}`);
        throw new Error(e);
    }
}

module.exports.updateStatus = async (id, author, serviceData) => {
    try {
        let post = await Post.findOneAndUpdate({_id: id}, {...serviceData}, { new: true })
            .populate({
            path: 'author',
            select: selectUser,
        }).populate({
            path: 'answers',
            // match: { author: uid },
            sort: { likes: -1 },
            populate : {
                path : 'author',
                select: selectUser,
            }
        }).populate({
            path: 'favorites',
            match: { _id: author },
            select: selectUser,
        }).exec();
        if (post) {
            return formatHelper(post);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, updatePost service ${e}`);
        throw new Error(e);
    }
}

module.exports.likeUnlike = async (id, uid, authorId) => {
    try {

        const exist = await Post.findOne({_id: id, likes: {"$eq": uid}});
        if (exist) {
            const updatePost = await Post.findOneAndUpdate(
                { _id: id },
                { $pull: { likes: uid }},
                { new: true }
            ).populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();
            return formatHelper(updatePost);
        } else {
            const updatePost = await Post.findOneAndUpdate(
                { _id: id },
                { $addToSet: { likes: uid }},
                { new: true }
            ).populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();
            const dataConfig = await configService.getConfig(idConfig);
            const currentUser = await userService.decrementCoins(uid, -dataConfig.costLike);
            await userService.incrementXps(authorId, dataConfig.gainXp);
            return [formatHelper(updatePost), currentUser];
        }

    } catch (e) {
        console.error(`Error, updatePost service ${e}`);
        throw new Error(e);
    }
}

module.exports.saveUnSave = async (id, uid) => {
    try {
        const exist = await Post.findOne({_id: id, favorites: {"$eq": uid}});
        if (exist) {
            const updatePost = await Post.findOneAndUpdate(
                { _id: id },
                { $pull: { favorites: uid }},
                { new: true }
            ).populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();
            return formatHelper(updatePost);
        } else {
            const updatePost = await Post.findOneAndUpdate(
                { _id: id },
                { $addToSet: { favorites: uid }},
                { new: true }
            ).populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();
            return formatHelper(updatePost);
        }

    } catch (e) {
        console.error(`Error, updatePost service ${e}`);
        throw new Error(e);
    }
}

module.exports.fetch = async (query, uid, limit, page) => {
    try {
        /*
        const posts = await Post.aggregate([
            {
                $match: query,
            },
            {
                $lookup: {
                    from: 'users',
                    localField: 'author',
                    foreignField: '_id',
                    as: 'author',
                },
            },
            {
                $unwind: {
                    path: "$author",
                    preserveNullAndEmptyArrays: true,
                }
            },
            {
                $lookup: {
                    from: 'answers',
                    localField: "_id",
                    foreignField: 'postId',
                    as: 'myAnswers',
                    pipeline: [
                        { $match: { author: uid }},
                        {
                            $lookup: {
                                from: 'users',
                                localField: 'author',
                                foreignField: '_id',
                                as: "author",
                                pipeline: [
                                    {
                                        $project: {
                                            "_id": 1,
                                            "email": 1,
                                            "displayName": 1,
                                            "genderId": 1,
                                            "token": 1,
                                            "lastSeen": 1,
                                            "photoProfile": 1,
                                            "role": 1,
                                            "dateBirth": 1,
                                            "isVerified": 1,
                                            "isBanned": 1,
                                            "hideIntro": 1,
                                            "coins": 1,
                                            "level": 1,
                                            "xp": 1,
                                            "createdAt": 1,
                                            "updatedAt": 1,
                                            "bio": 1,
                                            "countryCode": 1,
                                            "countryName": 1,
                                            "dialingCode": 1,
                                            "phone": 1,
                                        }
                                    },
                                ]
                            },
                        },
                        {
                            $unwind: {
                                path: "$author",
                                preserveNullAndEmptyArrays: true,
                            }
                        },
                    ],
                },
            },
            {
                $lookup: {
                    from: 'answers',
                    localField: "_id",
                    foreignField: 'postId',
                    as: 'answers',
                    pipeline: [
                        {
                            $sort: { "likes": -1 }
                        },
                        {
                            $limit: 1
                        },
                        {
                            $lookup: {
                                from: 'users',
                                localField: 'author',
                                foreignField: '_id',
                                as: "author",
                                pipeline: [
                                    {
                                        $project: {
                                            "_id": 1,
                                            "email": 1,
                                            "displayName": 1,
                                            "genderId": 1,
                                            "token": 1,
                                            "lastSeen": 1,
                                            "photoProfile": 1,
                                            "role": 1,
                                            "dateBirth": 1,
                                            "isVerified": 1,
                                            "isBanned": 1,
                                            "hideIntro": 1,
                                            "coins": 1,
                                            "level": 1,
                                            "xp": 1,
                                            "createdAt": 1,
                                            "updatedAt": 1,
                                            "bio": 1,
                                            "countryCode": 1,
                                            "countryName": 1,
                                            "dialingCode": 1,
                                            "phone": 1,
                                        }
                                    },
                                ]
                            },
                        },
                        {
                            $unwind: {
                                path: "$author",
                                preserveNullAndEmptyArrays: true,
                            }
                        },
                    ]
                },
            },
            // {
            //     $unwind: {
            //         path: "$answers",
            //         preserveNullAndEmptyArrays: true,
            //     }
            // },
        ]).limit(limit)
          .skip((page - 1) * limit)
          .sort({ 'createdAt': -1 })
          .exec();
        */

        const posts = await Post.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .sort({ createdAt: -1 })
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // options: { limit: 2 },
                // match: {
                //     $and: [
                //         {
                //             $or:[
                //                 { $expr: { $gt: [ { $size: "$likes"}, 1 ] }, author: uid },
                //                 { $expr: { $gt: [ { $size: "$likes"}, 1 ] }, author: {$ne: uid} },
                //             ],
                //         },
                //         {
                //             $or:[
                //                 { $expr: { $gt: [ { $size: "$likes"}, 0 ] }, author: uid },
                //                 { $expr: { $gt: [ { $size: "$likes"}, 0 ] }, author: {$ne: uid} },
                //             ],
                //         }

                        // { 'likes': { $size: "$likes" } },
                        // { author: uid },
                        // { $expr: { $gt: [ { $size: "$likes"}, 1 ] } },
                        // { 'likes': { $exists: false } },
                //     ],
                // },
                // sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();
        if (posts) {
            return formatHelper(posts);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.fetchByAuthor = async (query, uid, limit, page) => {
    try {
        const posts = await Post.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .sort({ createdAt: -1 })
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();

        if (posts) {
            return formatHelper(posts);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.getPost = async (id, uid) => {
    try {

        const post = await Post.findOne({_id: id})
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid},
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();

        if (post) {
            return formatHelper(post);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.delete = async (id) => {
    try {
        let post = await Post.findByIdAndDelete({_id: id})
        if (post) {
            return formatHelper(post);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, createPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.deleteAllOld = async (status) => {
    try {
        const posts = await Post.find({
            updatedAt: { $lte: new Date((new Date().getTime() - (24 * 60 * 60 * 1000))).toISOString()},
            status: status,
        });

        if (posts.length > 0) {
            for (let i = 0; i < posts.length; i++) {
                await Answer.deleteMany({postId: posts[i]._id})
                await Comment.deleteMany({postId: posts[i]._id});
                await Post.deleteOne({_id: posts[i]._id});
            }
            return formatHelper(posts);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, deleteAllOld service ${e}`);
        throw new Error(e);
    }
}

module.exports.search = async (query, uid, limit, page) => {
    try {
        const posts = await Post.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { uid: uid}
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();

        if (posts) {
            return formatHelper(posts);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.saved = async (query, uid, limit, page) => {
    try {
        const posts = await Post.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { uid: uid}
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();

        if (posts) {
            return formatHelper(posts);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getPost service ${e}`);
        throw new Error(e);
    }
}

module.exports.getPostWhenLikeAnswer = async (id, uid) => {
    try {
        const post = await Post.findOne({_id: id})
            .populate({
                path: 'author',
                select: selectUser,
            }).populate({
                path: 'answers',
                // match: { author: uid },
                sort: { likes: -1 },
                populate : {
                    path : 'author',
                    select: selectUser,
                }
            }).populate({
                path: 'favorites',
                match: { _id: uid },
                select: selectUser,
            }).exec();

        if (post) {
            return formatHelper(post);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getPost service ${e}`);
        throw new Error(e);
    }
}