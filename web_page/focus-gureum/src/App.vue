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
  --color-primary: #f4c6e4;
  --color-secondary: #c72a83;
  --color-thridary: #77c325;
  --color-background: #f3f3f3;
  --color-accent: #7b8eee;
  --color-focus: #2ee7bc;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
