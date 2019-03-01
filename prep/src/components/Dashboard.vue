<template>
  <div id="dashboard">
    <ul class="collection with-header">
      <li class="collection-header">
        <h4>Employees</h4>
      </li>
    </ul>

  </div>
</template>

<script>
import db from "./firebaseInit";

export default {
  name: "dashboard",
  data() {
    return {
      employees: []
    };
  },
  created() {
  }
};
</script>


