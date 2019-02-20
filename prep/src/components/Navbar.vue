<template>
    <nav v-if="isLoggedIn">
        <div class="nav-wrapper blue">
            <div class="container">
                <router-link to="/" class="brand-logo">Prep</router-link>
                <ul class="right">
                    <li><span class="email black-text" v-for="user in users" v-bind:key="user.role">{{user.role}} : </span></li>
                    <li><span class="email black-text">{{currentUser}}</span></li>
                    <li><router-link to="/">Dashboard</router-link></li>
                    <li v-if="isAdmin == 'admin' || isAdmin == 'Admin'"><router-link to="/register">Register</router-link></li>
                    <li><button v-on:click="logout" class="btn red">Logout</button></li>
                </ul>
            </div>
        </div>
    </nav>
</template>

<script>
import firebase from 'firebase'
import db from './firebaseInit'

export default {
    name: 'navbar',
    data() {
        return {
            isLoggedIn: false,
            currentUser: false,
            isAdmin: false,
            users: []
        }
    },
    created(){
        if(firebase.auth().currentUser) {
            this.isLoggedIn = true
            this.currentUser = firebase.auth().currentUser.email

            db.collection('users').where('email', '==', firebase.auth().currentUser.email).get().then(querySnapshot => {
                querySnapshot.forEach(user => {
                    const data = {
                        'email': user.data().email,
                        'dept': user.data().dept,
                        'role': user.data().role
                    }
                    this.users.push(data)
                    this.isAdmin = user.data().role
                })
            })
        }
    },
    methods: {
        logout: function() {
            firebase.auth().signOut().then(() => {
                this.$router.go({path: this.$router.path})
            })
        }
    }
}
</script>