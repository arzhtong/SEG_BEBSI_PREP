import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/dailycheckups/NewDailyCheckups.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "new-dailycheckups",
        params: { test_id: "id" }
      }
    }
  });

  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
    //snapshot test
    test("renders correctly", () => {
      expect(wrapper.element).toMatchSnapshot();
    }),
    test("has the right amount of inputs", () => {
      expect(wrapper.findAll("input")).toHaveLength(2);
    }),
    test("all inputs have required attribute", () => {
      var inputArray = wrapper.findAll("input");
      // get if there is an input without the required property
      inputArray = inputArray.filter(input => !input.attributes("required"));
      expect(inputArray).toHaveLength(0);
    }),
    test("the title is right", ()=> {
        expect(wrapper.find('h3').text()).toBe("Add Daily Check-ups")
    }),
    test("has the correct buttons rendered", () => {
        const CancelAdd = wrapper.find("#CancelAdd");
        expect(CancelAdd).toBeDefined(); 
    }),
    test("form submits successfully", () => {
        wrapper.setMethods({ saveDailyCheckups: jest.fn() });
        wrapper.find("#submit").trigger("submit");
    
        expect(wrapper.vm.saveDailyCheckups).toHaveBeenCalled();
    }),
    test("add correct instructions", () => {
        // initialize the method
        wrapper.setMethods({ addInstruction: jest.fn()})

        wrapper.vm. addInstruction()
        const data1 = wrapper.vm.data
        const data2 = { value: "Don't eat meat" };

        expect(data2.value).toBe("Don't eat meat")
        expect(wrapper.vm.data).toBe(data1)

      });

  db.app.delete();
});
