const mongoose = require('mongoose');

module.exports = async () => {
    try {
        mongoose.set("strictQuery", false)
        // await mongoose.connect('mongodb://popconchat:HgN2oLEhrp9pOP5j@ac-bsj9c0r-shard-00-00.exbpiv6.mongodb.net:27017,ac-bsj9c0r-shard-00-01.exbpiv6.mongodb.net:27017,ac-bsj9c0r-shard-00-02.exbpiv6.mongodb.net:27017/Popcorn?ssl=true&replicaSet=atlas-j9nlzg-shard-0&authSource=admin&retryWrites=true&w=majority', {useNewUrlParser: true});
        await mongoose.connect('mongodb+srv://popconchat:HgN2oLEhrp9pOP5j@popcorn.6l9d2js.mongodb.net/?retryWrites=true&w=majority', {useNewUrlParser: true});
        console.log('------ Database Connected ------');
    } catch (e) {
        console.error('Database connectivity error ', e);
        throw new Error(e);
    }
}

