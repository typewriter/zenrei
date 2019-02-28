<template>
  <div>
    <b-card class="result-card small">
      <b-card-text>
        {{synonym["eng"] && synonym["eng"].join(', ')}}<br />
        <span class="text-muted">{{synonym["jpn"] && synonym["jpn"].join('，')}}</span>
      </b-card-text>
    </b-card>
  </div>
</template>

<script>
export default {
  name: 'Synonym',
  props: ['synonym']
}
</script>

<style scoped>
.card-body {
  padding: 0.25rem;
}
.result-card {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
