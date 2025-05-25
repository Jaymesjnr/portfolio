// firebase-init.js
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
const firebaseConfig = { /* config here */ };
const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
