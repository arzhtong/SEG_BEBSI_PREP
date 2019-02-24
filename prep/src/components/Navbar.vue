<template>
    <nav v-if="isLoggedIn">
        <div class="nav-wrapper white">
            <router-link to="/" class="brand-logo left" id="logo">Prep</router-link>
         
                
                <ul>
                    <li class="right"><button v-on:click="logout" class="btn red" style="margin-left: 10px">Logout</button></li>
                    <li class="right"><span class="email black-text"><b>Account:</b> {{currentUser}}</span></li>
                    <li class="right"><span class="email black-text" v-for="user in users" v-bind:key="user.role"><b>Role:</b> {{user.role}} </span></li>
                    <li><router-link to="/" class="router .btn-rout">Dashboard</router-link></li>
                    <li><router-link to="/view-appointment" class=".btn-rout menuItem">Appointments</router-link></li>
                    <li><router-link v-if="isAdmin == 'admin' || isAdmin == 'Admin'" to="/view-staff" class=".btn-rout menuItem">Staff</router-link></li>
                    <li><router-link to="/" class=".btn-rout menuItem">Tests</router-link></li>
                </ul>
          
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
            isAdmin: null,
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

<style>
span {
    margin-right: 10px;
}
li{
    position: left;
}

#logo{
    margin-left: 10px;
    font-size: 2.5em;
    font-weight: bold;
}
.router {
    margin-left: 120px !important;
    font-size: 20px !important;
    color:#999999;
    font-weight: bold;
}
.menuItem{
    font-size: 20px !important;
    color:#999999 !important;
    font-weight: bold !important;
}

.btn-rout {width:60%;}
.brand-logo{
    color: #4b0082 !important;
}
</style>