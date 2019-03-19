<template>
    <div
        id="new-test"
        style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
    >
        <div id="mainScreen">
        <h3>New Test</h3>
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
            <div>
                <textEditor ref="textEditor"/>
            </div>
            <div class="navButtons">
                <button type="submit" class="btn" @click="saveTest">Submit</button>

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
    name: 'newTest',
    data() {
        return {
            title: '',
            department: '',
            testInformation: [],
            inputs: [],
            htmlForEditor: ''
        };
    },
    components: {
        textEditor
    },
    methods: {
        saveTest() { 
            if(this.validInputs()) {
                // run the editors save method
                this.$refs.textEditor.saveEditorData()
                // save the document
                db.collection('tests').add({
                    title: this.title,
                    type: this.department,
                    description: (this.$refs.textEditor.htmlForEditor === undefined ? '' : this.$refs.textEditor.htmlForEditor), 
                    editorImages: this.$refs.textEditor.images
                })
                .then(docRef => {
                    console.log("Document written with ID: ", docRef.id);
                    alert(`New test: ` + this.title + ` saved!`)
                })
                .catch(error => {
                    console.error("Error adding document: ", error);
                    return // dont leave the page if save fails
                });
                // return to tests page
                this.$router.push({ path: '/view-tests'})
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