<template>
  <div id="view-dailycheckups-info">
    <ul class="collection with-header">
      <li class="collection-header">
        <h4 style="padding:10px;font-weight: bold;">Daily Checkups Information:</h4>
      </li>
      <li class="collection-item">
        <b>Id:</b>
        {{code}}
      </li>
      <li class="collection-item">
        <b>Number of Days Before Test:</b>
        {{daysBeforeTest}}
      </li>
      <li v-if="description" class="collection-item">
        <b>Description:</b>
        {{description}}
      </li>
      <li class="collection-item">
        <b>Instructions:</b>
       
        <ul v-for="(value, key) in instructions" :key="key">
          <ol style="padding:10px;font-weight: bold;">Instruction {{key}}:</ol>
          <ol>Question: {{value.question}}</ol>
          <ol>Last checked time: 
            {{value.lastChecked.toDate().toISOString().split("T")[0]}}
            {{value.lastChecked.toDate().toTimeString().split(" ")[0]}}
          </ol>
          <ol>Status: {{value.answer}} </ol>
        </ul>
      </li>

      <li class="collection-item">
        <router-link
          v-bind:to="{name: 'edit-dailycheckups', params: {test_id: test_id, daily_id:this.code}}"
          class="btn green"
        >Edit</router-link>

        <router-link v-bind:to="{name: 'view-dailycheckups', params: {test_id: test_id}}">
          <button @click="deleteDailyCheckups" class="btn red">Delete</button>
        </router-link>

        <router-link
          v-bind:to="{name: 'view-dailycheckups', params: {test_id: test_id}}"
          class="btn grey"
        >Back</router-link>
      </li>
    </ul>

    <div class="fixed-action-btn"></div>
  </div>
</template>

<script>
import {dailycheckupMixin} from "../../../mixins/dailycheckupsMixin/dailycheckupMixin";
export default {
  name: "view-dailycheckups-info",
  mixins: [dailycheckupMixin],
  data(){
    return{
     test_id: this.$route.params.test_id,
     daily_id:this.$route.params.daily_id,
     code: null
    };
   
  },
  created(){
     this.code=this.$route.params.daily_id
     this.getDaily(this.test_id,this.daily_id)
  }

};
</script>
