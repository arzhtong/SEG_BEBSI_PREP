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
        </div>
    </div>
</template>

<script>
import db from "./firebaseInit";
import firebase from "firebase";
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';

export default {
    name: 'mainScreen',
    data() {
        return {
            title: '',
            editor: ClassicEditor,
            editorData: '',
            editorConfig: {
                // The configuration of the editor.
            }
        };
    },
    methods: {
        saveData() {
            alert(this.title + this.editorData);
        }
    }
}
</script>

<style>
.ck-editor__editable {
    min-height: 50vh;
}
</style>

