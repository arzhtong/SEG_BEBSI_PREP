<template>
    <div id="edit-dailycheckups" style="background-color:white;padding: 10px 50px 10px 50px; margin-top:10px">
       <h3>Edit Daily Check-ups</h3>

        <div class="row">
            <form @submit.prevent="updateDailyCheckups" class="col s12">
                <div class="row">
                    <div class="input-field col s12">
                        <p>Title</p>
                        <input type="text" v-model="title" required>
                    </div>
               </div>

               <div class="row">
                    <div class="input-field col s12">
                        <p>Description</p>
                        <input type="text" v-model="description" required>
                    </div>
               </div>

               <div class="row">
                    <div class="input-field col s12">
                         <p>Number of Days Before Test:</p>
                        <input type="number" min="0" v-model="daysBeforeTest" required>
                    </div>
               </div>


                <button @click="addInstruction" class="btn green"> Add instruction</button>
                <div class="row">
                    <div v-for="instruction in instructions" v-bind:key="instruction" class="input-field col s12">
                        <input type="text"  v-model="instruction.value" required>
                        <label>Instructions</label>
                        <button class="btn red" @click="deleteAddedInstruction(instructions.indexOf(instruction))"> remove instruction</button>
                    </div>
                </div>

       
                <div class="row">
                  <div v-for="instr in allInstrArray.length" v-bind:key="instr" class="input-field col s12">
                    <span>Instruction</span>
                    <input type="text" v-model="allInstrArray[instr - 1]" required>   
                    <button @click="deleteInstruction(instr -1)" class="btn red">remove instruction</button>
                  </div>
                </div>

                <button type="submit" class="btn">Submit</button>
                <router-link v-bind:to="{name: 'view-dailycheckups-info', params: {test_id:test_id, daily_id:title}}" class="btn grey">
                  Cancel
                </router-link>
                 
            </form>
       </div>
   </div>
</template>

<script>
import db from "../../firebaseInit";
import firebase from "firebase";

export default {
  name: "edit-dailycheckups",
  data() {
    return {
      title: '',
      daily_id:'',
      timeArray:[],
      allInstr: [],
      allInstrArray:[],
      instructions:[],
      description: null,
      daysBeforeTest:null,
      test_id: this.$route.params.test_id,
      daily_id: this.$route.params.daily_id
    };
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("dailyCheckups")
      .where("title", "==", this.$route.params.daily_id)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
                            
            (this.allInstr = doc.data().instructions),
            (this.description = doc.data().description),
            (this.daysBeforeTest = doc.data().daysBeforeTest),
            (this.title = doc.data().title);
        
         for (const [key, value] of Object.entries(this.allInstr)) {
               //convert the elements in insturction field to a new array 
               this.allInstrArray.push(value.question)   
               //convert the last checked time to a new array
               this.timeArray.push(value.lastChecked)    
          }
           
        })
      })
     this.title=this.$route.params.daily_id
  },
  beforeRouteEnter(to, from, next) {
    db.collection("tests")
      .doc(to.params.test_id)
      .collection("dailyCheckups")
      .where("title", "==", to.params.daily_id)
      .get()
      .then(querySnapshot => {
        fetch;
        querySnapshot.forEach(doc => {
          next(vm => {
            vm.title = doc.data().title;
            vm.description = doc.data().description;
            vm.daysBeforeTest=doc.data().daysBeforeTest;
          });
        });
      });
  },
  methods: {
    /*
    This method put all the elements in the array to the 
    instruction map and update all the data in daily checkups.
    */
    updateDailyCheckups() {
       //delete all the elements in instructions.
       for (var member in this.allInstr) delete this.allInstr[member]
       
       //add the original elements to the instruction map 
       for(var i =0 ; i < this.allInstrArray.length; i++){
          this.allInstr[i]={answer:false,lastChecked:this.timeArray[i],question:this.allInstrArray[i]}                   
       }
       
       //get the length of the instruction
       var l=Object.keys(this.allInstr).length
      
       //appending new element to the instruction map
       for(var i =l ; i < this.instructions.length+l; i++){
        this.allInstr[i]={answer:false,lastChecked:firebase.firestore.Timestamp.fromDate(new Date(Math.floor(Date.now()))),
         question:this.instructions[i-l].value}            
        }

      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("dailyCheckups")
        .where("title", "==", this.$route.params.daily_id)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                title: this.title,
                instructions: this.allInstr,
                description: this.description,
                daysBeforeTest:Number(this.daysBeforeTest),
              })
              .then(() => {             
                alert("You have updated the Daily check-ups!");
                this.$router.push({
                  name: "view-dailycheckups",
                  params: {test_id: this.$route.params.test_id }
                });
              });
          });
        });
    },
    /*
      This method add an instruction as an element of the instructions array.
    */
    addInstruction() {
       const data = {value: ''}
       this.instructions.push(data); 
    },
    /*
      This method delete the element in all instruction array.
    */
    deleteInstruction(index) {
       this.allInstrArray.splice(index, 1);
    },
    /*
      This method delete the instruction which added.
    */
    deleteAddedInstruction(index) {
       this.instructions.splice(index, 1);
    }
  }
};
</script>


