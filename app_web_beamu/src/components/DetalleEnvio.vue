<template>
  <VTimeline 
    align="center"
  >
    <VTimelineItem
      dot-color="primary"
      size="small"
      v-for="i in envio.estados"
    >
      <template #opposite>
        <strong class="me-4">{{ new Date(i.fecha).toLocaleString() }}</strong>
      </template> 
      <VCard>
        <VCardTitle class="mb-2 text-h6 bg-primary" >
          {{ formatearEstado(i.estado) }}
        </VCardTitle>
        <VCardText>
          <template v-if="i.estado === Estado.PENDIENTE">
            <p class="mb-1">
              <strong>Guía: </strong> 
              {{ envio.guia }}
            </p>
            <p class="mb-1">
              <strong>Cliente: </strong> 
              {{ envio.cliente.nombres }} {{ envio.cliente.apellidos }}
            </p>
            <p class="mb-1">
              <strong>Nombre del destinatario: </strong> 
              {{ envio.destinatario.nombre }}
            </p>
            <p class="mb-1">
              <strong>Dirección del destinatario: </strong> 
              {{ envio.destinatario.direccion }}
            </p>
            <p class="mb-1">
              <strong>Celular del destinatario: </strong> 
              {{ envio.destinatario.celular }}
            </p>
            <p class="mb-1">
              <strong>Sucursal Salida: </strong> 
              {{ envio.sucursalSalida.nombre }}
            </p>
            <p class="mb-1">
              <strong>Sucursal Llegada: </strong> 
              {{ envio.sucursalLlegada.nombre }}
            </p>
            <p class="mb-1">
              <strong>Peso: </strong> 
              {{ envio.pesoKg }} Kg
            </p>
            <p class="mb-1">
              <strong>Entregar a domicilio: </strong> 
              {{ envio.entregaDomicilio ? 'Si':'No' }}
            </p>
            <p class="mb-1">
              <strong>Total: </strong> 
              $ {{ envio.total }}
            </p>
          </template>
          <p v-if="i.observacion"class="mb-1">
            <strong>Observación: </strong> 
            {{ i.observacion }}
          </p>
        </VCardText>
      </VCard>
      <VImg
        v-if="i.imagenURL"
        :src="i.imagenURL"
      />
    </VTimelineItem>
  </VTimeline>
</template>

<script setup lang="ts">
import { Estado, type IEnvio } from "@/types";
import { capitalize, type PropType } from "vue";

defineProps({
  envio:{
    type: Object as PropType<IEnvio>,
    required: true
  }  
})

const formatearEstado = (estado: Estado)=>{
  switch(estado){
    case Estado.VIAJANDO:
      return 'Despachado al destino'
    case Estado.SUCURSAL:
      return 'Arribo en la Sucursal'
    case Estado.REPARTO:
      return 'En Reparto a su domicilio'
    case Estado.ENTREGADO:
      return 'Paquete entregado'
    default:
      return capitalize(Estado.PENDIENTE)
  }
}

</script>

<style scoped>

</style>