<template>
  <div id="view-appointment">
    <div class="container" style="width:100%;height:100%">
      <table
        class="collection with-header responsive-table"
        style="background: white;margin-top:10%;width:100%;height:auto"
      >
        <thead class="collection-header">
          <h4 style="padding:20px;font-size:3em;">
            <b>Appointments</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Mobile Code</th>
            <th>Date</th>
            <th>Time</th>
            <th>Location</th>
            <th>Staff Member</th>
            <th>Test</th>
          </tr>
        </thead>

        <tbody
          v-for="appointment in appointments"
          v-bind:key="appointment.datetime"
          class="collection-item"
        >
          <tr>
            <td style="padding: 20px;">{{appointment.code}}</td>
            <td>{{appointment.date}}</td>
            <td>{{appointment.time}}</td>
            <td>{{appointment.location}}</td>
            <td>{{appointment.staffMember}}</td>
            <td v-for="test in tests" v-bind:key="test.title">{{test.title}}</td>
            <td>
              <button class="btn blue" style="position:relative;text-align:center;">edit</button>
            </td>
            <td>
              <button class="btn red">Delete</button>
            </td>
            <td>
              <button class="btn Green">Message</button>
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
      testID: null
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
    db.collection("appointments")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(appointment => {
          const data = {
            code: appointment.id,
            date: appointment.data().date,
            time: appointment.data().time,
            staffMember: appointment.data().staffMember,
            location: appointment.data().location
          };
          this.testID = appointment.data().testID;
          this.appointments.push(data);
        });
        this.getDoc(this.testID);
      });
      

  },
  methods: {
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
</style>
