<template>
  <div id="app">
        <router-view />

  </div>
</template>

<script>
export default {
  name: 'App',
  components: {
  }
}
</script>

<style>
:root {
  --color-primary: #DAFDBA;
  --color-secondary: #9AEBA3;
  --color-thridary: #8edd3a;
  --color-background: #f3f3f3;
  --color-accent: #45C4B0;
  --color-focus: #8ac453;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
