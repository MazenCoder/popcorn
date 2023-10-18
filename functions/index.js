const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const { setGlobalOptions } = require("firebase-functions/v2");
setGlobalOptions({maxInstances: 10});

const dbConnection = require('./database/connection');
const logger = require("firebase-functions/logger");
dbConnection().then(r => logger.log('Successfully Connected'));
// const auth = admin.auth();
// const db = admin.firestore();

const utils = require("./utils");
const { onRequest} = require("firebase-functions/v2/https");




exports.getTimeServer = onRequest(async (req, res) => {
    // if (req.method !== 'POST') {
    //     return res.status(401).json({
    //         message: 'Bad request',
    //         state: "error",
    //     });
    // }

    const idToken = req.headers.authorization ?? '';
    const decodedIdToken = await utils.verifyIdToken(idToken);
    if (decodedIdToken) {
        // Using Realtime Database
        // const timestamp = await admin.database.ServerValue.TIMESTAMP;

        // Using Cloud Firestore
        // const timestamp = admin.firestore.FieldValue.serverTimestamp();

        // Cloud Firestore
        const timestamp = admin.firestore.Timestamp.now();

        return res.status(200).json({
            state: "success",
            message: `TimeServer: ${timestamp}`,
            timestamp: timestamp,
        });
    } else {
        return res.status(401).json({
            state: "error",
            message: "you are not authorized to perform this action",
        });
    }
});


const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(bodyParser.json());
//! Routers
app.use('/api/v1/user', require('./routers/user_router'));
app.use('/api/v1/room', require('./routers/room_router'));

exports.api = onRequest(app);