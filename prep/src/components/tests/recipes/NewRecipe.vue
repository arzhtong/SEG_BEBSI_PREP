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
                        <div class="input-field col s12">
                            <input type="text" v-model="subtitle">
                            <label>Subtitle</label>
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
                            <div v-for="(ingredient, index) in ingredients" v-bind:key="index" class="input-field col s12">
                                <input type="text" v-model="ingredients[index]" required>
                                <button @click="deleteIngredient(index)" class="btn red" type="button">remove ingredient</button>
                            </div>
                        </div>
                        <div>
                            <label id="heading">Instructions</label>
                            <hr>
                        </div>
                        <button @click="addInstruction" class="btn green"> add instruction</button>
                        <div class="row">
                            <div v-for="(instruction, index) in instructions" v-bind:key="index" class="input-field col s12">
                                <input type="text" v-model="instructions[index]" required>
                                <button @click="deleteInstruction(index)" class="btn red" type="button">remove instruction</button>
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
                            <option v-for="type in recipeTypes" v-bind:key="type.index" :value="type">{{type}}</option>
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
import { recipeMixin } from '../../../mixins/recipeMixin'

export default {
    name: 'new-recipe',
    mixins: [recipeMixin],
    data() {
        return {
            title: null,
            subtitle: null,
            imageURL: null,
            ingredients: [],
            instructions: [],
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
            // only save if recipe is valid
            if(this.validRecipe()) {
                // get correctly formatted arrays before saving
                var labels = this.getChips()
                db.collection('tests')
                .doc(this.$route.params.test_id)
                .collection('prepCards')
                .add({
                    cardType: 'recipe',
                    title: this.title,
                    subtitle: this.subtitle,
                    backgroundImage: this.imageURL,
                    ingredients: this.ingredients,
                    method: this.instructions,
                    labels: labels,
                    note: this.note,
                    recipeType: this.type,
                    externalURL: this.externalURL
                })
                .then(docRef => {
                    this.$router.push({ name: 'view-recipes', params: {test_id: this.$route.params.test_id} })
                })
                .catch(error => console.log(err))
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
#heading {
    font-size: 15px
}
#tags {
    padding-bottom: 15px
}
</style>