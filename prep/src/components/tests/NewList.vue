<template>
  <div id="new-list">
    <h3>New List</h3>
    <div class="row">
      <form @submit.prevent="createPrepCard" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="title">
            <label>Title</label>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
        <!-- cancel button -->
        <router-link
          v-bind:to="{name: 'view-prep-lists', params: {test_id: this.$route.params.test_id}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
export default {
  name: "new-list",
  data() {
    return {
      title: null,
      prepCardID: null,
      category: 'categoryList'
    };
  },
   created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("prepCards")
      .doc(this.$route.params.contents)
      .get()
      .then(doc => {
        // gets all the maps and pushes them seperately into an array
          doc.data().maps.forEach(map => {
            this.maps.push(map);
          })
        
      });
  },
  methods: {
    createPrepCard (){
        db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .add({
          title: this.title,
          contents: this.title,
          type: this.category
        }).then(docRef => {
          this.prepCardID = docRef.id
          this.$nextTick(() => this.saveList())
        })
      
    },
    saveList() {

        // makes a new document in the list collection in the database
         db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("lists")
        .doc(this.prepCardID)
        .set({})
 
    
        // reroutes to all the lists
        .then(docRef => {
          alert('List added!')
          this.$router.push({
            name: "view-prep-lists",
            params: { test_id: this.$route.params.test_id }
          });
        })
        .catch(error => console.log(err));
    }
  }
};
</script>