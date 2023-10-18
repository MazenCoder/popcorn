const mongoose = require('mongoose');
const Schema = mongoose.Schema;



const userSchema = Schema(
    {
        '_id': {
            type: String,
            required: true,
        },
        'email': {
            type: String,
            required: true,
        },
        'displayName': {
            type: String,
            required: true,
        },
        'password': {
            type: String,
            required: false,
        },
        'genderId': {
            type: Number,
            required: false,
        },
        'token': {
            type: String,
            required: false,
        },
        'lastSeen': {
            type: Date,
            required: true,
        },
        'photoProfile': {
            type: String,
            required: false,
        },
        'role': {
            type: String,
            required: true,
        },
        'dateBirth': {
            type: Date,
            required: false,
        },
        'phone': {
            type: String,
            required: false,
        },
        'countryCode': {
            type: String,
            required: false,
        },
        'countryName': {
            type: String,
            required: false,
        },
        'dialingCode': {
            type: String,
            required: false,
        },
        'isVerified': {
            type: Boolean,
            required: true,
        },
        'isBanned': {
            type: Boolean,
            required: true,
        },
        'hideIntro': {
            type: Boolean,
            required: true,
        },
        'bio': {
            type: String,
            required: false,
        },
        'createdAt': {
            type: Date,
            default: Date.now,
        },
        'updatedAt': {
            type: Date,
            default: Date.now,
        },
        'friends': [{
            type: String,
            ref: 'Friend'
        }],
        'blocks': [{
            type: String,
            ref: 'User'
        }],
        'runtimeType': {
            type: String,
            required: false,
        },
    },
    {
        timestamps: true ,
        collection: 'users',
        toObject: {
            transform: function (doc, ret, options) {
                delete ret.__v;
            },
        },
    },
);

module.exports = mongoose.model('User', userSchema);
