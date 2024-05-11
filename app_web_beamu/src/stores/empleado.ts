import { Rol, type IEmpleado, type IEmpleadoAgregar } from "@/types";
import { createUserWithEmailAndPassword, getAuth, sendPasswordResetEmail, deleteUser } from "firebase/auth";
import { addDoc, collection, deleteDoc, doc, getDoc, getDocs, getFirestore, query, updateDoc, where } from "firebase/firestore";
import {defineStore} from "pinia";
import { useErrorStore } from "./error";

interface IState{
  modal: boolean
  empleadoActual: IEmpleado | null
  empleadoPorEliminar: IEmpleado | null
  cargando: boolean
  empleados: IEmpleado[]
}

const _nombreColleccion = "empleados"

export const useEmpleadoStore = defineStore('empleado', {
  state: ():IState =>({
    modal: false,
    empleadoActual: null,
    cargando: false,
    empleadoPorEliminar: null,
    empleados: []
  }),
  actions: {
    abrirModal(){
      this.modal = true;
    },
    ocultarModal(){
      this.modal = false
      this.empleadoActual = null
    },
    abrirModalParaEditar(empleado:IEmpleado){
      this.empleadoActual = {...empleado}
      this.modal = true
    },
    async obtenerTodo(){
      try {
        this.cargando = true;
        const {docs} = await getDocs(
          query(
            collection(getFirestore(), _nombreColleccion),
            where('eliminado','==',false)
          )
        );
        this.empleados = docs.map(x => {
          const documento = x.data()
          return {
            id: x.id, 
            nombres: documento['nombres'],
            apellidos: documento['apellidos'],
            rol: documento['rol'],
            cedula: documento['cedula'],
            idSucursal: documento['idSucursal'],
            fechaNacimiento: documento['fechaNacimiento'],
            email: documento['email'],
            fechaRegistro: documento['fechaRegistro'],
          }
        })
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
      }
    },
    async agregar(empleado:IEmpleadoAgregar){
      const errorStore = useErrorStore()
      errorStore.restablecer()
      try {
        this.cargando = true;
        if(await this.existeEmail(empleado.email)){
          throw new Error('El email ya esta registrado!')
        }
        const auth = getAuth()
        const password =(Math.random()* Date.now()).toString();
        await createUserWithEmailAndPassword(auth,empleado.email, password)
        await sendPasswordResetEmail(auth,empleado.email)
        const empleadoFirestore = {
          nombres: empleado['nombres'],
          apellidos: empleado['apellidos'],
          rol: empleado['rol'],
          cedula: empleado['cedula'],
          idSucursal: empleado['rol'] == Rol.ADMINISTRADOR ? null : empleado['idSucursal'],
          fechaNacimiento: empleado['fechaNacimiento'],
          email: empleado['email'],
          fechaRegistro: new Date().toUTCString(),
          eliminado: false
        }
        const empleadoAgregado = await addDoc(collection(getFirestore(), _nombreColleccion),empleadoFirestore)
        this.empleados.push({
          id: empleadoAgregado.id,
          ...empleadoFirestore
        })
      } catch (error: any) {
        console.log(error);        
        errorStore.setError(error)
      }finally{
        this.cargando = false;
        if(!errorStore.mensaje) this.ocultarModal();
      }
    },
    async actualizar(empleado: IEmpleado){
      try {
        this.cargando = true;
        await updateDoc(doc(getFirestore(),_nombreColleccion, empleado.id),{
          nombres: empleado['nombres'],
          apellidos: empleado['apellidos'],
          rol: empleado['rol'],
          cedula: empleado['cedula'],
          idSucursal: empleado['idSucursal'],
          fechaNacimiento: empleado['fechaNacimiento'],
        })
        this.empleados = this.empleados.map(x => x.id === empleado.id ? empleado : x)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.ocultarModal();
      }
    },
    async existeEmail(email: string): Promise<boolean | undefined>{
      const querySnapshot = await getDocs(
        query(
          collection(getFirestore(), _nombreColleccion), 
          where('email', '==', email),
        )
      );
      return querySnapshot.docs.length !== 0
    },
    async eliminar(){
      try {
        this.cargando = true;
        await updateDoc(doc(getFirestore(),_nombreColleccion, this.empleadoPorEliminar!.id),{
         eliminado: true
        })
        this.empleados = this.empleados.filter(x => x.id !== this.empleadoPorEliminar!.id)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.empleadoPorEliminar = null;
      }
    },
    abrirConfirmacionEliminar(empleado: IEmpleado){
      this.empleadoPorEliminar = {...empleado}
    },
    cancelarConfirmacionEliminar(){
      this.empleadoPorEliminar = null
    },
  }
})