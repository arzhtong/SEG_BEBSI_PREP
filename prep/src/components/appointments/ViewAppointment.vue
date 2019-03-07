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

        <tbody class="collection-item" v-for="app in appointments" v-bind:key="app">
          <tr>
            <td>{{app.date}}</td>
            <td>{{app.time}}</td>
            <td>{{app.location}}</td>
            <td>{{testName}}</td>
            <td>{{testType}}</td>
            <td>
              <router-link v-bind:to="{name: 'edit-appointment', params: {id: router}}">
                <a class="tooltip" style="margin-right:20px">
                  <span class="tooltiptext">Edit Appointment</span>
                  <i class="material-icons">edit</i>
                </a>
              </router-link>
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
            v-for="checkup in dailyCheckups"
            v-bind:key="checkup"
          >
            <tr>
              <td>{{checkup.daysBeforeTest}}</td>
              <td style="padding-left:10% !important">{{checkup.description}}</td>
              <td style="padding-left:10% !important">
                <div v-for="(instr, value) in checkup.instructions" v-bind:key="instr">
                  <div style="float:left;">
                    <span>
                      <textarea
                        id="dailyInput"
                        class="dailyInput"
                        readonly="readonly"
                        type="text"
                        style="color:grey;width: 250px; word-wrap: break-word;resize: none;"
                        :value="value"
                        required
                      ></textarea>
                    </span>
                    <div style="float:right;">
                      <div v-if="instr" style="margin-top:15px">
                        <span style="margin:10px 0 0 5px;padding">
                          <a class="tooltip" style="margin-right:20px">
                            <span class="tooltiptext">Completed</span>
                            <i class="material-icons green-text">check_circle</i>
                          </a>
                        </span>
                      </div>
                      <div v-if="instr == false" style="margin-top:15px">
                        <span style="margin:10px 0 0 5px;">
                          <a class="tooltip" style="margin-right:20px">
                            <span class="tooltiptext">Not Completed</span>
                            <i class="material-icons red-text">cancel</i>
                          </a>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="btns">
                  <div>
                    <span style="margin:0px 0px 0px 40px;cursor:pointer">
                      <a @click="enableEditMode(checkup)" class="tooltip" style="margin-right:20px">
                        <span class="tooltiptext">Edit Daily Checkup</span>
                        <i style="font-size:30px" class="material-icons">edit</i>
                      </a>
                      <a class="tooltip" style="margin-right:20px">
                        <span class="tooltiptext">Add Daily Checkup</span>
                        <i style="font-size:30px" class="material-icons green-text">fiber_new</i>
                      </a>
                    </span>
                  </div>

                  <div>
                    <button
                      style="width:120px;margin-left:20px"
                      @click="addInstructionsToFb(checkup)"
                      class="btn"
                    >Save</button>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <router-link to="/view-appointments" class="btn">Go Back</router-link>
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
      newMap: new Map
    };
  },
  created() {
    this.listenDailyCheckups();
    this.getAppointmentInfo();
  },
  methods: {
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
    getTestInfo() {
      db.collection("tests")
        .doc(this.appointments[0].testID)
        .get()
        .then(doc => {
          (this.testName = doc.data().title), (this.testType = doc.data().type);
        });
    },
    listenDailyCheckups() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .orderBy("daysBeforeTest", "desc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if (change.type == "added") {
              const data = {
                docId: change.doc.id,
                daysBeforeTest: change.doc.data().daysBeforeTest,
                description: change.doc.data().description,
                instructions: change.doc.data().instructions
              };
              data.instructions = data.instructions
              this.dailyCheckups.push(data);
            }
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
    },
    addInstructions(index) {
      var inputValue = document.getElementById("dailyInput").value;
      var checkUp = this.dailyCheckups[index];

      if (checkUp.instructions.includes(inputValue)) {
         alert(index);
        alert("You have not made any changes!");
      } else {
        alert(index);
        // TODO: Fix arrays on fb
        //this.addInstrutionsToFb(checkUp.docId);
      }
    },
    addInstructionsToFb(checkup) {
      var inputArray = document.getElementsByClassName("dailyInput");
      var inputList = Array.from(inputArray);
      var map = new Map()
      
      
      // db.collection("appointments")
      //   .doc(this.$route.params.id)
      //   .collection("dailyCheckups")
      //   .doc(docId)
      //   .update({
      //     instructions: map
      //   })
      //   .catch(function(error) {
      //     console.error("Error writing document: ", error);
      //   });

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
