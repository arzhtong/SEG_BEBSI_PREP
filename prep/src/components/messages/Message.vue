<template>
  <div>
    <div class="containerChat" id="top">
      <div id="messages">
        <ul>
          <li v-for="message in messages" v-bind:key="message.datetime">
            <div v-if="message.isPatient == false" class="containerChat" style="max-width:100%;">
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <div>
                <i class="material-icons right">accessibility_new</i>
                <i v-if="message.seenByPatient == false" class="material-icons time-right">done</i>
                <i v-else class="material-icons blue-text right">done_all</i>
              </div>
            </div>
            <div
              v-if="message.isPatient == true"
              class="containerChat darker"
              style="max-width:100%"
            >
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <label class="right">Patient</label>
            </div>
          </li>
          <li v-if="messages.length == 0">
            <div class="containerChat" style="max-width:100%;">
              <p>Say hello to the patient 👋</p>
            </div>
          </li>
        </ul>
      </div>
      <form @submit.prevent="sendMessage">
        <div class="row">
          <div class="input-field col s12">
            <div id="foot">
              <textarea style="width:30%;height:80px;resize: none;" id="textArea" required></textarea>
              <button
                id="sendMessage"
                type="submit"
                class="btn btn-large"
                style="margin: 0 0 8% 10px"
              >
                <i class="material-icons left">send</i>
              </button>
            </div>
          </div>
        </div>
      </form>
      <router-link to="/view-appointments" class="btn" style="margin-bottom:10px;">Go Back</router-link>
    </div>
  </div>
</template>
<script>
import db from "../firebaseInit";
import firebase from "firebase";
import { encryptMessage, decryptMessage, generateKey } from "./AES.js";
export default {
  name: "message",
  data() {
    return {
      messages: [],
      messagesPatient: [],
      currentUser: null,
      isStaff: null
    };
  },
  created() {
    this.fetchData();
    this.clearNot();
  },
  methods: {
    clearNot() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .where("seenByStaff", "==", false)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                seenByStaff: true
              })
              .then(() => {
                console.log("Updated notification count");
              });
          });
        });
    },
    fetchData() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if (change.type === "added") {
              var msgDate = change.doc.data().datetime.toDate()
              var millisStr = msgDate.getTime().toString()
              var msg = decryptMessage(change.doc.data().content,
                this.$route.params.appointmentID,
                millisStr.substring(millisStr.length - 7)
              );
              const data = {
                content: msg,
                datetime: msgDate,
                isPatient: change.doc.data().isPatient,
                seenByPatient: change.doc.data().seenByPatient,
                timestamp: change.doc.data().datetime
              };
              this.messages.push(data);
              this.clearNot();
              console.log("New message sent!");
            }
            if (change.type === "modified") {
              for (var i = 0; i < this.messages.length; i++) {
                if (
                  this.messages[i].timestamp.toString() ==
                  change.doc.data().datetime.toString()
                ) {
                  if (
                    this.messages[i].seenByPatient !=
                    change.doc.data().seenByPatient
                  ) {
                    this.messages[
                      i
                    ].seenByPatient = change.doc.data().seenByPatient;
                    this.messages.push();
                  }
                }
              }
              console.log("Message modified!");
            }
          });
        });
    },
    sendMessage() {
      var checkMessage = document.getElementById("textArea").value.trim();
      if (checkMessage.length != 0 && checkMessage != "") {
        var message = document.getElementById("textArea").value;
        var currentDate = new Date(Date.now());
        var currentDatetime = firebase.firestore.Timestamp.fromDate(
          currentDate
        );
        var millisStr = currentDate.getTime().toString()
        var millisSubstring = millisStr.substring(millisStr.length - 7)
        var encryptedMessage = encryptMessage(message, this.$route.params.appointmentID, millisSubstring);
        db.collection("appointments")
          .doc(this.$route.params.appointmentID)
          .collection("messages")
          .add({
            content: encryptedMessage,
            datetime: currentDatetime,
            isPatient: false,
            seenByStaff: true,
            seenByPatient: false
          })
          .then(function() {
            document.getElementById("textArea").value = "";
            
            message = null;
            console.log("Document successfully written!");
          })
          .catch(function(error) {
            console.error("Error writing document: ", error);
          });
          
      }
    }
  }
};
</script>

<style>
#messages{
  max-height: 60vh;
  overflow-y: scroll;
}

#top {
  padding: 20px;
  height: auto;
}
.containerChat {
  word-wrap: break-word;
  border: 2px solid #dedede;
  background-color: #f1f1f1;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
  width: 100%;
}

#textArea {
  word-wrap: break-word;
  overflow: hidden;
  background-color: #f1f1f1;
  clear: both;
}

.darker {
  border-color: #ccc;
  background-color: #ddd;
}

.containerChat::after {
  content: "";
  clear: both;
  display: table;
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
