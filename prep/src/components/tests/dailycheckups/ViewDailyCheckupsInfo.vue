<template>
  <div id="view-dailycheckups-info">
    <ul class="collection with-header">
      <li class="collection-header">
        <h4 style="padding:10px;font-weight: bold;">Daily Checkups Information:</h4>
      </li>
      <li class="collection-item">
        <b>Id:</b>
        {{code}}
      </li>
      <li class="collection-item">
        <b>Title:</b>
        {{title}}
      </li>
      <li class="collection-item">
        <b>Number of Days Before Test:</b>
        {{daysBeforeTest}}
      </li>
      <li v-if="description" class="collection-item">
        <b>Description:</b>
        {{description}}
      </li>
      <li class="collection-item">
        <b>Instructions:</b>
       
        <ul v-for="(value, key) in instructions" :key="key">
          <ol style="padding:10px;font-weight: bold;">Instruction {{key}}:</ol>
          <ol>Question: {{value.question}}</ol>
          <ol>Last checked time: 
            {{value.lastChecked.toDate().toISOString().split("T")[0]}}
            {{value.lastChecked.toDate().toTimeString().split(" ")[0]}}
          </ol>
          <ol>Status: {{value.answer}} </ol>
        </ul>
      </li>

      <li class="collection-item">
        <router-link
          v-bind:to="{name: 'edit-dailycheckups', params: {test_id: test_id, daily_id:title}}"
          class="btn green"
        >Edit</router-link>

        <router-link v-bind:to="{name: 'view-dailycheckups', params: {test_id: test_id}}">
          <button @click="deleteDailyCheckups" class="btn red">Delete</button>
        </router-link>

        <router-link
          v-bind:to="{name: 'view-dailycheckups', params: {test_id: test_id}}"
          class="btn grey"
        >Back</router-link>
      </li>
    </ul>

    <div class="fixed-action-btn"></div>
  </div>
</template>

<script>
import db from "../../firebaseInit";

export default {
  name: "view-dailycheckups-info",
  data() {
    return {
      title: null,
      instructions: [],
      description: null,
      daysBeforeTest: null,
      code: null,
      test_id: this.$route.params.test_id
    };
  },
  beforeRouteEnter(to, from, next) {
    db.collection("tests")
      .doc(to.params.test_id)
      .collection("dailyCheckups")
      .where("title", "==", to.params.daily_id)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          next(vm => {
            vm.code = doc.id;
            vm.title = doc.data().title;
            vm.instructions = doc.data().instructions;
            vm.daysBeforeTest = doc.data().daysBeforeTest;
            vm.description = doc.data().description;
          });
        });
      });
  },
  watch: {
    $route: "fetchData"
  },
  methods: {
    /*
      This method get fields' data from firestore and assign
      it to the variables.
    */
    fetchData() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("dailyCheckups")
        .where("title", "==", this.$route.params.daily_id)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.code = doc.id;
            this.title = doc.data().title;
            this.instructions = doc.data().instructions;
            this.description = doc.data().description;
            this.daysBeforeTest = doc.data().daysBeforeTest;
          });
        });
    },
    /*
      This method is used for deleting the daily checkups and 
      pops up an alert window for checking.
    */
    deleteDailyCheckups() {
      if (confirm("Are you sure you want to delete this Daily Checkup?")) {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("dailyCheckups")
          .where("title", "==", this.$route.params.daily_id)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
              doc.ref
                .delete()
                .then(() => {
                  console.log("Document successfully deleted!");
                  alert(`Successfully deleted Daily Checkup!`);
                  location.reload();
                })
                .catch(function(error) {
                  console.error("Error removing document: ", error);
                  alert(`There was an error: ${error}`);
                });
            });
          });
      }
    }
  }
};
</script>
