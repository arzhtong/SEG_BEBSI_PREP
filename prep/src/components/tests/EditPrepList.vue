<template>
  <div id="edit-prep-list">
    <h3>Edit Preperation List</h3>
    <h4>{{title}}</h4>
    <div class="row">
      <form @submit.prevent="updatePrepList" class="col s12">
        <div class="row">
          <!-- gets all the maps that already exist in the database -->
          <div v-for="data in allData" v-bind:key="data" class="input-field col s12">
            <span>name</span>
            <input type="text" v-model="data.name" required>
            <!-- gets a description if it is found in the database -->
            <span v-if="data.description">description</span>
            <input v-if="data.description" type="text" v-model="data.description" required>
            <!-- adds an item to the list in the database -->
            <button @click="addToOldList(data)" class="btn green">new item</button>
            <div v-for="item in data.list.length" v-bind:key="item" class="input-field col s12">
              <span>Item</span>
              <input type="text" v-model="data.list[item - 1]" required>
              <!-- removes item from list in database -->
              <button @click="deleteFromOldList(data, item -1)" class="btn red">remove item</button>
            </div>
            <!-- removes map from database -->
            <button @click="deleteOldMap(allData.indexOf(data))" class="btn red">remove List</button>
          </div>
          <!-- adds a new map to be added to the database -->
          <button @click="addMap" class="btn green">new List</button>
          <div v-for="map in allMaps" v-bind:key="map" class="input-field col s12">
            <span>name</span>
            <input type="text" v-model="map.name" required>
            <span>description</span>
            <input type="text" v-model="map.description" required>
            <!-- adds an item to the list in the new map -->
            <button @click="addToList(map)" class="btn green">new item</button>
            <div v-for="item in map.list.length" v-bind:key="item" class="input-field col s12">
              <span>Item</span>
              <input type="text" v-model="map.list[item - 1]" required>
              <!-- remove item from the list in the new map -->
              <button @click="deleteFromList(map, item - 1)" class="btn red">remove item</button>
            </div>
            <!-- remove newly added map -->
            <button @click="deleteMap(allMaps.indexOf(map))" class="btn red">remove List</button>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
        <!-- cancel button -->
        <router-link
          v-bind:to="{name: 'view-prep-list', params: {test_id: this.$route.params.test_id, contents: List}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>  
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "edit-prep-list",
  data() {
    return {
      title: null,
      allData: [],// maps from database
      allMaps: [],// newly added maps
      test_id: this.$route.params.test_id,
      List: this.$route.params.contents
    };
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("lists")
      .doc(this.$route.params.contents)
      .get()
      .then(doc => {
        doc.data().maps.forEach(map => {
          this.allData.push(map);
        });
      });
    // gets the title of the list
    this.getTitle();
  },
  methods: {
    updatePrepList() {
      if (this.allMaps.length > 0) {
        // adds the 2 arrays together to form the new set of maps and adds the new array to the database
        var theMaps = this.allData.concat(this.allMaps);
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("lists")
          .doc(this.$route.params.contents)
          .set({
            maps: theMaps
          })
          .then(() => {
            // reroutes to the list
            this.$router.push({
              name: "view-prep-list",
              params: {
                test_id: this.$route.params.test_id,
                contents: this.$route.params.contents
              }
            });
          });
      } else {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("lists")
          .doc(this.$route.params.contents)
          .set({
            maps: this.allData
          })
          .then(() => {
            this.$router.push({
              name: "view-prep-list",
              params: {
                test_id: this.$route.params.test_id,
                contents: this.$route.params.contents
              }
            });
          });
      }
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
    // adds an item to the list of the old map
    addToOldList(newData) {
      const data = "";
      newData.list.push(data);
    },
    // deletes an item from the list of the new map
    deleteFromList(map, index) {
      map.list.splice(index, 1);
    },
    // deletes an item from the list of the old map
    deleteFromOldList(newData, index) {
      newData.list.splice(index, 1);
    },
    // deletes a map from the array in the database
    deleteOldMap(index) {
      this.allData.splice(index, 1);
    },
    // deletes newly added map
    deleteMap(index) {
      this.allMaps.splice(index, 1);
    },
    // gets title of the list from the database
    getTitle() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .where("contents", "==", this.$route.params.contents)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.title = doc.data().contents;
          });
        });
    }
  }
};
</script>