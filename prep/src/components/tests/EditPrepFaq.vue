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
                <input
                  id="chatCheck"
                  type="checkbox"
                  v-model="chatShortcut"
                  class="filled-in"
                  style="margin-top:10px"
                >
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
import { faqsMixin } from "../../mixins/faqsMixin.js";
export default {
  name: "edit-prep-faq",
  mixins: [faqsMixin],
  created(){
    this.createEditPrepFaq()
  }
};
</script>