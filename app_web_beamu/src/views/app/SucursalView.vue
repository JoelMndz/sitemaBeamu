<template>
  <VContainer>
    <VRow class="mt-5">
      <VCol>
        <VBtn 
          icon="mdi-plus"
          @click = "sucursalStore.abrirModal()"
        />
      </VCol>
    </VRow>
    <VRow>
      <VCol cols="12">
        <TablaSucursales />
      </VCol>
    </VRow>
    <VDialog 
      v-model="modal" 
      persistent
      width="450"
      >
      <FormSucursal />
    </VDialog>
  </VContainer>
</template>

<script setup lang="ts">
import FormSucursal from '@/components/FormSucursal.vue';
import TablaSucursales from '@/components/TablaSucursales.vue';
import { useSucursalStore } from '@/stores/sucursal';
import { storeToRefs } from 'pinia';

const sucursalStore = useSucursalStore()
const {modal,} = storeToRefs(sucursalStore)

</script>

<style scoped>

</style>