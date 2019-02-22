<template>
    <div id="view-staff">
        <div class="container" style="width:100%;height:100%">
        <table class="collection with-header responsive-table" style="background: white;margin-top:10%;width:100%;height:auto">
        <thead class="collection-header">
            <h4 style="padding:20px;font-size:3em;"><b>Staff</b></h4>
            
            

          <tr style="font-size:1.5em">
              <th style="padding: 20px;">Role</th>
              <th>Email</th>
              <th>Name</th>
              <th>Department</th>
              <th></th>
          </tr>
        </thead>

        <tbody v-for="user in users" v-bind:key="user.email" class="collection-item" >
          <tr>
            <td style="padding: 20px;">{{user.role}}</td>
            <td>{{user.email}}</td>
            <td>{{user.name}}</td>
            <td>{{user.dept}}</td>
            <td><router-link v-bind:to="{name: 'edit-employee', params: {email: user.email}}" class="secondary-content left">
                    <button class="btn blue" style="position:relative;text-align:center;">edit</button>
                </router-link>
            </td>
            <td><button class="btn red" >Delete</button></td>
          </tr>
        </tbody>
        <router-link to="/register" class="btn green" style="margin:20px">
            Add Staff
        </router-link>
      </table>
      </div>

    </div>
</template>

<script>
    import db from '../firebaseInit'
    import firebase from 'firebase'

    export default{
        name: 'view-staff',
        data() {
            return {
                users: [],
                isAdmin: null
            }
        },
        created () {
            if(firebase.auth().currentUser) {
                db.collection('users').where('email', '==', firebase.auth().currentUser.email).get().then(querySnapshot => {
                    querySnapshot.forEach(user => {
                        this.isAdmin = user.data().role
                    })
                })
            }
            db.collection('users').where('email', '<', '\uf8ff').get().then(querySnapshot => {
                    querySnapshot.forEach(user => {
                        const data = {
                        'email': user.data().email,
                        'name': user.data().name,
                        'dept': user.data().dept,
                        'role': user.data().role
                        }
                    this.users.push(data)
                })
            })

        }
    }
</script>

<style>

</style>
