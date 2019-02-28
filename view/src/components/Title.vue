<template>
  <b-container classs="title" fluid>
    <b-row class="bg-light">
      <b-col cols="12">
        <h1>
          Zenrei <span class="small text-muted">beta</span>
        </h1>
        <!-- <small>(from Japanese: 前例, "precedent")</small> -->
        <p class="small"><b-badge>Ruby only</b-badge> クラス名，メソッド名，変数名の使用実績をGitHubスター数上位リポジトリから検索</p>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
export default {
  name: 'Title',
  props: {
  }
}
</script>
