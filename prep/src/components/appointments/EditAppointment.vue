<template>
   <div id="edit-appointment" style="background-color:white" >
       <h3>Edit Appointment</h3>
    <div class="row">
      <form @submit.prevent="updateAppointment" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <p>Mobile Code:</p>
            <input type="text"  v-model="code" disabled required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Date:</p>
            <input type="date" class="datepicker" v-model="date" required>
            
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Time:</p>
            <input type="time" class="timepicker" v-model="time" required>
           
          </div>
        </div>
        
        <div class="row">
          <div class="input-field col s12">
            <p>Location:</p>
            <input type="text" v-model="location" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Change Referenced Test: </p> 
            <select class="browser-default" style="color:black" v-model="testID">
              <option v-for="test in tests" v-bind:key="test.testID" :value="test">{{test.title}}</option>
            </select>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Change Referenced Staff: </p> 
            <select class="browser-default" style="color:black" v-model="staffMember">
              <option v-for="user in users" v-bind:key="user.Ucode" :value="user">{{user.name}}</option>
            </select>
          </div>
        </div>

        
        <button type="submit" class="btn">Submit</button>
        <router-link to="/view-appointments" class="btn grey">Cancel</router-link>
      
      </form>
    </div>
    <br>
   </div>
</template>

<script>
import db from "../firebaseInit"; 
export default {
    name: 'edit-appointment',
    data(){
        return{
           date: "",
           time: "",
           code:null,
           location:null,
           testID:null,
           staffMember:null,
           tests:[],
           users:[]
           
        }
    },
    created(){
       db.collection("tests").get().then(querySnapshot => {
        querySnapshot.forEach(test => {
          const data = {
            testID: test.data().testID,
            title: test.data().title,
            type: test.data().type
          }
          this.tests.push(data);
        })
      }),
      db.collection("users").get().then(querySnapshot => {
        querySnapshot.forEach(user => {
          const data = {
            dept: user.data().dept,
            email: user.data().email,
            name: user.data().name,
            role: user.data().role,
            Ucode:user.id
          }
          this.users.push(data);
        })
      })
    },
    beforeRouteEnter(to, from, next) {
       
    db.collection("appointments").where("location", '==', to.params.id).get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          
          next(vm => {      
            vm.date=doc.data().datetime.toDate().toISOString().split('T')[0]
            vm.time=doc.data().datetime.toDate().toTimeString().split(' ')[0]
            vm.location = doc.data().location
            vm.testID=doc.data().testID
            vm.staffMember=doc.data().staffMember
            vm.code=doc.id           
          })
        })
      })
      
  },
  watch: {
    $route: "fetchData"
  },
  methods: {
    fetchData() {
      db.collection("appointments").where("location", '==', this.$route.params.id).get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.location = doc.data().location
            this.datetime=doc.data().datetime.toDate()
            this.testID=doc.data().testID
            this.staffMember=doc.data().staffMember
            this.code = doc.id
          })
        })
    },
    updateAppointment() {
      db.collection("appointments").where("location", '==', this.$route.params.id).get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                location: this.location,
                testID:this.testID.testID,
                code: this.code,
                staffMember:this.staffMember.Ucode
              })
              .then(() => {
                alert('Appointments info updated!')
                this.$router.push("/view-appointment")
              })
              .catch(error => console.log(err));
          })
        })
    }
  }
}
</script>
<style>
p{
  color: #2196f3;
}
h3{
  font-weight: bold;
  margin-left: 20px;
}
</style>
