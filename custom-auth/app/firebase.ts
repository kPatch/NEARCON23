import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
const firebaseConfig = {
    apiKey: "AIzaSyDXe3ilwWOJbV785682ueePJaPz-D61Cp0",
    authDomain: "nearcon23.firebaseapp.com",
    projectId: "nearcon23",
    storageBucket: "nearcon23.appspot.com",
    messagingSenderId: "973691889479",
    appId: "1:973691889479:web:c56369ba042973745fce62",
    measurementId: "G-W8VEG87F9Y"
};
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app)