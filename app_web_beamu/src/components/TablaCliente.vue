<template>
  <VCard>
    <VCardText>
      <VDataTable
        :headers="headers"
        :items="clientes"
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
            @click="clienteStore.abrirModalParaEditar(item)"
          />
            
          <VBtn
            size="small"
            variant="text"
            icon="mdi-delete"
            color="error"
            @click="clienteStore.abrirConfirmacionEliminar(item)"
          />
        </template>
      </VDataTable>
    </VCardText>
  </VCard>
  <VDialog
    :model-value="!!clientePorEliminar"
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
        ¿Estás seguro de eliminar el empleado "{{ clientePorEliminar?.nombres }} {{ clientePorEliminar?.apellidos }}"?
      </VCardText>
      <VCardActions>
        <VSpacer/>
        <VBtn
          variant="tonal"
          color="error"
          :disabled="cargando"
          @click="clienteStore.cancelarConfirmacionEliminar()"
        >Cancelar</VBtn>
        <VBtn
          variant="tonal"
          :disabled="cargando"
          :loading="cargando"
          @click="clienteStore.eliminar()"
        >Eliminar</VBtn>
      </VCardActions>
    </VCard>
  </VDialog>
</template>

<script setup lang="ts">
import { useClienteStore } from '@/stores/cliente';
import { storeToRefs } from 'pinia';

const clienteStore = useClienteStore();
const {clientes, cargando, clientePorEliminar} = storeToRefs(clienteStore)
const headers = [
  {title: 'Nombre Completo', key:'nombreCompleto'},
  {title: 'Cédula', value:'cedula'},
  {title: 'Email', value:'email'},
  {title: 'Fecha Nacimiento', value:'fechaNacimiento'},
  {title: 'Acciones', key:'acciones'}
]
</script>

<style scoped>

</style>