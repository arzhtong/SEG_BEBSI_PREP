<template>
  <div id="view-appointment" style="width:100%;">
    <div class="container" style="width:100%;height:100%;">
      <table class="collection with-header responsive-table" style="background: white;">
        <thead class="collection-header">
          <h4 style="padding:30px;font-size:3em;">
            <b>Appointments</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Mobile Code</th>
            <th>Datetime</th>
            <th>Location</th>
            <th>Test</th>
          </tr>
        </thead>

        <tbody class="collection-item">
          <tr v-for="appointment in appointments" v-bind:key="appointment.datetime">
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
              <router-link v-bind:to="{name: 'message', params: {appointmentID: appointment.code}}">
                <i class="material-icons left green-text" style="font-size:40px">insert_comment</i>
                <span>
                  <span v-if="notifications[ids.indexOf(appointment.code)] != 0">
                    <span
                      v-if="ids.includes(appointment.code) == true"
                      class="new badge"
                    >{{notifications[ids.indexOf(appointment.code)]}}</span>
                  </span>
                </span>
              </router-link>
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
      tests: [],
      testID: null,
      staffMemberID: null,
      notifications: [],
      ids: []
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
                this.fetchData(appointment.id);
              });
              this.getDoc();
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
    },
    fetchData(id) {
      db.collection("appointments")
        .doc(id)
        .collection("messages")
        .where("seenByStaff", "==", false)
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if (change.doc.data().isPatient == true) {
              var count = snapshot.size;
              if (this.ids.indexOf(id) != -1) {
                var index = this.ids.indexOf(id);
                this.notifications[index] = count;
                this.notifications.push();
              } else {
                this.notifications.push(count);
                this.ids.push(id);
              }
            }
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
