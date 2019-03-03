<template>
  <div id="app">
    <Navbar />
    <div id ="main" class="row">
      <div>
        <Sidebar />
      </div>
      <div id="central" class="col s12 m12 l10" style="overflow-y: scroll; max-height: 90vh;">
        <router-view/>
      </div>

    </div>
  </div>
</template>

<script>
import Navbar from './components/Navbar'
import Sidebar from './components/Sidebar'

export default {
  name: 'App',
  components: {
    Navbar,
    Sidebar
  }
}
</script>
