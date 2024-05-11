<template>
  <VForm
    ref="form"
    @submit.prevent="procesarFormulario"
  >
  <VCard>
    <VCardTitle class="text-center text-h5">{{ tituloFormulario }}</VCardTitle>
    <VCardText>
      <Error />
      <VTextField
        label="Nombres"
        :class="mensaje ? 'my-4' : 'mb-4'"
        v-model.trim="campos.nombres"
        :rules="reglas.requerido"
      />
      <VTextField
        label="Apellidos"
        class="mb-4"
        v-model.trim="campos.apellidos"
        :rules="reglas.requerido"
      />
      <VTextField
        label="Cédula"
        class="mb-4"
        v-model.trim="campos.cedula"
        :rules="[...reglas.requerido,...reglas.cedula]"
      />
      <VTextField 
        type="date"
        label="Fecha nacimiento"
        class="mb-4"
        v-model="campos.fechaNacimiento"
        :rules="reglas.requerido"
      /> 
      <VTextField 
        type="email"
        label="Email"
        class="mb-4"
        v-model="campos.email"
        :rules="[...reglas.requerido, ...reglas.email]"
      /> 
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
import { useSucursalStore } from "@/stores/sucursal";
import { Rol } from "@/types";
import { storeToRefs } from "pinia";
import { onBeforeMount, reactive, computed,ref } from "vue";
import type { VForm } from "vuetify/components";
import Error from "./Error.vue";
import { useErrorStore } from "@/stores/error";
import { useClienteStore } from "@/stores/cliente";

const form = ref<null | VForm>(null)
const clienteStore = useClienteStore()
const sucursalStore = useSucursalStore()
const errorStore = useErrorStore()
const {mensaje} = storeToRefs(errorStore)
const {sucursales} = storeToRefs(sucursalStore)
const {clienteActual, cargando} = storeToRefs(clienteStore)
const campos = reactive({
  nombres: '',
  apellidos: '',
  cedula: '',
  fechaNacimiento: '',
  email: '',
})
const reglas = {
  requerido: [
    (v: string) => !!v || 'Campo requerido'
  ],
  cedula: [
    (v: string) => v.length == 10 || 'La cédula debe tener 10 digitos'
  ],
  email: [
    (v: string) => /.+@.+\..+/.test(v) || 'El email no es válido'
  ],
}

const tituloFormulario = computed(()=> clienteActual.value ? 'Editar Cliente' : 'Agregar Cliente')

const procesarFormulario = async()=>{
  const {valid} = await form.value!.validate()
  if(valid){
    if(clienteActual.value == null){
      await clienteStore.agregar(campos)
    }else{
      clienteStore.actualizar({
        ...campos as any,
      })
    }
  }
}

const cancelar = ()=>{
  clienteStore.ocultarModal()
}

onBeforeMount(()=>{
  if(clienteActual.value !== null){
    Object.assign(campos, {...clienteActual.value})
  }
})
</script>

<style scoped>

</style>