<template>
  <div class="result">
    <b-card bg-variant="light">
      <div class="result-card small">
        <strong>{{result.Name}}</strong> ({{typeMap[result.Type]}})<br />
        <a :href="'https://github.com/' + result.Repository">{{result.Repository}}</a>: {{result.Filename}}
        <!-- <a :href="'https://github.com/' + result.Repository">{{result.Repository}}</a>: <a :href="'https://github.com/' + result.Repository + '/blob/master/' + result.Filename" :title="result.Filename">{{result.Filename}}</a> -->
      </div>
    </b-card>
  </div>
</template>

<script>
export default {
  name: 'Result',
  props: ['result', 'keyword'],
  data: function () {
    return {
      typeMap: {
        10: 'クラス',
        11: 'モジュール',
        20: 'メソッド',
        30: '変数',
        31: '引数',
        32: 'インスタンス変数',
        33: 'グローバル変数'
      }
    }
  }
}
</script>

<style scoped>
.result-card {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.card-body {
  padding: 0.25rem;
}
</style>
