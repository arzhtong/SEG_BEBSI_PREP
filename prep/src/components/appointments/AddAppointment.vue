<template>
  <div
    id="new-appointment"
    style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <h3>New Appointment</h3>
    <div class="row">
      <form @submit.prevent="saveAppointment" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="date" class="datepicker" v-model="date" required>
            <label>Date</label>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <input type="time" class="timepicker" v-model="time" required>
            <label>Time</label>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="location" required>
            <label>Location</label>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Staff Member</span>
            <input type="text" v-model="currentUser" disabled required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Choose Test</span>
            <select class="browser-default" style="color:black" v-model="testID">
              <option v-for="test in tests" v-bind:key="test.testID" :value="test">{{test.title}}</option>
            </select>
            
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Generated Mobile Code</span>
            <input type="text" v-model="code" disabled required>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
        <router-link to="/view-appointments" class="btn grey">Cancel</router-link>
      </form>
    </div>
  </div>
</template>


<script>
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "add-appointment",
  data() {
    return {
      date: "",
      time: "",
      location: null,
      staffMember: null,
      testID: null,
      currentUser: firebase.auth().currentUser.email,
      code: null,
      tests: []
    };
  },
  created() {
    var bool = true;
    while (bool == true) {
      bool = this.generateCode();
    }
    this.getDocId();
    db.collection("tests")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(test => {
          const data = {
            testID: test.data().testID,
            title: test.data().title,
            type: test.data().type
          };
          this.tests.push(data);
        });
      });
  },
  methods: {
    generateCode() {
      var ID = Math.random()
        .toString(36)
        .substr(2, 9);
      var docRef = db.collection("appointments").doc(ID);
      docRef
        .get()
        .then(doc => {
          if (doc.exists) {
            alert("Code exists");
            return true;
          } else {
            this.code = ID;
            return false;
          }
        })
        .catch(function(error) {
          alert(error);
        });
    },
    saveAppointment() {
      db.collection("appointments")
        .doc(this.code)
        .set({
          datetime: firebase.firestore.Timestamp.fromDate(new Date(Date.parse(this.date + 'T' + this.time + 'Z'))),
          location: this.location,
          staffMember: this.staffMember,
          testID: this.testID.testID
        })
        .then(docRef => {
          alert("Successfully created new appointment!");
          this.$router.push("/view-appointments");
        })
        .catch(error => console.log(err));
    },
    getDocId() {
      db.collection("users")
        .where("email", "==", this.currentUser)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.staffMember = doc.id;
            return;
          });
        });
    }
  }
};
</script>
  <style>
label,
span {
  color: #2196f3 !important;
}
</style>
