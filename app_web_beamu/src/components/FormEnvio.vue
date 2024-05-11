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
          label="Cliente que envía el paquete"
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
        <VSelect 
          label="Tipo de Envío"
          class="mb-4"
          :items="tiposEnvios"
          item-title="nombre"
          item-value="id"
          v-model="campos.idTipoEnvio"
          @update:model-value="(v) => {tipoEnvio = tiposEnvios.find(x => x.id == v)!; actualizarTotal()}"
          :item-props="(x) => ({title: x.nombre, subtitle: `$${x.precioKg}`})"
          :rules="[campoRequerido]"
        />
        <VTextField 
          type="number"
          step="0.1"
          label="Peso (KG)"
          class="mb-4"
          v-model.number="campos.pesoKg"
          @update:model-value="actualizarTotal"
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
import type {ITipoEnvio} from "@/types";
import {Rol} from "@/types";
import { storeToRefs } from "pinia";
import { onBeforeMount } from "vue";
import { onMounted } from "vue";
import { reactive } from "vue";
import {ref} from "vue";
import type { VForm } from "vuetify/components";

const form = ref<null | VForm>(null)
const envioStore = useEnvioStore()
const autenticacionStore = useAutenticacionStore()
const sucursalStore = useSucursalStore()
const {sucursales} = storeToRefs(sucursalStore)
const {usuario} = storeToRefs(autenticacionStore)
const {cargando, tiposEnvios} = storeToRefs(envioStore)
const { clientes} = storeToRefs(useClienteStore())
const tipoEnvio = ref<ITipoEnvio | null>(null)
interface IForm{
  idCliente: string | null
  idTipoEnvio: string | null
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
  idTipoEnvio: null,
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
    (v: number) => !tipoEnvio.value || tipoEnvio.value && v <= tipoEnvio.value.pesoMaximoKg && v > 0 || `No puede sobre pasar el peso máximo (${tipoEnvio.value.pesoMaximoKg} Kg)`
  ]
}

const actualizarTotal = ()=>{
  try {
    campos.total = campos.pesoKg * tipoEnvio.value!.precioKg
  } catch (error) {
    
  }
}

const cancelar = ()=>{
  envioStore.ocultarModal()
}

const procesarFormulario = async()=>{
  const {valid} = await form.value!.validate()
  if(valid){
    await envioStore.agregar({
      ...campos, 
      idSecretario: usuario.value!.id,
      idCliente: campos.idCliente!,
      idTipoEnvio: campos.idTipoEnvio!,
      idSucursalSalida: campos.idSucursalSalida!,
      idSucursalLlegada: campos.idSucursalLlegada!
    })
  }
}

onMounted(()=>{
  campos.idSucursalSalida = usuario.value!.idSucursal ?? null
})

</script>

<style scoped>

</style>