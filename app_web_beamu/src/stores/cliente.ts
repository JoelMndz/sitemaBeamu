import { type ICliente, type IClienteAgregar } from "@/types";
import { addDoc, collection, doc, getDocs, getFirestore, query, updateDoc, where } from "firebase/firestore";
import {defineStore} from "pinia";

interface IState{
  modal: boolean
  clienteActual: ICliente | null
  clientePorEliminar: ICliente | null
  cargando: boolean
  clientes: ICliente[]
}

const _nombreColleccion = "clientes"

export const useClienteStore = defineStore('clientes', {
  state: ():IState=> ({
    modal: false,
    cargando: false,
    clienteActual: null,
    clientePorEliminar: null,
    clientes: []
  }),
  actions: {
    abrirModal(){
      this.modal = true;
    },
    ocultarModal(){
      this.modal = false
      this.clienteActual = null
    },
    abrirModalParaEditar(cliente:ICliente){
      this.clienteActual = {...cliente}
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
        this.clientes = docs.map(x => {
          const documento = x.data()
          return {
            id: x.id, 
            nombres: documento['nombres'],
            apellidos: documento['apellidos'],
            cedula: documento['cedula'],
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
    async agregar(cliente: IClienteAgregar){
      try {
        this.cargando = true;
        const clienteAgregado = await addDoc(collection(getFirestore(), _nombreColleccion),{...cliente, eliminado: false})
        this.clientes.push({
          ...cliente,
          id: clienteAgregado.id,
          fechaRegistro: new Date().toUTCString(),
        })
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.ocultarModal();
      }
    },
    async actualizar(cliente: ICliente){
      try {
        this.cargando = true;
        await updateDoc(doc(getFirestore(), _nombreColleccion, cliente.id), {
          nombres: cliente['nombres'],
          apellidos: cliente['apellidos'],
          cedula: cliente['cedula'],
          fechaNacimiento: cliente['fechaNacimiento'],
        })
        this.clientes = this.clientes.map(x => x.id === cliente.id ? cliente : x)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.ocultarModal();
      }
    },
    async eliminar(){
      try {
        this.cargando = true;
        await updateDoc(doc(getFirestore(),_nombreColleccion, this.clientePorEliminar!.id),{
         eliminado: true
        })
        this.clientes = this.clientes.filter(x => x.id !== this.clientePorEliminar!.id)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.clientePorEliminar = null;
      }
    },
    abrirConfirmacionEliminar(cliente: ICliente){
      this.clientePorEliminar = {...cliente}
    },
    cancelarConfirmacionEliminar(){
      this.clientePorEliminar = null
    },
  },
})

