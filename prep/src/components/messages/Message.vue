<template>
  <div>
    <div>
      <h2>Chat Messages</h2>

      <ul>
        <li v-for="message in messages" v-bind:key="message.datetime">
          <div class="container" style="max-width:100%;">
            <p>{{message.content}}</p>
            <span class="time-right">{{message.datetime}}</span>
          </div>
        </li>
      </ul>
      <ul>
        <li v-for="message in messagesPatient" v-bind:key="message.datetime">
          <div class="container darker" style="max-width:100%">
            <p>{{message.content}}</p>
            <span class="time-left">{{message.datetime}}</span>
          </div>
        </li>
      </ul>

      <div class="row">
        <div>
          <button class="btn" type="submit">Submit</button>
        </div>
        <div class="input-field col s12">
          <input type="text" required>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "message",
  data() {
    return {
      email: null,
      name: null,
      dept: null,
      role: null,
      messages: [],
      messagesPatient: [],
      currentUser: null
    };
  },
  created() {
    this.currentUser = firebase.auth().currentUser.email;
    // db.collection("users")
    //   .where("email", "<", "\uf8ff")
    //   .get()
    //   .then(querySnapshot => {
    //     querySnapshot.forEach(user => {
    //       const data = {
    //         email: user.data().email,
    //         name: user.data().name,
    //         dept: user.data().dept,
    //         role: user.data().role
    //       };
    //       this.users.push(data);
    //     });
    //   });
    this.fetchDataStaff();
    this.fetchDataPatient();
  },
  methods: {
    fetchDataStaff() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .where("isPatient", "==", false)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            const data = {
              content: doc.data().content,
              datetime: doc.data().datetime.toDate()
            };
            this.messages.push(data);
          });
        });
    },
    fetchDataPatient() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .where("isPatient", "==", true)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            const data = {
              content: doc.data().content,
              datetime: doc.data().datetime.toDate()
            };
            this.messagesPatient.push(data);
          });
        });
    }
  }
};
</script>
<style>
.container {
  border: 2px solid #dedede;
  background-color: #f1f1f1;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
  width: 100%;
}

.darker {
  border-color: #ccc;
  background-color: #ddd;
}

.container::after {
  content: "";
  clear: both;
  display: table;
}

.container img {
  float: left;
  max-width: 60px;
  width: 100%;
  margin-right: 20px;
  border-radius: 50%;
}

.container img.right {
  float: right;
  margin-left: 20px;
  margin-right: 0;
}

.time-right {
  float: right;
  color: #aaa;
}

.time-left {
  float: left;
  color: #999;
}
</style>
