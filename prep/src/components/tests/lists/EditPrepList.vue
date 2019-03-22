<template>
  <div id="edit-prep-list">
    <div class="fixed-action-btn">
      <router-link
        v-bind:to="{name: 'view-prep-list', params: {test_id: this.$route.params.test_id, contents: List}}"
        class="btn-floating btn-large black"
      >
        <i class="material-icons">arrow_back</i>
      </router-link>
    </div>
    <h3>Edit Preperation List</h3>
    <div class="row">
      <form @submit.prevent="updatePrepList" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>title</span>
            <input type="text" v-model="title" required>
          </div>
        </div>
        <div class="row">
          <!-- gets all the maps that already exist in the database -->
          <div v-for="data in allData" v-bind:key="data.id" class="input-field col s12">
            <span>name</span>
            <input type="text" v-model="data.name" required>
            <!-- gets a description if it is found in the database -->
            <span >description</span>
            <input type="text" v-model="data.description" >
            <!-- adds an item to the list in the database -->
            <button @click="addToOldList(data)" class="btn green">new item</button>
            <div v-for="item in data.list.length" v-bind:key="item" class="input-field col s12">
              <span>Item</span>
              <input type="text" v-model="data.list[item - 1]" required>
              <!-- removes item from list in database -->
              <button
                type="button"
                @click="deleteFromOldList(data, item - 1)"
                class="btn red"
              >remove item</button>
            </div>
            <!-- removes map from database -->
            <button
              type="button"
              @click="deleteOldMap(allData.indexOf(data))"
              class="btn red"
            >remove List</button>
          </div>
          <!-- adds a new map to be added to the database -->
          <button @click="addMap" class="btn green">new List</button>
          <div v-for="map in allMaps" v-bind:key="map.id" class="input-field col s12">
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
import { listsMixin } from "../../../mixins/listsMixin/listsMixin.js";
export default {
  name: "edit-prep-list",
  mixins: [listsMixin],
  created (){
    this.createEditPrepList()
  }
};

</script>
