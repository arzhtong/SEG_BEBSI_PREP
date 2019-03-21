import db from "../../components/firebaseInit";
import firebase from "firebase";

export const editdailycheckupsMixin = {
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