<template>
  <div id="view-appointment" style="width:100%;">
    <div class="container" style="width:100%;height:100%;">
      <table class="collection with-header responsive-table" style="background: white;">
        <thead class="collection-header">
          <h3>
            <b>Appointments</b>
          </h3>
          <div style="padding:20px;display:flex;" class="row">
            <div class="input-field col s12">
              <span>
                <b>Sort by:</b>
              </span>
              <select id="select" @change="sort" class="browser-default" style="color:black">
                <option value="Date" selected>Date in ascending order</option>
                <option value="Date desc">Date in descending order</option>
              </select>
            </div>
            <div class="input-field col s12" style="padding:15px;">
              <input
                id="datePicker"
                @change="sortByDate"
                value="Calendar"
                type="text"
                class="datepicker"
                style="text-align:center"
              >
              <button style="margin-left:20%" @click="resetTable" class="btn">Reset</button>
            </div>
            <div>
              <a @click="clickInput" class="blue-text tooltip" style="margin-top: 45px !important;">
                <span class="tooltiptext">Click the calendar to sort by specific date</span>
                <i class="material-icons">calendar_today</i>
              </a>
            </div>
          </div>

          <tr style="font-size:1.5em">
            <th>
              <a class="black-text tooltip" style="margin-left: 25px !important;">
                <span class="tooltiptext">Mobile Code</span>
                <i class="material-icons">phonelink_lock</i>
              </a>
            </th>
            <th>
              <a class="black-text tooltip">
                <span class="tooltiptext">Date and Time</span>
                <i class="material-icons">event</i>
              </a>
            </th>
            <th>
              <a class="black-text tooltip">
                <span class="tooltiptext">Location</span>
                <i class="material-icons">location_on</i>
              </a>
            </th>
            <th>
              <a class="black-text tooltip">
                <span class="tooltiptext">Test info</span>
                <i class="material-icons">info</i>
              </a>
            </th>
          </tr>
        </thead>

        <tbody class="collection-item">
          <tr v-for="appointment in appointments" v-bind:key="appointment.datetime">
            <td style="padding-left: 20px;">{{appointment.code}}</td>
            <td>{{appointment.datetime.toDate()}}</td>
            <td>{{appointment.location}}</td>
            <td v-for="test in tests" v-bind:key="test.title">{{test.title}}</td>

            <td>
              <router-link v-bind:to="{name: 'edit-appointment', params: {id:appointment.code}}">
                <a class="tooltip">
                  <span class="tooltiptext">Edit Appointment</span>
                  <i class="material-icons" style="position:relative;text-align:center;">edit</i>
                </a>
              </router-link>
            </td>
            <td>
              <a class="tooltip">
                <span class="tooltiptext">Edit Appointment</span>
                <i
                  @click="deleteAppointment(appointment.location)"
                  class="red-text material-icons"
                  style="position:relative;text-align:center;cursor:pointer;"
                  
                >delete</i>
              </a>
            </td>
            <td>
              <router-link v-bind:to="{name: 'message', params: {appointmentID: appointment.code}}">
                <i class="material-icons left green-text" style="margin-left:5px;font-size:30px;text-align:center">insert_comment</i>
                
                <span v-if="notifications[ids.indexOf(appointment.code)] != 0">
                  <span
                    v-if="ids.includes(appointment.code) == true"
                    class="new badge"
                  >{{notifications[ids.indexOf(appointment.code)]}}</span>
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
      ids: [],
      id: null
    };
  },
  created() {
    this.getApp(null, "asc");
  },
  methods: {
    getApp(sign, dir) {
      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.isAdmin = doc.data().role;
            this.staffMemberID = doc.id;
          });
          this.getAppointments(sign, dir);
        });
    },
    getAppointments(sign, dir) {
      if (sign != null) {
        db.collection("appointments")
          .where("datetime", ">=", dir)
          .where("datetime", "<=", sign)
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
      } else {
        db.collection("appointments")
          .orderBy("datetime", dir)
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
      }
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
        .where("isPatient", "==", true)
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            this.id = id;
            var count = snapshot.size;
            if (this.ids.indexOf(id) != -1) {
              var index = this.ids.indexOf(id);
              this.notifications[index] = count;
              this.notifications.push();
            } else {
              this.notifications.push(count);
              this.ids.push(id);
            }
          });
        });
    },
    deleteAppointment(appointmentLocation) {
      if (confirm(`Are you sure you want to delete this appointment`)) {
        db.collection("appointments")
          .where("location", "==", appointmentLocation)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
              doc.ref
                .delete()
                .then(() => {
                  console.log("Document successfully deleted!");
                  alert(`Successfully deleted Appointment`);
                  location.reload();
                })
                .catch(function(error) {
                  console.error("Error removing document: ", error);
                  alert(`There was an error: ${error}`);
                });
            });
          });
      }
    },
    sort() {
      var selectValue = document.getElementById("select").value;
      this.clearData();

      if (selectValue == "Date") {
        // Sort by date asc
        this.getApp(null, "asc");
      } else if (selectValue == "Date desc") {
        // Sort by date desc
        this.getApp(null, "desc");
      }
    },
    sortByDate() {
      var value = document.getElementById("datePicker").value;
      if (value == null) {
        this.getApp(null, "asc");
      }
      var convertDate = new Date(value);
      var newDay = new Date(value);
      convertDate.setDate(convertDate.getDate() + 1);

      var timestamp1 = firebase.firestore.Timestamp.fromDate(convertDate);
      var timestamp2 = firebase.firestore.Timestamp.fromDate(newDay);

      this.clearData();
      this.getApp(timestamp1, timestamp2);
    },
    resetTable() {
      this.clearData();
      document.getElementById("select").value = "Date";
      document.getElementById("datePicker").value = "Calendar";
      this.getApp(null, "asc");
    },
    clearData() {
      this.appointments = [];
      this.tests = [];
      this.notifications = [];
      this.ids = [];
    },
    clickInput() {
      document.getElementById("datePicker").click();
    }
  }
};
</script>

<style>
h3 {
  padding: 20px;
}

td,
th {
  padding: 10px !important;
}
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
</style>
