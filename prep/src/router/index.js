import Vue from 'vue'
import Router from 'vue-router'
import Dashboard from '@/components/Dashboard'
import ViewStaff from '@/components/staff/ViewStaff'
import EditStaff from '@/components/staff/EditStaff'
import ViewAppointments from '@/components/appointments/ViewAppointments'
import AddAppointment from '@/components/appointments/AddAppointment'
import EditAppointment from '@/components/appointments/EditAppointment'
import Login from '@/components/auth/Login'
import Register from '@/components/auth/Register'
import ResetPassword from '@/components/auth/ResetPassword'
import Message from '@/components/messages/Message'
import AddTest from '@/components/AddTest'
import firebase from 'firebase'


Vue.use(Router)

let router = new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Dashboard,
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
      path: '/add-appointment',
      name: 'add-appointment',
      component: AddAppointment,
      meta: {
        requiresAuth: true
      }
    },
    {

      path: '/edit-appointment/:id',
      name: 'edit-appointment',
      component: EditAppointment,
      meta: {
        requiresAuth: true
      }
    },
    {

      path: '/message/:appointmentID',
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