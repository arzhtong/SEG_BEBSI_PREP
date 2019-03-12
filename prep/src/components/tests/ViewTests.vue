<template>
  <div id="view-tests" style="width:100%;">
    <div class="container" style="width:100%;height:100%;">
      <table
        class="collection with-header responsive-table"
        style="background: white;width:100%;height:auto;"
      >
        <thead class="collection-header">
          <h4 style="padding:20px;font-size:3em;">
            <b>Tests</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Title</th>
            <th>Daily check-ups</th>
            <th>Preparation cards</th>
            <th>Preparation contents</th>
            <th>Recipes</th>
            <th>edit</th>
          </tr>
        </thead>

        <tbody v-for="test in tests" v-bind:key="test.id" class="collection-item">
          <tr>
            <td style="padding: 20px;">{{test.title}}{{test.hasRecipes}}</td>
            <td>
                <div id="badge">
                    <span class="new badge red center-align" data-badge-caption="Incomplete"></span>
                </div>
                <div>
                    <router-link to class="btn blue">Show</router-link>
                </div>
            </td>
            <td>
                <div id="badge">
                    <span class="new badge red center-align" data-badge-caption="Incomplete"></span>
                </div>
                <div>
                    <router-link to class="btn blue">Show</router-link>
                </div>
            </td>
            <td>
                <div id="badge">
                    <span class="new badge red center-align" data-badge-caption="Incomplete"></span>
                </div>
                <div>
                    <router-link to class="btn blue">Show</router-link>
                    <!-- <button @click="incomplete(test.id, 'recipes')">test</button> -->
                </div>
            </td>
            <td>
                <div id="badge">
                    <span class="new badge red center-align" data-badge-caption="Incomplete"></span>
                </div>
                <div>
                <router-link
                    v-bind:to="{name: 'view-recipes', params: {test_id: test.id}}"
                    class="btn blue"
                >Show</router-link>
                </div>
            </td>
            <td>
                <div>
                    <router-link 
                    v-bind:to="{name: 'edit-test', params: {test_id: test.id}}" class="btn blue">Edit</router-link>
                </div>
            </td>
          </tr>
        </tbody>
        <router-link to="/add-test" class="btn green" style="margin:20px">
            Add Test
        </router-link>
      </table>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "view-tests",
  data() {
    return {
      tests: []
    };
  },
  created() {
    db.collection("tests")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          const data = {
            id: doc.id,
            test_id: doc.data().testID,
            title: doc.data().title,
            // hasDailyCheckups: ,
            // hasRecipes: ,
          };
          this.tests.push(data);
        });
      });
  },
  methods: {
    subcollectionEmpty(testID, collection) {
        return db.collection("tests")
            .doc(testID)
            .collection(collection)
            .get()
            .then(querySnapshot => {
                return querySnapshot.size === 0
            })
    }
  }
};
</script>

<style scoped>

#badge {
    padding: 3px;
}

</style>

