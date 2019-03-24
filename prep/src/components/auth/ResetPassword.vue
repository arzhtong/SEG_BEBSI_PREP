<template>
  <div>
    <div class="container" style="padding-top:10em">
      <div class="row">
        <div class="col s12 m8 offset-m2">
          <div class="login card-panel white blue-text center">
            <h3>Reset Password</h3>
            <div class="input-field">
              <i class="material-icons prefix">email</i>
              <input type="text" name="email" id="email">
              <label class="blue-text" for="email">Email</label>
            </div>
            <router-link id="backToLoginBtn" to="/login" style="margin-right:50px;">Back to Login</router-link>
            <button
              id="resetPassBtn"
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
import { authMixin } from "../../mixins/authMixin/authMixin";
export default {
  name: "resetPassword",
  mixins: [authMixin]
};
</script>
<style>
body {
  background: #007bff;
  background: linear-gradient(to right, #4b0082, #0062e6);
}
</style>
