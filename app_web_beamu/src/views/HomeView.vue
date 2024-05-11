<template>
  <VContainer>
    <VRow>
      <VCol>
        <h2>Rastrear envío</h2>
      </VCol>
    </VRow>
    <VRow>
      <VCol>
        <VTextField 
          variant="solo-filled"
          label="Código del envío"
          v-model="codigo"
          clearable
          :rules="[(v) => !!v || 'Ingrese el código']"
          :loading="cargando"
        >
          <template #append-inner>
            <VBtn
              variant="text"
              icon="mdi-magnify"
              @click="buscarEnvio"
            />
          </template>
        </VTextField> 
      </VCol>
    </VRow>
    <VRow v-if="envio" class="mt-5" justify="center">
      <VCol cols="auto">
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
      </VCol>
    </VRow>
  </VContainer>

  <VSnackbar
      v-model="snackbar"
      :timeout="5000"
      location="top center"
    >
      El código no existe!
      <template v-slot:actions>
        <v-btn
          color="blue"
          variant="text"
          @click="snackbar = false"
        >
          Close
        </v-btn>
      </template>
    </VSnackbar>
</template>

<script lang="ts" setup>
import type { ICliente, IEnvio, IEnvioDetalle, ISucursal } from '@/types';
import {Estado} from "@/types";

import { doc, getDoc, getFirestore } from 'firebase/firestore';
import { capitalize, ref } from 'vue';

const codigo = ref('m6Rh6ZHNphvJ5kYVebBw');
const cargando = ref(false);
const snackbar = ref(false);
const envio = ref<IEnvioDetalle | null>(null);

const buscarEnvio = async()=>{
  try {
    cargando.value = true;
    const resultado = await getDoc(
      doc(getFirestore(),'envios', codigo.value)
    );
    if(!resultado.exists()){
      snackbar.value = true;
      return;
    }
    
    const resultadoCliente = await getDoc(
      doc(getFirestore(),'clientes', resultado.data()!['idCliente'])
    );
    const resultadoSucursalSalida = await getDoc(
      doc(getFirestore(),'sucursales', resultado.data()!['idSucursalSalida'])
    );
    const resultadoSucursalLlegada = await getDoc(
      doc(getFirestore(),'sucursales', resultado.data()!['idSucursalLlegada'])
    );
    
    envio.value = {
      ...{id: resultado.id,
      ...resultado.data()!} as IEnvio,
      cliente: {
        id: resultado.data()!['idCliente'],
        ...resultadoCliente.data()!
      } as ICliente,
      sucursalSalida: {
        id: resultado.data()!['idSucursalSalida'],
        ...resultadoSucursalSalida.data()!
      } as ISucursal,
      sucursalLlegada: {
        id: resultado.data()!['idSucursalLlegada'],
        ...resultadoSucursalLlegada.data()!
      } as ISucursal
    }
  } catch (error) {
    console.log(error);    
  }finally{
    cargando.value = false
  }
}

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
