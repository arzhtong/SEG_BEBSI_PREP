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

        <tbody class="collection-item" v-for="(app, index) in appointments" v-bind:key="index">
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
            v-for="(checkup, index) in dailyCheckups"
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
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "view-appointment",
  data() {
    return {
      dailyCheckups: [],
      appointments: [],
      testName: null,
      testType: null,
      router: this.$route.params.id,
      newMap: new Map(),
      past: this.$route.params.expired
    };
  },
  created() {
    this.listenDailyCheckups();
    this.getAppointmentInfo();
  },
  methods: {
    /*
      This method gets the information for the specified
      appointment with doc id given by the router.
    */
    getAppointmentInfo() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .get()
        .then(doc => {
          const data = {
            testID: doc.data().testID,
            date: doc
              .data()
              .datetime.toDate()
              .toISOString()
              .split("T")[0],
            time: doc
              .data()
              .datetime.toDate()
              .toTimeString()
              .split(" ")[0],
            location: doc.data().location
          };
          this.appointments.push(data);
          this.getTestInfo();
        });
    },
    /*
      This methid gets the needed information from the 
      tests collection with a doc id specified in the
      clicked appointment.
    */
    getTestInfo() {
      db.collection("tests")
        .doc(this.appointments[0].testID)
        .get()
        .then(doc => {
          (this.testName = doc.data().title), (this.testType = doc.data().type);
        });
    },
    /*
      This method listens live to the dailyCheckups 
      collection in the clicked appointment in order
      to get if any changes were made.
    */
    listenDailyCheckups() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .orderBy("daysBeforeTest", "desc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            // on page load
            if (change.type == "added") {
              const data = {
                docId: change.doc.id,
                daysBeforeTest: change.doc.data().daysBeforeTest,
                description: change.doc.data().description,
                instructions: change.doc.data().instructions
              };

              this.dailyCheckups.push(data);
            }
            // if modified (e.g set to true)
            if (change.type == "modified") {
              for (var i = 0; i < this.dailyCheckups.length; i++) {
                if (
                  this.dailyCheckups[i].daysBeforeTest ==
                  change.doc.data().daysBeforeTest
                ) {
                  this.dailyCheckups[
                    i
                  ].instructions = change.doc.data().instructions;
                  this.dailyCheckups.push();
                }
              }
            }
          });
        });
    },
    /*
      This method enables the dailyCheckyps to be modified.
      Note: This method is left here for expandability purposes
      and it does not function in this current website version.
    */
    enableEditMode(currentCheckup) {
      var inputArray = document.getElementsByClassName("dailyInput");
      var inputList = Array.from(inputArray);
      for (var i = 0; i < inputList.length; i++) {
        if (inputList[i].value in currentCheckup.instructions) {
          if (inputList[i].readOnly == true) {
            inputList[i].readOnly = false;
            inputList[i].style.color = "#2196f3";
          } else {
            inputList[i].readOnly = true;
            inputList[i].style.color = "grey";
          }
        }
      }
    }
  }
};
</script>
  <style scoped>
.tooltip {
  position: relative;
  display: inline-block;
}

.tooltip .tooltiptext {
  visibility: hidden;
  width: 100px;
  background-color: #555;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 100%;
  margin-left: -60px;
  opacity: 0;
  transition: opacity 0.3s;
}

.tooltip .tooltiptext::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #555 transparent transparent transparent;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
}
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
