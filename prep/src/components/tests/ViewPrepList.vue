<template>
  <div id="view-prep-list">
    <ul class="collection with-header">
      <li class="collection-header">
        <!-- title of the list -->
        <h4>{{title}}:</h4>
        <!-- route to all the lists -->
        <router-link
          v-bind:to="{name: 'view-prep-lists', params: {test_id: test_id}}"
          class="btn grey"
        >Back</router-link>
        <!-- edit the list -->
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
        <!-- shows all the maps in the database -->
        <div v-for="map in maps" v-bind:key="map.id">
          <li class="collection-item">
            <h6>
              <B>Name:</B>
              {{map.name}}
            </h6>
          </li>
          <ul>
            <li v-for="item in map.list" v-bind:key="item">{{item}}</li>
          </ul>
          <li v-if="map.description" class="collection-item">
            <B>Description:</B>
            {{map.description}}
          </li>
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
      title: null,
      test_id: this.$route.params.test_id
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
          this.title = doc.data().title
      });
  },
  methods: {
    // deletes the list from the database as well as its card
    deleteList() {
      if (confirm("Are you sure?")) {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("prepCards")
          .doc(this.$route.params.contents)
          .delete()
          .then(doc => {
            alert('List deleted!')
            this.$router.push({
              name: "view-prep-lists",
              params: { test_id: this.$route.params.test_id }
            });
          });
          
      }
    }
  }
};
</script>