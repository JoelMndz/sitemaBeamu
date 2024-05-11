<template>
  <VApp>
    <VMain>
      <Navbar v-if="!usuario" />
      <RouterView />
    </VMain>
  </VApp> 
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia';
import { useAutenticacionStore } from './stores/autenticacion';
import Navbar from './components/Navbar.vue';


const autenticacionStore = useAutenticacionStore()
const {usuario} = storeToRefs(autenticacionStore)
</script>

<style scoped>

</style>
