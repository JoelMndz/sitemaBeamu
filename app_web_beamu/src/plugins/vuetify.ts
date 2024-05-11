import type { App } from "vue";
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

export function registerVuetify(app:App){
  const vuetify = createVuetify({
    components,
    directives,
    defaults: {
      VBtn: {
        color: 'primary',
      },
      VTextField: {
        variant: 'outlined',
        density: 'comfortable',
        color: 'primary',
        hideDetails: 'auto',
      },
      VAutocomplete:{
        variant: 'outlined',
        density: 'comfortable',
        color: 'primary',
        hideDetails: 'auto',
      },
      VSwitch:{
        density: 'comfortable',
        color: 'primary',
        hideDetails: 'auto',
      },
      VTextarea: {
        variant: 'outlined',
        density: 'comfortable',
        color: 'primary',
        hideDetails: 'auto',
      },
      VSelect: {
        variant: 'outlined',
        density: 'comfortable',
        color: 'primary',
        hideDetails: 'auto',
      },
    },
    theme: {
      defaultTheme: 'light',
      themes:{
        light: {
          dark: false,
          colors: {
            primary: '#374FCB',
            'on-primary': '#fff',
            'background': '#f4f5fa',
          }
        },
        dark:{
          dark: true
        }
      }
    }
  })
  app.use(vuetify)
}