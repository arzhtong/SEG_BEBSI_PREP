<template>
<div>
    <div class="loaderWrapper">
        <!-- Spinner that displays during image upload -->
        <div v-if="uploading" id="loader">
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
            <label style="font-size:25px">Uploading file... {{uploadPercentage}}%</label>
        </div>
    </div>

    <div id="app">
        <vue-editor id="editor"
        useCustomImageHandler
        @imageAdded="handleImageAdded" v-model="htmlForEditor">
        </vue-editor>
    </div>
    <div class="center-align">
        <a class="btn green" @click="saveEditorData">Done</a>
    </div>
</div>
</template>
 
<script>
import { VueEditor } from 'vue2-editor';
import firebase from "firebase";

export default {
    data() {
        return {
            htmlForEditor: '',
            editor: '',
            cursorLocation: '',
            uploadPercentage: 0,
            uploading: false,
            uploadEnd: false,
            uploadTask: ''  
        }
    },
    components: {
        VueEditor
    },
 
    methods: {
        handleImageAdded: function(file, Editor, cursorLocation, resetUploader) {
            
            this.editor = Editor;
            this.cursorLocation = cursorLocation;
            let fileName = file.name;
            let fileExtension = fileName.split('.')[fileName.split('.').length - 1].toLowerCase();
            let fileSize = file.size;
            let mbSize = (fileSize / 1048576).toFixed(2);

            // stop upload if wrong format or size 
            if (!(fileExtension === "jpg" || fileExtension === "png" || fileExtension === "gif") || fileSize > 1048576) { 
                let txt = "File type : " + fileExtension + "\n\n";
                txt += "Size: " + mbSize + " MB \n\n";
                txt += "Please make sure your file is in jpg, png or gif format and less than 1 MB.\n\n";
                alert(txt);
            } else { // add image to images/ folder on firebase
                this.uploading = true
                this.uploadTask = firebase.storage().ref('images/' + fileName).put(file);
            }
        },
        deleteImage() {
            firebase.storage().ref('images/' + this.fileName).delete().then(() => {
                this.uploading = false
                this.uploadEnd = false
                this.uploadPercentage = 0
                this.downloadURL = ''
            })
            .catch((error) => {
                console.error(`file delete error occured: ${error}`)
            })
        },
        saveEditorData() {
            this.$emit('editorData', this.htmlForEditor)
        }
    },
    watch: {
        // triggered on image upload
        uploadTask: function() {
            this.uploadTask.on('state_changed', snapshot => {
                var progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                this.uploadPercentage = progress;
            },

            (error) => {
                console.error(`file upload error occured: ${error}`)
            },
            
            () => {
                this.uploadTask.snapshot.ref.getDownloadURL().then(downloadURL => {
                this.uploadEnd = true
                this.uploading = false
                this.editor.insertEmbed(this.cursorLocation, 'image', downloadURL) // place in editor
                })
            });
        }
    }
}
</script> 

<style scoped>

.center-align {
    padding-top: 5px;
}
#app {
    background-color: white;
}

.loaderWrapper {
    height: 90px;
}

</style>