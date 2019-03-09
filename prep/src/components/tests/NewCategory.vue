<template>
  <div id="new-category">
    <h3>New Category</h3>
    <div class="row">
      <form @submit.prevent="saveCategory" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>Choose category type</span>
            <select class="browser-default" style="color:black" v-model="category">
              <option v-for="category in categories" v-bind:key="category" :value="category">{{category}}</option>
            </select>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="title">
            <label>Title</label>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-prep-categories', params: {test_id: this.$route.params.test_id}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
export default {
  name: "new-category",
  data() {
    return {
      title: null,
      categories: ['categoryList', 'information'],
      category: null
    };
  },
  methods: {
    saveCategory() {
        
         db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepContents")
        .doc(this.title)
        .set({})
        
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .add({
          title: this.title,
          contents: this.title,
          type: this.category
        })
        .then(docRef => {
          this.$router.push({
            name: "view-prep-categories",
            params: { test_id: this.$route.params.test_id }
          });
        })
        .catch(error => console.log(err));
    }
  }
};
</script>