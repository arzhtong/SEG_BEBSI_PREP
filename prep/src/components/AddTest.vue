<template>
    <div
        id="new-test"
        style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
    >
        <div id="mainScreen">
        <h3>New Test</h3>
            <div class="row">
                <div class="input-field col s12">
                    <input type="text" v-model="title">
                    <label>Title</label>
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
            
            <!-- <div v-for="(input, index) in inputs" :key="index">
                <div v-if="input == 'image'" class="valign-wrapper row" id="imageWrapper">
                    <div class="inline-block left-align col s6" id="images">
                        <imageUploader v-on:downloadURL="testInformation.push($event);"/>
                    </div>
                    <div class="inline-block right-align col s6">
                        <a 
                            class="btn-floating red tooltipped" 
                            data-position="left" 
                            data-tooltip="remove" 
                            id="removeText" 
                            @click="removeInput(index)">
                            <i class="material-icons">clear</i>
                        </a>
                    </div>
                </div>

                <div v-else id="textWrapper">
                    <input type="text" v-model="testInformation[index]">
                    <div class="right-align">
                        <a 
                            class="btn-floating red tooltipped" 
                            data-position="left" 
                            data-tooltip="remove" 
                            id="removeText" 
                            @click="removeInput(index)">
                            <i class="material-icons">clear</i>
                        </a>
                    </div>
                </div>

            </div>

            <div class="valign-wrapper flow">
                <a class="waves-light btn-small" @click="addTextInput">Add text</a>
                <a class="waves-light btn-small" @click="addImageInput">Add image</a>
                <a class="waves-light btn-small" @click="saveData">finished</a>
                <a class="waves-light btn-small">cancle</a>
            </div> -->
            
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
        saveData() {
            alert(this.testInformation[0] + this.testInformation[2]);
            // alert(this.title + this.editorData);
        },
        addImageInput() {
            this.inputs.push('image')
        },
        addTextInput() {
            this.inputs.push('text')
            this.testInformation.push('')
        },
        removeInput(index) {
            this.inputs.splice(index, 1)
            this.testInformation.splice(index, 1)
        },
        saveTest(information) {
            if(this.title.trim() === '') {
                alert('Please enter a title for this test before saving')
            }
            else {
                alert(information)

                // information[0] is the editor text
                // information[1] is the array of image names
            }
            //information - from the text editor
            // save this to firebase here
        }
    },
    mounted() {
         $(document).ready(function() {
            $('.collapsible').collapsible();
        });
    }
}


</script>

<style scoped>

#imageWrapper {
    width: 102%;
}

#textWrapper {
    padding-bottom: 20px;
    padding-top: 10px;
}

.inline-block {
  display: inline-block;
  padding: 10px;
  
}
</style>

