<template>
    <div class="navbar-fixed">
        <nav v-if="isLoggedIn">
            <div class="nav-wrapper white">
                <router-link to="/" class="brand-logo left" id="logo">Prep</router-link>
            
                    <ul>
                        <li class="right"><button v-on:click="logout" class="btn red" style="margin-left: 10px">Logout</button></li>
                    </ul>
            
            </div>
        </nav>
    </div>
</template>

<script>
import firebase from "firebase";
import db from "./firebaseInit";

export default {
  name: "navbar",
  data() {
    return {
      isLoggedIn: false,
      currentUser: false,
      isAdmin: null,
      users: []
    };
  },
  created() {
    if (firebase.auth().currentUser) {
      this.isLoggedIn = true;
      this.currentUser = firebase.auth().currentUser.email;

      db.collection("users")
        .where("email", "==", firebase.auth().currentUser.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(user => {
            const data = {
              email: user.data().email,
              dept: user.data().dept,
              role: user.data().role
            };
            this.users.push(data);
            this.isAdmin = user.data().role;
          });
        });
    }
  },
  methods: {
    logout: function() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.$router.go({ path: this.$router.path });
        });
    }
  }
};
</script>

<style>
span {
  margin-right: 10px;
}
li {
  position: left;
}


.right {
    padding-right: 30px;
}

#logo{
    margin-left: 10px;
    font-size: 2.5em;
    font-weight: bold;

}
.router {
  margin-left: 120px !important;
  font-size: 20px !important;
  color: #999999;
  font-weight: bold;
}
.menuItem {
  font-size: 20px !important;
  color: #999999 !important;
  font-weight: bold !important;
}

.btn-rout {
  width: 60%;
}
.brand-logo {
  color: #4b0082 !important;
}
</style>