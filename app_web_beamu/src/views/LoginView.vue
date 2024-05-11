<template>
  <VContainer>
    <VRow justify="center" align="center" style="height: 95vh;">
      <VCol cols="8" md="5">
        <VForm
          @submit.prevent="enviarFormulario"
        >
          <VCard
            class="pa-5"
            elevation="3"
          >
          <VCardTitle class="mb-1 text-center">
            <img
              class="bg-grey-lighten-2"
              height="125"
              src="../assets/logo.jpg"
            ></img>
            </VCardTitle>
            <VCardText>
              <h5 class="text-h6 mb-2">
                Bienvenido a Bemau Express! 👋🏻
              </h5>
              <Error />
              <VTextField
                label="Email"
                variant="outlined"
                type="email"
                class="mb-6 mt-4"
                v-model="campos.email"
              />
              <VTextField
                :type="verPassword ? 'text':'password'"
                label="Contraseña"
                variant="outlined"
                class="mb-8"
                v-model="campos.password"
              >
                <template #append-inner>
                  <VIcon 
                    style="cursor: pointer;"
                    :icon="verPassword ? 'mdi-eye-off':'mdi-eye'"
                    @click="verPassword = !verPassword"
                    />
                </template>
              </VTextField>
              <VBtn 
                type="submit"
                :loading="cargando"
                :disabled="cargando"
                class="w-100">
                Ingresar
              </VBtn>
            </VCardText>
          </VCard>
        </VForm>
      </VCol>
    </VRow>
  </VContainer>
</template>

<script setup lang="ts">
import { useAutenticacionStore } from "@/stores/autenticacion";
import {ref, reactive} from "vue";
import {storeToRefs} from "pinia";
import Error from "@/components/Error.vue";
import { onUnmounted } from "vue";
import { useErrorStore } from "@/stores/error";

const verPassword = ref(false)
const campos = reactive({
  email: 'luisjo3lml@gmail.com',
  password: '12345678'
})

const autenticacionStore = useAutenticacionStore()
const {cargando} = storeToRefs(autenticacionStore)

const enviarFormulario = ()=>{
  autenticacionStore.login(campos);
}

onUnmounted(()=>{
  // useErrorStore().restablecer()
})
</script>

<style scoped>

</style>@/stores/autenticacion