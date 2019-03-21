import db from "../../components/firebaseInit";
import firebase from "firebase";

export const newdailycheckupsMixin = {
    data() {
        return {
          title: null,
          instructions: [],
    
          description: null,
          daysBeforeTest: null
        };
      },
      methods: {
        /*
          This method creates an empty map which is inserted by the 
          elements from the instructions array. Then assign this map
          to daily checkup's instruction field.
        */
        saveDailyCheckups() {
          var map = {};
          var lastChecked = firebase.firestore.Timestamp.fromDate(
            new Date(Date.now())
          );
          for (var i = 0; i < this.instructions.length; i++) {
            map[i] = { answer: false, question: this.instructions[i].value, lastChecked: lastChecked };
          }
    
          db.collection("tests")
            .doc(this.$route.params.test_id)
            .collection("dailyCheckups")
            .add({
              title: this.title,
              instructions: map,
              description: this.description,
              daysBeforeTest: Number(this.daysBeforeTest)
            })
            .then(docRef => {
              alert("Successfully created new Daily Check-ups!");
              this.$router.push({
                name: "view-dailycheckups",
                params: { test_id: this.$route.params.test_id }
              });
            })
            .catch(error => console.log(err));
        },
        /*
          This method add an instruction as an element of the instructions array.
        */
        addInstruction() {
          const data = { value: "" };
          this.instructions.push(data);
        },
        /*
          This method delete the instruction which added.
        */
        deleteInstruction(index) {
          this.instructions.splice(index, 1);
        }
      }
};