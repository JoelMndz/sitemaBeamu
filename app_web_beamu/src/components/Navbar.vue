<template>
  <VAppBar>
    <template #title>
      <VImg 
        width="130"
        src="src/assets/logo.jpg"
        @click="$router.push('/')"
        style="cursor: pointer;"
      />
    </template>
    <template #append>
      <VBtn
        class="me-5"
        variant="outlined"
        to="/login"
      >Iniciar sesión</VBtn>
    </template>
  </VAppBar>
</template>

<script setup lang="ts">

</script>

<style scoped>

</style>