<template>
  <div id="view-prep-list">
    <ul class="collection with-header">
      <li class="collection-header">
        <h4>{{this.$route.params.contents}}:</h4>
        <router-link
          v-bind:to="{name: 'view-prep-categories', params: {test_id: test_id}}"
          class="btn grey"
        >Back</router-link>
         <router-link
          v-bind:to="{name: 'edit-prep-list', params: {test_id: test_id, contents: this.$route.params.contents}}"
          class="btn green"
        >Edit</router-link>
        <button @click="deleteList" class="btn red">Delete</button>
      </li>
      <li class="collection-item">
        <b>
          <h5>Lists:</h5>
        </b>
        <div v-for="map in maps" v-bind:key="map">
          <li class="collection-item">
            <h6><B>Name:</B> {{map.name}}</h6>
          </li>
          <ul>
            <li v-for="item in map.list" v-bind:key="item">{{item}}</li>
          </ul>
          <li v-if="map.description" class="collection-item"> <B>Description: </B> {{map.description}}</li>
        </div>
      </li>
    </ul>
    <div class="fixed-action-btn"></div>
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "view-prep-list",
  data() {
    return {
      maps: [],
      test_id: this.$route.params.test_id
    };
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("lists")
      .doc(this.$route.params.contents)
      .get()
      .then(doc => {
        (doc.data().maps).forEach((map) => {
              this.maps.push(map)
          })
      });
  },
  methods: {
    deleteList() {
      if (confirm("Are you sure?")) {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("prepCards")
          .where("contents", "==", this.$route.params.contents)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
              doc.ref.delete();
            });
          });
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("lists")
          .doc(this.$route.params.contents)
          .get()
          .then(doc => {
            doc.ref.delete();
            this.$router.push({
              name: "view-prep-categories",
              params: { test_id: this.$route.params.test_id }
            });
          });
      }
    }
  }
};
</script>