<template>
  <VContainer>
    <VRow class="mt-5">
      <VCol>
        <VBtn 
          icon="mdi-plus"
          @click = "envioStore.abrirModal()"
        />
      </VCol>
    </VRow>
    <VRow>
      <VCol cols="12">
        <TablaEnvio />
      </VCol>
    </VRow>
    <VDialog 
      v-model="modal" 
      persistent
      width="450"
      >
      <FormEnvio />
    </VDialog>
    <VDialog 
      :model-value="envioPorEntregar != null"
      persistent
      width="450"
      >
      <FormEntregarEnvio />
    </VDialog>
  </VContainer>
</template>

<script setup lang="ts">
import FormEntregarEnvio from '@/components/FormEntregarEnvio.vue';
import FormEnvio from '@/components/FormEnvio.vue';
import TablaEnvio from '@/components/TablaEnvio.vue';
import { useClienteStore } from '@/stores/cliente';
import { useEnvioStore } from '@/stores/envio';
import { useSucursalStore } from '@/stores/sucursal';
import { storeToRefs } from 'pinia';
import { onBeforeMount } from 'vue';

const envioStore = useEnvioStore()
const clienteStore = useClienteStore()
const sucursalStore = useSucursalStore()
const {modal, envioPorEntregar} = storeToRefs(envioStore)

onBeforeMount(async()=>{
  
  await sucursalStore.obtenerTodo()
  await clienteStore.obtenerTodo()
  await envioStore.obtenerTiposEnvios()
  await envioStore.obtenerTodo()
})
</script>

<style scoped>

</style>