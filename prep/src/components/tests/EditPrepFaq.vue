<template>
  <div id="edit-recipe">
    <h3>Edit FAQ</h3>
    <div class="row">
      <form @submit.prevent="updateFAQ" class="col s12">
          <!-- adds the question input field -->
        <div class="row">
          <div class="input-field col s12">
            <span>Question</span>
            <input type="text" v-model="question" required>
          </div>
        </div>
        <!-- adds the answer input field -->
        <div class="row">
          <div class="input-field col s12">
            <span>Answer</span>
            <input type="text" v-model="answer">
          </div>
        </div>
        <!-- adds 2 checkboxes representing shortcuts on the app -->
        <div class="row">
        <div class="input-field col s12">
          <p style="margin-right: 100%">
            <label>
              <input id="chatCheck" type="checkbox" v-model="chatShortcut" class="filled-in" style="margin-top:10px">
              <span class="blue-text" style="margin-top:10px">Has chat shortcut?</span>
            </label>
          </p>
        </div>
        </div>
        <div class="row">
        <div class="input-field col s12">
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
        </div>
        <button type="submit" class="btn">Submit</button>
        <!-- cancel button -->
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
  // sets values of fields before entering the page
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
        // gets the value of the checkbox
        if (document.getElementById("chatCheck").checked) {
        this.chatShortcut = true;
      }
      if (document.getElementById("informationCheck").checked) {
        this.informationShortcut = true;
      }
      // updates the fields in the database 
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
              .then(() => { // route back to faq viewing page
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