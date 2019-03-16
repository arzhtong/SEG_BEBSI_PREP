<template>
  <div id="edit-recipe">
    <h3>Edit FAQ</h3>
    <div class="row">
      <form @submit.prevent="updateFAQ" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>Question</span>
            <input type="text" v-model="question" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Answer</span>
            <input type="text" v-model="answer">
          </div>
        </div>
        <div class="input-field">
          <p style="margin-right: 100%">
            <label>
              <input id="chatCheck" type="checkbox" v-model="chatShortcut" class="filled-in" style="margin-top:10px">
              <span class="blue-text" style="margin-top:10px">Has chat shortcut?</span>
            </label>
          </p>
        </div>
        <div class="input-field">
          <p style="margin-right: 100%">
            <label>
              <input
                id="informationCheck"
                type="checkbox"
                class="filled-in"
                v-model="informationShortcut"
                style="margin-top:10px"
              >
              <span class="blue-text" style="margin-top:10px">Has information shortcut?</span>
            </label>
          </p>
        </div>
        <button type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-prep-faqs', params: {test_id: test_id}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "edit-prep-faq",
  data() {
    return {
      answer: null,
      question: [],
      chatShortcut: null,
      informationShortcut: null,
      test_id: this.$route.params.test_id
    };
  },
  beforeRouteEnter(to, from, next) {
    db.collection("tests")
      .doc(to.params.test_id)
      .collection("faqs")
      .doc(to.params.faq_id)
      .get()
      .then(doc => {
          next(vm => {
            vm.question = doc.data().question;
            vm.answer = doc.data().answer;
            vm.chatShortcut = doc.data().chatShortcut
            vm.informationShortcut = doc.data().informationShortcut
        });
      });
  },
  methods: {
    updateFAQ() {
        if (document.getElementById("chatCheck").checked) {
        this.chatShortcut = true;
      }
      if (document.getElementById("informationCheck").checked) {
        this.informationShortcut = true;
      }
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("faqs")
        .doc(this.$route.params.faq_id)
        .get()
        .then(doc => {
            doc.ref
              .update({
                question: this.question,
                answer: this.answer,
                chatShortcut: this.chatShortcut,
                informationShortcut: this.informationShortcut
              })
              .then(() => {
                this.$router.push({
                  name: "view-prep-faqs",
                  params: { test_id: this.$route.params.test_id }
                });
              });
          });
    }
  }
};
</script>