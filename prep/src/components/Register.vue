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
                                <input type="text" name="email" id="email" v-model="email">
                                <label class="blue-text" for="email">Email</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">lock</i>
                                <input type="password" name="password" id="password" v-model="password">
                                <label class="blue-text" for="password">Password</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">face</i>
                                <input type="text" name="first" id="first" v-model="name">
                                <label class="blue-text" for="name">Name</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">assignment</i>
                                <input type="text" name="department" id="department" v-model="dept">
                                <label class="blue-text" for="dept">Department</label>
                            </div>
                            <div class="input-field">
                                <i class="material-icons prefix">perm_identity</i>
                                <input type="text" name="role" id="role" v-model="role">
                                <label class="blue-text" for="role">Role</label>
                            </div>
                        <button v-on:click="register" type="submit" class="btn btn-large blue lighten-2 black-text">Register</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import firebase from 'firebase'
import db from './firebaseInit'

export default {
    name: 'register',
    data: function() {
        return{
            email: '',
            password: '',
            name: null,
            dept: null,
            role: null
        }
    },
    methods: {
        register: function(e) {
            firebase.auth()
                .createUserWithEmailAndPassword(this.email, this.password)
                .then(
                    user => {
                        db.collection('users').add({
                            email: this.email,
                            name: this.name,
                            dept: this.dept,
                            role: this.role
                        })
                        .then(userRef => {
                            alert(`Registration Successful!`)
                            this.$router.go({path: this.$router.path})
                        })
                        .catch(error => console.log(err))
                    },
                    err => {
                        alert(err.message);
                    }
                )
            e.preventDefault();
        
        },
       
    }
}
</script>
