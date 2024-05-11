import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import { useAutenticacionStore } from '@/stores/autenticacion'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: HomeView
    },
    {
      path: '/login',
      component: () => import('../views/LoginView.vue')
    },
    {
      path: '/app',
      meta:{
        protegida: true
      },
      component: ()=> import('@/layout/Layout.vue'),
      children: [
        {
          path: 'sucursal',
          component: () => import('../views/app/SucursalView.vue')
        },
        {
          path: 'empleado',
          component: () => import('../views/app/EmpleadoView.vue')
        },
        {
          path: 'cliente',
          component: () => import('../views/app/ClienteView.vue')
        },
        {
          path: 'envio',
          component: () => import('../views/app/EnvioView.vue')
        },
      ]
    },
  ]
})

router.beforeEach((to, from, next)=>{
  const {usuario} = useAutenticacionStore()
  if(to.meta?.protegida && usuario == null){
    return next('/login')
  }
  if(!to.meta?.protegida && usuario != null){
    return next('/app/sucursal')
  }
  next()
})

export default router
