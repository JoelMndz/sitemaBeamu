<template>
  <VAlert 
    v-if="mensaje"
    border="start"
    close-label="Close Alert"
    color="error"
    title="Error"
    variant="tonal"
    >
    <template #close>
      <VBtn 
        @click="errorStore.restablecer()"
        color="error"/>
    </template>
    {{ mensaje }}
  </VAlert>
</template>

<script setup lang="ts">
import { useErrorStore } from '@/stores/error';
import { storeToRefs } from 'pinia';


const errorStore = useErrorStore()
const {mensaje} = storeToRefs(errorStore)

</script>

<style scoped>

</style>