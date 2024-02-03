const firebaseConfig = {
    apiKey: "AIzaSyDDbeeO-lUONKX-OM30J5G8BaXYVXh01dU",
    authDomain: "lighting-64964.firebaseapp.com",
    projectId: "lighting-64964",
    storageBucket: "lighting-64964.appspot.com",
    messagingSenderId: "285241454617",
    appId: "1:285241454617:web:6e02ddcea75bafd9d1ba88",
    measurementId: "G-PR4J4KPTXG"
  };


firebase.initializeApp(firebaseConfig);

// make auth and firestore references
const auth = firebase.auth();
const db = firebase.firestore();

// update firestore settings
db.settings({ timestampsInSnapshots: true });

