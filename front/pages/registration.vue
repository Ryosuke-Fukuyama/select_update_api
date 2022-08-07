<template>
  <div>
    <h1>Signup-Form</h1>
    <p>{{ message }}</p>
    <!-- name:<input type="text-field" v-model="name" label="name"> -->
    <br>
    email:<input type="text-field" v-model="email" label="email">
    <br>
    password:<input type="text-field" v-model="password" label="password">
    <br>
    <button @click="singup">New Account</button>
  </div>
</template>

<script>
import { getAuth, createUserWithEmailAndPassword } from 'firebase/auth'

export default {
  data: () => ({
    // form {
      // name: '',
      email: '',
      password: '',
    // },
    message: ''
  }),

  methods: {
    singup() {
      // this.$axios.post(
      //   `https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${process.env.API_KEY}`, {
      //   email: this.email, password: this.password, returnSecureToken: true
      // })
      const auth = getAuth()
      createUserWithEmailAndPassword(auth, this.email, this.password)
        .then((res) => {
          // const token = res.data.idToken
          const token = res.user.accessToken
          const params = { token, registration: { email: res.user.email } }
          const url = '/api/v1/users/registrations'
          this.$axios.post(url, params)
            .then((res) => {
              // console.log(res.data.uid)
              this.$router.push('/')
            })
        })
        .catch((err) => {
          console.log(err)
          // debugger
          this.setErrorMessage(err.code)
        })
    },

    setErrorMessage(error_code) {
      switch (error_code) {
        case 'auth/invalid-email':
          this.message = 'メールアドレスの形式に誤りがあります。'
          break
        case 'auth/email-already-in-use':
          this.message = '入力されたメールアドレスは既に使用されています。'
          break
        case 'auth/weak-password':
          this.message = 'パスワードは6文字以上で入力してください。'
          break
        default:
          this.message = '新規登録に失敗しました。'
          break
      }
    },
  },
}
</script>
