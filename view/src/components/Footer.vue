<template>
  <b-container classs="footer" fluid>
    <b-row class="bg-light mt-2">
      <b-col cols="12">
        <b-badge variant="white">Developed by </b-badge> typewriter<br>
        <b-badge variant="white">Website</b-badge>&nbsp;<a href="https://www.nyamikan.net">にゃみかん (www.nyamikan.net)</a><br>
        <b-badge variant="white">GitHub</b-badge>&nbsp;<a href="https://github.com/typewriter/zenrei">typewriter / zenrei</a>
      </b-col>
    </b-row>
    <b-row class="bg-light pt-2 pb-2">
      <b-col cols="12">
        <b-badge variant="white">ライセンス表示</b-badge>&nbsp;
        <a href="http://compling.hss.ntu.edu.sg/wnja/index.ja.html">Japanese Wordnet (1.1) © 2009-2011 NICT, 2012-2015 Francis Bond and 2016-2017 Francis Bond, Takayuki Kuribayashi</a>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
export default {
  name: 'Footer',
  props: {
  }
}
</script>
