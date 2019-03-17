<template>
    <div id="add-article" style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px">
        <div id="mainScreen">
            <h3>New Recipe</h3>
            <div class="row">
                <div class="col s12">
                    <div class="card-panel light-blue">
                        <span class="card-title white-text"><i class="small material-icons">info_outline</i>Info</span>
                        <p class="white-text">Fill in the fields below and then click submit. Only a title is required, all other fields are optional.</p>
                    </div>
                </div>
                <form @submit.prevent="saveRecipe" class="col s12">
                    <div class="row">
                        <div class="input-field col s12">
                            <input type="text" v-model="title" required>
                            <label>Title *</label>
                        </div>
                    </div>
                    <div>
                        <div class="row">
                            <div class="input-field col s12">
                                <input type="text" v-model="externalURL">
                                <label>Recipe link</label>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div>
                            <label id="heading">Ingredients</label>
                            <hr>
                        </div>
                        <button @click="addIngredient" class="btn green"> add ingredient</button>
                        <div class="row">
                            <div v-for="ingredient in ingredients" :key="ingredient.id" class="input-field col s12">
                                <input type="text" v-model="ingredient.value" required>
                                <button class="btn red" @click="deleteIngredient(ingredients.indexOf(ingredient))"> remove ingredient</button>
                            </div>
                        </div>
                        <div>
                            <label id="heading">Instructions</label>
                            <hr>
                        </div>
                        <button @click="addInstruction" class="btn green"> add instruction</button>
                        <div class="row">
                            <div v-for="instruction in instructions" :key="instruction.id" class="input-field col s12">
                                <input type="text" v-model="instruction.value" required>
                                <button class="btn red" @click="deleteInstruction(instructions.indexOf(instruction))"> remove instruction</button>
                            </div>
                        </div>
                    </div>
                    <div id="tags">
                        <!-- chips component for recipe tags -->
                        <div class="chips chips-placeholder"></div>
                    </div>
                    <div>
                        <label id="heading">Type</label>
                        <hr>
                    </div>
                    <div class="row">
                        <select class="browser-default" style="color:black" v-model="type">
                            <option v-for="type in types" v-bind:key="type.index" :value="type">{{type}}</option>
                        </select>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <input type="text" v-model="note">
                            <label>Notes</label>
                        </div>
                    </div>
                    <imageUploader 
                    v-on:downloadURL="imageURL=$event"
                    />
                    <button type="submit" class="btn">Submit</button>
                    <router-link v-bind:to="{name: 'view-recipes', params: {test_id: this.$route.params.test_id}}" class="btn grey">Cancel</router-link>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
import db from '../../firebaseInit'
import imageUploader from '../../shared/ImageUploader'

export default {
    name: 'new-recipe',
    data() {
        return {
            idCounter: 0, // unique number for v-for of ingredients and instructions
            title: null,
            imageURL: null,
            ingredients: [],
            instructions: [],
            types: ['salad','soup','vegetable','roast','stew','pizza','sandwich','wrap', 'pie', 'fish', 'beef', 'chicken', 'curry', 'eggs'],
            type: null,
            note: null,
            externalURL: null
        }
    },
    components: {
        imageUploader
    },
    methods: {
        saveRecipe() {
            // get correctly formatted arrays before saving
            var labels = this.getChips()
            var ingredients = this.getValuesArray(this.ingredients)
            var instructions = this.getValuesArray(this.instructions)
            db.collection('tests')
              .doc(this.$route.params.test_id)
              .collection('recipes').add({
                title: this.title,
                backgroundImage: this.imageURL,
                ingredients: ingredients,
                method: instructions,
                labels: labels,
                note: this.note,
                type: this.type,
                externalURL: this.externalURL
            })
            .then(docRef => {
                this.$router.push({ name: 'view-recipes', params: {test_id: this.$route.params.test_id} })
            })
            .catch(error => console.log(err))
        },
        addInstruction() {
            const data = {
                value: '',
                yes: this.idCounter
            }
            this.instructions.push(data)
            this.idCounter ++
        },
        deleteInstruction(index) {
            this.instructions.splice(index, 1)
        },
        addIngredient() {
            const data = {
                value: '',
                yes: this.idCounter
            }
            this.ingredients.push(data)
            this.idCounter ++
        },
        deleteIngredient(index) {
            this.ingredients.splice(index, 1)
        },
        // get string arrays from ingredients and instructions
        getValuesArray(arrayIn) {
            var arr = []
            for(var i = 0; i < arrayIn.length; i++) {
                arr.push(arrayIn[i].value)
            }
            return arr
        },
        // get array of tag strings from chips
        getChips() {
            var arr = M.Chips.getInstance($('.chips')).chipsData
            var chips = []
            if(arr.length !== 0) {
                for(var i = 0; i < arr.length; i++) {
                    chips.push(arr[i].tag)
                }
            }
            return (chips.length === 0 ? null : chips)
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
#heading {
    font-size: 15px
}
#tags {
    padding-bottom: 15px
}
</style>