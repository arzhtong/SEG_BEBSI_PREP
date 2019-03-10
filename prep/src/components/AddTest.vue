<template>
    <div
        id="new-test"
        style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
    >
        <div id="mainScreen">
        <h3>New Test</h3>
            <div class="row">
                <div class="input-field col s12">
                    <input type="text" v-model.trim="title">
                    <label>Title</label>
                </div>
            </div>
            <div class="row">
                <div class="input-field col s12">
                    <input type="text" v-model.trim="department">
                    <label>Department</label>
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
                <textEditor v-on:editorData="saveTest($event)"/>
            </div>
        </div>
    </div>
</template>

<script>
import db from "./firebaseInit"
import firebase from "firebase"
import imageUploader from "./ImageUploader"
import textEditor from "./TextEditor"

export default {
    name: 'mainScreen',
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
        imageUploader,
        textEditor
    },
    methods: {
        saveTest(information) { //information - from the text editor
            if(this.validInputs()) {
                db.collection('tests').add({
                    title: this.title,
                    type: this.department,
                    description: (information[0] !== undefined ? information[0] : ''), // information[0] is the editor text
                    editorImages: (information[1] !== undefined ? information[1] : '') // information[1] is the array of image names
                })
                .then(docRef => {
                    console.log("Document written with ID: ", docRef.id);
                    alert(`New test: ` + this.title + ` saved!`)
                })
                .catch(error => {
                    console.error("Error adding document: ", error);
                });
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
         $(document).ready(function() {
            $('.collapsible').collapsible();
        });
    }
}


</script>