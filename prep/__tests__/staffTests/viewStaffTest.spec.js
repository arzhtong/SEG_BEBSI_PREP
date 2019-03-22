import { shallowMount } from "@vue/test-utils";
// import ComponentFunctions from '../../src/mixins/usersMixin/userMixin'
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase";
// @ts-ignore
import Component from "../../src/components/staff/ViewStaff.vue";

Vue.use(VueRouter);
describe("Component", () => {
  const wrapper = shallowMount(Component);
  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
  test('renders correctly', () => {
    expect(wrapper.element).toMatchSnapshot()
  });
  db.app.delete();
});
