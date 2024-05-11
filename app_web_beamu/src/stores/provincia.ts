import { FirebaseError } from "firebase/app";
import {defineStore} from "pinia";
import {provicias} from "../constants/provincias";

interface IState{
  datosGeograficos : {
    [codigoProvincia: string]: {
      provincia: string,
      cantones: {
        [codigoCanton: string]: {
          canton: string,
          parroquias:{
            [codigoParroquia: string]: string
          }
        }
      }
    }
  }
}

export const useProvinciaStore = defineStore('provincia',{
  state:():IState=>({
    datosGeograficos: provicias
  }),
  getters:{
    provincias: (state)=>{
      return Object.keys(state.datosGeograficos)
        .map(x => ({codigo: x, nombre: state.datosGeograficos[x].provincia}))
    },
    cantones: (state)=>{
      return (codigoProvincia: string) => (
        Object.keys(state.datosGeograficos[codigoProvincia].cantones)
          .map(x => ({
            codigo: x,
            nombre: state.datosGeograficos[codigoProvincia].cantones[x].canton
          }))        
      )
    }
  }
})