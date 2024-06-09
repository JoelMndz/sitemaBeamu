<template>
  <VForm 
    ref="form"
    @submit.prevent="procesarFormulario"  
  >
    <VCard>
      <VCardTitle class="text-center text-h5"> Agregar Envío </VCardTitle>
      <VCardText>
        <VAutocomplete 
          v-model="campos.idCliente"
          prepend-inner-icon="mdi-magnify"
          label="Cliente que envía el paquete"
          :custom-filter="buscarCliente"
          :items="clientes"
          item-value="id"
          :item-props="(i) => ({title: i.nombres, subtitle: i.cedula})"
          class="mb-4"
          :rules="[campoRequerido]"
        />
        <VSelect 
          label="Sucursal Salida"
          class="mb-4"
          :items="sucursales"
          item-title="nombre"
          item-value="id"
          :readonly="usuario!.rol == Rol.SECRETARIO"
          v-model="campos.idSucursalSalida"
          :rules="[campoRequerido]"
        />
        <VSelect 
          label="Sucursal Llegada"
          class="mb-4"
          :items="sucursales"
          item-title="nombre"
          item-value="id"
          v-model="campos.idSucursalLlegada"
          :rules="[campoRequerido]"
        />
        <VTextField 
          type="number"
          step="0.1"
          label="Peso (KG)"
          class="mb-4"
          v-model.number="campos.pesoKg"
          @update:model-value="()=> campos.total = campos.pesoKg > 15 ? campos.pesoKg * 0.11 : 3"
          :rules="[campoRequerido, ...reglas.peso]"
        /> 
        <VTextField 
          label="Nombre destinatario"
          class="mb-4"
          v-model="campos.destinatario.nombre"
          :rules="[campoRequerido]"
        /> 
        <VTextField 
          label="Celular destinatario"
          class="mb-4"
          v-model="campos.destinatario.celular"
          :rules="[campoRequerido]"
        /> 
        <VTextField 
          label="Dirección destinatario"
          class="mb-4"
          v-model="campos.destinatario.direccion"
          :rules="[campoRequerido]"
        /> 
        <VSwitch 
          class="mb-4"
          v-model="campos.entregaDomicilio"
          label="Entregar en el domicilio"
        />
        <VTextField 
          label="Total"
          class="mb-4"
          prefix="$"
          readonly
          v-model="campos.total"
        /> 
        <VTextarea
          label="Observación"
          v-model="campos.observacion"
          rows="1"
          class="mb-4"
          auto-grow
          max-rows="3"
        ></VTextarea>
        <VCardActions>
          <VSpacer/>
          <VBtn
            variant="elevated"
            color="error"
            @click="cancelar()"
            :disabled="cargando"
          >
            Cancelar
          </VBtn>
          <VBtn
            type="submit"
            variant="elevated"
            :disabled="cargando"
            :loading="cargando"
          >
            Guardar
          </VBtn>
        </VCardActions>
      </VCardText>
    </VCard>
  </VForm>
</template>

<script setup lang="ts">
import { useAutenticacionStore } from "@/stores/autenticacion";
import { useClienteStore } from "@/stores/cliente";
import { useEnvioStore } from "@/stores/envio";
import { useSucursalStore } from "@/stores/sucursal";
import {Rol, type ICliente, type IEnvio} from "@/types";
import { storeToRefs } from "pinia";
import { onMounted } from "vue";
import { reactive } from "vue";
import {ref} from "vue";
import { type VForm } from "vuetify/components";

const form = ref<null | VForm>(null)
const envioStore = useEnvioStore()
const autenticacionStore = useAutenticacionStore()
const sucursalStore = useSucursalStore()
const {sucursales} = storeToRefs(sucursalStore)
const {usuario} = storeToRefs(autenticacionStore)
const {cargando, envios} = storeToRefs(envioStore)
const { clientes} = storeToRefs(useClienteStore())
interface IForm{
  idCliente: string | null
  pesoKg: number
  entregaDomicilio: boolean
  destinatario: {
    nombre: string
    direccion: string
    celular: string
  }
  idSucursalSalida: string | null
  idSucursalLlegada: string | null
  observacion: string
  total: number
}
const campos = reactive<IForm>({
  idCliente: null,
  pesoKg: 0,
  entregaDomicilio: false,
  destinatario: {
    nombre: '',
    direccion: '',
    celular: ''
  },
  idSucursalSalida: null,
  idSucursalLlegada: null,
  observacion: '',
  total: 0
})
const campoRequerido = (v:string) => !!v || 'Campo requerido!'
const reglas = {
  peso: [
    (v: number) => v > 0 || `El peso no puede ser negativo`
  ]
}

const cancelar = ()=>{
  envioStore.ocultarModal()
}

const procesarFormulario = async()=>{
  const {valid} = await form.value!.validate()
  if(valid){
    await envioStore.agregar({
      ...campos,
      guia: generarGuia(envios.value),
      idSecretario: usuario.value!.id,
      idCliente: campos.idCliente!,
      idSucursalSalida: campos.idSucursalSalida!,
      idSucursalLlegada: campos.idSucursalLlegada!
    })
  }
}

const buscarCliente = (valueTitle:string, queryText:string, item:any)=>{
  return item!.raw.cedula.indexOf(queryText) > -1 || 
    item.raw.nombres.toLowerCase().indexOf(queryText.toLowerCase()) > -1 ||
    item.raw.apellidos.toLowerCase().indexOf(queryText.toLowerCase()) > -1
}

const generarGuia = (envios: IEnvio[])=>{
  let guia = '';
  do{
    guia = `${(Math.round(Math.random()*1000))+1000}`;
  }while(envios.find(x => x.guia === guia));
  return guia;
}

onMounted(()=>{
  campos.idSucursalSalida = usuario.value!.idSucursal ?? null
})

</script>

<style scoped>

</style>