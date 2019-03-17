<template>
  <div>
    <div class="containerChat" id="top">
      <div id="messages">
        <ul>
          <li v-for="message in messages" v-bind:key="message.msgKey">
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
              <textarea
                @focus="scroll"
                style="width:30%;height:80px;resize: none;"
                id="textArea"
                required
              ></textarea>
              <button
                id="sendMessage"
                type="submit"
                class="btn btn-large"
                style="margin: 0 0 5% 10px"
              >
                <i class="material-icons left">send</i>
              </button>
            </div>
          </div>
        </div>
      </form>
      <template v-if="this.$route.params.expired == false">
        <router-link to="/view-appointments" class="btn" style="margin-bottom:10px;">Go Back</router-link>
      </template>
      <template v-else>
        <router-link to="/past-appointments" class="btn" style="margin-bottom:10px;">Go Back</router-link>
      </template>
    </div>
  </div>
</template>
<script>
import db from "../firebaseInit";
import firebase, { firestore } from "firebase";
import { encryptMessage, decryptMessage, generateKey } from "./AES.js";
export default {
  name: "message",
  data() {
    return {
      messages: [],
      messagesPatient: [],
      allMessages: [],
      currentUser: null,
      isStaff: null
    };
  },
  created() {
    this.clearNot();
    this.fetchData();
    this.getAllMessages();
  },
  methods: {
    /*
      This method gets all the messages on page load (after decrypting them).
    */
    getAllMessages() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            var msgDate = doc.data().datetime.toDate();
            var millisStr = msgDate.getTime().toString();
            var msg = decryptMessage(
              doc.data().content,
              this.$route.params.appointmentID
            );
            const data = {
              msgKey: doc.data().content,
              content: msg,
              datetime: msgDate,
              isPatient: doc.data().isPatient,
              seenByPatient: doc.data().seenByPatient,
              timestamp: doc.data().datetime
            };

            this.allMessages.push(data);
            this.messages = this.allMessages;
          });
        });
    },
    /*
      This method set all messages sent by the user(Patient)
      to seen by the Staff Member.
    */
    clearNot() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            if (doc.data().seenByStaff == false) {
              doc.ref
                .update({
                  seenByStaff: true
                })
                .then(() => {
                  console.log("Updated notification count");
                });
            }
          });
        });
    },
    /*
      This method listens for any changes in the messages collection
      and gets if any new messages have been sent (after decrypting them)
    */
    fetchData() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            // get the newest message
            if (change.type === "added") {
              var msg = decryptMessage(
                change.doc.data().content,
                this.$route.params.appointmentID
              );
              const data = {
                content: msg,
                datetime: change.doc.data().datetime.toDate(),
                isPatient: change.doc.data().isPatient,
                seenByPatient: change.doc.data().seenByPatient,
                timestamp: change.doc.data().datetime
              };
              this.messages.push(data);
              this.clearNot();
            }
            // if the collection has been changed mark as seen
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
          this.scroll();
        });
    },
    /*
      This method sends(adds) the specified message to the firestore,
      after encrypting it.
    */
    sendMessage() {
      var checkMessage = document.getElementById("textArea").value.trim();
      if (checkMessage.length != 0 && checkMessage != "") {
        var message = ""
        message = document.getElementById("textArea").value;
        var encryptedMessage = encryptMessage(
          message,
          this.$route.params.appointmentID
        );
        db.collection("appointments")
          .doc(this.$route.params.appointmentID)
          .collection("messages")
          .add({
            content: encryptedMessage,
            datetime: firebase.firestore.Timestamp.fromDate(
              new Date(Date.now())
            ),
            isPatient: false,
            seenByStaff: true,
            seenByPatient: false
          })
          .then(function() {
            document.getElementById("textArea").value = "";
            message = null;
            var elem = document.getElementById("messages");
            elem.scrollTop = elem.scrollHeight;
            console.log("Document successfully written!");
          })
          .catch(function(error) {
            console.error("Error writing document: ", error);
          });
      }
    },
    /*
      This method automatically scrolls the message component to
      the bottom or newest message so it is visible to the user.
    */
    scroll() {
      var elmnt = document.getElementById("messages");
      elmnt.scrollTop = elmnt.scrollHeight;
    }
  }
};
</script>

<style>
#messages {
  max-height: 50vh;
  overflow-y: auto;
}

p{
  white-space: pre;
}

.containerChat {
  word-wrap: break-word;
  border: 2px solid #dedede;
  background-color: #f1f1f1;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
  width: 100%;
  overflow-x: hidden;
  max-height: 100vh;
}

#textArea {
  word-wrap: break-word;
  white-space: normal;
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
