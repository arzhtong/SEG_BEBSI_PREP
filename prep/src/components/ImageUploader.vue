<template>
    <div class="row">
        <!-- Spinner that displays during image upload -->
        <div v-if="uploading && !uploadEnd" id="loader">
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
        <!-- Display image and delete button after upload -->
        <div class="float: left">
            <div>
                <img 
                :src="downloadURL"
                width="100%" 
                style="max-height: 150px; max-width: 150px;"/>
                <!-- Wrapper to use custom upload button -->
                <div v-if="!uploadEnd && !uploading" class="upload-btn-wrapper">
                    <a class="waves-effect waves-light btn" onclick="document.getElementById('fileButton').click()"><i class="material-icons left">add</i>Upload image</a>
                    <input type="file" value="uplaod" id="fileButton" @change="upload">
                </div> 
            </div>
            <div class="center">
                <a v-if="uploadEnd" class="waves-effect waves-light btn red" @click="deleteImage()">delete</a>
            </div>
        </div>
    </div>
</template>

<script>
import db from "./firebaseInit";
import firebase from "firebase";

export default {
    name: 'imageUploader',

    data() {
        return {
            selectedFile: null,
            uploadPercentage: 0,
            uploading: false,
            uploadEnd: false,
            uploadTask: '',
            fileName: '',
            downloadURL: ''
        }
    },
    methods: {
        upload(event) {
            this.selectedFile = event.target.files[0];
            this.fileName = this.selectedFile.name
            let fileExtension = this.fileName.split('.')[this.fileName.split('.').length - 1].toLowerCase();
            let fileSize = this.selectedFile.size;
            let mbSize = (fileSize / 1048576).toFixed(2);

            // check the file for format and size 
            if (!(fileExtension === "jpg" || fileExtension === "png" || fileExtension === "gif") || fileSize > 1048576) { 
                let txt = "File type : " + fileExtension + "\n\n";
                txt += "Size: " + mbSize + " MB \n\n";
                txt += "Please make sure your file is in jpg, png or gif format and less than 1 MB.\n\n";
                alert(txt);
            } else {
                this.uploading = true
                this.uploadTask = firebase.storage().ref('images/' + this.fileName).put(this.selectedFile);
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
        }
    },
    watch: {
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
                this.downloadURL = downloadURL
                this.$emit('downloadURL', downloadURL)
                })
            });
        }
    }
}
</script>

<style scoped>
.upload-btn-wrapper {
  position: relative;
  overflow: hidden;
  display: inline-block;
  cursor: pointer;
}

.upload-btn-wrapper input[type=file] {
  font-size: 100px;
  position: absolute;
  left: 0;
  top: 0;
  opacity: 0;
  cursor: pointer;
}
</style>
