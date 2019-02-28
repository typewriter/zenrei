<template>
  <div v-if="suggest.Name == keyword">
    <strong v-if="suggest.Name == keyword">{{suggest.Name}}</strong>
    &nbsp;<span class="small text-muted">{{suggest.Count}}箇所</span>
  </div>
  <div v-else>
    <b-link @click="useName">{{suggest.Name}}</b-link>
    &nbsp;<span class="small text-muted">{{suggest.Count}}箇所</span>
  </div>
</template>

<script>
export default {
  name: 'Suggest',
  props: ['suggest', 'keyword'],
  methods: {
    useName () {
      this.$emit('use', this.suggest.Name)
    }
  }
}
</script>

<style scoped>
div {
  overflow-wrap: anywhere;
}
</style>

