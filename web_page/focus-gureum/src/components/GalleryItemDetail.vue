<template>
  <div>
    <h2>Gallery Item: {{ name }}</h2>
    <p>This is the detail view for the gallery item named "{{ name }}".</p>
  </div>
</template>

<script>
export default {
  props: ['name'],
}
</script>
