<template>
    <div>
        <div class="container" style="padding-top:10em">
            <div class="row">
                <div class="col s12 m8 offset-m2">
                    <div class="login card-panel white blue-text center">
                        <h3>Register</h3>
                        <form @submit.prevent="saveUser">
                            <div class="input-field">
                                <i class="material-icons prefix">email</i>
                                <input type="text" name="email" id="email" v-model="email" required>
                                <label class="blue-text" for="email">Email</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">lock</i>
                                <input type="password" name="password" id="password" v-model="password" required>
                                <label class="blue-text" for="password">Password</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">face</i>
                                <input type="text" name="first" id="first" v-model="name" required>
                                <label class="blue-text" for="name">Name</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">assignment</i>
                                <input type="text" name="department" id="department" v-model="dept" required>
                                <label class="blue-text" for="dept">Department</label>
                            </div>
                            
                            <div class="input-field"> 
                                
                                <p style="margin-right: 100%">  
                                <i style="margin-left:8px" class="material-icons prefix blue-text">assignment_ind</i>     
                            <label style="border-bottom:1px solid #9e9e9e;">   
                                <input id="check" type="checkbox" class="filled-in" style="margin-top:10px" />
                                <span class="blue-text" style="margin-top:10px">Admin</span>
                            </label>
                            </p>
                            </div>
                        
                        <button style="margin-top:70px" v-on:click="register" type="submit" class="btn btn-large blue lighten-2 black-text">Register</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import firebase from 'firebase'
import db from '../firebaseInit'

export default {
    name: 'register',
    data: function() {
        return{
            email: '',
            password: '',
            name: null,
            dept: null,
            role: 'Staff'
        }
    },
    methods: {
        /*
            This function creates a new user on firestore as well
            as google authentication service
        */
        register: function(e) {
            if(this.name != null && this.dept != null && this.role != null){
                firebase.auth()
                    .createUserWithEmailAndPassword(this.email, this.password)
                    .then(
                        user => {
                            if(document.getElementById("check").checked){
                                this.role = 'Admin'
                            }
                            db.collection('users').add({
                                email: this.email.toLowerCase(),
                                name: this.name,
                                dept: this.dept,
                                role: this.role
                            })
                            .then(userRef => {
                                alert(`Registration Successful!`)
                                window.location.href = '/';
                            })
                            .catch(error => console.log(err))
                        },
                        err => {
                            alert(err.message);
                        }
                    )
                e.preventDefault();
            }
        },
       
    }
}
</script>
