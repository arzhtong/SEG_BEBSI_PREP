import Vue from 'vue'
import Router from 'vue-router'
import ViewStaff from '@/components/staff/ViewStaff'
import ViewTests from '@/components/tests/ViewTests'
import ViewRecipes from '@/components/tests/ViewRecipes'
import ViewRecipeInfo from '@/components/tests/ViewRecipeInfo'
import NewRecipe from '@/components/tests/NewRecipe'
import EditRecipe from '@/components/tests/EditRecipe'
import EditStaff from '@/components/staff/EditStaff'
import ViewAppointments from '@/components/appointments/ViewAppointments'
import PastAppointments from '@/components/appointments/PastAppointments'
import AddAppointment from '@/components/appointments/AddAppointment'
import EditAppointment from '@/components/appointments/EditAppointment'
import ViewAppointment from '@/components/appointments/ViewAppointment'
import Login from '@/components/auth/Login'
import Register from '@/components/auth/Register'
import ResetPassword from '@/components/auth/ResetPassword'
import Message from '@/components/messages/Message'
import AddTest from '@/components/tests/AddTest'
import firebase from 'firebase'


Vue.use(Router)

let router = new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: ViewAppointments,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
      meta: {
        requiresGuest: true
      }
    },
    {
      path: '/register',
      name: 'register',
      component: Register,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/resetPassword',
      name: 'resetPassword',
      component: ResetPassword,
      meta: {
        requiresGuest: true
      }
    },
    {
      path: '/edit-staff/:email',
      name: 'edit-staff',
      component: EditStaff,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-staff',
      name: 'view-staff',
      component: ViewStaff,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-appointments',
      name: 'view-appointments',
      component: ViewAppointments,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/past-appointments',
      name: 'past-appointments',
      component: PastAppointments,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/add-appointment',
      name: 'add-appointment',
      component: AddAppointment,
      meta: {
        requiresAuth: true
      }
    },
    {

      path: '/edit-appointment/:expired/:id',
      name: 'edit-appointment',
      component: EditAppointment,
      meta: {
        requiresAuth: true
      }
    },
    {

      path: '/message/:expired/:appointmentID',
      name: 'message',
      component: Message,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/add-test',
      name: 'add-test',
      component: AddTest,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-tests',
      name: 'view-tests',
      component: ViewTests,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-recipes/:test_id',
      name: 'view-recipes',
      component: ViewRecipes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/new-recipe/:test_id',
      name: 'new-recipe',
      component: NewRecipe,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-recipe-info/:test_id/:recipe_id',
      name: 'view-recipe-info',
      component: ViewRecipeInfo,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-recipe/:test_id/:recipe_id',
      name: 'edit-recipe',
      component: EditRecipe,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-appointment/:expired/:id',
      name: 'view-appointment',
      component: ViewAppointment,
      meta: {
        requiresAuth: true
      }
    }
  ]
})

// Nav Guard

router.beforeEach((to, from, next) => {
  // Check for required auth guard
  if(to.matched.some(record => record.meta.requiresAuth)) {
    // Check if NOT logged in
    if(!firebase.auth().currentUser) {
      // Go to login page
      next({
        path: '/login',
        query: {
          redirect: to.fullPath
        }
      })
    }else {
      // Proceed to route
      next()
    }
  }else if(to.matched.some(record => record.meta.requiresGuest)) {
    // Check if logged in
    if(firebase.auth().currentUser) {
      // Go to Dashboard
      next({
        path: '/',
        query: {
          redirect: to.fullPath
        }
      })
    }else {
      // Proceed to route
      next()
    }
  }else {
    // Proceed to route
    next()
  }
})

export default router
