<template>
  <div id="view-prep-lists">
    <ul class="collection with-header">
      <li class="collection-header">
        <div class="container" style="width:100%;height:100%">
          <table
            class="collection with-header responsive-table"
            style="background: white;margin-top:10%;width:100%;height:auto"
          >
            <thead class="collection-header">
              <h4 style="padding:20px;font-size:3em;">
                <b>Lists</b>
              </h4>

              <tr style="font-size:1.5em">
                <th style="padding: 20px;">List Name</th>
                <th></th>
              </tr>
            </thead>

            <tbody v-for="list  in lists" v-bind:key="list.id" class="collection-item">
              <tr>
                <td style="padding: 20px;">{{list.id}}</td>
                <td>
                  <router-link
                    v-bind:to="{name: 'view-prep-list', params: {test_id: test_id, contents: list.id}}"
                    class="btn blue"
                    style="margin:20px"
                  >show</router-link>
                </td>
              </tr>
            </tbody>
            <router-link
              v-bind:to="{name: 'new-list', params: {test_id: test_id}}"
              class="btn green"
              style="margin:20px"
            >Add List</router-link>
          </table>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import db from "../firebaseInit";

export default {
  name: "view-prep-lists",
  data() {
    return {
      lists: [],
      test_id: this.$route.params.test_id
    };
  },
  created() {
    db.collection("tests")
      .doc(this.$route.params.test_id)
      .collection("lists")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          const data = {
            id: doc.id
          };
          this.lists.push(data);
        });
      });
  }
};
</script>


