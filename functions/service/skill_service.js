const Skill = require("../database/models/skill_model");
const { formatHelper, selectUser} = require('../helper/format_helper');



module.exports.add = async (serviceData) => {
    try {
        let skill = new Skill({...serviceData});
        let result = await skill.save();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, addSkill service ${e}`);
        throw new Error(e);
    }
}

module.exports.update = async (id, uid, serviceData) => {
    try {
        const skill = await Skill.findOneAndUpdate({_id: id}, {...serviceData}, { new: true });
        //     .populate({
        //     path: 'users',
        //     match: { _id: uid },
        //     select: selectUser,
        // }).exec();
        if (skill) {
            return formatHelper(skill);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, updateSkill service ${e}`);
        throw new Error(e);
    }
}

module.exports.delete = async (id) => {
    try {
        const skill = await Skill.findOneAndDelete({_id: id});
        if (skill) {
            return formatHelper(skill);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, deleteSkill service ${e}`);
        throw new Error(e);
    }
}

module.exports.getSkill = async (id) => {
    try {
        const skill = await Skill.findOne({_id: id});
        if (skill) {
            return formatHelper(skill);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getSkill service ${e}`);
        throw new Error(e);
    }
}

module.exports.getAll = async () => {
    try {
        const skills = await Skill.find({});
        if (skills) {
            return formatHelper(skills);
        } else {
            return null;
        }
    } catch (e) {
        console.error(`Error, getAll service ${e}`);
        throw new Error(e);
    }
}