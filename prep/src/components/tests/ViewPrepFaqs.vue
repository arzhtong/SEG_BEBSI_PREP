<template>
  <div id="view-prep-faqs">
    <ul class="collection with-header">
      <li class="collection-header">
        <div class="container" style="width:100%;height:100%">
          <router-link
            v-bind:to="{name: 'new-recipe', params: {test_id: testID}}"
            class="btn green"
            style="margin:20px"
          >Add FAQ</router-link>
        </div>

        <ul class="collapsible"> 
            <li v-for="faq in faqs" v-bind:key="faq.id">
              <div class="collapsible-header"><b>Question: </b> &nbsp; {{faq.question}}</div>
              <div class="collapsible-body">
                <span><ul>
                    <li><b>Answer: </b>&nbsp; {{faq.answer}}</li>
                    <li v-if="faq.chatShortcut"> <b>Has a chat shortcut: </b>&nbsp;Yes</li>
                    <li v-else><b>Has a chat shortcut: </b>&nbsp;No</li>
                    <li v-if="faq.informationShortcut"> <b>Has an information shortcut: </b>&nbsp;Yes</li>
                    <li v-else><b>Has an information shortcut: </b>&nbsp;No</li>
                    </ul></span>
              </div>
            </li>
        </ul>
      </li>
    </ul>
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "view-prep-faqs",
  data() {
    return {
      faqs: [],
      testID: this.$route.params.test_id
    };
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("faqs")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          const data = {
            id: doc.id,
            answer: doc.data().answer,
            chatShortcut: doc.data().chatShortcut,
            informationShortcut: doc.data().informationShortcut,
            question: doc.data().question
          };
          this.faqs.push(data);
        });
      });
  },
  mounted() {
    M.AutoInit();
  }
};
</script>


