<template>
  <div
    id="new-dailycheckups"
    style="background-color:white;padding: 10px 50px 10px 50px; margin-top:10px"
  >
    <h3>Add Daily Check-ups</h3>

    <div class="row">
      <form @submit.prevent="saveDailyCheckups" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="title" required>
            <label>Title</label>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <input type="text" v-model="description" required>
            <label>Description</label>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <input type="number" min="0" v-model="daysBeforeTest" required>
            <label>Number of Days Before Test:</label>
          </div>
        </div>

        <button @click="addInstruction" class="btn green">new instruction</button>
        <div class="row">
          <div
            v-for="instruction in instructions"
            v-bind:key="instruction"
            class="input-field col s12"
          >
            <input type="text" v-model="instruction.value" required>
            <label>Instructions</label>
            <button
              class="btn red"
              @click="deleteInstruction(instructions.indexOf(instruction))"
            >remove instruction</button>
          </div>
        </div>

        <button type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-dailycheckups', params: {test_id: this.$route.params.test_id}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import { newdailycheckupsMixin } from "../../../mixins/dailycheckupsMixin/newdailycheckupsMixin";

export default {
 name: "new-dailycheckups",
  mixins: [newdailycheckupsMixin],
  created() {
    this.addInstruction();
    this.deleteInstruction();
  }
};
</script>

<style>
label {
  color: #2196f3 !important;
}
</style>



