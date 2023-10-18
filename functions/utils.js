const User = require('./database/models/user_model');
const { selectUser} = require('./helper/format_helper');
const {CloudTasksClient} = require('@google-cloud/tasks');
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {getMessaging} = require("firebase-admin/messaging");
const client = new CloudTasksClient();
const db = admin.firestore();
const auth = admin.auth();


async function sendNotifyReport(params) {
    try {
        const { report, uid, _id } = params;
        const tokens = await getAllAdminTokens();
        if (tokens.length > 0) {
            const _message = {
                data: {
                    title: `Nouveau rapport!`,
                    body: `${report}`,
                    action: "report",
                    id_action: _id,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                }
            };
            await sendNotify(_message, tokens);
        }
    } catch (error) {
        functions.logger.error(`sendNotifyReport: ${error}`);
    }
}


async function sendNotifyRequest(params) {
    try {
        const { requester, recipient } = params;
        // ref= https://docs.nativescript.org/plugins/firebase-messaging.html#send-one-image-notification-for-both-ios-and-android
        if (recipient.token) {
            const _message = {
                data: {
                    title: `Nouvel ami`,
                    body: `${requester.displayName} t'envoyer une demande d'ami`,
                    action: "friendRequest",
                    id_action: `${requester._id}`,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                }
            }
            return await sendNotify(_message, recipient.token);
        }
    } catch (error) {
        functions.logger.error(`sendNotifyReport: ${error}`);
    }
}

async function sendNotify(payload, tokens) {
    if (tokens.length > 0) {
        const options = {
            priority: 'high',
            timeToLive: 60 * 60 * 24,
            contentAvailable: true,
            mutableContent: true,
        };

        return await getMessaging().sendToDevice(tokens, payload, options)
            .then((response) => {
                functions.logger.log('Successfully sent message: ', response.results);
            }).catch((error) => {
                functions.logger.error('Error sending message: ', error);
            });
    }
}

async function verifyIdToken(idToken) {
    return await auth.verifyIdToken(idToken).then((decodedToken) => {
        return decodedToken.uid;
    }).catch((error) => {
        return null;
    });
}

async function getUserById(uid) {
    try {
        return await User.findOne({_id: uid}).select(selectUser);
    } catch (error) {
        functions.logger.error(`getUserById: ${error}`);
        return null;
    }
}



async function getAllAdminEmails() {
    let _emails = [];
    try {
        const users = await User.find({role: "admin"}).select(selectUser);
        for (let i = 0; i < users.length; i++) {
            _emails.push(users[i].email);
        }
    } catch (error) {
        functions.logger.error(`getAdminTokens: ${error}`);
    }
    return _emails;
}

async function getAllAdminTokens() {
    let _tokens = [];
    try {
        const users = await User.find({role: "admin"}).select(selectUser);
        for (let i = 0; i < users.length; i++) {
            const token = users[i].token;
            if (token) {
                _tokens.push(token);
            }
        }
    } catch (error) {
        functions.logger.error(`getAdminTokens: ${error}`);
    }
    return _tokens;
}


function diffDays(date) {
    const now = new Date();
    const diffTime = Math.abs(now - date);
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
}



module.exports = {
    sendNotifyReport,
    sendNotifyRequest,
    sendNotify,
    getUserById,
    getAllAdminEmails,
    getAllAdminTokens,
    diffDays,
    verifyIdToken,
};