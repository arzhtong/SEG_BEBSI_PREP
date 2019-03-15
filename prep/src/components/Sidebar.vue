<template>
    <div v-if="isLoggedIn">
        <div class="col s0 m0 l2">
            <ul id="slide-out" class="sidenav sidenav-fixed">
                
                <div id="user">
                    
                    <li><span id="role" class="email black-text" v-for="user in users" v-bind:key="user.role"> 
                            {{user.role}} 
                            <router-link id="settings" v-bind:to="{name: 'edit-staff', params: {email: user.email}}"><i class="fa fa-cog right"></i></router-link>
                        </span>
                    </li>
                    <li><span id="email" class="email black-text"> {{currentUser}}</span></li>
                </div>
                <li><div class="divider"></div></li>
                <li><router-link to="/view-appointments" class="menuItem" exact-active-class="exact active" exact>Current Appointments</router-link></li>
                <li><router-link to="/past-appointments" class="menuItem" exact-active-class="exact active" exact>Past Appointments</router-link></li>
                <li><router-link v-if="isAdmin == 'Admin'" to="/view-staff" class="menuItem" exact-active-class="exact active" exact>Staff</router-link></li>
                <li><router-link to="/view-tests" class="menuItem" exact-active-class="exact active" exact>Tests</router-link></li>
                <li><router-link to="/add-appointment" class="waves-effect waves-light btn red">Add Appointment</router-link></li>
            </ul>

            <a href="#" data-target="slide-out" class="sidenav-trigger"><i class="material-icons">menu</i></a>
        
        </div>
    </div>
</template>

<script>
import firebase from 'firebase'
import db from './firebaseInit'

export default {
    name: 'sidebar',
    data () {
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
    mounted() {
        M.AutoInit();
    }
}

</script>

<style>
.menuItem:hover,
.menuItem.router-link-active,
.menuItem.router-link-exact-active {
    cursor: pointer;
    background-color: rgb(240, 240, 240); 
    
}

.sidenav-trigger {
    color: white;
}

#settings {
    font-size: 20px;
    color: darkgrey;
}

#central {
    padding-left: 85px;
}

#slide-out {
    width: 270px;
    overflow: hidden;
    margin-top: 65px;
}

#user {
    text-align: center;
    padding-top: 30px;
    padding-bottom: 30px;
}

#role {
    text-align: center;
    font-size: 2em;
    font-weight: bold;
}
</style>


