import { createRouter, createWebHistory } from 'vue-router'
import MainPage from '../components/MainPage.vue'
import GalleryItemDetail from '../components/GalleryItemDetail.vue'
import SignInPage from '@/components/SignInPage.vue'
import SignUpPage from '@/components/SignUpPage.vue'
import HabbitTracker  from '@/components/HabbitTrackerPage.vue'

const routes = [
  {
    path: '/signin',
    name: 'SignInPage',
    component: SignInPage,
  },
    {
    path: '/signup',
    name: 'SignUpPage',
    component: SignUpPage,
  },
   {
    path: '/habbit-tracker',
    name: 'HabbitTracker',
    component: HabbitTracker,
  },
  {
    path: '/',
    name: 'Home',
    component: MainPage,
  },
  {
    path: '/gallery/:name:id?',
    name: 'GalleryItemDetail',
    component: GalleryItemDetail,
    props: true, 
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
