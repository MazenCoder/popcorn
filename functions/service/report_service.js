const Report = require("../database/models/report_model");
const { formatHelper, selectUserReport} = require('../helper/format_helper');


module.exports.create = async (serviceData) => {
    try {
        let report = new Report({...serviceData});
        let result = await report.save();
        return formatHelper(result);
    } catch (e) {
        console.error(`Error, add service ${e}`);
        throw new Error(e);
    }
}


module.exports.fetch = async (query, limit, page) => {
    try {
        const types = await Report.find(query)
            .limit(limit)
            .skip((page - 1) * limit)
            .sort({ 'createdAt': -1 })
            .populate({
                path: 'authorUid reportUid',
                select: selectUserReport,
            }).exec();
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