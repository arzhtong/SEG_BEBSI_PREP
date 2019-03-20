<template>
    <div id="view-articles" style="background-color:white; padding: 10px 50px 10px 50px; margin-top:10px">
        <div id="mainScreen">
            <h4 style="font-size:3em;"><b>Articles</b></h4>
            <h5><b>Test: </b>{{test_title}}</h5>

            <div v-if="articles.length === 0" class="row">
                <div class="col s12">
                <div class="card-panel light-blue">
                    <span class="card-title white-text"><i class="small material-icons">info_outline</i>Info</span>
                    <p class="white-text">There are currently no articles for this test.<br> To add one, please click on the button below.
                    </p>
                </div>
                </div>
            </div>

            <table v-else class="collection with-header responsive-table">
                <thead class="collection-header">
                    <tr style="font-size:1.5em">
                        <th style="padding: 20px;">Article title</th> 
                        <th class="right" style="margin-right: 20px;">Description</th>
                        <th></th>
                    </tr> 
                </thead> 

                <tbody v-for="article in articles" v-bind:key="article.id" class="collection-item" >
                    <tr>
                        <td style="padding: 20px;">{{article.title}}</td>
                        <td class="right">
                            <router-link 
                            v-bind:to="{name: 'edit-article', params: {test_id: test_id, article_id: article.id, test_title: test_title}}"
                            class="btn blue">Show/edit</router-link>
                        </td>
                        <td>
                            <a class="tooltip">
                                <span class="tooltiptext">Delete Article</span>
                                <i
                                @click="deleteArticle(article.id)"
                                class="red-text material-icons"
                                style="position:relative;text-align:center;cursor:pointer;"
                                >delete</i>
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
            <router-link 
            v-bind:to="{name: 'add-article', params: {test_id: this.test_id, title: this.test_title}}" 
            class="btn green">
                Add article
            </router-link>
            <router-link to="/view-tests" class="btn grey">
                back
            </router-link>
        </div>
    </div>
</template>

<script>
import db from "../../firebaseInit"

export default {
    name: 'view-articles',
    data() {
        return {
            articles: [],
            test_id: this.$route.params.test_id,
            test_title: this.$route.params.title
        }
    },
    created() {
        db.collection('tests')
          .doc(this.$route.params.test_id)
          .collection('prepCards')
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
                if(doc.data().type === 'article') {
                    const article = {
                        id: doc.id,
                        title: doc.data().title
                    }
                    this.articles.push(article)
                }
            })
          })
    },
    methods: {
        editArticle() {
            this.$router.push({name: 'edit-article', params: {test_id: this.test_id, article_id: article.id, test_title: this.test_title}})
        },
        deleteArticle(id) {
            // delete the article from prepcards
            db.collection('tests')
            .doc(this.$route.params.test_id)
            .collection('prepCards')
            .doc(id)
            .delete()
            .then(() => {
                this.articles.splice(id, 1)
                console.log("Document successfully deleted!")
                alert(`Successfully deleted Article`)
            })
            .catch((error) => {
                console.error("Error removing document: ", error)
                alert(`There was an error: ${error}`)
            })
        }
    }
}
</script>
