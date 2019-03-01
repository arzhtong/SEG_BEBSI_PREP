<template>
  <div id="view-messages">
    <div class="container" style="width:100%;height:100%">
      <table
        class="collection with-header responsive-table"
        style="background: white;width:100%;height:auto"
      >
        <thead class="collection-header">
          <h4 style="padding:20px;font-size:3em;">
            <b>Messages</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Most recent message</th>
            <th>Location</th>
            <th>Date</th>
            <th>Time</th>
            <th>Test</th>
          </tr>
        </thead>

        <tbody  class="collection-item">
          <tr>
            <td style="padding: 20px;">
             
          
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td>
              <router-link
              
                class="secondary-content left">
                <button
              
                  class="btn blue"
                  style="position:relative;text-align:center;"
                >edit</button>
              </router-link>
            </td>
            <td>
              <router-link to="" class="btn">View Messages</router-link>
            </td>
          </tr>
        </tbody>
        
      </table>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
import firebase from "firebase";

export default {
  name: "view-messages",
  data() {
    return {
      users: [],
      isAdmin: null,
      currentEmail: null
    };
  },
  created() {
   
  },
  methods: {
  }
};
</script>

<style>
</style>
