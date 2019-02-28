<template>
  <b-col cols="12" md="6">
    <b-card class="result-card">
      <b-card-text>
        <strong>{{keyword}}</strong>
        <span v-if="synonym.length === 0">見つかりませんでした．</span>
      </b-card-text>
      <Synonym v-for="synonymItem in synonym" v-bind:synonym="synonymItem" />
    </b-card>
  </b-col>
</template>

<script>
import Synonym from './Synonym.vue'

export default {
  name: 'SynonymKey',
  props: ['synonym', 'keyword'],
  components: {
    Synonym: Synonym
  }
}
</script>

<style scoped>
.card-body {
  padding: 0.5rem;
}
</style>
