import {defineStore} from "pinia";
import {getAuth, signInWithEmailAndPassword} from "firebase/auth";
import {getApp} from "firebase/app";
import { Rol, type IUsuario } from "@/types";
import { getFirestore, getDocs, where, getDoc, collection, query} from "firebase/firestore";
import router from "@/router";
import { useErrorStore } from "./error";

interface IState{
  usuario: IUsuario | null
  cargando: boolean
}

export const useAutenticacionStore = defineStore('autenticacion',{
  state:():IState=>({
    usuario: null,
    cargando: false
  }),
  actions:{
    async login(credenciales:{email: string, password: string}){
      const errorStore = useErrorStore()
      try {
        this.cargando = true;
        const auth = getAuth(getApp())      
        const respuesta = await signInWithEmailAndPassword(auth, credenciales.email, credenciales.password);
        const usuarioActual = await this.buscarPorEmail(respuesta.user.email!); 
        if(usuarioActual){
          this.usuario = usuarioActual
          router.push(usuarioActual.rol === Rol.ADMINISTRADOR ? '/app/sucursal' : '/app/envio')
        }
      } catch (error: any) {
        errorStore.setError(error);
      }
      finally{
        this.cargando = false;
      }
    },
    async buscarPorEmail(email: string): Promise<IUsuario | undefined>{
      const querySnapshot = await getDocs(
        query(
          collection(getFirestore(), 'empleados'), 
          where('email', '==', email), 
          where('rol', 'in', [Rol.ADMINISTRADOR, Rol.SECRETARIO]),
          where('eliminado', '==', false), 
        )
      );
      for (let i = 0; i < querySnapshot.docs.length; i++) {
        const user = querySnapshot.docs[i].data();
        return {
          id: querySnapshot.docs[i].id,
          nombres: user['nombres'],
          apellidos: user['apellidos'],
          cedula: user['cedula'],
          email: user['email'],
          idSucursal: user['idSucursal'],
          rol: user['rol'],
        }
      }
      throw new Error('No estás autorizado!')
    },
    cerrarSesion(){
      this.usuario = null;
      router.push('/login')
    }
  },
  persist: true
})