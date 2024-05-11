<template>
  <VContainer>
    <VRow class="mt-5">
      <VCol>
        <VBtn 
          icon="mdi-plus"
          @click = "empleadoStore.abrirModal()"
        />
      </VCol>
    </VRow>
    <VRow>
      <VCol cols="12">
        <TablaEmpleado />
      </VCol>
    </VRow>
    <VDialog 
      v-model="modal" 
      persistent
      width="450"
      >
      <FormEmpleado />
    </VDialog>
  </VContainer>
</template>

<script setup lang="ts">
import TablaEmpleado from '@/components/TablaEmpleado.vue';
import FormEmpleado from '@/components/FormEmpleado.vue';
import { useEmpleadoStore } from '@/stores/empleado';
import { storeToRefs } from 'pinia';
import { onBeforeMount } from 'vue';
import { useSucursalStore } from '@/stores/sucursal';

const empleadoStore = useEmpleadoStore()
const sucursalStore = useSucursalStore()
const {modal} = storeToRefs(empleadoStore)

onBeforeMount(async()=>{
  await sucursalStore.obtenerTodo()
  await empleadoStore.obtenerTodo()
})
</script>

<style scoped>

</style>