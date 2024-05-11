<template>
  <VNavigationDrawer
    permanent
    class="pa-2"
    color="background"
  >
    <v-list-item
      class="py-5"
      prepend-avatar="https://randomuser.me/api/portraits/men/85.jpg"
      :title="nombreCompleto"
      nav
      >
    </v-list-item>

    <v-divider></v-divider>

    <v-list density="compact" nav>
      <template v-for="ruta in rutas" :key="ruta.titulo">
        <v-list-item 
          v-if="ruta.roles.find(x => x === usuario?.rol)"
          :prepend-icon="ruta.icono" 
          :title="ruta.titulo"
          :to="ruta.path"/>
      </template> 
    </v-list>
    <template #append>
      <VBtn
        color="error"
        class="w-100"
        @click="autenticacionStore.cerrarSesion()"
      >
        Salir
      </VBtn>
    </template>
  </VNavigationDrawer>
</template>

<script setup lang="ts">
import { useAutenticacionStore } from '@/stores/autenticacion';
import { Rol } from '@/types';
import { storeToRefs } from 'pinia';
import { computed } from 'vue';


const autenticacionStore = useAutenticacionStore()
const {usuario} = storeToRefs(autenticacionStore)
const rutas = [
  {
    titulo: 'Sucursales',
    icono: ' mdi-office-building-outline',
    path: '/app/sucursal',
    roles: [Rol.ADMINISTRADOR]
  },
  {
    titulo: 'Empleado',
    icono: 'mdi-account-tie',
    path: '/app/empleado',
    roles: [Rol.ADMINISTRADOR]
  },
  {
    titulo: 'Clientes',
    icono: 'mdi-account',
    path: '/app/cliente',
    roles: [Rol.ADMINISTRADOR, Rol.SECRETARIO]
  },
  {
    titulo: 'Envíos',
    icono: 'mdi-cube-send',
    path: '/app/envio',
    roles: [Rol.ADMINISTRADOR, Rol.SECRETARIO]
  },
]

const nombreCompleto = computed(()=> usuario.value?.nombres + ' ' + usuario.value?.apellidos)
</script>

<style scoped>

</style>