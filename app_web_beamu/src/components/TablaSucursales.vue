<template>
  <VCard>
    <VCardText>
      <VDataTable
        :headers="headers"
        :items="sucursales"
        item-value="id"
        :loading="cargando"
      >
        <template #item.acciones="{item}">
          <VBtn
            variant="text"
            class="me-2"
            size="small"
            icon="mdi-pencil"
            color="warning"
            @click="sucursalStore.abrirModalParaEditar(item)"
          />
            
          <VBtn
            size="small"
            variant="text"
            icon="mdi-delete"
            color="error"
            @click="sucursalStore.abrirConfirmacionEliminar(item)"
          />
        </template>
      </VDataTable>
    </VCardText>
  </VCard>
  <VDialog
    :model-value="!!sucursalPorEliminar"
    persistent
    width="450"
  >
    <VCard>
      <VCardTitle
        class="text-h5"
      >
        Eliminar Sucursal
      </VCardTitle>
      <VCardText>
        ¿Estás seguro de eliminar la sucursal "{{ sucursalPorEliminar?.nombre }}"?
      </VCardText>
      <VCardActions>
        <VSpacer/>
        <VBtn
          variant="tonal"
          color="error"
          :disabled="cargando"
          @click="sucursalStore.cancelarConfirmacionEliminar()"
        >Cancelar</VBtn>
        <VBtn
          variant="tonal"
          :disabled="cargando"
          :loading="cargando"
          @click="sucursalStore.eliminar()"
        >Eliminar</VBtn>
      </VCardActions>
    </VCard>
  </VDialog>
</template>

<script setup lang="ts">
import { useSucursalStore } from '@/stores/sucursal';
import { storeToRefs } from 'pinia';
import { onBeforeMount } from 'vue';

const sucursalStore = useSucursalStore();
const {sucursales, cargando, sucursalPorEliminar} = storeToRefs(sucursalStore)
const headers = [
  {title: 'Nombre', value:'nombre'},
  {title: 'Provincia', value:'provincia.nombre'},
  {title: 'Cantón', value:'canton.nombre'},
  {title: 'Dirección', value:'direccion'},
  {title: 'Acciones', key:'acciones'}
]

onBeforeMount(()=>{
  sucursalStore.obtenerTodo()
})
</script>

<style scoped>

</style>