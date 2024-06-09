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
      <VSelect 
        label="Rol"
        class="mb-4"
        :items="Object.values(Rol).map(x => ({id: x, title: capitalize(x)}))"
        v-model="campos.rol"
        item-title="title"
        item-value="id"
        clearable
        :rules="reglas.requerido"
      /> 
      <VSelect 
        label="Sucursal"
        v-if="campos.rol !== Rol.ADMINISTRADOR"
        class="mb-4"
        :items="sucursales"
        item-value="id"
        item-title="nombre"
        v-model="campos.idSucursal"
        clearable
        :rules="reglas.requerido"
      /> 
      <VTextField 
        type="date"
        label="Fecha nacimiento"
        class="mb-4"
        v-model="campos.fechaNacimiento"
        :rules="reglas.requerido"
      /> 
      <template
        v-if="!empleadoActual"
      >
        <VTextField 
          type="email"
          label="Email"
          class="mb-4"
          v-model="campos.email"
          :rules="[...reglas.requerido, ...reglas.email]"
        /> 
        
      </template>
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
import { useEmpleadoStore } from "@/stores/empleado";
import { useSucursalStore } from "@/stores/sucursal";
import { Rol } from "@/types";
import { storeToRefs } from "pinia";
import { capitalize, onBeforeMount } from "vue";
import { reactive } from "vue";
import { computed } from "vue";
import {ref} from "vue";
import type { VForm } from "vuetify/components";
import Error from "./Error.vue";
import { useErrorStore } from "@/stores/error";

const form = ref<null | VForm>(null)
const empleadoStore = useEmpleadoStore()
const sucursalStore = useSucursalStore()
const errorStore = useErrorStore()
const {mensaje} = storeToRefs(errorStore)
const {sucursales} = storeToRefs(sucursalStore)
const {empleadoActual, cargando} = storeToRefs(empleadoStore)
const campos = reactive({
  nombres: '',
  apellidos: '',
  cedula: '',
  rol: null,
  idSucursal: null,
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

const tituloFormulario = computed(()=> empleadoActual.value ? 'Editar Empleado' : 'Agregar Empleado')

const procesarFormulario = async()=>{
  const {valid} = await form.value!.validate()
  if(valid){
    if(empleadoActual.value == null){
      await empleadoStore.agregar({
        ...campos, 
        rol: campos.rol as any
        })
    }else{
      empleadoStore.actualizar({
        ...campos as any,
      })
    }
  }
}

const cancelar = ()=>{
  empleadoStore.ocultarModal()
}

onBeforeMount(()=>{
  if(empleadoActual.value !== null){
    Object.assign(campos, {...empleadoActual.value})
  }
})
</script>

<style scoped>

</style>