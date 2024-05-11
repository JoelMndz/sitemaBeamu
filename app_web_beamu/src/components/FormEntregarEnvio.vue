<template>
  <VForm 
    ref="form"
    @submit.prevent="procesarFormulario"  
  >
    <VCard>
      <VCardTitle class="text-center text-h5"> Entregar Envío </VCardTitle>
      <VCardText>
        <p>Cliente: {{ clientes.find(x => x.id === envioPorEntregar?.idCliente)?.nombres }} {{ clientes.find(x => x.id === envioPorEntregar?.idCliente)?.apellidos }}</p>
        <p>Datos destinatario: {{ envioPorEntregar?.destinatario.nombre }} - {{ envioPorEntregar?.destinatario.celular }}</p>
        <VTextarea
          label="Observación"
          v-model="observacion"
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
import { useClienteStore } from "@/stores/cliente";
import { useEnvioStore } from "@/stores/envio";
import { storeToRefs } from "pinia";
import {ref} from "vue";
import type { VForm } from "vuetify/components";

const form = ref<null | VForm>(null)
const envioStore = useEnvioStore()
const {cargando, envioPorEntregar} = storeToRefs(envioStore)
const { clientes } = storeToRefs(useClienteStore())
const observacion = ref(''); 

const cancelar = ()=>{
  envioStore.cerrarModalParaEntregar()
}

const procesarFormulario = async()=>{
  const {valid} = await form.value!.validate()
  if(valid){
    await envioStore.entregarEnvio(observacion.value)
  }
}

</script>

<style scoped>

</style>