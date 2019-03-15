<template>
  <div id="view-staff">
    <div class="container" style="width:100%;height:100%">
      <table
        class="collection with-header responsive-table"
        style="background: white;width:100%;height:auto"
      >
        <thead class="collection-header">
          <h4 style="padding:20px;font-size:3em;">
            <b>Staff</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Role</th>
            <th>Email</th>
            <th>Name</th>
            <th>Department</th>
            <th></th>
          </tr>
        </thead>

        <tbody v-for="user in users" v-bind:key="user.email" class="collection-item">
          <tr>
            <td style="padding: 20px;">
              {{user.role}}
              <i class="material-icons" v-if="user.email == currentEmail">accessibility_new</i>
            </td>
            <td>{{user.email}}</td>
            <td>{{user.name}}</td>
            <td>{{user.dept}}</td>
            <td>
              <router-link
                v-bind:to="{name: 'edit-staff', params: {email: user.email}}"
                class="secondary-content left">
                <button
                  v-if="user.email == currentEmail || user.role != 'Admin'"
                  class="btn blue"
                  style="position:relative;text-align:center;"
                >edit</button>
              </router-link>
            </td>
            <td>
              <button
                v-if="user.role != 'Admin'"
                class="btn red"
                @click="deleteUser(user.email)"
              >Delete</button>
            </td>
          </tr>
        </tbody>
        <router-link to="/register" class="btn green" style="margin:20px">Add Staff</router-link>
      </table>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "view-staff",
  data() {
    return {
      users: [],
      isAdmin: null,
      currentEmail: null
    };
  },
  created() {
    /*
      Get the information specifically for the
      currently logged in user.
    */
    if (firebase.auth().currentUser) {
      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(user => {
            this.isAdmin = user.data().role;
            this.currentEmail = user.data().email;
          });
        });
    }
    /*
      Get the information for all users in the firestore.
    */
    db.collection("users")
      .where("email", "<", "\uf8ff")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(user => {
          const data = {
            email: user.data().email,
            name: user.data().name,
            dept: user.data().dept,
            role: user.data().role
          };
          this.users.push(data);
        });
      });
  },
  methods: {
    /*
      This method deletes the clicked user
      from firestore and removes it from the user table.
    */
    deleteUser(userEmail) {
      if (confirm(`Are you sure you want to delete user ${userEmail}`)) {
        db.collection("users")
          .where("email", "==", userEmail)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
              doc.ref
                .delete()
                .then(() => {
                  console.log("Document successfully deleted!");
                  alert(`Successfully deleted user ${userEmail}`);
                  location.reload();
                })
                .catch(function(error) {
                  console.error("Error removing document: ", error);
                  alert(`There was an error: ${error}`);
                });
            });
          });
      }
    }
  }
};
</script>

<style>
</style>
