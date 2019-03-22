<template>
  <div id="new-prep-faq">
    <h3>New FAQ</h3>
    <div class="row">
      <form @submit.prevent="saveFAQ" class="col s12">
        <!-- adds a question input field -->
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="question" required>
            <label>Question</label>
          </div>
        </div>
        <!-- adds an answer input field -->
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="answer" required>
            <label>Answer</label>
          </div>
        </div>
        <!-- adds 2 checkboxes representing shortcuts in the app -->
        <div class="row">
          <div class="input-field col s12">
            <p style="margin-right: 100%">
              <label>
                <input id="chatCheck" type="checkbox" class="filled-in">
                <span class="blue-text">Has chat shortcut?</span>
              </label>
            </p>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <p style="margin-right: 100%">
              <label>
                <input id="informationCheck" type="checkbox" class="filled-in">
                <span class="blue-text">Has information shortcut?</span>
              </label>
            </p>
          </div>
        </div>
        <div>
          <button type="submit" class="btn">Submit</button>
          <!-- cancel button -->
          <router-link
            v-bind:to="{name: 'view-prep-faqs', params: {test_id: this.$route.params.test_id}}"
            class="btn grey"
          >Cancel</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { faqsMixin } from "../../../mixins/faqsMixin/faqsMixin.js";
export default {
  name: "new-prep-faqs",
  mixins: [faqsMixin],
};

</script>
