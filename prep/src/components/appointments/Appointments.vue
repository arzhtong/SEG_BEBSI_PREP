<template>
  <div id="view-appointment" style="width:100%;">
    <div class="container" style="width:100%;height:100%;">
      <table class="collection with-header responsive-table" style="background: white;">
        <thead class="collection-header">
          <h3>
            <b>{{pastString}} Appointments</b>
          </h3>
          <div style="padding:20px;display:flex;" class="row">
            <div class="input-field col s12">
              <span style="color:black !important">
                <b>Sort by:</b>
              </span>
              <select id="select" @change="sort" class="browser-default" style="color:black">
                <option value="Date" selected>Date in ascending order</option>
                <option value="Date desc">Date in descending order</option>
              </select>
              <button style="margin-top:5px;" @click="resetTable" class="btn">Reset</button>
            </div>
            <div class="input-field col s12" style="padding:15px;">
              <input
                required
                id="datePicker"
                value
                type="date"
                min="2019-01-01"
                style="text-align:center"
              >
            </div>
            <div>
              <a class="blue-text tooltip" style="margin-top: 45px !important;cursor:pointer">
                <span class="tooltiptext">Click this calendar icon to sort by specific date</span>
                <i class="material-icons" @click="sortByDate">calendar_today</i>
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
            <th></th>
            <th></th>
            <th></th>
          </tr>
        </thead>

        <tbody class="collection-item">
          <tr v-for="appointment in appointments" v-bind:key="appointment.datetime">
            <td style="padding-left: 20px;">{{appointment.code}}</td>
            <td>{{appointment.datetime.toDate()}}</td>
            <td>{{appointment.location}}</td>
            <td v-for="test in tests" v-bind:key="test.title">{{test.title}}</td>

            <td>
              <router-link
                v-bind:to="{name: 'view-appointment', params: {expired:past ,id:appointment.code}}"
              >
                <a class="tooltip">
                  <span class="tooltiptext">View Appointment</span>
                  <i
                    class="material-icons"
                    style="position:relative;text-align:center;"
                  >remove_red_eye</i>
                </a>
              </router-link>
            </td>
            <td>
              <a class="tooltip">
                <span class="tooltiptext">Delete Appointment</span>
                <i
                  @click="deleteAppointment(appointment.code)"
                  class="red-text material-icons"
                  style="position:relative;text-align:center;cursor:pointer;"
                >delete</i>
              </a>
            </td>
            <td>
              <router-link v-bind:to="{name: 'message', params: {expired: past, appointmentID: appointment.code}}">
                <i
                  class="material-icons left green-text"
                  style="margin-left:5px;font-size:30px;text-align:center"
                >insert_comment</i>
                
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
        <template v-if="past==false">
          <router-link to="/add-appointment" class="btn green" style="margin:20px">Add Appointment</router-link>
        </template>
      </table>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "view-appointments",
  props: ["past"],
  data() {
    return {
      appointments: [],
      tests: [],
      testID: null,
      staffMemberID: null,
      notifications: [],
      ids: [],
      id: null,
      today: new Date(),
      yesterday: null,
      currentDate: Date.now().toLocaleString,
      pastString: ""
    };
  },
  created() {
    this.yesterday = new Date(this.today.setDate(this.today.getDate() - 1));
    this.getApp("asc");
    if (this.past) {
      this.pastString = "Past ";
    }
  },
  methods: {
    sortByExpiration() {
      var pastAppointments = [];
      var currentAppointments = [];
      for (var i = 0; i < this.appointments.length; i++) {
        if (this.appointments[i].datetime.toDate() < this.today) {
          pastAppointments.push(this.appointments[i]);
        } else if (this.appointments[i].datetime.toDate() > this.yesterday) {
          currentAppointments.push(this.appointments[i]);
        }
      }
      if (this.past) {
        this.appointments = pastAppointments;
      } else {
        this.appointments = currentAppointments;
      }
    },
    getApp(dir) {
      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.isAdmin = doc.data().role;
            this.staffMemberID = doc.id;
          });
          this.getAppointments(dir);
        });
    },
    getAppointments(dir) {
      db.collection("appointments")
        .orderBy("datetime", dir)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(appointment => {
            const data = {
              code: appointment.id,
              datetime: appointment.data().datetime,
              staffMember: appointment.data().staffMember,
              location: appointment.data().location,
              id: appointment.id
            };
            this.testID = appointment.data().testID;
            this.appointments.push(data);
            this.fetchData(appointment.id);
          });
          this.getDoc();
          this.sortByExpiration();
        });
    },
    getDoc() {
      db.collection("tests")
        .doc(this.testID)
        .get()
        .then(doc => {
          const data = {
            title: doc.data().title,
            type: doc.data().type
          };
          this.tests.push(data);
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
    deleteAppointment(code) {
      if (confirm(`Are you sure you want to delete this appointment`)) {
        db.collection("appointments")
          .doc(code)
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
      }
    },
    sort() {
      var selectValue = document.getElementById("select").value;
      this.clearData();

      if (selectValue == "Date") {
        // Sort by date asc
        this.getApp("asc");
      } else if (selectValue == "Date desc") {
        // Sort by date desc
        this.getApp("desc");
      }
    },
    sortByDate() {
      var value = document.getElementById("datePicker").value;

      var newDay = new Date(value);
      var newAppointments = [];
      for (var i = 0; i < this.appointments.length; i++) {
        var date = this.appointments[i].datetime.toDate();
        var wholeDate =
          date.getDate().toString() +
          date.getMonth().toString() +
          date.getFullYear().toString();
        var convertWholeDate =
          newDay.getDate().toString() +
          newDay.getMonth().toString() +
          newDay.getFullYear().toString();

        if (wholeDate == convertWholeDate) {
          newAppointments.push(this.appointments[i]);
          this.fetchData(this.appointments[i].id);
        }
      }
      if (newAppointments.length != 0) {
        this.clearData();
        this.appointments = newAppointments;
        this.appointments.push();
      } else {
        if (value == "") {
          alert("Please enter a date first!");
        } else {
          alert("No appointments scheduled for " + value + "!");
        }
        this.clearData();
        this.getApp("asc");
        document.getElementById("datePicker").value = "";
      }
      document.getElementById("select").value = "Date";
    },
    resetTable() {
      this.clearData();
      document.getElementById("select").value = "Date";
      document.getElementById("datePicker").value = "";
      this.getApp("asc");
    },
    clearData() {
      this.appointments = [];
      this.tests = [];
      this.notifications = [];
      this.ids = [];
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
