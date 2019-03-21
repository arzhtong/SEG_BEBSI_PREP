import db from "../components/firebaseInit";
import firebase from "firebase";

export const viewdailycheckupsMixin ={
    data() {
        return {
            dailyCheckups: [],
            testID: this.$route.params.test_id              
        }
    },
   created () {
        db.collection('tests').doc(this.$route.params.test_id).collection('dailyCheckups').orderBy('daysBeforeTest','desc').get().then(querySnapshot => {
            querySnapshot.forEach(doc => {
                const data = {
                    'id': doc.id,
                    'daysBeforeTest':doc.data().daysBeforeTest,
                    'description':doc.data().description,
                    'instrcutions': doc.data().instructions,
                    'title':doc.data().title,
                }
                this.dailyCheckups.push(data)
            })
        })
    }


};