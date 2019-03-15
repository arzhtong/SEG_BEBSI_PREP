<template>
  <div id="edit-prep-list">
    <h3>Edit Preperation List</h3>
    <div class="row">
      <form @submit.prevent="updatePrepList" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>Title</span>
            <input type="text" v-model="title">
          </div>
        </div>
        <div class="row">
          <div v-for="data in allData" v-bind:key="data" class="input-field col s12">
            <span>name</span>
            <input type="text" v-model="data.name" required>
            <span v-if="data.description">description</span>
            <input v-if="data.description" type="text" v-model="data.description" required>
            <button @click="addToOldList(data)" class="btn green">new item</button>
            <div v-for="item in data.list.length" v-bind:key="item" class="input-field col s12">
              <span>Item</span>
              <input type="text" v-model="data.list[item - 1]" required>
              <button @click="deleteFromOldList(data, item -1)" class="btn red">remove item</button>
            </div>
            <button @click="deleteOldMap(allData.indexOf(data))" class="btn red">remove List</button>
          </div>
          <button @click="addMap" class="btn green">new List</button>
          <div v-for="map in allMaps" v-bind:key="map" class="input-field col s12">
            <span>name</span>
            <input type="text" v-model="map.name" required>
            <span>description</span>
            <input type="text" v-model="map.description" required>
            <button @click="addToList(map)" class="btn green">new item</button>
            <div v-for="item in map.list.length" v-bind:key="item" class="input-field col s12">
              <span>Item</span>
              <input type="text" v-model="map.list[item - 1]" required>
              <button @click="deleteFromList(map, item - 1)" class="btn red">remove item</button>
            </div>
            <button @click="deleteMap(allMaps.indexOf(map))" class="btn red">remove List</button>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
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
      allData: [],
      allMaps: [],
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
        (doc.data().maps).forEach((map) => {
              this.allData.push(map)
          })
      });
  
    this.getTitle();
  },
  methods: {
    updatePrepList() { 
      if(this.allMaps.length > 0) {
        var theMaps = this.allData.concat(this.allMaps)
         db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("lists")
        .doc(this.$route.params.contents)
        .set( 
         {
           maps: theMaps
         }
        )
      }
      else{
         db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("lists")
        .doc(this.$route.params.contents)
        .set(
         {
           maps: this.allData
         }
        )
      }

      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .where("contents", "==", this.$route.params.contents)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                contents: this.title
              })
              .then(() => {
                this.$router.push({
                  name: "view-prep-list",
                  params: { test_id: this.$route.params.test_id, contents: this.$route.params.contents }
                });
              });
          });
        });
    },
    addMap() {
      let data = new Object();
      data.name = "";
      data.description = "";
      data.list = [];
      this.allMaps.push(data);
    },
    addToList(map) {
      const data = ""
      map.list.push(data)
    },
    addToOldList(newData) {
      const data = "";
      newData.list.push(data);
    },
    deleteFromList(map, index) {
      map.list.splice(index, 1);
    },
    deleteFromOldList(newData, index) {
      newData.list.splice(index, 1);
    },
     deleteOldMap(index) {
      this.allData.splice(index, 1);
    },
    deleteMap(index) {
      this.allMaps.splice(index, 1);
    },
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