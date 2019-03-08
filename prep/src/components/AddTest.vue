<template>
    <div id="mainScreen">
      <h3>New Test</h3>
      <div class="row">
        <form @submit.prevent="" class="col s12">
          <div class="row">
            <div class="input-field col s12">
              <input type="text" v-model="title">
              <label>Title</label>
            </div>
          </div>
        </form>
        </div>

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
            alert(information)
            //information - from the text editor
            // save this to firebase here
        }
    }
}


</script>

<style scoped>

#imageWrapper {
    background: lightblue;
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

