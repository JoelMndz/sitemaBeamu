import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import {initializeApp} from "firebase/app";
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

import App from './App.vue'
import router from './router'
import { registerVuetify } from './plugins/vuetify'

const firebaseConfig = {
  apiKey: "AIzaSyA_su-8so8PIynYXmeRMIn3rvm5JgMZYas",
  authDomain: "sistema-bemau.firebaseapp.com",
  projectId: "sistema-bemau",
  storageBucket: "sistema-bemau.appspot.com",
  messagingSenderId: "120264168787",
  appId: "1:120264168787:web:722b855d616d72c30f3da6"
};
initializeApp(firebaseConfig);

const app = createApp(App)

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)
app.use(pinia)
app.use(router)
registerVuetify(app)

app.mount('#app')
