/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyAdminsOnHelpRequest = functions.firestore
  .document('Help Requests/{requestId}')
  .onCreate(async (snap, context) => {
    const helpRequest = snap.data();

    // Get all admin users
    const adminQuery = await admin.firestore()
      .collection('Accounts')
      .where('userType', '==', 'Admin')
      .get();

    const tokens = [];
    adminQuery.forEach(doc => {
      const data = doc.data();
      if (data.fcmToken) {
        tokens.push(data.fcmToken);
      }
    });

    if (tokens.length === 0) return null;

    const payload = {
      notification: {
        title: 'New Help Request',
        body: `A new help request: ${helpRequest.accidentType || 'Unknown'}`,
      },
      data: {
        requestId: context.params.requestId,
      }
    };

    return admin.messaging().sendToDevice(tokens, payload);
  });