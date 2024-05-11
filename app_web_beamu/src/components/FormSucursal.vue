<template>
  <VForm 
    ref="form"
    @submit.prevent="procesarFormulario"  
  >
    <VCard>
      <VCardTitle class="text-center text-h5">{{ tituloFormulario }}</VCardTitle>
      <VCardText>
        <VTextField
          label="Nombre"
          class="mb-4"
          v-model="campos.nombre"
          :rules="[campoRequerido]"
        />
        <VSelect 
          label="Provincia"
          class="mb-4"
          :items="provinciaStore.provincias"
          item-title="nombre"
          item-value="codigo"
          v-model="campos.provincia.codigo"
          clearable
          :rules="[campoRequerido]"
          @update:model-value="cambioProvincia"
        /> 
        <VSelect 
          label="Cantón"
          class="mb-4"
          :items="cantonesPorProvincia()"
          item-title="nombre"
          item-value="codigo"
          v-model="campos.canton.codigo"
          :rules="[campoRequerido]"
          clearable
          @update:model-value="cambioCanton"
        /> 
        <VTextField 
          label="Dirección"
          class="mb-4"
          v-model="campos.direccion"
          :rules="[campoRequerido]"
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
import { useProvinciaStore } from "@/stores/provincia";
import { useSucursalStore } from "@/stores/sucursal";
import { storeToRefs } from "pinia";
import { onBeforeMount } from "vue";
import { reactive } from "vue";
import { computed } from "vue";
import {ref} from "vue";
import type { VForm } from "vuetify/components";

const form = ref<null | VForm>(null)
const sucursalStore = useSucursalStore()
const provinciaStore = useProvinciaStore()
const {sucursalActual, cargando} = storeToRefs(sucursalStore)
const campos = reactive<{
  nombre: string,
  provincia: {
    codigo: string | null,
    nombre: string
  },
  canton: {
    codigo: string | null,
    nombre: string
  },
  direccion: string
}>({
  nombre: '',
  provincia: {
    codigo: null,
    nombre: ''
  },
  canton: {
    codigo: null,
    nombre: ''
  },
  direccion: ''
})
const campoRequerido = (v:string) => !!v || 'Campo requerido!'

const tituloFormulario = computed(()=> sucursalActual.value == null ? 'Agregar Sucursal' : 'Editar Sucursal')

const cantonesPorProvincia = ()=>{
  return campos.provincia.codigo ? 
    provinciaStore.cantones(campos.provincia.codigo) : []
}

const cambioProvincia = (codigoProvincia: string | null)=>{
  campos.provincia.nombre = ''
  campos.canton.codigo = null
  campos.canton.nombre = ''
  if(codigoProvincia == null) return;
  campos.provincia.nombre = provinciaStore.provincias.find(x => x.codigo === codigoProvincia)!.nombre
}

const cambioCanton = (codigoCanton: string | null) => {
  campos.canton.nombre = ''
  if(codigoCanton == null) return;
  campos.canton.nombre =  provinciaStore.cantones(campos.provincia.codigo!).find(x => x.codigo === codigoCanton)!.nombre
}

const cancelar = ()=>{
  sucursalStore.ocultarModal()
}


const procesarFormulario = async()=>{
  const {valid} = await form.value!.validate()
  if(valid){
    if(sucursalActual.value == null){
      await sucursalStore.agregar({
        ...campos, 
        provincia: {...campos.provincia, codigo: campos.provincia.codigo!}, 
        canton: {...campos.canton, codigo: campos.canton.codigo!}
      })
    }else{
      sucursalStore.actualizar({
        ...campos, 
        id: sucursalActual.value.id,
        provincia: {...campos.provincia, codigo: campos.provincia.codigo!}, 
        canton: {...campos.canton, codigo: campos.canton.codigo!}
      })
    }
  }
}

onBeforeMount(()=>{
  if(sucursalActual.value !== null){
    Object.assign(campos, {...sucursalActual.value})
  }
})
</script>

<style scoped>

</style>