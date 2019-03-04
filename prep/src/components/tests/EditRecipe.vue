<template>
  <div id="edit-recipe">
    <h3>Edit Recipe</h3>
    <div class="row">
      <form @submit.prevent="updateRecipe" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="title" required>
            <label>Title</label>
          </div>
        </div>
        <button @click="addInstruction" class="btn green">new instruction</button>
        <div class="row">
          <div
          v-for="instr in allInstr" v-bind:key="instr" 
          class="input-field col s12">
            <input type="text" v-model="allInstr[allInstr.indexOf(instr)]" required>
            <label>Instructions</label>
            <button @click="deleteInstruction" class="btn red">remove instruction</button>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="notes">
            <label>Notes</label>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-recipe-info', params: {test_id: test_id, recipe_id: recipe_id}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "edit-recipe",
  data() {
    return {
      title: null,
      allInstr: [],
      notes: null,
      test_id: this.$route.params.test_id,
      recipe_id: this.$route.params.recipe_id
    }
  },
  created () {
        db.collection('tests').doc(this.$route.params.test_id).collection('recipes').get().then(querySnapshot => {
             querySnapshot.forEach(doc => {
                 
                    this.allInstr = doc.data().instructions,
                    this.notes =  doc.data().notes,
                    this.title =  doc.data().title
                
             })
        })
    },
  beforeRouteEnter(to, from, next) {
    db.collection("tests")
      .doc(to.params.test_id)
      .collection("recipes")
      .where("title", "==", to.params.recipe_id)
      .get()
      .then(querySnapshot => {
        fetch;
        querySnapshot.forEach(doc => {
          next(vm => {
            vm.title = doc.data().title;
            vm.notes = doc.data().notes;
          });
        });
      });
  },
  watch: {
    $route: "fetchData"
  },
  methods: {
    fetchData() {
      alert("instructions");
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("recipes")
        .where("title", "==", this.$route.params.recipe_id)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.title = doc.data().title;
            this.allinstr = doc.data().instructions;
            this.notes = doc.data().notes;
          });
        });          
    },
    updateRecipe() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("recipes")
        .where("title", "==", this.$route.params.recipe_id)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                title: this.title,
                instructions: this.allinstr,
                notes: this.notes
              })
              .then(() => {
                this.$router.push({
                  name: "view-recipes",
                  params: { test_id:  this.$route.params.test_id}
                });
              });
          });
        });
    },
    addInstruction() {
      const data = ""
      this.allInstr.push(data);
    },
    deleteInstruction(index) {
      this.allInstr.splice(index, 1);
    }
  }
};
</script>