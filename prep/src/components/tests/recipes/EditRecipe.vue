<template>
  <div
    id="add-article"
    style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <div id="edit-recipe">
      <h3>Edit Recipe</h3>
      <div class="row">
        <form @submit.prevent="updateRecipe" class="col s12">
          <div class="row">
            <div class="input-field col s12">
              <span id="title">Title</span>
              <input type="text" v-model="title" required>
            </div>
            <div class="input-field col s12">
                <span>Subtitle</span>
                <input type="text" v-model="subtitle">
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span id="title">Link</span>
              <input type="text" v-model="externalURL">
            </div>
          </div>
          <button @click="addInstruction" class="btn green">new instruction</button>
          <div class="row">
            <div v-for="instr in allInstr.length" v-bind:key="instr" class="input-field col s12">
              <span id="title">Instruction</span>
              <input type="text" v-model="allInstr[instr - 1]" required>
              <button @click="deleteInstruction(instr -1)" class="btn red">remove instruction</button>
            </div>
          </div>
          <div>
            <span id="title">Tags</span>
          </div>
          <div id="tags">
              <!-- chips component for recipe tags -->
              <div class="chips chips-placeholder"></div>
          </div>
          <div>
            <span id="title">Type</span>
          </div>
          <div class="row">
            <select class="browser-default" style="color:black" v-model="type">
              <option v-for="type in types" v-bind:key="type.index" :value="type">{{type}}</option>
            </select>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span id="title">Notes</span>
              <input type="text" v-model="note">
            </div>
          </div>
          <imageUploader 
          :imageURL="imageURL" 
          v-on:downloadURL="imageURL=$event"/>
          <button type="submit" class="btn">Submit</button>
          <router-link
            v-bind:to="{name: 'view-recipe-info', params: {test_id: test_id, recipe_id: recipe_id}}"
            class="btn grey"
          >Cancel</router-link>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import db from '../../firebaseInit'
import imageUploader from '../../shared/ImageUploader'
import { recipeMixin } from '../../../mixins/recipeMixin'

export default {
  name: "edit-recipe",
  mixins: [recipeMixin],
  data() {
    return {
      title: null,
      subtitle: null,
      allInstr: [],
      imageURL: null,
      ingredients: [],
      instructions: [],
      type: null,
      note: null,
      externalURL: null,
      labels: [],
      test_id: this.$route.params.test_id,
      recipe_id: this.$route.params.recipe_id
    }
  },
  components: {
    imageUploader
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("recipes")
      .doc(this.$route.params.recipe_id)
      .get()
      .then(doc => {
        if (doc.exists) {
          this.title = doc.data().title,
          this.subtitle = doc.data().subtitle,
          this.imageURL = doc.data().backgroundImage,
          this.labels = doc.data().labels,
          this.externalURL = doc.data().externalURL,
          this.allInstr = doc.data().method,
          this.note = doc.data().note,
          this.type = doc.data().type
          this.$nextTick(() => this.loadChips())
        }
      })
  },
  beforeRouteEnter(to, from, next) {
    db.collection("tests")
      .doc(to.params.test_id)
      .collection("recipes")
      .doc(to.params.recipe_id)
      .get()
      .then(doc => {
        if (doc.exists) {
          next(vm => {
            vm.title = doc.data().title
            vm.subtitle = doc.data().subtitle
            vm.imageURL = doc.data().backgroundImage
            vm.labels = doc.data().labels
            vm.externalURL = doc.data().externalURL
            // vm.ingredients = doc.data().ingredients
            // vm.instructions = doc.data().method
            vm.note = doc.data().note
            vm.type = doc.data().type
          })
        }
      })
  },
  methods: {
    updateRecipe() {
      // only save if recipe is valid
      if(this.validRecipe()) {
        // get correctly formatted arrays before saving
        var labels = this.getChips()
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("recipes")
          .doc(this.$route.params.recipe_id)
          .update({
            title: this.title,
            subtitle: this.subtitle,
            method: this.allInstr,
            note: this.note,
            labels: labels,
            backgroundImage: this.imageURL,
            type: this.type,
            externalURL: this.externalURL
          })
          .then(() => {
            this.$router.push({
              name: "view-recipes",
              params: { test_id: this.$route.params.test_id }
            })
          })
      }
    },
    addInstruction() {
      const data = ""
      this.allInstr.push(data)
    },
    deleteInstruction(index) {
      this.allInstr.splice(index, 1)
    },
    loadChips() {
      if(this.labels !== null) {
        var instance = M.Chips.getInstance($('.chips'))
        for(var i = 0; i < this.labels.length; i++) {
          instance.addChip({
            tag: this.labels[i]
          })
        }
      }
    }
  },
  mounted() {
    // initialise chips for recipe tags
    $('.chips-placeholder').chips({
        placeholder: 'Enter a tag'
    })
  }
}
</script>

<style scoped>
#title {
  color: #2196f3;
}
</style>