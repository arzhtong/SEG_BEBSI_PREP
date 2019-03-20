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
import { messageMixin } from "../../mixins/messageMixin";
export default {
  name: "message",
  mixins: [messageMixin],
  created() {
    this.clearNot();
    this.fetchData();
    this.getAllMessages();
  }
};
</script>

<style>
#messages {
  max-height: 50vh;
  overflow-y: auto;
}

p {
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
