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
                        <input type="text" v-model="daysBeforeTest" required>
                    </div>
               </div>

               <button @click="addInstruction" class="btn green">new instruction</button>
        <div class="row">
          <div v-for="instr in allInstr.length" v-bind:key="instr" class="input-field col s12">
            <span>Instruction</span>
            <input type="text" v-model="allInstr[instr - 1]" required>   
            <button @click="deleteInstruction(instr -1)" class="btn red">remove instruction</button>
          </div>
        </div>
                <button type="submit" class="btn">Submit</button>
                
            </form>
       </div>
                
    </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "edit-dailycheckups",
  data() {
    return {
      title: null,
      allInstr: [],
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
        });
      });
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
    updateDailyCheckups() {
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
                daysBeforeTest:Number(this.daysBeforeTest)
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
    addInstruction() {
      const data = "";
      this.allInstr.push(data);
    },
    deleteInstruction(index) {
      this.allInstr.splice(index, 1);
    }
  }
};
</script>


