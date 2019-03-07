<template>
    <div id="mainScreen">
      <h3>New Test</h3>
      <div class="row">
        <form @submit.prevent="" class="col s12">
          <div class="row">
            <div class="input-field col s12">
              <input type="text" v-model="title" required>
              <label>Title</label>
            </div>
          </div>
        <div id="editor">
            <ckeditor :editor="editor" v-model="editorData" :config="editorConfig"></ckeditor>
        </div>
        <button @click="saveData" class="btn">Test</button>
        </form>
        
        <div class="container" id="images">
            <imageUploader />
        </div>
        <div class="container" id="images1">
            <imageUploader />
        </div>
        </div>
    </div>
</template>

<script>
import db from "./firebaseInit";
import firebase from "firebase";
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
import imageUploader from "./ImageUploader";

export default {
    name: 'mainScreen',
    data() {
        return {
            selectedFile: null,
            title: '',
            editor: ClassicEditor,
            editorData: '',
            editorConfig: {
                // The configuration of the editor.
                // removePlugins: [ 'Heading', 'Link' ]

            }
        };
    },
    components: {
        imageUploader
    },
    methods: {
        saveData() {
            alert(this.title + this.editorData);
        },
        onFileSelected(event) {
            this.selectedFile = event.target.files[0]
            firebase.storage().ref('test_images/' + this.selectedFile.name).put(this.selectedFile)
        }

    }
}


</script>

<style>
.ck-editor__editable {
    min-height: 50vh;
}
</style>

