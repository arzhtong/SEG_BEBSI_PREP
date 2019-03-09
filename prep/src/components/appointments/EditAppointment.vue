<template>
   <div id="edit-appointment"  style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px" >
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
            <p>Date</p>
            <input type="date" min="2019-01-01" class="datepicker" v-model="date" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Time</p>
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
        <router-link v-bind:to="{name: 'view-appointment', params: {id: router}}" class="btn grey">Cancel</router-link>
      
      </form>
    </div>
    <br>
   </div>
</template>

<script>
import db from "../firebaseInit"; 
import firebase from "firebase";
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
          users:[],
          router: this.$route.params.id
           
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

   db.collection("appointments").doc(to.params.id).get()
     .then(doc => {
       if (doc.exists) {
         next(vm => {
           vm.date=doc.data().datetime.toDate().toISOString().split('T')[0]
           vm.time=doc.data().datetime.toDate().toTimeString().split(' ')[0]
           vm.location = doc.data().location
           vm.testID=doc.data().testID
           vm.staffMember=doc.data().staffMember
           vm.code=doc.id
         })
       }

     })

 },
  watch: {
    $route: "fetchData"
  },
  methods: {
    fetchData(){
         db.collection("appointments").doc(this.$route.params.id).get()
        .then(doc => {
       if (doc.exists) {
         this.location = doc.data().location
         this.datetime=doc.data().datetime
         this.testID=doc.data().testID
         this.staffMember=doc.data().staffMember
         this.code = doc.id
        
       }

     })
    },
    updateAppointment(){
     db.collection("appointments")
       .doc(this.$route.params.id)
       .set({
         location: this.location,
         testID: this.testID.testID,
         datetime: firebase.firestore.Timestamp.fromDate(new Date(Date.parse(this.date + "T" + this.time + "Z"))),
         staffMember: this.staffMember.Ucode
       })
       .then(() => {
         alert("Appointments info updated!")
         this.$router.push("/view-appointments")
       })
       .catch(function(error) {
         console.error("Error writing document: ", error)
       })
     }
    
  }
}
</script>
<style scoped>
p{
  color: #2196f3;
}
h3{
  font-weight: bold;
  margin-left: 20px;
}
</style>
