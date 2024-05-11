<template>
  <VCard>
    <VCardText>
      <VDataTable
        :headers="headers"
        :items="empleados"
        item-value="id"
        :loading="cargando"
      >
      <template #item.nombreCompleto="{item}">
          {{ item.nombres }} {{ item.apellidos }}
        </template>
        <template #item.acciones="{item}">
          <VBtn
            variant="text"
            class="me-2"
            size="small"
            icon="mdi-pencil"
            color="warning"
            @click="empleadoStore.abrirModalParaEditar(item)"
          />
            
          <VBtn
            size="small"
            variant="text"
            icon="mdi-delete"
            color="error"
            @click="empleadoStore.abrirConfirmacionEliminar(item)"
          />
        </template>
      </VDataTable>
    </VCardText>
  </VCard>
  <VDialog
    :model-value="!!empleadoPorEliminar"
    persistent
    width="450"
  >
    <VCard>
      <VCardTitle
        class="text-h5"
      >
        Eliminar Empleado
      </VCardTitle>
      <VCardText>
        ¿Estás seguro de eliminar el empleado "{{ empleadoPorEliminar?.nombres }} {{ empleadoPorEliminar?.apellidos }}"?
      </VCardText>
      <VCardActions>
        <VSpacer/>
        <VBtn
          variant="tonal"
          color="error"
          :disabled="cargando"
          @click="empleadoStore.cancelarConfirmacionEliminar()"
        >Cancelar</VBtn>
        <VBtn
          variant="tonal"
          :disabled="cargando"
          :loading="cargando"
          @click="empleadoStore.eliminar()"
        >Eliminar</VBtn>
      </VCardActions>
    </VCard>
  </VDialog>
</template>

<script setup lang="ts">
import { useEmpleadoStore } from '@/stores/empleado';
import { storeToRefs } from 'pinia';

const empleadoStore = useEmpleadoStore();
const {empleados, cargando, empleadoPorEliminar} = storeToRefs(empleadoStore)
const headers = [
  {title: 'Nombre Completo', key:'nombreCompleto'},
  {title: 'Cédula', value:'cedula'},
  {title: 'Rol', value:'rol'},
  {title: 'Email', value:'email'},
  {title: 'Fecha Nacimiento', value:'fechaNacimiento'},
  {title: 'Acciones', key:'acciones'}
]
</script>

<style scoped>

</style>