<template>
  <b-container fluid>
    <b-row class="mt-2">
      <b-col cols="12">
        <b-form inline>
          <label for="keyword">クラス名/メソッド名/変数名:</label>&nbsp;
          <b-input v-model="keyword" id="keyword" size="40" placeholder="certificate" />
        </b-form>
      </b-col>
    </b-row>
    <b-row class="mt-4">
      <b-col cols="7" md="4" class="mt-2">
        <p><strong>候補</strong><br><span class="small text-muted">頻度順，前方一致</span></p>
        <!-- eslint-disable-next-line -->
        <Suggest v-for="suggest in suggests" v-bind:suggest="suggest" v-bind:keyword="debounceKeyword" @use="useName" />
        <p v-if="suggests && suggests.length <= 0">見つかりませんでした．</p>
      </b-col>
      <b-col cols="5" md="2" class="mt-2">
        <p><strong>類語</strong></p>
        <p>未実装</p>
      </b-col>
      <b-col cols="12" md="6" class="mt-2">
        <p><strong>使用箇所 <span v-if="results && results.length > 0 && results.length > 100">(100〜 件)</span><span v-if="results && results.length > 0 && results.length <= 100">({{results.length}} 件)</span></strong><br><span class="small text-muted">辞書順，前方一致，大文字小文字を区別</span></p>
        <!-- eslint-disable-next-line -->
        <Result v-for="result in results" v-bind:result="result" v-bind:keyword="debounceKeyword" />
        <p v-if="results && results.length <= 0">{{debounceKeyword}} にマッチする結果が見つかりませんでした．</p>
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
      this.debounceKeyword = this.keyword.trim()
    }, 250),
    useName (value) {
      console.log(value)
      this.keyword = value
    }
  },
  asyncComputed: {
    async results () {
      const keyword = this.debounceKeyword
      const res = await Axios.get('/v1/search?q=' + keyword)
      return res.data[keyword] || []
    },
    async suggests () {
      const keyword = this.debounceKeyword
      const res = await Axios.get('/v1/suggest?q=' + keyword)
      return res.data || []
    }
  }
}
</script>
