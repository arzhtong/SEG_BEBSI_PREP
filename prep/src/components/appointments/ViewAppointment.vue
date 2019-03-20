<template>
  <div
    id="new-appointment"
    style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <div id="mainScreen">
      <h4 style="font-size:3em;">
        <b>Appointment: {{this.$route.params.id}}</b>
      </h4>
      <table class="collection with-header responsive-table" style="background: white;height:auto">
        <thead class="collection-header">
          <tr style="font-size:1.5em;">
            <th>Date</th>
            <th>Time</th>
            <th>Location</th>
            <th>Test</th>
            <th>Test Type</th>
          </tr>
        </thead>

        <tbody class="collection-item" v-for="(app, index) in appointmentsView" v-bind:key="index">
          <tr>
            <td>{{app.date}}</td>
            <td>{{app.time}}</td>
            <td>{{app.location}}</td>
            <td>{{testName}}</td>
            <td>{{testType}}</td>
            <td>
              <template v-if="past == false">
                <router-link
                  v-bind:to="{name: 'edit-appointment', params: {expired: past, id: router}}"
                >
                  <a class="tooltip" style="margin-right:20px">
                    <span class="tooltiptext">Edit Appointment</span>
                    <i class="material-icons">edit</i>
                  </a>
                </router-link>
              </template>
            </td>
          </tr>
        </tbody>
      </table>
      <div style="padding-top:5%;" id="dailyCheckups">
        <h4>Daily Checkups</h4>
        <table
          class="collection with-header responsive-table"
          style="background: white;height:auto"
        >
          <thead class="collection-header">
            <tr style="font-size:1.5em;">
              <th>Days to appointment</th>
              <th style="padding-left:10% !important">Description</th>
              <th style="padding-left:10% !important">Instructions:</th>
            </tr>
          </thead>

          <tbody
            style="word-wrap: break-word;"
            class="collection-item"
            v-for="(checkup, index) in dailyCheckupsView"
            v-bind:key="index"
          >
            <tr>
              <td>{{checkup.daysBeforeTest}}</td>
              <td style="padding-left:10% !important">{{checkup.description}}</td>
              <td style="padding-left:10% !important">
                <div v-for="(instruction, index) in checkup.instructions" v-bind:key="index">
                  <div style="float:left;">
                    <span>
                      <textarea
                        id="dailyInput"
                        class="dailyInput"
                        readonly="readonly"
                        type="text"
                        style="color:grey;width: 250px; word-wrap: break-word;resize: none;"
                        :value="instruction.question"
                        required
                      ></textarea>
                    </span>
                    <div style="float:right;">
                      <div v-if="instruction.answer" style="margin-top:15px">
                        <span style="margin:10px 0 0 5px;padding">
                          <a class="tooltip" style="margin-right:20px">
                            <span class="tooltiptext">Completed</span>
                            <i class="material-icons green-text">check_circle</i>
                          </a>
                        </span>
                      </div>
                      <div v-else style="margin-top:15px">
                        <span style="margin:10px 0 0 5px;">
                          <a class="tooltip" style="margin-right:20px">
                            <span class="tooltiptext">Not Completed</span>
                            <i class="material-icons red-text">cancel</i>
                          </a>
                        </span>
                      </div>
                      <span style="margin:10px 0 0 5px;">
                        <a class="tooltip black-text" style="margin-right:20px">
                          <span class="tooltiptext">Last modified</span>
                          {{instruction.lastChecked.toDate().toISOString()
                          .split("T")[0]}}
                          <br>
                          {{instruction.lastChecked.toDate().toTimeString()
                          .split(" ")[0]}}
                        </a>
                      </span>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <template v-if="past==false">
        <router-link to="/view-appointments" class="btn">Go Back</router-link>
      </template>
      <template v-else>
        <router-link to="/past-appointments" class="btn">Go Back</router-link>
      </template>
    </div>
  </div>
</template>


<script>
import { appointmentMixin } from "../../mixins/appointmentMixin";
export default {
  name: "view-appointment",
  mixins: [appointmentMixin],
  created() {
    this.listenDailyCheckups();
    this.getAppointmentInfo();
  }
};
</script>
  <style scoped>
label {
  color: #2196f3 !important;
}

span {
  color: #2196f3;
}
tr {
  border-bottom: 2px dotted lightgrey;
}
textarea {
  border-top: none;
  border-left: none;
  border-right: none;
  border-bottom: 2px solid rgb(0, 71, 6);
}
input:read-only {
  color: grey;
}
.btn {
  margin: 10px;
}
</style>
