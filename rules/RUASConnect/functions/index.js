const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const FieldValue = require('firebase-admin').firestore.FieldValue;

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});


// Updating the likes
exports.updateNotesLikeCount = functions.firestore.document(`notes/{courseCode}/uploaded_files/{uuid}/liked_by/{userId}`).onWrite((change, context) => {
    if (change.before.exists) {
        // Update Event
        console.log('Update Event took place');
        return null;
    } else if (!change.after.exists) {
        // Delete Event
        console.log('Like Decrement called');
        const statRef = admin.firestore().collection('notes').doc(context.params.courseCode).collection('uploaded_files').doc(context.params.uuid);
        return statRef.update('stats.like_count', FieldValue.decrement(1))
    } else {
        // Add Event
        console.log('Like Increment called');
        const statRef = admin.firestore().collection('notes').doc(context.params.courseCode).collection('uploaded_files').doc(context.params.uuid);
        return statRef.update('stats.like_count', FieldValue.increment(1))
    }
});

exports.updateQuestionsLikeCount = functions.firestore.document(`questions/{courseCode}/uploaded_files/{uuid}/liked_by/{userId}`).onWrite((change, context) => {
    if (change.before.exists) {
        // Update Event
        console.log('Update Event took place');
        return null;
    } else if (!change.after.exists) {
        // Delete Event
        console.log('Like Decrement called');
        const statRef = admin.firestore().collection('questions').doc(context.params.courseCode).collection('uploaded_files').doc(context.params.uuid);
        return statRef.update('stats.like_count', FieldValue.decrement(1))
    } else {
        // Add Event
        console.log('Like Increment called');
        const statRef = admin.firestore().collection('questions').doc(context.params.courseCode).collection('uploaded_files').doc(context.params.uuid);
        return statRef.update('stats.like_count', FieldValue.increment(1))
    }
});

exports.updateAssignmentsLikeCount = functions.firestore.document(`assignments/{courseCode}/uploaded_files/{uuid}/liked_by/{userId}`).onWrite((change, context) => {
    if (change.before.exists) {
        // Update Event
        console.log('Update Event took place');
        return null;
    } else if (!change.after.exists) {
        // Delete Event
        console.log('Like Decrement called');
        const statRef = admin.firestore().collection('assignments').doc(context.params.courseCode).collection('uploaded_files').doc(context.params.uuid);
        return statRef.update('stats.like_count', FieldValue.decrement(1))
    } else {
        // Add Event
        console.log('Like Increment called');
        const statRef = admin.firestore().collection('assignments').doc(context.params.courseCode).collection('uploaded_files').doc(context.params.uuid);
        return statRef.update('stats.like_count', FieldValue.increment(1))
    }
});

// updating download count
exports.updateDownloadCount = functions.https.onCall((data, context) => {

    const uid = context.auth.uid;

    if (uid === undefined) {
        console.log('Unauthenticated !');
        return null;
    }

    const arenaName = data.arenaName;
    const courseCode = data.courseCode;
    const uuid = data.uuid;

    const statRef = admin.firestore().collection(arenaName).doc(courseCode).collection('uploaded_files').doc(uuid);

    return statRef.update('stats.download_count', FieldValue.increment(1));

});

// updating view count
exports.updateViewCount = functions.https.onCall((data, context) => {

    const uid = context.auth.uid;

    if (uid === undefined) {
        console.log('Unauthenticated !');
        return null;
    }

    const arenaName = data.arenaName;
    const courseCode = data.courseCode;
    const uuid = data.uuid;

    const statRef = admin.firestore().collection(arenaName).doc(courseCode).collection('uploaded_files').doc(uuid);

    return statRef.update('stats.view_count', FieldValue.increment(1));

});

// Tested Works !
exports.createDocumentForArenaUpload = functions.storage.bucket().object().onFinalize(
    async (object) => {
        console.log(`created File : ${object}`);
        const custMetadata = object.metadata;

        const fullPathName = object.name;

        if (!fullPathName.startsWith('notes/') && !fullPathName.startsWith('assignments/') && !fullPathName.startsWith('questions/')) {
            console.log(`Not an Arena File : ${fullPathName}`);
            return null;
        }

        // Get all the file properties

        const size = object.size;
        const timeCreated = object.timeCreated;
        const title = custMetadata.title;
        const description = custMetadata.description;
        const uploaderUid = custMetadata.uploaderUid;
        const uploaderUsername = custMetadata.uploaderUsername;
        const arenaName = custMetadata.arenaName;
        const courseCode = custMetadata.courseCode;
        const uuid = custMetadata.uuid;
        const fileName = custMetadata.fileName;
        const uploadLocation = custMetadata.uploadLocation;

        const batch = admin.firestore().batch();

        // check if the courseCode exists in arena
        var doesExist = (await admin.firestore().collection(arenaName).doc(courseCode).get()).exists;

        if (!doesExist) {
            await admin.firestore().collection(arenaName).doc(courseCode).set({ 'exists': true });
        }

        const globRef = admin.firestore().collection(arenaName).doc(courseCode).collection('uploaded_files').doc(uuid);
        const userRef = admin.firestore().collection('users').doc(uploaderUid).collection('uploaded_files').doc(uuid);

        // Not using another collection because cant order the values
        // const docStatsRef = admin.firestore().collection(arenaName).doc(courseCode).collection('uploaded_files').doc(uuid).collection('doc_stats').doc('count');


        const fileDetails = {
            'title': title,
            'description': description,
            'uploaderUid': uploaderUid,
            'uploaderUsername': uploaderUsername,
            'timeCreated': timeCreated,
            'fileName': fileName,
            'uuid': uuid,
            'arenaName': arenaName,
            'courseCode': courseCode,
            'size': (parseInt(size) * 1e-3).toFixed(2).toString() + ' kB',
            'uploadLocation': uploadLocation,
        };

        const globFileDetails = Object.assign({}, fileDetails);

        globFileDetails.stats = {
            'like_count': 0,
            'download_count': 0,
            'view_count': 0,
        }

        batch.set(userRef, fileDetails);
        batch.set(globRef, globFileDetails);

        return await batch.commit();
    }
);
