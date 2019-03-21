import db from "../../components/firebaseInit";
import firebase from "firebase";

export const viewdailycheckupsInfoMixin = {
    data() {
        return {
          daily_id:'',
          title: '',
          instructions: [],
          description: null,
          daysBeforeTest: null,
          code: null,
          test_id: this.$route.params.test_id
        };
      },
      created(){
        this.title=this.$route.params.daily_id
      },
      beforeRouteEnter(to, from, next) {
        db.collection("tests")
          .doc(to.params.test_id)
          .collection("dailyCheckups")
          .where("title", "==", to.params.daily_id)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
              next(vm => {
                vm.code = doc.id;
                vm.title = doc.data().title;
                vm.instructions = doc.data().instructions;
                vm.daysBeforeTest = doc.data().daysBeforeTest;
                vm.description = doc.data().description;
              });
            });
          });
      },
      watch: {
        $route: "fetchData"
      },
      methods: {
        /*
          This method get fields' data from firestore and assign
          it to the variables.
        */
        fetchData() {
          db.collection("tests")
            .doc(this.$route.params.test_id)
            .collection("dailyCheckups")
            .where("title", "==", this.$route.params.daily_id)
            .get()
            .then(querySnapshot => {
              querySnapshot.forEach(doc => {
    
                this.code = doc.id;
                this.title = doc.data().title;
                this.instructions = doc.data().instructions;
                this.description = doc.data().description;
                this.daysBeforeTest = doc.data().daysBeforeTest;
              })
            })
           
    
        },
        /*
          This method is used for deleting the daily checkups and 
          pops up an alert window for checking.
        */
        deleteDailyCheckups() {
          if (confirm("Are you sure you want to delete this Daily Checkup?")) {
            db.collection("tests")
              .doc(this.$route.params.test_id)
              .collection("dailyCheckups")
              .where("title", "==", this.$route.params.daily_id)
              .get()
              .then(querySnapshot => {
                querySnapshot.forEach(doc => {
                  doc.ref
                    .delete()
                    .then(() => {
                      console.log("Document successfully deleted!");
                      alert(`Successfully deleted Daily Checkup!`);
                      location.reload();
                    })
                    .catch(function(error) {
                      console.error("Error removing document: ", error);
                      alert(`There was an error: ${error}`);
                    });
                });
              });
          }
        }
}
};