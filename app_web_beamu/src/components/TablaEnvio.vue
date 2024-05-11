<template>
  <VCard>
    <VCardText>
      <VDataTable
        :headers="headers"
        :items="envios"
        item-value="id"
        :loading="cargando"
      >
        <template #item.fechaRegistro="{item}">
          {{ new Date(item.fechaRegistro).toLocaleString() }}
        </template>
        <template #item.idTipoEnvio="{item}">
          {{ tiposEnvios.find(x=> x.id === item.idTipoEnvio)?.nombre }}
        </template>
        <template #item.idCliente="{item}">
          {{ nombreCompletoDelCliente(item.idCliente) }}
        </template>
        <template #item.estados="{item, value}">
          {{ item.estados[item.estados.length - 1].estado }}
        </template>
        <template #item.acciones="{item}">
          <VBtn
            v-if="Estado.SUCURSAL === item.estados[item.estados.length - 1].estado"
            variant="text"
            class="me-2"
            size="small"
            icon="mdi-email-fast"
            color="green"
            @click="envioStore.abrirModalParaEntregar(item)"
          />

          <VBtn
            variant="text"
            class="me-2"
            size="small"
            icon="mdi-file-pdf-box"
            color="red"
            @click="envioStore.generarPDF(item)"
          />
            
          <VBtn
            size="small"
            variant="text"
            icon="mdi-delete"
            color="error"
            @click="envioStore.abrirConfirmacionEliminar(item)"
          />
        </template>
      </VDataTable>
    </VCardText>
  </VCard>
  <VDialog
    :model-value="!!envioPorEliminar"
    persistent
    width="450"
  >
    <VCard>
      <VCardTitle
        class="text-h5"
      >
        Eliminar Envío
      </VCardTitle>
      <VCardText>
        ¿Estás seguro de eliminar el envío "{{ envioPorEliminar?.cliente.nombres }} {{ envioPorEliminar?.cliente.apellidos }}"?
      </VCardText>
      <VCardActions>
        <VSpacer/>
        <VBtn
          variant="tonal"
          color="error"
          :disabled="cargando"
          @click="envioStore.cancelarConfirmacionEliminar()"
        >Cancelar</VBtn>
        <VBtn
          variant="tonal"
          :disabled="cargando"
          :loading="cargando"
          @click="envioStore.eliminar()"
        >Eliminar</VBtn>
      </VCardActions>
    </VCard>
  </VDialog>
</template>

<script setup lang="ts">
import { useClienteStore } from '@/stores/cliente';
import { useEnvioStore } from '@/stores/envio';
import { storeToRefs } from 'pinia';
import {Estado} from "@/types";


const envioStore = useEnvioStore();
const {clientes} = storeToRefs(useClienteStore())
const {envios, cargando, envioPorEliminar, tiposEnvios} = storeToRefs(envioStore)
const headers = [
  {title: 'Fecha', value:'fechaRegistro'},
  {title: 'Cliente', value:'idCliente'},
  {title: 'Sucursal Salida', key:'sucursalSalida.nombre'},
  {title: 'Sucursal Llegada', key:'sucursalLlegada.nombre'},
  {title: 'Estado', key:'estados'},
  {title: 'Total', value:'total'},
  {title: 'Acciones', key:'acciones'}
]

const nombreCompletoDelCliente = (id:string)=>{
  const cliente = clientes.value.find(x => x.id === id)
  return `${cliente?.nombres} ${cliente?.apellidos}`
}
</script>

<style scoped>

</style>