<template>
    <div id="new-recipe">
        <h3>New Recipe</h3>
        <div class="row">
            <form @submit.prevent="saveRecipe" class="col s12">
                <div class="row">
                    <div class="input-field col s12">
                        <input type="text" v-model="title" required>
                        <label>Title</label>
                    </div>
                </div>
                <button @click="addInstruction" class="btn green"> new instruction</button>
                <div class="row">
                    <div v-for="instruction in instructions" v-bind:key="instruction" class="input-field col s12">
                        <input type="text" v-model="instruction.value" required>
                        <label>Instructions</label>
                        <button class="btn red" @click="deleteInstruction(instructions.indexOf(instruction))"> remove instruction</button>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <input type="text" v-model="notes">
                        <label>Notes</label>
                    </div>
                </div>
                <button type="submit" class="btn">Submit</button>
                <router-link v-bind:to="{name: 'view-recipes', params: {test_id: this.$route.params.test_id}}" class="btn grey">Cancel</router-link>
            </form>
        </div>
    </div>
</template>

<script>
import db from '../firebaseInit'
    export default{
        name: 'new-recipe',
        data() {
            return {
                title: null,
                instructions: [],
                message: "",
                notes: null
            }
        },
        methods: {
            saveRecipe(){
                var array = []
                for(var i =0 ; i < this.instructions.length; i++){
                    array.push(this.instructions[i].value)
                }
                db.collection('tests').doc(this.$route.params.test_id).collection('recipes').add({
                    title: this.title,
                    instructions: array,
                    notes: this.notes
                })
                .then(docRef => {
                    this.$router.push({ name: 'view-recipes', params: {test_id: this.$route.params.test_id} })
                })
                .catch(error => console.log(err))
            },
            addInstruction() {
                const data = {value: ''}
                this.instructions.push(data); 
            },
            deleteInstruction(index) {
                this.instructions.splice(index, 1);
            }
        }
    }
</script>