<template>
    <div id="view-recipes">
        <ul class="collection with-header">
            <li class="collection-header">
                
<div class="container" style="width:100%;height:100%">
        <table class="collection with-header responsive-table" style="background: white;margin-top:10%;width:100%;height:auto">
        <thead class="collection-header">
            <h4 style="padding:20px;font-size:3em;"><b>Recipes</b></h4>
            
          <tr style="font-size:1.5em">
              <th style="padding: 20px;">Dish Name</th> 
              <th>Description</th>
          </tr> 
        </thead> 

        <tbody v-for="recipe in recipes" v-bind:key="recipe.id" class="collection-item" >
          <tr >
            <td style="padding: 20px;">{{recipe.title}}</td>
            <td><router-link v-bind:to="{name: 'view-recipe-info', params: {test_id: testID, recipe_id: recipe.title}}" class="btn blue">Show</router-link></td>
          </tr>
        </tbody>
        <router-link v-bind:to="{name: 'new-recipe', params: {test_id: testID}}" class="btn green" style="margin:20px">
            Add Recipe
        </router-link>
      </table>
      </div>

            </li>
            
        </ul>

    </div>
</template>

<script>
    import db from '../firebaseInit'

    export default{
        name: 'view-recipes',
        data() {
            return {
                recipes: [],
                testID: this.$route.params.test_id
                
            }
        },
       created () {
            db.collection('tests').doc(this.$route.params.test_id).collection('recipes').get().then(querySnapshot => {
                querySnapshot.forEach(doc => {
                    const data = {
                        'id': doc.id,
                        'instrcutions': doc.data().instrcutions,
                        'notes': doc.data().notes,
                        'title': doc.data().title,
                    }
                    this.recipes.push(data)
                })
            })
        }
    }
</script>


