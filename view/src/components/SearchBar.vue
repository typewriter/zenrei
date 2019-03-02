<template>
  <b-container fluid>
    <b-row class="mt-1">
      <b-col cols="12">
        <b-form v-on:submit.prevent inline>
          <label for="keyword">調べたいクラス/メソッド/変数名:</label>&nbsp;
          <b-form-input v-model="keyword" id="keyword" size="60" placeholder="certificate" ref="keyword" />
        </b-form>
      </b-col>
    </b-row>
    <b-row class="mt-1">
      <b-col cols="5" md="4" xl="2" class="mt-1">
        <p><strong>使用頻度</strong>&nbsp;<b-spinner variant="secondary" type="grow" small v-if="suggesting" /><br><span class="small text-muted">頻度順，前方一致</span></p>
        <!-- eslint-disable-next-line -->
        <Suggest v-for="suggest in suggests" v-bind:suggest="suggest" v-bind:keyword="debounceKeyword" @use="useName" />
        <p v-if="suggests && suggests.length <= 0">見つかりませんでした．</p>
      </b-col>
      <b-col cols="7" md="8" xl="6" class="mt-1">
        <p><strong>各単語ごとの類語</strong>&nbsp;<b-spinner variant="secondary" type="grow" small v-if="synonyming" /><br><span class="small text-muted">日本語WordNetによる</span></p>
        <b-container fluid>
          <b-row>
            <!-- eslint-disable-next-line -->
            <SynonymKey v-for="(synonym, word) in synonyms" v-bind:synonym="synonym" v-bind:keyword="word" />
          </b-row>
        </b-container>
      </b-col>
      <b-col cols="12" xl="4" class="mt-1">
        <p><strong>使用箇所 <span v-if="results && results.length > 0 && results.length > 100">(100〜 件)</span><span v-if="results && results.length > 0 && results.length <= 100">({{results.length}} 件)</span></strong>&nbsp;<b-spinner variant="secondary" type="grow" small v-if="resulting" /><br><span class="small text-muted">辞書順，前方一致，大文字小文字を区別</span></p>
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
import SynonymKey from './SynonymKey.vue'

export default {
  name: 'SearchBar',
  data: function () {
    return { keyword: '', debounceKeyword: '', suggesting: false, synonyming: false, resulting: false }
  },
  mounted () {
    this.$refs.keyword.focus();
  },
  components: {
    Result: Result,
    Suggest: Suggest,
    SynonymKey: SynonymKey
  },
  watch: {
    keyword: function (val) {
      this.suggesting = true
      this.synonyming = true
      this.resulting = true
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
      this.resulting = false
      return res.data[keyword] || []
    },
    async suggests () {
      const keyword = this.debounceKeyword
      const res = await Axios.get('/v1/suggest?q=' + keyword)
      this.suggesting = false
      return res.data || []
    },
    async synonyms () {
      var results = {}

      if (this.debounceKeyword === '') {
        this.synonyming = false
        return results
      }

      const keywords = this.debounceKeyword.toLowerCase().split('_')

      for (let keyword of keywords) {
        if (keyword === "") { continue }

        var lemmas = [keyword]

        var result = {}
        for (let lemma of lemmas) {
          const res = await Axios.get('/v1/synonym?q=' + lemma)
          if (res.data == null) { continue }

          for (let v of res.data) {
            if (!(v.Synset in result)) { result[v.Synset] = {} }
            if (!(v.Lang in result[v.Synset])) { result[v.Synset][v.Lang] = [] }
            result[v.Synset][v.Lang].push(v.Name)
          }
        }
        results[keyword] = result
      }
      this.synonyming = false
      return results
    }
  }
}
</script>
