<template>
    <div
        id="edit-test"
        style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
    >
        <div id="mainScreen">
        <h4 style="font-size:3em;">
            <b>{{title}}</b>
        </h4>
        <h5 style="padding:10px;">
            <b>Department: {{department}}</b>
        </h5>
            <div class="info">
                <ul class="collapsible">
                    <li>
                    <div class="collapsible-header"><i class="small material-icons">info_outline</i>Info</div>
                    <div class="collapsible-body"><span></span></div>
                    </li>
                </ul>
            </div>
            <ul class="collection">
                <li class="collection-item avatar">
                    <i class="material-icons circle green">create</i>
                    <h5 class="titles">Test description</h5>
                    <p>Incomplete</p>
                    <router-link 
                        v-bind:to="{name: 'edit-test', params: {test_id: test_id}}" 
                        class="btn blue secondary-content"
                    >Show/Edit</router-link>
                </li>
                <li class="collection-item avatar">
                    <i class="material-icons circle green">done_all</i>
                    <h5 class="titles">Daily check-ups</h5>
                    <p>First Line <br>
                        Second Line
                    </p>
                    <router-link 
                        to="" 
                        class="btn blue secondary-content"
                    >Show/Edit</router-link>
                </li>
                <li class="collection-item avatar">
                    <i class="material-icons circle blue">assignment</i>
                    <h5 class="titles">Articles</h5>
                    <p>First Line <br>
                        Second Line
                    </p>
                    <router-link 
                        to="" 
                        class="btn blue secondary-content"
                    >Show/Edit</router-link>
                </li>
                <li class="collection-item avatar">
                    <i class="material-icons circle blue">list</i>
                    <h5 class="titles">Lists</h5>
                    <p>First Line <br>
                        Second Line
                    </p>
                    <router-link 
                        to="" 
                        class="btn blue secondary-content"
                    >Show/Edit</router-link>
                </li>
                <li class="collection-item avatar">
                    <i class="material-icons circle orange">help_outline</i>
                    <h5 class="titles">FAQs</h5>
                    <p>First Line <br>
                        Second Line
                    </p>
                    <router-link 
                        to="" 
                        class="btn blue secondary-content"
                    >Show/Edit</router-link>
                </li>
                <li class="collection-item avatar">
                    <i class="material-icons circle red">local_dining</i>
                    <h5 class="titles">Recipes</h5>
                    <router-link
                        v-bind:to="{name: 'view-recipes', params: {test_id: test_id}}"
                        class="btn blue secondary-content"
                    >Show/Edit</router-link>
                </li>
            </ul>
        </div>
    </div>
</template>
<script>
import db from "../firebaseInit"
import firebase from "firebase"
import textEditor from "../shared/TextEditor"

export default {
    name: 'editTest',
    data() {
        return {
            test_id: this.$route.params.test_id,
            title: '',
            department: ''
        }
    },
        beforeRouteEnter(to,from,next) {
        db.collection('tests')
          .doc(to.params.test_id)
          .get()
          .then(doc => {
              if(doc.exists) {
                  next(vm => {
                      vm.title = doc.data().title
                      vm.department = doc.data().type
                  })
              }
          })
    },
    watch: {
        $route: "fetchData"
    },
    methods: {
        fetchData() {
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .get()
                .then(doc => {
                if (doc.exists) {
                    this.title = doc.data().title
                    this.department = doc.data().type
                }
                });
            },
    },
    mounted() {
        // initalise colapsablie component
         $(document).ready(function() {
            $('.collapsible').collapsible();
        });
    }
}
</script>

<style scoped>
.titles {
    font-size: 17pt;
}
.info {
    padding-bottom: 20px;
}
.collapsible-header {
    color: #2196f3;
}
</style>