import { createRouter, createWebHistory } from 'vue-router'
import MainPage from '../components/MainPage.vue'
import GalleryItemDetail from '../components/GalleryItemDetail.vue'
import SignInPage from '@/components/SignInPage.vue'
import SignUpPage from '@/components/SignUpPage.vue'

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
    path: '/',
    name: 'Home',
    component: MainPage,
  },
  {
    path: '/gallery/:name',
    name: 'GalleryItemDetail',
    component: GalleryItemDetail,
    props: true, // This will pass the name param as a prop to GalleryItemDetail
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
