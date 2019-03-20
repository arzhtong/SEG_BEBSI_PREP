// This mixin will be used for any functionality that is shared between the staff components.
// To make use of the functionality in this file import { appointmentMixin } from '(this location)'
// and then add 'mixins: [appointmentMixin]' just before the data of the component.

import db from "../components/firebaseInit";
import firebase from "firebase";

export const appointmentMixin = {
  data() {
    return {
      // Part of the Appointments Component.
      appointments: [],
      allAppointments: [],
      dailyCheckups: [],
      notifications: [],
      ids: [],
      staffMemberID: "",
      today: new Date(),
      yesterday: null,
      currentDate: Date.now().toLocaleString,
      pastString: "",
      //Part of the ViewAppointment Component.
      dailyCheckupsView: [],
      appointmentsView: [],
      testName: null,
      testType: null,
      router: this.$route.params.id, // used in Edit as well
      newMap: new Map(),
      past: this.$route.params.expired,
      //Part of the EditAppointment Component
      date: "",
      time: "",
      code: null,
      location: null,
      staffMember: null,
      users: [],
      expired: this.$route.params.expired,
      //Part of the AddAppointment Component
      testID: null,
      currentUser: firebase.auth().currentUser.email,
      tests: [],
      doctor: ""
    };
  },
  methods: {
    /*
        This method sets the date for yesterday and pastString.

        Part of the Appointments Component.
      */
    setDate() {
      this.yesterday = new Date(this.today.setDate(this.today.getDate() - 1));
      if (this.past) {
        this.pastString = "Past ";
      }
    },
    /*
        This method sorts the appointments collection into two 
        collections of past and current appointments. It takes into account
        the expired boolean as well as the date.

        Part of the Appointments Component.
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
        This method sorts the appointments either in asc or
        desc order.

        Part of the Appointments Component.
    */
    sortByOrder() {
      // @ts-ignore
      var selectValue = document.getElementById("select").value;
      this.clearData(); // clears all input field values and arrays
      // @ts-ignore
      document.getElementById("searchCode").value = "";
      // @ts-ignore
      document.getElementById("datePicker").value = "";
      if (selectValue == "Date") {
        // Sort by date asc
        this.getAppointments("asc");
      } else if (selectValue == "Date desc") {
        // Sort by date desc
        this.getAppointments("desc");
      }
    },
    /*
        This method sorts the appointments by a specific
        date specified by the user.

        Part of the Appointments Component.
    */
    sortByDate() {
      // @ts-ignore
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
        this.getAppointments("asc");
        // @ts-ignore
        document.getElementById("datePicker").value = "";
      }
      // @ts-ignore
      document.getElementById("searchCode").value = "";
      // @ts-ignore
      document.getElementById("select").value = "Date";
    },
    /*
        This method sorts the appointments by a specified code.
        If there is a substring that matches the whole appointment(s)
        will be returned,

        Part of the Appointments Component.
    */
    sortByCode() {
      // @ts-ignore
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
        this.getAppointments("asc");
        // @ts-ignore
        document.getElementById("searchCode").value = "";
      }
      // @ts-ignore
      document.getElementById("select").value = "Date";
    },
    /*
        This method makes sure it will take the
        information only for the currently logged in
        user. 

        Part of the Appointments Component.
    */
    loadUser() {
      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.isAdmin = doc.data().role;
            this.staffMemberID = doc.id;
          });
        });
    },
    /*
        This method gets all the appointments for the
        logged in user and orders them either asc or decs
        datetime.

        Part of the Appointments Component.
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

        Part of the Appointments Component.
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

        Part of the Appointments Component.
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

        Part of the Appointments Component.
    */
    fetchData(id) {
      db.collection("appointments")
        .doc(id)
        .collection("messages")
        .where("seenByStaff", "==", false)
        .where("isPatient", "==", true)
        .onSnapshot(snapshot => {
          // @ts-ignore
          // @ts-ignore
          // @ts-ignore
          // @ts-ignore
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

        Part of the Appointments Component.
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

        Part of the Appointments Component.
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
        This method resets all the input field values
        as well as the arrays and runs the query again to
        get all appointments.

        Part of the Appointments Component.
    */
    resetTable() {
      this.clearData();
      // @ts-ignore
      document.getElementById("select").value = "Date";
      // @ts-ignore
      document.getElementById("datePicker").value = "";
      // @ts-ignore
      document.getElementById("searchCode").value = "";
      this.getAppointments("asc");
    },
    /*
        This method sets all arrays except, 
        dailyCheckups and tests, to empty.

        Part of the Appointments Component.
    */
    clearData() {
      this.appointments = [];
      this.notifications = [];
      this.ids = [];
    },
    /*
        This method gets the information for the specified
        appointment with doc id given by the router.

        Part of the ViewAppointment Component.
    */
    getAppointmentInfo() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .get()
        .then(doc => {
          const data = {
            testID: doc.data().testID,
            date: doc
              .data()
              .datetime.toDate()
              .toISOString()
              .split("T")[0],
            time: doc
              .data()
              .datetime.toDate()
              .toTimeString()
              .split(" ")[0],
            location: doc.data().location
          };
          this.appointmentsView.push(data);
          this.getTestInfo();
        });
    },
    /*
        This methid gets the needed information from the 
        tests collection with a doc id specified in the
        clicked appointment.

        Part of the ViewAppointment Component.
    */
    getTestInfo() {
      db.collection("tests")
        .doc(this.appointmentsView[0].testID)
        .get()
        .then(doc => {
          (this.testName = doc.data().title), (this.testType = doc.data().type);
        });
    },
    /*
        This method listens live to the dailyCheckups 
        collection in the clicked appointment in order
        to get if any changes were made.

        Part of the ViewAppointment Component.
    */
    listenDailyCheckups() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .orderBy("daysBeforeTest", "desc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            // on page load
            if (change.type == "added") {
              const data = {
                docId: change.doc.id,
                daysBeforeTest: change.doc.data().daysBeforeTest,
                description: change.doc.data().description,
                instructions: change.doc.data().instructions
              };

              this.dailyCheckupsView.push(data);
            }
            // if modified (e.g set to true)
            if (change.type == "modified") {
              for (var i = 0; i < this.dailyCheckupsView.length; i++) {
                if (
                  this.dailyCheckupsView[i].daysBeforeTest ==
                  change.doc.data().daysBeforeTest
                ) {
                  this.dailyCheckupsView[
                    i
                  ].instructions = change.doc.data().instructions;
                  this.dailyCheckupsView.push();
                }
              }
            }
          });
        });
    },
    /*
        This method enables the dailyCheckyps to be modified.
        Note: This method is left here for expandability purposes
        and it does not function in this current website version.

        Part of the ViewAppointment Component.
    */
    enableEditMode(currentCheckup) {
      var inputArray = document.getElementsByClassName("dailyInput");
      var inputList = Array.from(inputArray);
      for (var i = 0; i < inputList.length; i++) {
        // @ts-ignore
        if (inputList[i].value in currentCheckup.instructions) {
          // @ts-ignore
          if (inputList[i].readOnly == true) {
            // @ts-ignore
            inputList[i].readOnly = false;
            // @ts-ignore
            inputList[i].style.color = "#2196f3";
          } else {
            // @ts-ignore
            inputList[i].readOnly = true;
            // @ts-ignore
            inputList[i].style.color = "grey";
          }
        }
      }
    },
    /*
        This method gets the data from all users
        in the firestore.

        Part of the EditAppointment Component.
    */
    getAllUsers() {
      db.collection("users")
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
        This method gets the data and loads
        all the fields.

        Part of the EditAppointment Component.
    */
    loadFields() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .get()
        .then(doc => {
          if (doc.exists) {
            this.date = doc
              .data()
              .datetime.toDate()
              .toISOString()
              .split("T")[0];
            this.time = doc
              .data()
              .datetime.toDate()
              .toTimeString()
              .split(" ")[0];
            this.location = doc.data().location;
            this.testID = doc.data().testID;
            this.staffMember = doc.data().staffMember;
            this.code = doc.id;
          }
        });
    },
    /*
      This method updates the information
      for the specified appointment on firestore.

      Part of the EditAppointment Component.
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
    },
    /*
        This method gets all the information
        from the tests collection in firestore.

        Part of the AddAppointment Component
    */
    getTests() {
      // Get all the information from tests collection
      db.collection("tests")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(test => {
            const data = {
              testID: test.id,
              title: test.data().title,
              type: test.data().type
            };
            this.tests.push(data);
          });
        });
    },
    /*
        This method checks if the generated code
        exists in firestore. It also calls the method
        that generates the code.

        Part of the AddAppointment Component
    */
    checkIfCodeExists() {
      this.generateCode().then(foc => {
        if (foc == true) {
          // recursively generate a new code
          document.getElementById("mainScreen").style.display = "none";
          this.checkIfCodeExists();
        } else {
          // hide loader and show main screen
          document.getElementById("el").classList.remove("active");
          document.getElementById("loader").style.display = "none";
          document.getElementById("mainScreen").style.display = null;
        }
      });
    },
    /*
        This method generates a random code of length 9
        and puts it as the doc id in the appointments' collection.

        Part of the AddAppointment Component

        @return Promise
    */
    generateCode() {
      var ID = Math.random()
        .toString(36)
        .substr(2, 9);

      var docRef = db.collection("appointments").doc(ID);
      return docRef
        .get()
        .then(doc => {
          if (doc.exists) {
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
    /*
        This method creates a new appointment and
        sets each field. 

        Part of the AddAppointment Component
    */
    saveAppointment() {
      db.collection("appointments")
        .doc(this.code)
        .set({
          datetime: firebase.firestore.Timestamp.fromDate(
            new Date(Date.parse(this.date + "T" + this.time + "Z"))
          ),
          location: this.location,
          staffMember: this.staffMember,
          testID: this.testID.testID,
          expired: false,
          doctor: this.doctor,
          testName: this.testID.title
        })
        .then(docRef => {
          this.addDailyCheckups();
          alert(
            "Successfully created new appointment with code " + this.code + " !"
          );
          this.$router.push("/view-appointments");
        })
        .catch(error => console.log(error));
    },
    /*
        This method gets the dailyCheckup collection
        from tests and adds it to the newly created appointment.

        Part of the AddAppointment Component
    */
    addDailyCheckups() {
      db.collection("tests")
        .doc(this.testID.testID)
        .collection("dailyCheckups")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            db.collection("appointments")
              .doc(this.code)
              .collection("dailyCheckups")
              .add(doc.data())
              .then(docRef => {
                console.log("Added dailyCheckup");
              })
              .catch(error => console.log(error));
          });
        });
    },
    /*
        This method gets the document id of
        the currently logged in person.

        Part of the AddAppointment Component
    */
    getDocId() {
      db.collection("users")
        .where("email", "==", this.currentUser)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.staffMember = doc.id;
            this.doctor = doc.data().name;
          });
        });
    }
  }
};
