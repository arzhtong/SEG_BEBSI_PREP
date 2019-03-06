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
            <th>Test</th>
            <th>Test Type</th>
          </tr>
        </thead>

        <tbody class="collection-item">
          <tr>
            <td>sadsa</td>
            <td>asd</td>
            <td>sad</td>
            <td>sad</td>
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
                <span v-for="instr in checkup.instructions" v-bind:key="instr">
                  <input
                    class="dailyInput"
                    id="dailyInput"
                    readonly="readonly"
                    :value="instr"
                    style="word-wrap: break-word;widht:50px !important"
                  >
                  <label>
                  <input @change="enableEditMode" id="check" type="checkbox" class="filled-in">
                  <span class="black-text">Edit Mode</span>
                </label>
                
                <button
                  @click="addInstructions(checkup.instructions.indexOf(instr))"
                  class="btn"
                >Submit changes</button>
                </span>
                
                
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
      dailyCheckups: []
    };
  },
  created() {
    this.listenDailyCheckups();
  },
  methods: {
    listenDailyCheckups() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .orderBy("daysBeforeTest", "desc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            const data = {
              docId: change.doc.id,
              daysBeforeTest: change.doc.data().daysBeforeTest,
              description: change.doc.data().description,
              instructions: change.doc.data().instructions
            };
            this.dailyCheckups.push(data);
          });
        });
    },
    enableEditMode() {
      var checkBox = document.getElementById("check").checked;
      var input = document.getElementById("dailyInput");
      if (checkBox) {
        input.readOnly = false;
      } else {
        input.readOnly = true;
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
    addInstrutionsToFb(docId) {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .doc(docId)
        .update({
          instructions: {
            [0]: document.getElementById("dailyInput").value
          }
        })
        .catch(function(error) {
          console.error("Error writing document: ", error);
        });
    }
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
input:read-only {
  color: grey;
}
.btn {
  margin: 10px;
}
</style>
