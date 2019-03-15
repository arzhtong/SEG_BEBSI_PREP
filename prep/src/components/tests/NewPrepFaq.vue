<template>
  <div id="new-prep-faq">
    <h3>New FAQ</h3>
    <div class="row">
      <form @submit.prevent="saveFAQ" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="question" required>
            <label>Question</label>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="answer" required>
            <label>Answer</label>
          </div>
        </div>
        <div class="input-field">
          <p style="margin-right: 100%">
            <label>
              <input id="chatCheck" type="checkbox" class="filled-in" style="margin-top:10px">
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
                style="margin-top:10px"
              >
              <span class="blue-text" style="margin-top:10px">Has information shortcut?</span>
            </label>
          </p>
        </div>
        <button type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-prep-faqs', params: {test_id: this.$route.params.test_id, contents: this.$route.params.contents}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
export default {
  name: "new-recipe",
  data() {
    return {
      question: null,
      answer: null,
      chatShortcut: null,
      informationShortcut: null
    };
  },
  methods: {
    saveFAQ() {
      if (document.getElementById("chatCheck").checked) {
        this.chatShortcut = true;
      }
      if (document.getElementById("informationCheck").checked) {
        this.informationShortcut = true;
      }
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("faqs")
        .add({
          question: this.question,
          answer: this.answer,
          chatShortcut: this.chatShortcut,
          informationShortcut: this.informationShortcut
        })
        .then(docRef => {
          this.$router.push({
            name: "view-prep-faqs",
            params: {
              test_id: this.$route.params.test_id,
              contents: this.$route.params.contents
            }
          });
        })
        .catch(error => console.log(err));
    }
  }
};
</script>