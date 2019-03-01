<template>
  <div>
    <div class="containerChat" id="top">
      <h3>Chat with 
        {{this.$route.params.appointmentID}}</h3>
      <div>
        <ul>
          <li v-for="message in messages" v-bind:key="message.datetime">
            <div v-if="message.isPatient == false" class="containerChat" style="max-width:100%;">
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <i class="material-icons right">accessibility_new</i>
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
    this.clearNot();
  },
  methods: {
    // listenForEnterKey() {
    //   var input = document.getElementById("textArea");
    //   input.addEventListener("keydown", function(event) {
    //     if (event.keyCode === 13) {
    //       event.preventDefault()
    //         document.getElementById("sendMessage").click()
    //     }
    //   });
    // },
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
              const data = {
                content: change.doc.data().content,
                datetime: change.doc.data().datetime.toDate(),
                isPatient: change.doc.data().isPatient
              };
              this.messages.push(data);
              console.log("New message sent!");
            }
          });
        });
    },
    sendMessage() {
      var checkMessage = document.getElementById("textArea").value.trim();
      if (checkMessage.length != 0 && checkMessage != "") {
        var message = document.getElementById("textArea").value;
        db.collection("appointments")
          .doc(this.$route.params.appointmentID)
          .collection("messages")
          .add({
            content: message,
            datetime: firebase.firestore.Timestamp.fromDate(
              new Date(Date.now())
            ),
            isPatient: false
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
#top {
  padding: 20px;
  height: auto;
}
.containerChat {
  border: 2px solid #dedede;
  background-color: #f1f1f1;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
  width: 100%;
  
}

#textArea {
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
