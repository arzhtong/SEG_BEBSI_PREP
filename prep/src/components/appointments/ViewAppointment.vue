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
      <div id="dailyCheckups">
        <h4>Daily Checkups</h4>
        <table
          class="collection with-header responsive-table"
          style="background: white;height:auto"
        >
          <thead class="collection-header">
            <tr style="font-size:1.5em;">
              <th>Days to appointment</th>
              <th>Description</th>
              <th>Instructions:</th>
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
              <td>{{checkup.description}}</td>
              <td>
                <span v-for="(instr, value) in checkup.instructions" v-bind:key="instr">
                  <span>{{value}}</span>
                  <input
                    class="dailyInput"
                    id="dailyInput"
                    readonly="readonly"
                    :value="instr"
                    style="word-wrap: break-word;widht:20px !important"
                  >
                
                </span>
                  <!-- <label>
                  <input @change="enableEditMode" id="check" type="checkbox" class="filled-in">
                  <span class="black-text">Edit Mode</span>
                </label>
                
                <button
                  @click="addInstructions(checkup.instructions.indexOf(instr))"
                  class="btn"
                >Submit changes</button> -->
                
              </td>
            </tr>
          </tbody>
        </table>
      </div>
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
      router: this.$route.params.id
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
              date: doc.data().datetime.toDate().toISOString().split('T')[0],
              time: doc.data().datetime.toDate().toTimeString().split(' ')[0],
              location: doc.data().location
            }
            this.appointments.push(data)
            this.getTestInfo();
        })
    },
    getTestInfo(){
      db.collection("tests").doc(this.appointments[0].testID).get()
      .then(doc => {
          this.testName = doc.data().title,
          this.testType = doc.data().type
      })
    },
    listenDailyCheckups() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .orderBy("daysBeforeTest", "desc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if(change.type == "added"){
                const data = {
                docId: change.doc.id,
                daysBeforeTest: change.doc.data().daysBeforeTest,
                description: change.doc.data().description,
                instructions: change.doc.data().instructions
              };
              this.dailyCheckups.push(data);
            }
            if(change.type == "modified"){
              for(var i = 0; i < this.dailyCheckups.length; i++){
                if(this.dailyCheckups[i].daysBeforeTest == change.doc.data().daysBeforeTest){
                  this.dailyCheckups[i].instructions = change.doc.data().instructions
                  this.dailyCheckups.push()
                }
              }
            }
           
          });
        });
    },
    // enableEditMode() {
    //   var checkBox = document.getElementById("check").checked;
    //   var input = document.getElementById("dailyInput");
    //   if (checkBox) {
    //     input.readOnly = false;
    //   } else {
    //     input.readOnly = true;
    //   }
    // },
    // addInstructions(index) {
    //   var inputValue = document.getElementById("dailyInput").value;
    //   var checkUp = this.dailyCheckups[index];

    //   if (checkUp.instructions.includes(inputValue)) {
    //      alert(index);
    //     alert("You have not made any changes!");
    //   } else {
    //     alert(index);
    //     // TODO: Fix arrays on fb
    //     //this.addInstrutionsToFb(checkUp.docId);
    //   }
    // },
    // addInstrutionsToFb(docId) {
    //   db.collection("appointments")
    //     .doc(this.$route.params.id)
    //     .collection("dailyCheckups")
    //     .doc(docId)
    //     .update({
    //       instructions: {
    //         [0]: document.getElementById("dailyInput").value
    //       }
    //     })
    //     .catch(function(error) {
    //       console.error("Error writing document: ", error);
    //     });
    // }
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
input:read-only {
  color: grey;
}
.btn {
  margin: 10px;
}
</style>
