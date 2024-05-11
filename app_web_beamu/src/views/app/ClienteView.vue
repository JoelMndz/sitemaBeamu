<template>
  <VContainer>
    <VRow class="mt-5">
      <VCol>
        <VBtn 
          icon="mdi-plus"
          @click = "clienteStore.abrirModal()"
        />
      </VCol>
    </VRow>
    <VRow>
      <VCol cols="12">
        <TablaCliente />
      </VCol>
    </VRow>
    <VDialog 
      v-model="modal" 
      persistent
      width="450"
      >
      <FormCliente />
    </VDialog>
  </VContainer>
</template>

<script setup lang="ts">
import FormCliente from '@/components/FormCliente.vue';
import TablaCliente from '@/components/TablaCliente.vue';
import { useClienteStore } from '@/stores/cliente';
import { storeToRefs } from 'pinia';
import { onBeforeMount } from 'vue';

const clienteStore = useClienteStore()
const {modal} = storeToRefs(clienteStore)

onBeforeMount(async()=>{
  await clienteStore.obtenerTodo()
})
</script>

<style scoped>

</style>