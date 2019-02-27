<template>
  <div id="view-appointment">
    <div class="container" style="width:100%;height:100%;">
      <table class="collection with-header responsive-table" style="background: white;">
        <thead class="collection-header">
          <h4 style="padding:20px;font-size:3em;">
            <b>Appointments</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Mobile Code</th>
            <th>Datetime</th>
            <th>Location</th>
            <th>Test</th>
          </tr>
        </thead>

        <tbody
          v-for="appointment in appointments"
          v-bind:key="appointment.datetime"
          class="collection-item"
        >
          <tr>
            <td style="padding-left: 20px;">{{appointment.code}}</td>
            <td>{{appointment.datetime.toDate()}}</td>
            <td>{{appointment.location}}</td>
            <td v-for="test in tests" v-bind:key="test.title">{{test.title}}</td>
            <td>
              <button class="btn blue" style="position:relative;text-align:center;">edit</button>
            </td>
            <td>
              <button class="btn red">Delete</button>
            </td>
            <td>
              <router-link v-bind:to="{name: 'message', params: {appointmentID: appointment.code}}" class="btn Green">Message</router-link>
            </td>
          </tr>
        </tbody>

        <router-link to="/add-appointment" class="btn green" style="margin:20px">Add Appointment</router-link>
      </table>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "view-appointments",
  data() {
    return {
      appointments: [],
      isAdmin: null,
      code: null,
      tests: [],
      testID: null,
      staffMemberID: null
    };
  },
  created() {
    if (firebase.auth().currentUser) {
      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(user => {
            this.isAdmin = user.data().role;
          });
        });
    }
    this.getApp();
  },
  methods: {
    getApp() {
      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.staffMemberID = doc.id;
          });
          db.collection("appointments")
            .where("staffMember", "==", this.staffMemberID)
            .get()
            .then(querySnapshot => {
              querySnapshot.forEach(appointment => {
                const data = {
                  code: appointment.id,
                  datetime: appointment.data().datetime,
                  staffMember: appointment.data().staffMember,
                  location: appointment.data().location
                };
                this.testID = appointment.data().testID;
                this.appointments.push(data);
              });
              this.getDoc(this.testID);
            });
        });
    },
    getDoc() {
      db.collection("tests")
        .where("testID", "==", this.testID)
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
    }
  }
};
</script>

<style>
td,
th {
  padding: 5px !important;
}
</style>
