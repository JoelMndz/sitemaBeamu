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
          label="Guía del envío"
          v-model="codigo"
          clearable
          :rules="[(v) => !!v || 'Ingrese la guía']"
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
        <DetalleEnvio :envio="envio" />
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
import DetalleEnvio from '@/components/DetalleEnvio.vue';
import type { ICliente, IEnvio, ISucursal } from '@/types';
import {Estado} from "@/types";

import { collection, doc, getDoc, getDocs, getFirestore, query, where } from 'firebase/firestore';
import { capitalize, ref } from 'vue';

const codigo = ref('');
const cargando = ref(false);
const snackbar = ref(false);
const envio = ref<IEnvio | null>(null);

const buscarEnvio = async()=>{
  try {
    cargando.value = true;
    const respuesta = await getDocs(
      query(
        collection(getFirestore(), 'envios'),
        where('guia','==',codigo.value)
      )
    );
    if(respuesta.docs.length == 0){
      snackbar.value = true;
      return;
    }
    const resultado = respuesta.docs[0];
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

</script>
