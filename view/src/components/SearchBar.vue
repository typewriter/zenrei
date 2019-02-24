<template>
  <b-container fluid>
    <b-row class="mt-2">
      <b-col cols=12>
        <b-form inline>
          <label for="keyword">クラス名/メソッド名/変数名:</label>&nbsp;
          <b-input v-model="keyword" id="keyword" size="40" placeholder="certificate" />
        </b-form>
      </b-col>
    </b-row>
    <b-row class="mt-4">
      <b-col cols=8>
        <p><strong>検索結果 <span v-if="results && results.length > 0 && results.length > 100">(100〜 件)</span><span v-if="results && results.length > 0 && results.length <= 100">({{results.length}} 件)</span></strong></p>
        <!-- eslint-disable-next-line -->
        <Result v-for="result in results" v-bind:result="result" />
        <p v-if="results && results.length <= 0">{{debounceKeyword}} にマッチする結果が見つかりませんでした．</p>
      </b-col>
      <b-col cols=4>
        <p><strong>候補</strong></p>
        <!-- eslint-disable-next-line -->
        <Suggest v-for="suggest in suggests" v-bind:suggest="suggest" />
        <p v-if="suggests && suggests.length <= 0">見つかりませんでした。</p>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import Axios from 'axios'
import _ from 'lodash'
import Result from './Result.vue'
import Suggest from './Suggest.vue'

export default {
  name: 'SearchBar',
  data: function () {
    return { keyword: '', debounceKeyword: '' }
  },
  components: {
    Result: Result,
    Suggest: Suggest
  },
  watch: {
    keyword: function (val) {
      this.debouncer()
    }
  },
  methods: {
    debouncer: _.debounce(function () {
      this.debounceKeyword = this.keyword
    }, 250)
  },
  asyncComputed: {
    async results () {
      const keyword = this.debounceKeyword
      const res = await Axios.get('/search?q=' + keyword)
      return res.data[keyword] || []
    },
    async suggests () {
      const keyword = this.debounceKeyword
      const res = await Axios.get('/suggest?q=' + keyword)
      return res.data || []
    }
  }
}
</script>
