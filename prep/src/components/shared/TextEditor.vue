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
            <label style="font-size:25px">Saving file... {{uploadPercentage}}%</label>
        </div>
    </div>

    <div id="app">
        <vue-editor id="editor"
        useCustomImageHandler
        @imageAdded="handleImageAdded" 
        v-model="htmlForEditor"
        :editorToolbar="customToolbar">
        </vue-editor>
    </div>
    <!-- <div class="center-align">
        <a class="btn green" @click="saveEditorData">Done</a>
    </div> -->
</div>
</template>
 
<script>
import { VueEditor } from 'vue2-editor';
import firebase from "firebase";

export default {
    props: ["editorInformation", "editorImages"],
    data() {
        return {
            htmlForEditor: '',
            images: [],
            editor: '',
            cursorLocation: '',
            uploadPercentage: 0,
            uploading: false,
            uploadEnd: false,
            uploadTask: '',
            fileName: '',
            customToolbar: [
            [{ 'header': [false, 1, 2, 3] }],
            ['bold', 'italic', 'underline', 'strike'],
            ['blockquote', 'code-block'],
            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
            [{ 'indent': '-1'}, { 'indent': '+1' }],
            ['link', 'image', 'formula']
          ]
        }
    },
    components: {
        VueEditor
    },
    // load any editor information provided in the props 
    mounted() {
        if(this.editorInformation !== '') {
            this.htmlForEditor = this.editorInformation
        }
        if (this.editorImages !== undefined && this.editorImages !== '') {
            this.images = this.editorImages
        }
    },
    methods: {
        handleImageAdded: function(file, Editor, cursorLocation, resetUploader) {
            
            this.editor = Editor;
            this.cursorLocation = cursorLocation;
            this.fileName = file.name;
            let fileExtension = this.fileName.split('.')[this.fileName.split('.').length - 1].toLowerCase();
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
                this.uploadTask = firebase.storage().ref('images/' + this.fileName).put(file)
            }
        },
        saveEditorData() {
            this.uploading = true
            this.deleteImages()
            this.uploading = false
            // this.$emit('editorData', [this.htmlForEditor, this.images])
        },
        deleteImages() {
            let temp = []
            if(!(this.images === undefined || this.images.length == 0)) {
                // check if any images have been removed from the editor
                for (var i = 0; i < this.images.length; i++) { 
                    if(this.htmlForEditor.indexOf(this.images[i]) < 0) {
                        // delete if they have been removed
                        firebase.storage().ref('images/' + this.images[i]).delete().then(() => {
                        })
                        .catch((error) => {
                            console.error(`file delete error occured: ${error}`)
                        })
                    } else {
                        temp.push(this.images[i])
                    }
                };
            }
            // update images array
            this.images = temp
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
                this.images.push(this.fileName);
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