const Room = require('../database/models/room_model');
const { formatHelper, selectUser} = require('../helper/format_helper');



module.exports.getRoom = async (id) => {
    try {
        let room = await Room.findOne({_id: id}).populate({
            path: 'author',
            // select: selectUser,
        }).exec();
        if (room) {
            return formatHelper(room);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getRoom service: ${e}`);
        throw new Error(e);
    }
}

module.exports.getRoomByAuthorId = async (uid) => {
    try {
        let room = await Room.findOne({author: uid}).populate({
            path: 'author',
            // select: selectUser,
        }).exec();
        if (room) {
            return formatHelper(room);
        } else {
            return null;
        }

    } catch (e) {
        console.error(`Error, getRoomByAuthorId service: ${e}`);
        throw new Error(e);
    }
}

module.exports.createRoom = async (serviceData) => {
    try {
        const room = new Room({...serviceData});
        const result = await room.save();
        const populatedResult = await Room.populate(
            result, {
            path: 'author',
            // select: selectUser,
        });
        return formatHelper(populatedResult);
    } catch (e) {
        console.error(`Error, createRoom service: ${e}`);
        throw new Error(e);
    }
}

module.exports.updateRoom = async (id, serviceData) => {
    try {
        const room = await Room.findOneAndUpdate({_id: id}, {...serviceData}, { new: true })
            .populate({
            path: 'author',
            // select: selectUser,
        }).exec();
        if (room) {
            return formatHelper(room);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, updateRoom service: ${e}`);
        throw new Error(e);
    }
}

module.exports.updateToken = async (id, token) => {
    try {
        let room = await Room.findOneAndUpdate({_id: id}, {token: token}, {new: true})
            .populate({
            path: 'author',
            // select: selectUser,
        }).exec();
        return formatHelper(room);
    } catch (e) {
        console.error(`Error, updateToken service: ${e}`);
        throw new Error(e);
    }
}

module.exports.search = async (query, page, limit) => {
    try {
        const rooms = await Room.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .sort({ createdAt: -1 })
            .populate({
                path: 'author',
                // select: selectUser,
            }).exec();
        if (rooms) {
            return formatHelper(rooms);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, search service: ${e}`);
        throw new Error(e);
    }
}

module.exports.fetch = async (query, page, limit) => {
    try {
        const rooms = await Room.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .sort({ createdAt: -1 })
            .populate({
                path: 'author',
                // select: selectUser,
            }).exec();
        console.error(`===> , rooms ${rooms}`);
        if (rooms) {
            return formatHelper(rooms);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, fetch service: ${e}`);
        throw new Error(e);
    }
}
