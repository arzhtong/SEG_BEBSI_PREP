<template>
   <div id="edit-appointment" style="background-color:white">
       <h3>Edit Appointment</h3>
    <div class="row">
      <form @submit.prevent="updateAppointment" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="date"  v-model="datetime" required>
          </div>
        </div>
        
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="location" required>
          </div>
        </div>
        
        <button type="submit" class="btn">Submit</button>
        <router-link to="/view-appointments" class="btn grey">Cancel</router-link>
      </form>
    </div>
   </div>
</template>

<script>
import db from "../firebaseInit"; 
export default {
    name: 'edit-appointment',
    data(){
        return{
           code:null,
           location:null,
           datetime:null,
           
        }
    },
    beforeRouteEnter(to, from, next) {
    
    db.collection("appointments").where(FieldPath.documentId(), "==", this.$route.params.id).get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          next(vm => {
            vm.location = doc.data().location
            vm.datetime=doc.data().datetime.toDate()
            vm.code = doc.data().id
            
          })
        })
      })
      
  },

  methods: {
    fetchData() {
      db.collection("appointments").get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.location = doc.data().location
            this.datetime=doc.data().datetime
            this.code = doc.data().id
          });
        });
    },
    updateAppointment() {
      db.collection("appointments")
        .where("code", "==", this.$route.params.code)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                location: this.location,
                datetime:this.datetime,
                code: this.code
              })
              .then(() => {
                alert('Appointments info updated!')
                this.$router.push("/view-appointment");
              });
          });
        });
    }
  }
}
</script>

