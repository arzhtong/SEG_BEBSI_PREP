<template>
    <div id="view-prep-categories">
        <ul class="collection with-header">
            <li class="collection-header">
                
<div class="container" style="width:100%;height:100%">
        <table class="collection with-header responsive-table" style="background: white;margin-top:10%;width:100%;height:auto">
        <thead class="collection-header">
            <h4 style="padding:20px;font-size:3em;"><b>Preparation Categories</b></h4>
            
          <tr style="font-size:1.5em">
              <th style="padding: 20px;">contents</th> 
              <th>Description</th>
          </tr> 
        </thead> 

        <tbody v-for="category in categories" v-bind:key="category.id" class="collection-item" >
          <tr >
            <td style="padding: 20px;">{{category.contents}}</td>
            <td><button @click="routeToCard(category.type, category.contents)"  class="btn blue">Show</button></td>
          </tr>
        </tbody>
        <router-link v-bind:to="{name: 'new-category', params: {test_id: test_id}}" class="btn green" style="margin:20px">
            Add category
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
        name: 'view-prep-categories',
        data() {
            return {
                categories: [],
                test_id: this.$route.params.test_id
                
            }
        },
       created () {
            db.collection('tests').doc(this.$route.params.test_id).collection('prepCards').get().then(querySnapshot => {
                querySnapshot.forEach(doc => {
                    const data = {
                        'id': doc.id,
                        'contents': doc.data().contents,
                        'type': doc.data().type
                        
                    }
                    this.categories.push(data)
                })
            })
        },
        methods: {
            routeToCard(categoryType, categoryContents){
                if(categoryType === 'categoryList'){
                    this.$router.push({name: 'view-prep-list', params: {test_id: this.$route.params.test_id, contents: categoryContents}})
                }
            }
        }
    }
</script>


