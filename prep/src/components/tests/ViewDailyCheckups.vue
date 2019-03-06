<template>
  <div id="view-dailycheckups">
       <ul class="collection with-header">
           <li class="collection-header">
               <div calss="container" style="width:100%;height:100%">
                   <table calss="collection with-header responsive-table" style="background: white;margin-top:10%;width:100%;height:auto">
                       <thead calss="collection-header">
                          <h4 style="padding:10px;font-size:3em;font-weight: bold;">Daily Check-ups</h4>
                          <tr style="font-size:1.5em">
                               <th>Id</th>
                               <th>Title</th> 
                               <th>Days Before Test</th>
                               <th>Description</th>
                           </tr>
                       </thead>
                       <tbody v-for="dailyCheckup in dailyCheckups" v-bind:key="dailyCheckup.id" class="collection-item">
                           <tr>
                               <td>{{dailyCheckup.id}}</td>
                               <td>{{dailyCheckup.title}}</td>
                               <td>{{dailyCheckup.daysBeforeTest}}</td>
                               <td><button class="btn blue" style="position:relative;text-align:center;">Show Information</button></td>
                              
                           </tr>
                          
                       </tbody>
                       <br>
                        <router-link v-bind:to="{name: 'new-dailycheckups', params: {id: testID}}"> <button class="btn green" style="position:relative;text-align:center;">Add DailyCheckUps</button></router-link>
                        <router-link to="/view-tests" ><button class="btn grey" style="margin:20px;">Back</button></router-link>
                       
                   </table>
               </div>
           </li>
       </ul>
  </div>
</template>

<script>
    import db from '../firebaseInit'
    export default{
        name: 'view-dailycheckups',
        data() {
            return {
                dailyCheckups: [],
                testID: this.$route.params.id
                
            }
        },
       created () {
            db.collection('tests').doc(this.$route.params.id).collection('dailyCheckups').get().then(querySnapshot => {
                querySnapshot.forEach(doc => {
                    const data = {
                        'id': doc.id,
                        'daysBeforeTest':doc.data().daysBeforeTest,
                        'description':doc.data().description,
                        'instrcutions': doc.data().instructions,
                        'title':doc.data().title,
                    }
                    this.dailyCheckups.push(data)
                })
            })
        }
    }
</script>


