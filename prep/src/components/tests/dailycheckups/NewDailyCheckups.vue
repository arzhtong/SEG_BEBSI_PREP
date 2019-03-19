<template>
  <div
    id="new-dailycheckups"
    style="background-color:white;padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <h3>Add Daily Check-ups</h3>

    <div class="row">
      <form @submit.prevent="saveDailyCheckups" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="title" required>
            <label>Title</label>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="description" required>
            <label>Description</label>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <input type="number" min="0" v-model="daysBeforeTest" required>
            <label>Number of Days Before Test:</label>
          </div>
        </div>

        <button @click="addInstruction" class="btn green">new instruction</button>
        <div class="row">
          <div
            v-for="instruction in instructions"
            v-bind:key="instruction"
            class="input-field col s12"
          >
            <input type="text" v-model="instruction.value" required>
            <label>Instructions</label>
            <button
              class="btn red"
              @click="deleteInstruction(instructions.indexOf(instruction))"
            >remove instruction</button>
          </div>
        </div>

        <button type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-dailycheckups', params: {test_id: this.$route.params.test_id}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>
<script>
import db from "../../firebaseInit";
import firebase from "firebase";
export default {
  name: "new-dailycheckups",
  data() {
    return {
      title: null,
      instructions: [],

      description: null,
      daysBeforeTest: null
    };
  },
  methods: {
    /*
      This method creates an empty map which is inserted by the 
      elements from the instructions array. Then assign this map
      to daily checkup's instruction field.
    */
    saveDailyCheckups() {
      var map = {};
      var lastChecked = firebase.firestore.Timestamp.fromDate(
        new Date(Date.now())
      );
      for (var i = 0; i < this.instructions.length; i++) {
        map[i] = { answer: false, question: this.instructions[i].value, lastChecked: lastChecked };
      }

      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("dailyCheckups")
        .add({
          title: this.title,
          instructions: map,
          description: this.description,
          daysBeforeTest: Number(this.daysBeforeTest)
        })
        .then(docRef => {
          alert("Successfully created new Daily Check-ups!");
          this.$router.push({
            name: "view-dailycheckups",
            params: { test_id: this.$route.params.test_id }
          });
        })
        .catch(error => console.log(err));
    },
    /*
      This method add an instruction as an element of the instructions array.
    */
    addInstruction() {
      const data = { value: "" };
      this.instructions.push(data);
    },
    /*
      This method delete the instruction which added.
    */
    deleteInstruction(index) {
      this.instructions.splice(index, 1);
    }
  }
};
</script>

<style>
label {
  color: #2196f3 !important;
}
</style>



