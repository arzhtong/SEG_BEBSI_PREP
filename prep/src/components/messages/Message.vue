<template>
  <div>
    <div>
      <h2>Chat Messages</h2>
      <div>
        <ul>
          <li v-for="message in messages" v-bind:key="message.datetime">
            <div v-if="message.isPatient == false" class="container" style="max-width:100%;">
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <i class="material-icons right">accessibility_new</i>
            </div>
            <div v-if="message.isPatient == true" class="container darker" style="max-width:100%">
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <label class="right">Patient</label>
            </div>
          </li>
        </ul>
      </div>

      <div class="row">
        <div class="input-field col s12">
          <textarea style="width:30%;height:80px;resize: none;" data-length="120" id="textArea" @click="listenForEnterKey"></textarea>
          <button
            id="sendMessage"
            @click="sendMessage"
            class="btn btn-large"
            style="margin: 0 0 5% 10px"
          >
            <i class="material-icons left">send</i>
          </button>
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
      messages: [],
      messagesPatient: [],
      currentUser: null,
      isStaff: null
    };
  },
  created() {
    this.currentUser = firebase.auth().currentUser.email;
    this.fetchData();
  },
  methods: {
    listenForEnterKey() {
      var input = document.getElementById("textArea");
      input.addEventListener("keyup", function(event) {
        if (event.keyCode === 13) {
          event.preventDefault();
          document.getElementById("sendMessage").click();
        }
      });
    },
    fetchData() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            const data = {
              content: change.doc.data().content,
              datetime: change.doc.data().datetime.toDate(),
              isPatient: change.doc.data().isPatient
            };
            this.messages.push(data);
          });
        });
    },
    sendMessage() {
      var message = document.getElementById("textArea").value;
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .add({
          content: message,
          datetime: firebase.firestore.Timestamp.fromDate(new Date(Date.now())),
          isPatient: false
        })
        .then(function() {
          document.getElementById("textArea").value = "";
          console.log("Document successfully written!");
        })
        .catch(function(error) {
          console.error("Error writing document: ", error);
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
