<template>
  <div
    id="edit-appointment"
    style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <h3>Edit Appointment</h3>
    <div class="row">
      <form @submit.prevent="updateAppointment" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <p>Mobile Code:</p>
            <input type="text" v-model="code" disabled required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Date</p>
            <input type="date" min="2019-01-01" class="datepicker" v-model="date" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Time</p>
            <input type="time" class="timepicker" v-model="time" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Location:</p>
            <input type="text" v-model="location" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Change Referenced Staff:</p>
            <select class="browser-default" style="color:black" v-model="staffMember">
              <option v-for="user in users" v-bind:key="user.Ucode" :value="user">{{user.name}}</option>
            </select>
          </div>
        </div>

        <button type="submit" class="btn">Submit</button>

        <router-link
          v-bind:to="{name: 'view-appointment', params: {expired: expired, id: router}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
    <br>
  </div>
</template>

<script>
import db from "../firebaseInit";
import firebase from "firebase";
export default {
  name: "edit-appointment",
  data() {
    return {
      date: "",
      time: "",
      code: null,
      location: null,
      staffMember: null,
      users: [],
      router: this.$route.params.id,
      expired: this.$route.params.expired
    };
  },
  created() {
    // Gets all the information from the
    // users collection
      db
        .collection("users")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(user => {
            const data = {
              dept: user.data().dept,
              email: user.data().email,
              name: user.data().name,
              role: user.data().role,
              Ucode: user.id
            };
            this.users.push(data);
          });
        });
  },
  /*
    This method is ran before the router navigates to the page.
    It preloads the input boxes with appointments information.
  */
  beforeRouteEnter(to, from, next) {
    db.collection("appointments")
      .doc(to.params.id)
      .get()
      .then(doc => {
        if (doc.exists) {
          next(vm => {
            vm.date = doc
              .data()
              .datetime.toDate()
              .toISOString()
              .split("T")[0];
            vm.time = doc
              .data()
              .datetime.toDate()
              .toTimeString()
              .split(" ")[0];
            vm.location = doc.data().location;
            vm.testID = doc.data().testID;
            vm.staffMember = doc.data().staffMember;
            vm.code = doc.id;
          });
        }
      });
  },
  watch: {
    $route: "fetchData"
  },
  methods: {
    /*
      This method collects data for the specified 
      appointment from the router navigation bar.
    */
    fetchData() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .get()
        .then(doc => {
          if (doc.exists) {
            this.location = doc.data().location;
            this.datetime = doc.data().datetime;
            this.staffMember = doc.data().staffMember;
            this.code = doc.id;
          }
        });
    },
    /*
      This method updates the information
      for the specified appointment on firestore.
    */
    updateAppointment() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .update({
          location: this.location,
          datetime: firebase.firestore.Timestamp.fromDate(
            new Date(Date.parse(this.date + "T" + this.time + "Z"))
          ),
          staffMember: this.staffMember.Ucode,
          doctor: this.staffMember.name
        })
        .then(() => {
          alert("Appointments info updated!");
          this.$router.push("/view-appointments");
        })
        .catch(function(error) {
          console.error("Error writing document: ", error);
        });
    }
  }
};
</script>
<style scoped>
p {
  color: #2196f3;
}
h3 {
  font-weight: bold;
  margin-left: 20px;
}
</style>
