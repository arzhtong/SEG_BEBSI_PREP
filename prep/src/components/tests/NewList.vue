<template>
  <div id="new-list">
    <h3>New List</h3>
    <div class="row">
      <div class="fixed-action-btn">
        <router-link
          v-bind:to="{name: 'view-prep-lists', params: {test_id: this.$route.params.test_id}}"
          class="btn-floating btn-large black"
        >
          <i class="material-icons">arrow_back</i>
        </router-link>
      </div>
      <form @submit.prevent="createPrepCard" class="col s12">
        
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="title" required>
            <label>Title</label>
          </div>
        </div>
        <div>
         <!-- adds a new map to be added to the database -->
          <button @click="addMap" class="btn green">new List</button>
          <div v-for="map in allMaps" v-bind:key="map.id" class="input-field col s12">
            <span>name</span>
            <input type="text" v-model="map.name" required>
            <span>description</span>
            <input type="text" v-model="map.description" >
            <!-- adds an item to the list in the new map -->
            <button @click="addToList(map)" class="btn green">new item</button>
            <div v-for="item in map.list.length" v-bind:key="item" class="input-field col s12">
              <span>Item</span>
              <input type="text" v-model="map.list[item - 1]" required>
              <!-- remove item from the list in the new map -->
              <button
                type="button"
                @click="deleteFromList(map, item - 1)"
                class="btn red"
              >remove item</button>
            </div>
            <!-- remove newly added map -->
            <button
              type="button"
              @click="deleteMap(allMaps.indexOf(map))"
              class="btn red"
            >remove List</button>
          </div>
          </div>
          <div style="margin-top:10px">
        <button type="submit" class="btn">Submit</button>
        <!-- cancel button -->
        <router-link
          v-bind:to="{name: 'view-prep-lists', params: {test_id: this.$route.params.test_id}}"
          class="btn grey"
        >Cancel</router-link>
        </div>
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
      allMaps: [], // newly added maps
      category: "categoryList"
    };
  },
  methods: {
    createPrepCard() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .add({
          title: this.title,
          contents: this.title,
          type: this.category,
          maps: this.allMaps
        })
        // reroutes to all the lists
        .then(docRef => {
          alert("List added!");
          this.$router.push({
            name: "view-prep-lists",
            params: { test_id: this.$route.params.test_id }
          });
        })
        .catch(error => console.log(err));
    },
    // adds a new map to the array
    addMap() {
      let data = new Object();
      data.name = "";
      data.description = "";
      data.list = [];
      this.allMaps.push(data);
    },
    // adds an item to the list of the new map
    addToList(map) {
      const data = "";
      map.list.push(data);
    },
    // deletes an item from the list of the new map
    deleteFromList(map, index) {
      map.list.splice(index, 1);
    },
    // deletes newly added map
    deleteMap(index) {
      this.allMaps.splice(index, 1);
    },
  }
};
</script>