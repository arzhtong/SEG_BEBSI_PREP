<template>
    <div id="view-prep-list">
        <ul class="collection with-header">
            <li class="collection-header">
                <h4>{{this.$route.params.contents}}:</h4>
                <router-link v-bind:to="{name: 'view-prep-categories', params: {test_id: test_id}}" class="btn grey">Back</router-link>
            </li>
            <li class="collection-item"><b><h5>Lists:</h5></b>
            <div v-for="map in maps[0]" v-bind:key="map" >
                <li class="collection-item"><h6>{{map.name}}</h6> </li>
                <ul >
                <li v-for="item in map.list" v-bind:key="item">{{item}}</li>
             </ul> 
             <li v-if="map.description"  class="collection-item"> {{map.description}}</li>

            </div>
            </li>  
        </ul>
         <div class="fixed-action-btn">
        </div>
    </div>
</template>

<script>
    import db from '../firebaseInit'

    export default{
        name: 'view-prep-list',
        data() {
            return {
                maps: [],
                test_id: this.$route.params.test_id
            }
        },
        created () {
            db.collection('tests').doc(this.$route.params.test_id).collection('prepContents')
            .doc(this.$route.params.contents).get().then(doc => {
                    const data = doc.data()
                       
                    
                    this.maps.push(data)
                })
        }

            
        
    }
</script>