import type { ISucursal } from "@/types";
import { addDoc, collection, deleteDoc, doc, getDoc, getDocs, getFirestore, updateDoc, where } from "firebase/firestore";
import {defineStore} from "pinia";

interface IState{
  modal: boolean,
  sucursalActual: ISucursal | null,
  sucursalPorEliminar: ISucursal | null,
  cargando: boolean,
  sucursales: ISucursal[]
}

const _nombreColleccion = 'sucursales'

export const useSucursalStore = defineStore('sucursal',{
  state:():IState=>({
    modal: false,
    sucursalActual: null,
    cargando: false,
    sucursales: [],
    sucursalPorEliminar: null
  }),
  actions:{
    abrirModal(){
      this.modal = true;
    },
    ocultarModal(){
      this.modal = false;
      this.sucursalActual = null;
    },
    abrirModalParaEditar(sucursal: ISucursal){
      this.sucursalActual = {
        ...sucursal,
        provincia:{ ...sucursal.provincia },
        canton:{ ...sucursal.canton },
      }
      this.modal = true;
    },
    async obtenerTodo(){
      try {
        this.cargando = true;
        const {docs} = await getDocs(collection(getFirestore(), _nombreColleccion));
        this.sucursales = docs.map(x => {
          const documento = x.data()
          return {
            id: x.id, 
            nombre: documento['nombre'],
            provincia: documento['provincia'],
            canton: documento['canton'],
            direccion: documento['direccion']
          }
        })
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
      }
    },
    async agregar(sucursal:{nombre: string, provincia:{codigo: string, nombre: string}, canton:{codigo: string, nombre: string}, direccion: string}){
      try {
        this.cargando = true;
        const sucursalAgregada = await addDoc(collection(getFirestore(), _nombreColleccion),sucursal)
        this.sucursales.push({id: sucursalAgregada.id, ...sucursal})
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.ocultarModal();
      }
    },
    async actualizar(sucursal: ISucursal){
      try {
        this.cargando = true;
        await updateDoc(doc(getFirestore(),_nombreColleccion, sucursal.id),{
          nombre: sucursal.nombre,
          provincia: sucursal.provincia,
          canton: sucursal.canton,
          direccion: sucursal.direccion
        })
        this.sucursales = this.sucursales.map(x => x.id === sucursal.id ? sucursal : x)
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
        await deleteDoc(doc(getFirestore(),_nombreColleccion, this.sucursalPorEliminar!.id))
        this.sucursales = this.sucursales.filter(x => x.id !== this.sucursalPorEliminar!.id)
      } catch (error) {
        console.log(error);
        
      }finally{
        this.cargando = false;
        this.sucursalPorEliminar = null;
      }
    },
    abrirConfirmacionEliminar(sucursal: ISucursal){
      this.sucursalPorEliminar = {...sucursal}
    },
    cancelarConfirmacionEliminar(){
      this.sucursalPorEliminar = null
    },
  }
})