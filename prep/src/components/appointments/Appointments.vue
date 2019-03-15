<template>
  <div id="view-appointment" style="width:100%;">
    <div class="container" style="width:100%;height:100%;">
      <table class="collection with-header responsive-table" style="background: white;">
        <thead class="collection-header">
          <h3>
            <b>{{pastString}} Appointments</b>
          </h3>
          <div>
            <div style="padding:20px;display:flex;" class="row">
              <div class="input-field col s12">
                <span style="color:black !important">
                  <b>Sort by:</b>
                </span>
                <select id="select" @change="sort" class="browser-default" style="color:black">
                  <option value="Date" selected>Date in ascending order</option>
                  <option value="Date desc">Date in descending order</option>
                </select>
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
            <div style="position:relative; bottom:50px;">
              <div class="input-field col s12" style="width:70%;">
                <span class="blue-text" for>Search By Code</span>
                <input
                  id="searchCode"
                  required
                  @keydown.enter.prevent
                  @keydown.enter="sortByCode"
                  class="file-path validate"
                  type="text"
                >
                <div>
                  <button style="margin:5px" @click="sortByCode" class="btn">Search</button>
                  <button style="margin:5px" @click="resetTable" class="btn">Reset</button>
                </div>
              </div>
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
                <span class="tooltiptext">Completed Daily Checkups</span>
                <i class="material-icons">done_outline</i>
              </a>
            </th>
            <th></th>
            <th></th>
            <th></th>
            <th></th>
          </tr>
        </thead>

        <tbody class="collection-item">
          <tr v-for="appointment in appointments" v-bind:key="appointment.code">
            <td style="padding-left: 20px;">{{appointment.code}}</td>
            <td>{{appointment.datetime.toDate()}}</td>
            <td>{{appointment.location}}</td>
            <template v-for="checkup in dailyCheckups">
              <td
                v-bind:key="checkup.id"
                v-if="checkup.id == appointment.code"
              >{{checkup.count}}/{{checkup.length}}</td>
            </template>
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
            <td v-if="past==false">
              <a class="tooltip">
                <span class="tooltiptext">Make Appointment Expired</span>
                <i
                  @click="expireAppointment(appointment.code, false)"
                  class="orange-text material-icons"
                  style="position:relative;text-align:center;cursor:pointer;"
                >timer_off</i>
              </a>
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
              <router-link
                v-bind:to="{name: 'message', params: {expired: past, appointmentID: appointment.code}}"
              >
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
        <template v-else>
          <router-link
            to="/add-appointment"
            class="btn green"
            style="margin:20px"
            disabled
          >Add Appointment</router-link>
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
      allAppointments: [],
      staffMemberID: null,
      notifications: [],
      ids: [],
      today: new Date(),
      yesterday: null,
      currentDate: Date.now().toLocaleString,
      pastString: "",
      dailyCheckups: []
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
    /*
      This method sorts the appointments collection into two 
      collections of past and current appointments. It takes into account
      the expired boolean as well as the date.
    */
    sortByExpiration() {
      var pastAppointments = [];
      var currentAppointments = [];
      for (var i = 0; i < this.appointments.length; i++) {
        if (
          this.appointments[i].datetime.toDate() < this.today ||
          this.appointments[i].expired == true
        ) {
          if (this.appointments[i].expired == false) {
            this.expireAppointment(this.appointments[i].code, true);
          }
          pastAppointments.push(this.appointments[i]);
        } else if (
          this.appointments[i].datetime.toDate() > this.yesterday &&
          this.appointments[i].expired == false
        ) {
          currentAppointments.push(this.appointments[i]);
        }
      }
      // Assign the appropriate array to the appointments array
      if (this.past) {
        this.appointments = pastAppointments;
      } else {
        this.appointments = currentAppointments;
      }
      this.allAppointments = this.appointments;
    },
    /*
      This method makes sure it will take the
      information only for the currently logged in
      user. 
    */
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
    /*
      This method gets all the appointments for the
      logged in user and orders them either asc or decs
      datetime.
    */
    getAppointments(dir) {
      db.collection("appointments")
        .orderBy("datetime", dir)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(appointment => {
            if (appointment.data().staffMember == this.staffMemberID) {
              const data = {
                code: appointment.id,
                datetime: appointment.data().datetime,
                staffMember: appointment.data().staffMember,
                location: appointment.data().location,
                id: appointment.id,
                testID: appointment.data().testID,
                expired: appointment.data().expired
              };
              this.appointments.push(data);
              this.listenForDailyCheckups(appointment.id);
              this.fetchData(appointment.id);
            }
          });
          this.sortByExpiration(); // sorts the array by date
        });
    },
    /*
      This method gets the number of dailyCheckups marked
      as true as well as the length of the instructions array.
    */
    getDailyCheckups(id, bool) {
      var count = 0;
      var length = 0;
      db.collection("appointments")
        .doc(id)
        .collection("dailyCheckups")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            // Get only the number of completed dailyCheckups
            Object.values(doc.data().instructions).forEach(map => {
              if (map.answer) {
                count++;
              }
              length++;
            });
          });
          const data = {
            id: id,
            count: count,
            length: length
          };
          // if true it means sth. needs to be pushed to the array
          if (bool) {
            this.dailyCheckups.push(data);
          }
          for (var i = 0; i < this.dailyCheckups.length; i++) {
            if (this.dailyCheckups[i].id == id) {
              this.dailyCheckups[i] = data;
              this.dailyCheckups.push();
            }
          }
        });
    },
    /*
      This method listen live to the changes on the firestore
      and gets any changes made to the dailyCheckups collection.
    */
    listenForDailyCheckups(id) {
      this.dailyCheckups = [];
      this.getDailyCheckups(id, true);
      db.collection("appointments")
        .doc(id)
        .collection("dailyCheckups")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if (change.type == "modified") {
              // just edit the dailyCheckups
              this.getDailyCheckups(id, false);
            }
          });
        });
    },
    /*
      This method listens live to the firestore in order
      to get if any unseen messages have been received from
      a user(patient).
    */
    fetchData(id) {
      db.collection("appointments")
        .doc(id)
        .collection("messages")
        .where("seenByStaff", "==", false)
        .where("isPatient", "==", true)
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
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
    /*
      This method deletes an appointment with a specified
      code (doc id).
    */
    deleteAppointment(code) {
      if (confirm(`Are you sure you want to delete this appointment`)) {
        db.collection("appointments")
          .doc(code)
          .delete()
          .then(() => {
            console.log("Document successfully deleted!");
            alert(`Successfully deleted appointment ` + code);
            location.reload();
          })
          .catch(function(error) {
            console.error("Error removing document: ", error);
            alert(`There was an error: ${error}`);
          });
      }
    },
    /*
      This method marks an appointment as expired,
      meaning it will be sent to the past appointments
      collection.
    */
    expireAppointment(id, bool) {
      // Make a specific appointment expired
      if (bool == false) {
        if (
          confirm(
            "Are you sure you want to mark appointment " + id + " as expired?"
          )
        ) {
          db.collection("appointments")
            .doc(id)
            .update({
              expired: true
            })
            .then(function() {
              location.reload();
              console.log("Document successfully over-written!");
            })
            .catch(function(error) {
              console.error("Error writing document: ", error);
            });
        }
      } else {
        db.collection("appointments")
          .doc(id)
          .update({
            expired: true
          })
          .then(function() {
            console.log("Document successfully over-written!");
          })
          .catch(function(error) {
            console.error("Error writing document: ", error);
          });
      }
    },
    /*
      This method sorts the appointments either in asc or
      desc order.
    */
    sort() {
      var selectValue = document.getElementById("select").value;
      this.clearData(); // clears all input field values and arrays
      document.getElementById("searchCode").value = "";
      document.getElementById("datePicker").value = "";
      if (selectValue == "Date") {
        // Sort by date asc
        this.getApp("asc");
      } else if (selectValue == "Date desc") {
        // Sort by date desc
        this.getApp("desc");
      }
    },
    /*
      This method sorts the appointments by a specific
      date specified by the user.
    */
    sortByDate() {
      var value = document.getElementById("datePicker").value;
      var newDay = new Date(value);
      var newAppointments = [];
      for (var i = 0; i < this.allAppointments.length; i++) {
        var date = this.allAppointments[i].datetime.toDate();
        var wholeDate =
          date.getDate().toString() +
          date.getMonth().toString() +
          date.getFullYear().toString();
        var convertWholeDate =
          newDay.getDate().toString() +
          newDay.getMonth().toString() +
          newDay.getFullYear().toString();

        if (wholeDate == convertWholeDate) {
          newAppointments.push(this.allAppointments[i]);
          // Get the notifications
          this.fetchData(this.allAppointments[i].id);
        }
      }
      // if a match has been found
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
      document.getElementById("searchCode").value = "";
      document.getElementById("select").value = "Date";
    },
    /*
      This method resets all the input field values
      as well as the arrays and runs the query again to
      get all appointments.
    */
    resetTable() {
      this.clearData();
      document.getElementById("select").value = "Date";
      document.getElementById("datePicker").value = "";
      document.getElementById("searchCode").value = "";
      this.getApp("asc");
    },
    /*
      This method sets all arrays except, 
      dailyCheckups and tests, to empty.
    */
    clearData() {
      this.appointments = [];
      this.notifications = [];
      this.ids = [];
    },
    /*
      This method sorts the appointments by a specified code.
      If there is a substring that matches the whole appointment(s)
      will be returned,
    */
    sortByCode() {
      var inputValue = document.getElementById("searchCode").value;
      var codeArray = [];
      for (var i = 0; i < this.allAppointments.length; i++) {
        if (
          this.allAppointments[i].code.includes(inputValue) &&
          inputValue != ""
        ) {
          codeArray.push(this.allAppointments[i]);
        }
      }
      // if there is a match
      if (codeArray.length != 0) {
        this.clearData();
        this.appointments = codeArray;
        this.appointments.push();
      } else {
        if (inputValue != "") {
          alert("No code found for " + inputValue + " !");
        }
        this.clearData();
        this.getApp("asc");
        document.getElementById("searchCode").value = "";
      }
      document.getElementById("select").value = "Date";
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

</style>
