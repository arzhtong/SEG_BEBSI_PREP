<template>
  <div id="dashboard">
    <div id="dashboard-top" class="dcontent">

    </div>
    <div class="dcontent">
      <Appointments />
    </div>

  </div>
</template>

<script>
import db from "./firebaseInit";

import Appointments from "./appointments/ViewAppointments";

export default {
  name: "dashboard",
  components: {

    Appointments
  }
};
</script>

<style scoped>
.dcontent {
  padding-bottom: 20px;
  overflow-y: auto;
}

#dashboard-top {
  max-height: 400px;
}
</style>


