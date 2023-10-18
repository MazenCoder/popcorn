

module.exports.formatHelper = (data) => {
    if (Array.isArray(data)) {
        let list = [];
        for (val of data) {
            list.push(val.toObject());
        }
        return list;
    }
    return data.toObject();
}

module.exports.selectUser = '_id email displayName genderId token ' +
    'lastSeen photoProfile role dateBirth isVerified isBanned hideIntro ' +
    'coins level xp blocks skills friends targetFriends createdAt updatedAt';

module.exports.selectUserReport = '_id email displayName genderId token ' +
    'lastSeen photoProfile role dateBirth isVerified isBanned hideIntro ' +
    'coins level xp blocks skills targetFriends createdAt updatedAt';

module.exports.selectConfigs = 'verifyEmail costComment costLike gainXp';


module.exports.idConfig = 'sawwl';