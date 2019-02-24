<template>
  <div>
    <div class="container" style="padding-top:10em">
      <div class="row">
        <div class="col s12 m8 offset-m2">
          <div class="login card-panel white blue-text center">
            <h3>ResetPassword</h3>
            <div class="input-field">
              <i class="material-icons prefix">email</i>
              <input type="text" name="email" id="email">
              <label class="blue-text" for="email">Email</label>
            </div>
            <router-link to="/login" style="margin-right:100px;">Back to Login</router-link>
            <button
              @click="sendResetEmail"
              class="btn btn-large blue lighten-2 black-text"
            >Reset Password</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from "firebase";

export default {
  name: "resetPassword",
  data: function() {
    return {
      email: ""
    };
  },
  methods: {
    sendResetEmail: function(e) {
      var email = document.getElementById("email").value;
      firebase
        .auth()
        .sendPasswordResetEmail(email)
        .then(function() {
          // Password reset email sent.
          alert(`Password email has been sent to ${email}`);
          window.location.href = '/';
        })
        .catch(function(error) {
          // Error occurred. Inspect error.code.
          alert(error);
        });
    }
  }
};
</script>
<style>
body {
  background: #007bff;
  background: linear-gradient(to right, #4b0082, #0062e6);
}
</style>
