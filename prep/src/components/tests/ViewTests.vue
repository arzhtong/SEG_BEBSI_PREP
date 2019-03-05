<template>
    <div id="view-tests">
        <ul class="collection with-header">
            <li class="collection-header">
                
<div class="container" style="width:100%;height:100%">
        <table class="collection with-header responsive-table" style="background: white;margin-top:10%;width:100%;height:auto">
        <thead class="collection-header">
            <h4 style="padding:20px;font-size:3em;"><b>Tests</b></h4>
            
          <tr style="font-size:1.5em">
              <th style="padding: 20px;">Title</th>
              <th>Daily check-ups</th>
              <th>Preparation categories</th>
              <th>Recipes</th>
          </tr>
        </thead>
 
        <tbody v-for="test in tests" v-bind:key="test.id" class="collection-item" >
          <tr >
            <td style="padding: 20px;">{{test.title}}</td>
            <td><router-link to="" class="btn blue">Show</router-link></td>
            <td><router-link v-bind:to="{name: 'view-prep-categories', params: {test_id: test.id}}" class="btn blue">Show</router-link></td>
            <td><router-link v-bind:to="{name: 'view-recipes', params: {test_id: test.id}}" class="btn blue">Show</router-link></td>
          </tr>
        </tbody>
        <router-link to="/register" class="btn green" style="margin:20px">
            Add Test
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
        name: 'view-tests',
        data() {
            return {
                tests: []
            }
        },
        created () {
            db.collection('tests').get().then(querySnapshot => {
                querySnapshot.forEach(doc => {
                    const data = {
                        'id': doc.id,
                        'test_id': doc.data().testID,
                        'title': doc.data().title,

                    }
                    this.tests.push(data)
                })
            })
        }
    }
</script>


