<template>
    <div
        id="edit-test-description"
        style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
    >
        <div id="mainScreen">
        <h3>Edit Test</h3>
            <div class="row">
                <div class="input-field col s12">
                    <p>Title</p>
                    <input type="text" v-model.trim="title">
                </div>
            </div>
            <div class="row">
                <div class="input-field col s12">
                    <p>Department</p>
                    <input type="text" v-model.trim="department">
                </div>
            </div>
            <ul class="collapsible">
                <li>
                <div class="collapsible-header"><i class="small material-icons">info_outline</i>Info</div>
                <div class="collapsible-body"><span>Please use the text area below to enter information about this test. If this information is not currently available, 
                you can leave this blank for now and edit the information later.<br><br>Images can also be uploaded by clicking on the 
                image icon. Images should be placed inbetween blocks of text so that they correctly display in the app.</span></div>
                </li>
            </ul>
            <div class="loaderWrapper">
                <!-- Spinner that displays during image upload -->
                <div v-if="!dataLoaded" id="loader">
                    <div id="el" class="preloader-wrapper big active">
                        <div class="spinner-layer spinner-blue-only">
                            <div class="circle-clipper left">
                                <div class="circle"></div>
                            </div>
                            <div class="gap-patch">
                                <div class="circle"></div>
                            </div>
                            <div class="circle-clipper right">
                                <div class="circle"></div>
                            </div>
                        </div>
                    </div>
                    <label style="font-size:25px">Loading... please wait</label>
                </div>
            </div>
            <div v-if="dataLoaded">
                <textEditor 
                :editorInformation="htmlForEditor" 
                :editorImages="imagesForEditor"
                ref="textEditor"/>
            </div>
            <div class="navButtons">
                <button type="submit" class="btn" @click="updateTest">Submit</button>

                <router-link
                to="/view-tests"
                class="btn grey"
                >Cancel</router-link>
            </div>
        </div>
    </div>
</template>

<script>
import db from "../firebaseInit"
import firebase from "firebase"
import textEditor from "../shared/TextEditor"

export default {
    name: 'editTestDescription',
    data() {
        return {
            title: '',
            department: '',
            imagesForEditor: [],
            htmlForEditor: '',
            dataLoaded: false
        };
    },
    components: {
        textEditor
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
                      vm.htmlForEditor = doc.data().description
                      vm.imagesForEditor = doc.data().editorImages
                      vm.dataLoaded = true 
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
                    this.htmlForEditor = doc.data().description
                    this.imagesForEditor = doc.data().editorImages
                    this.dataLoaded = true
                }
                });
            },
        updateTest() {
            if(this.validInputs()) {
                // run the editors save method
                this.$refs.textEditor.saveEditorData()
                // update the document
                db.collection("tests")
                    .doc(this.$route.params.test_id)
                    .update({
                        title: this.title,
                        type: this.department,
                        description: this.$refs.textEditor.htmlForEditor,
                        editorImages: this.$refs.textEditor.images
                    })
                    .then(() => {
                        alert("Test info updated!")
                    })
                    .catch(function(error) {
                        console.error("Error writing document: ", error)
                        return // dont leave the page if save fails
                    })
                    // return to tests page
                    this.$router.push("/view-tests")
            }
        },
        validInputs() {
            if(this.title === '' || this.department ==='') {
                alert('Please enter a title and department for this test before saving')
                return false
            }
            return true
        }
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
.navButtons {
    padding-top: 10px;
}
p {
  color: #2196f3;
}
h3 {
  font-weight: bold;
  margin-left: 20px;
}
.collapsible-header {
    color: #2196f3;
}
</style>