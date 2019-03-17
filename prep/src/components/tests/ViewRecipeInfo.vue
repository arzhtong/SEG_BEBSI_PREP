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
            <li v-if="notes" class="collection-item"><b>Notes:</b> {{notes}}</li> 
        </ul>
        <router-link v-bind:to="{name: 'view-recipes', params: {test_id: test_id}}" class="btn grey">
            Back
            </router-link>
            <router-link v-bind:to="{name: 'edit-recipe', params: {test_id: test_id, recipe_id: title}}" class="btn green">
            Edit
            </router-link>
            <button @click="deleteRecipe" class="btn red">
            Delete
            </button>
         <div class="fixed-action-btn">
        </div>
    </div>
</template>

<script>
    import db from '../firebaseInit'

    export default{
        name: 'view-recipe-info',
        data() {
            return {
                title: null,
                instructions: [],
                notes: null,
                test_id: this.$route.params.test_id
            }
        },
        beforeRouteEnter (to, from, next) {
            db.collection('tests').doc(to.params.test_id).collection('recipes').where('title', '==', to.params.recipe_id).get()
            .then(querySnapshot => {
                querySnapshot.forEach(doc => {
                    next(vm => {
                        vm.title = doc.data().title
                        vm.instructions = doc.data().instructions
                        vm.notes = doc.data().notes
                    })
                })
            })
        },
        watch: {
            '$route': 'fetchData'
        },
        methods: {
            fetchData (){
                db.collection('tests').doc(this.$route.params.test_id).collection('recipes').where('title', '==', this.$route.params.recipe_id).get()
                .then(querySnapshot => {
                    querySnapshot.forEach(doc => {
                        this.title = doc.data().title
                        this.instructions = doc.data().instructions
                        this.notes = doc.data().notes
                    })
                })
            },
            deleteRecipe (){
                if(confirm('Are you sure?')){
                     db.collection('tests').doc(this.$route.params.test_id).collection('recipes').where('title', '==', this.$route.params.recipe_id).get()
                    .then(querySnapshot => {
                        querySnapshot.forEach(doc => {
                            doc.ref.delete()
                            this.$router.push({name: 'view-recipes', params: {test_id: this.$route.params.test_id}})
                        })
                    })
                }
            }
            
        }
    }
</script>