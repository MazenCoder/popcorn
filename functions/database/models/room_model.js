const mongoose = require('mongoose');
const Schema = mongoose.Schema;



const roomSchema = Schema(
    {
        '_id': {
            type: String,
            required: true,
        },
        'author': {
            type: String,
            ref: 'User',
            required: true,
        },
        'name': {
            type: String,
            required: true,
        },
        'description': {
            type: String,
            required: false,
        },
        'bio': {
            type: String,
            required: false,
        },
        'status': {
            type: Number,
            required: true,
        },
        'token': {
            type: String,
            required: false,
        },
        'roomImage': {
            type: String,
            required: false,
        },
        'backgroundImage': {
            type: String,
            required: false,
        },
        'toastMessage': {
            type: String,
            required: false,
        },
        'members': [{
            type: String,
            ref: 'User'
        }],
        'banned': [{
            type: String,
            ref: 'User'
        }],
        'createdAt': {
            type: Date,
            default: Date.now,
        },
        'updatedAt': {
            type: Date,
            default: Date.now,
        },
        'runtimeType': {
            type: String,
            required: false,
        },
    },
    {
        timestamps: true ,
        collection: 'rooms',
        toObject: {
            transform: function (doc, ret, options) {
                delete ret.__v;
            },
        },
    },
);

module.exports = mongoose.model('Room', roomSchema);
