import { FirebaseError } from "firebase/app";
import {defineStore} from "pinia";

interface IState{
  mensaje: string | String | null
}

export const useErrorStore = defineStore('error',{
  state:():IState=>({
    mensaje: null
  }),
  actions:{
    setError(error: any){
      if( typeof error === 'string' || error instanceof String){
        this.mensaje = error;
      }else if(error instanceof FirebaseError){
        console.log(error.code);
        if(error.code === 'auth/invalid-credential'){
          this.mensaje = 'Credenciales incorrectas'
        }else if(error.code === 'auth/too-many-requests'){
          this.mensaje = 'Intentalo más tarde'
        }else{
          this.mensaje = error.message;
        }
      }else {
        this.mensaje = error.message ?? 'Ocurió un error inesperado'
      }
    },
    restablecer(){
      this.mensaje = null;
    }
  }
})