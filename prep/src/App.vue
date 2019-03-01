<template>
  <div id="app">
    <Navbar />
    <div class="container" style="max-width:100%;">
      <router-view/>
    </div>
  </div>
</template>

<script>
import Navbar from './components/Navbar'

export default {
  name: 'App',
  components: {
    Navbar
  }
}
</script>



