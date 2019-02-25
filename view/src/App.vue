<template>
  <div id="app">
    <Title />
    <SearchBar />
    <Footer />
  </div>
</template>

<script>
// Use bootstrap-vue
import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import AsyncComputed from 'vue-async-computed'

// Other components
import Title from './components/Title.vue'
import SearchBar from './components/SearchBar.vue'
import Footer from './components/Footer.vue'

Vue.use(BootstrapVue)
Vue.use(AsyncComputed)

export default {
  name: 'app',
  components: {
    Title,
    SearchBar,
    Footer
  }
}
</script>
