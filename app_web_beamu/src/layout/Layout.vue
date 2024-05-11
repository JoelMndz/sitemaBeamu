<template>
  <VContainer>
    <MenuDrawer/>
    <RouterView />
  </VContainer>
</template>

<script setup lang="ts">
import MenuDrawer from "@/components/MenuDrawer.vue";
import {RouterView} from "vue-router";

</script>

<style scoped>

</style>