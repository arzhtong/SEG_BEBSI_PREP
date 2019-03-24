<template>
    <div id="add-article" style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px">
        <div id="mainScreen" class="row">
            <h3>New Article</h3>
            <form @submit.prevent="saveArticle" class="col s12">
                <div class="row">
                    <div class="input-field col s12">
                        <p>Title</p>
                        <input type="text" v-model.trim="title" required>
                    </div>
                </div>
                <ul class="collapsible">
                    <li>
                        <div class="collapsible-header"><i class="small material-icons">info_outline</i>Info</div>
                        <div class="collapsible-body"><span>Please use the text area below to enter information about this article. If this information is not currently available, 
                        you can leave this blank for now and edit the information later.<br><br>Images can also be uploaded by clicking on the 
                        image icon. Images should be placed inbetween blocks of text so that they correctly display in the app.</span></div>
                    </li>
                </ul>
                <div>
                    <textEditor ref="textEditor"/>
                </div>
                <div class="navButtons">
                    <button type="submit" class="btn">Submit</button>
                    <router-link v-bind:to="{name: 'view-articles', params: {test_id: this.test_id, test_title: this.test_title}}" class="btn grey">Cancel</router-link>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import { articleQuereyMixin } from '../../../mixins/articleMixins/articleQuereyMixin'
import { articleMixin } from '../../../mixins/articleMixins/articleMixin'

export default {
    name: 'addArticle',
    mixins: [articleQuereyMixin, articleMixin],
    data() {
        return {
        }
    }
}
</script>

<style scoped>
.navButtons {
    padding-top: 10px;
}
p {
  color: #2196f3;
}
h3 {
  font-weight: bold;
  margin-left: 20px;
}
.collapsible-header {
    color: #2196f3;
}
</style>