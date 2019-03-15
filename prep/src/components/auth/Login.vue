<template>
  <div>
    <div class="container" style="padding-top:10em">
      <div class="row">
        <div class="col s12 m8 offset-m2">
          <div class="login card-panel white blue-text center">
            <h3>Login</h3>
            <form>
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

              <button v-on:click="login" class="btn btn-large blue lighten-2 black-text">Login</button>
              <router-link to="/resetPassword" style="margin-left:50px;">Forgot Password?</router-link>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from "firebase";

export default {
  name: "login",
  data: function() {
    return {
      email: "",
      password: ""
    };
  },
  methods: {
    /*
    Verify the user by sending a request to the firestore
    and create a new Session.
   */
    login: function(e) {
      firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
      firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .then(
          user => {
            this.$router.go({ path: this.$router.path });
          },
          err => {
            alert(err.message);
          }
        );
      e.preventDefault();
    }
  }
};
</script>
<style>
body {
  background: #007bff;
  background: linear-gradient(to right, #4b0082, #0062e6);
  margin: 0;
  position: relative;
  top: 50%;
  left: 7%;
  overflow: hidden;
}
</style>
