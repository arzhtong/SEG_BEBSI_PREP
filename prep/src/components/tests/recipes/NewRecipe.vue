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
                            <input type="text" v-model="title" id="title" required>
                            <label for="title">Title *</label>
                        </div>
                        <div class="input-field col s12">
                            <input type="text" id="subtitle" v-model="subtitle">
                            <label for="subtitle">Subtitle</label>
                        </div>
                    </div>
                    <div>
                        <div class="row">
                            <div class="input-field col s12">
                                <input type="text" id="recipeLink" v-model="externalURL">
                                <label for="recipeLink">Recipe link</label>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div>
                            <label id="heading">Ingredients</label>
                        </div>
                        <button @click="addIngredient" class="btn green" id="addBtn" type="button"> add ingredient</button>
                        <div class="row">
                            <div v-for="(ingredient, index) in ingredients" v-bind:key="index" class="input-field col s12">
                                <div class="valign-wrapper">
                                    <input type="text" v-model="ingredients[index]" required>
                                    <a class="btn-floating red" @click="deleteIngredient(index)" id="removeBtn"><i class="material-icons">close</i></a>
                                </div>
                            </div>
                        </div>
                        <div>
                            <label id="heading">Instructions</label>
                        </div>
                        <button @click="addInstruction" class="btn green" id="addBtn" type="button"> add instruction</button>
                        <div class="row">
                            <div v-for="(instruction, index) in instructions" v-bind:key="index" class="input-field col s12">
                                <div class="valign-wrapper">
                                    <input type="text" v-model="instructions[index]" required>
                                    <a class="btn-floating red" @click="deleteInstruction(index)" id="removeBtn"><i class="material-icons">close</i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div id="tags" class="input-field col s6">
                            <!-- chips component for recipe tags -->
                            <div class="chips chips-placeholder"></div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s6">
                            <select  v-model="recipeType">
                            <option value="" disabled selected><label>Choose Recipe type</label></option>
                            <option v-for="type in recipeTypes" v-bind:key="type.index" :value="type">{{type}}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <textarea id="notes" class="materialize-textarea" v-model="note">
                            </textarea>
                            <label for="notes">Notes</label>
                        </div>
                    </div>
                    <imageUploader 
                    id="addBtn"
                    v-on:downloadURL="imageURL=$event"
                    />
                    <br>
                    <button type="submit" class="btn">Submit</button>
                    <router-link v-bind:to="{name: 'view-recipes', params: {test_id: this.$route.params.test_id}}" class="btn grey">Cancel</router-link>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
import { recipeMixin } from '../../../mixins/recipeMixin/recipeMixin'
import { recipeQueryMixin } from '../../../mixins/recipeMixin/recipeQueryMixin'

export default {
    name: 'new-recipe',
    mixins: [recipeMixin, recipeQueryMixin],
    data() {
        return {
            test_id: this.$route.params.test_id,
            recipe_id: this.$route.params.recipe_id
        }
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
#addBtn {
    margin: 10px;
}
</style>