<template>
  <div id="dashboard">
    <div id="dashboard-top" class="dcontent">
      <Messages />
    </div>
    <div class="dcontent">
      <Appointments />
    </div>

  </div>
</template>

<script>
import db from "./firebaseInit";
import Messages from "./messages/ViewMessages";
import Appointments from "./appointments/ViewAppointments";

export default {
  name: "dashboard",
  components: {
    Messages,
    Appointments
  }
};
</script>

<style scoped>
.dcontent {
  padding-bottom: 20px;
  overflow-y: scroll;
}

#dashboard-top {
  max-height: 400px;
}
</style>


