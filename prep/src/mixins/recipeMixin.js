// This mixin will be used for any functionality that is shared between the recipe components.
// To make use of the functionality in this file import { recipeMixin } from '(this location)'
// and then add 'mixins: [recipeMixin]' just before the data of the component.


export const recipeMixin = {
    data() { 
        return {
            // possible types for a recipe
            types: [
                "salad",
                "soup",
                "vegetable",
                "roast",
                "stew",
                "pizza",
                "sandwich",
                "wrap",
                "pie",
                "fish",
                "beef",
                "chicken",
                "curry",
                "eggs"
            ]
        }
    },
    methods: {
        addInstruction() {
            const data = {
                value: ''
            }
            this.instructions.push(data)
        },
        deleteInstruction(index) {
            this.instructions.splice(index, 1)
        },
        addIngredient() {
            const data = {
                value: ''
            }
            this.ingredients.push(data)
        },
        deleteIngredient(index) {
            this.ingredients.splice(index, 1)
        },
        // get string arrays from ingredients and instructions
        getValuesArray(arrayIn) {
            var arr = []
            for(var i = 0; i < arrayIn.length; i++) {
                arr.push(arrayIn[i].value)
            }
            return arr
        },
        // get array of tag strings from chips
        getChips() {
            var arr = M.Chips.getInstance($('.chips')).chipsData
            var chips = []
            if(arr.length !== 0) {
                for(var i = 0; i < arr.length; i++) {
                    chips.push(arr[i].tag)
                }
            }
            return (chips.length === 0 ? null : chips)
        },
        // make sure the recipe has the required fields
        validRecipe() {
            if(!((this.externalURL !== null && this.externalURL !== '') || (this.ingredients.length > 0 && this.instructions.length > 0))) {
                alert('Please provide a recipe link or a method and ingredients')
                return false
            } else {
                return true
            }
        }
    }
}