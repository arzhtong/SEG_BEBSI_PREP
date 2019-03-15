<template>
  <div id="edit-recipe">
    <h3>Edit Recipe</h3>
    <div class="row">
      <form @submit.prevent="updateRecipe" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>Title</span>
            <input type="text" v-model="title" required>
          </div>
        </div>
        <button @click="addInstruction" class="btn green">new instruction</button>
        <div class="row">
          <div v-for="instr in allInstr.length" v-bind:key="instr" class="input-field col s12">
            <span>Instruction</span>
            <input type="text" v-model="allInstr[instr - 1]" required>   
            <button @click="deleteInstruction(instr -1)" class="btn red">remove instruction</button>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Notes</span>
            <input type="text" v-model="notes">
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
    };
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("recipes")
      .where("title", "==", this.$route.params.recipe_id)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          (this.allInstr = doc.data().instructions),
            (this.notes = doc.data().notes),
            (this.title = doc.data().title);
        });
      });
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
  methods: {
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
                instructions: this.allInstr,
                notes: this.notes
              })
              .then(() => {
                this.$router.push({
                  name: "view-recipes",
                  params: { test_id: this.$route.params.test_id }
                });
              });
          });
        });
    },
    addInstruction() {
      const data = "";
      this.allInstr.push(data);
    },
    deleteInstruction(index) {
      this.allInstr.splice(index, 1);
    }
  }
};
</script>