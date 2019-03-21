<template>
    <div id="view-recipe-info">
        <ul class="collection with-header">
            <li class="collection-header">
                <h4>Recipe Information:</h4>
            </li>
            <li v-if="imageURL" class="collection-item">
                <div class="center-align">
                    <img :src="imageURL" width="100%" style="max-height: 250px; max-width: 250px;"/>
                </div>
            </li>
            <li class="collection-item">
                <b>Dish Name:</b> {{title}}
                <i v-if="subtitle"> - {{subtitle}}</i>
            </li>
            <li v-if="type" class="collection-item"><b>Type:</b> {{type}}</li>
            <li v-if="labels" class="collection-item"><b>Labels:</b> {{labels}}</li>
            <li v-if="externalURL" class="collection-item"><b>Recipe link:</b> <a :href="externalURL">{{externalURL}}</a></li>
            <li v-if="ingredients" class="collection-item"><b>Ingredients:</b>
                <ol >
                    <li v-for="ingredient in ingredients" v-bind:key="ingredient">{{ ingredient }}</li>
                </ol> 
            </li>
            <li v-if="instructions" class="collection-item"><b>Instructions:</b>
                <ol >
                    <li v-for="instruction in instructions" v-bind:key="instruction">{{ instruction }}</li>
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
            recipe_id: this.$route.params.recipe_id,
            title: null,
            subtitle: null,
            labels: null,
            imageURL: null,
            externalURL: null,
            ingredients: [],
            instructions: [],
            note: null,
            type: null,
            test_id: this.$route.params.test_id
        }
    },
    beforeRouteEnter (to, from, next) {
        db.collection('tests')
          .doc(to.params.test_id)
          .collection('prepCards')
          .doc(to.params.recipe_id)
          .get()
          .then(doc => {
              if(doc.exists) {
                next(vm => {
                    vm.title = doc.data().title
                    vm.subtitle = doc.data().subtitle
                    vm.labels = doc.data().labels
                    vm.imageURL = doc.data().backgroundImage
                    vm.externalURL = doc.data().externalURL
                    vm.ingredients = doc.data().ingredients
                    vm.instructions = doc.data().method
                    vm.note = doc.data().note
                    vm.type = doc.data().recipeType
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
              .collection('prepCards')
              .doc(this.$route.params.recipe_id)
              .get()
              .then(doc => {
                if(doc.exists) {
                    this.title = doc.data().title
                    this.subtitle = doc.data().subtitle
                    this.labels = doc.data().labels
                    this.imageURL = doc.data().backgroundImage
                    this.externalURL = doc.data().externalURL
                    this.ingredients = doc.data().ingredients
                    this.instructions = doc.data().method
                    this.note = doc.data().note
                    this.type = doc.data().recipeType
                }
              })
        },
        deleteRecipe () {
            if(confirm('Are you sure?')) {
                db.collection('tests')
                    .doc(this.$route.params.test_id)
                    .collection('prepCards')
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