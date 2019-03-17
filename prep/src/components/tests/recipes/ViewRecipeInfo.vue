<template>
    <div id="view-recipe-info">
        <ul class="collection with-header">
            <li class="collection-header">
                <h4>Recipe Information:</h4>
            </li>
            <li class="collection-item"><b>Dish Name:</b> {{title}}</li>
            <li class="collection-item"><b>Instructions:</b>
            <ol >
                <li v-for="instruction in instructions" v-bind:key="instruction">{{instruction}}</li>
            </ol> 
            
            </li> 
            <li v-if="note" class="collection-item"><b>Notes:</b> {{note}}</li> 
        </ul>
        <router-link v-bind:to="{name: 'view-recipes', params: {test_id: test_id}}" class="btn grey">Back</router-link>
        <router-link v-bind:to="{name: 'edit-recipe', params: {test_id: test_id, recipe_id: recipe_id}}" class="btn green">Edit</router-link>
        <button @click="deleteRecipe" class="btn red">Delete</button>
    </div>
</template>

<script>
import db from '../../firebaseInit'

export default {
    name: 'view-recipe-info',
    data() {
        return {
            title: null,
            recipe_id: this.$route.params.recipe_id,
            instructions: [],
            note: null,
            test_id: this.$route.params.test_id
        }
    },
    beforeRouteEnter (to, from, next) {
        db.collection('tests')
          .doc(to.params.test_id)
          .collection('recipes')
          .doc(to.params.recipe_id)
          .get()
          .then(doc => {
              if(doc.exists) {
                next(vm => {
                    vm.title = doc.data().title
                    vm.instructions = doc.data().method
                    vm.note = doc.data().note
                })
              }
          })
    },
    watch: {
        '$route': 'fetchData'
    },
    methods: {
        fetchData () {
            db.collection('tests')
              .doc(this.$route.params.test_id)
              .collection('recipes')
              .doc(this.$route.params.recipe_id)
              .get()
              .then(doc => {
                if(doc.exists) {
                    this.title = doc.data().title
                    this.instructions = doc.data().method
                    this.note = doc.data().note
                }
              })
        },
        deleteRecipe () {
            if(confirm('Are you sure?')) {
                db.collection('tests')
                    .doc(this.$route.params.test_id)
                    .collection('recipes')
                    .doc(this.$route.params.recipe_id)
                    .get()
                    .then(doc => {
                        if(doc.exists) {
                        doc.ref.delete()
                    }
                    this.$router.push({name: 'view-recipes', params: {test_id: this.$route.params.test_id}})
                    })
            }
        }   
    }
}
</script>