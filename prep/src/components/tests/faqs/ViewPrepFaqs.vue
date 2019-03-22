<template>
  <div id="view-prep-faqs">
    <ul class="collection with-header">
      <li class="collection-header">
        <div class="container" style="width:100%;height:100%">
          <router-link
            v-bind:to="{name: 'new-prep-faq', params: {test_id: testID}}"
            class="btn green"
            style="margin:20px"
          >Add FAQ</router-link>
          <router-link
            to="/view-tests"
            class="btn grey"
          >Back</router-link>
        </div>

        <!-- adds a dropdown -->
        <ul class="collapsible">
          <li v-for="faq in faqs" v-bind:key="faq.id">
            <div class="collapsible-header">
              <b>Question:</b>
              &nbsp; {{faq.question}}
            </div>
            <div class="collapsible-body">
              <span>
                <ul>
                  <li>
                    <b>Answer:</b>
                    &nbsp; {{faq.answer}}
                  </li>
                  <li v-if="faq.chatShortcut">
                    <b>Has a chat shortcut:</b>&nbsp;Yes
                  </li>
                  <li v-else>
                    <b>Has a chat shortcut:</b>&nbsp;No
                  </li>
                  <li v-if="faq.informationShortcut">
                    <b>Has an information shortcut:</b>&nbsp;Yes
                  </li>
                  <li v-else>
                    <b>Has an information shortcut:</b>&nbsp;No
                  </li>
                  <li>
                      <!-- delete faq -->
                    <button
                      @click="deleteFAQ(faq.id)"
                      class="waves-effect waves-light btn-small red"
                    >delete</button>
                    <!-- edit faq -->
                    <router-link
                      v-bind:to="{name: 'edit-prep-faq', params: {test_id: testID, faq_id: faq.id}}"
                      class="waves-effect waves-light btn-small green"
                    >Edit</router-link>
                  </li>
                </ul>
              </span>
            </div>
          </li>
        </ul>
      </li>
    </ul>
  </div>
</template>

<script>
import { faqsMixin } from "../../../mixins/faqsMixin/faqsMixin.js";
export default {
  name: "view-prep-faqs",
  mixins: [faqsMixin],
  created (){
    this.createFaqs();
  },
   mounted() {
    M.AutoInit(); // initializes materialize components for the dropdowns
  },
};

</script>




