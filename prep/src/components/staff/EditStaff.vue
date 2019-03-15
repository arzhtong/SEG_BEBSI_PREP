<template>
  <div
    id="edit-employee"
    style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <h3>Edit User</h3>
    <div class="row">
      <form @submit.prevent="updateUser" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>Email:</span>
            <input type="text" v-model="email" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Name:</span>
            <input type="text" v-model="name" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Department:</span>
            <input type="text" v-model="dept" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Role:</span>
            <input disabled type="text" v-model="role" required>
          </div>
        </div>
        <button type="submit" class="btn">Submit</button>
        <router-link to="/view-staff" class="btn grey">Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
export default {
  name: "edit-staff",
  data() {
    return {
      email: null,
      name: null,
      dept: null,
      role: null
    };
  },
  /*
    This method is executed before page load,
    in order to fill all the fields with the
    needed user information.
  */
  beforeRouteEnter(to, from, next) {
    db.collection("users")
      .where("email", "==", to.params.email)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          next(vm => {
            vm.email = doc.data().email;
            vm.name = doc.data().name;
            vm.dept = doc.data().dept;
            vm.role = doc.data().role;
          });
        });
      });
  },
  watch: {
    $route: "fetchData"
  },
  methods: {
    /*
      This method gets the currently clicked user information.
    */
    fetchData() {
      db.collection("users")
        .where("email", "==", this.$route.params.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.email = doc.data().employee_id;
            this.name = doc.data().name;
            this.dept = doc.data().dept;
            this.role = doc.data().role;
          });
        });
    },
    /*
      This method updates the user information on
      firestore.
    */
    updateUser() {
      db.collection("users")
        .where("email", "==", this.$route.params.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                email: this.email,
                name: this.name,
                dept: this.dept,
                role: this.role
              })
              .then(() => {
                alert('User info updated!')
                this.$router.push("/view-staff");
              });
          });
        });
    }
  }
};
</script>
  <style>
  span{
      color:#2196f3;
  }
</style>