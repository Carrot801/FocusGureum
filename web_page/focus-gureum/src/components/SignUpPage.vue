<template>
  <div>
    <div class="sign-in-page">
      <div class="sign-in-header">
        <h1>Create account</h1>
      </div>
      <div class="sign-in-container">
      <input
        v-model="nickname"
        :class="['email-input', emailError ? 'input-error' : '']"
        type="text"
        placeholder="Enter your nickname"
      />

        <input
        v-model="password"
        :class="['password-input', passwordError ? 'input-error' : '']"
        :type="showPassword ? 'text' : 'password'"
        placeholder="Enter your password"
        />
        <img
        :src="showPassword ? closedEyeIcon : openEyeIcon"
        @click="togglePasswordVisibility"
        class="eye-icon"
        alt="Toggle Password Visibility"
        />
        <input
          v-model="repeatedPassword"
          :class="['password-input', repeatedPasswordError ? 'input-error' : '']"
          :type=" 'password'"
          placeholder="Repeat your password"    
        />
          
        <span v-if="passwordError" class="error-message">
          Password must be at least 8 characters long.
        </span>
        <span v-if="repeatedPasswordError" class="repeated-error-message">
          Password must be the same as the first one.
        </span>

      </div>
      <div>
        <button
          class="signup-button"
          @click="registerUser"
        >
          Sign Up
        </button>
      </div>
      <div>
        <p>
          Don't have an account? <a class="link" href="/signin">Sign In</a>
        </p>
      </div>
    </div>
  </div>
</template>


<script>
// import { create } from 'core-js/core/object';
// import { routeLocationKey } from 'vue-router';
import {getToken} from'@/utils'
import validator from 'validator';
export default {
  
    name: 'SignInPage',
    data() {
        return {
            nickname: '',
            password: '',
            repeatedPassword: '',
            repeatedPasswordError: false,
            login: '',
            nicknameError: false,
            emailError: false,
            passwordError: false,
            showPassword: false,
            openEyeIcon: require('@/assets/view.png'),
            closedEyeIcon: require('@/assets/hide.png')
        };
    },
    computed: {
        isFormValid() {
            return this.login.trim() !== '' && this.password.trim() !== '';
        },
        isPasswordValid() {
          return validator.isLength(this.password, { min: 8 });
        },
        isSamePassword() {
          return this.repeatedPassword === this.password;
        }
    },
    methods: {
        async registerUser() {
          this.nicknameError = this.nickname.trim() === '';
          this.passwordError = !this.isPasswordValid;
          this.repeatedPasswordError = this.repeatedPassword !== this.password;

          if (
            this.nicknameError ||
            this.passwordError ||
            this.repeatedPasswordError
          ) {
            return;
          }

          try {
            const response = await fetch('/auth/addNewUser', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                nickname: this.nickname,
                avator: '',
                email: '',
                password: this.password,
                role: "ROLE_USER",
                createdAt: new Date().toISOString()
              }),
            });
            if (!response.ok) {
              throw new Error(`Server error: ${response.statusText}`);
            }
            await getToken(this.nickname,this.password,this.$router);
            const result = await response.text();
            console.log(result);
          } catch (error) {
            console.error('Error registering user:', error);
          }
        },
        togglePasswordVisibility(){
            this.showPassword = !this.showPassword;
        }
    }
};
</script>

<style scoped>
.sign-in-page {
    position: fixed;
    display: fixed;
    justify-content: center;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    align-items: center;
    height: 460px;
    width: 500px;
    background-color: var(--color-background);
    border-radius: 15px;
    border: 4px solid var(--color-accent);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);

}
.sign-in-header {
    position: relative;
    text-align: center;
    top: 10px;
    height: 10px;
}
.sign-in-container{
    display: flex;
    flex-direction: column;
    gap: 30px;
    align-items: center;
}
.password-input {
    width: 80%;
    height: 30px;
    position: relative;
    align-items: center;
    padding:10px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: var(--color-primary);
    transition: background-color 0.3s;
    cursor: pointer;
}
.email-input:focus,
.password-input:focus {
    background-color: #f0f0f0;
    outline-color: var(--color-focus);
    outline-width: 2px;
}
.email-input {
    width: 80%;
    height: 30px;
    display: flex;
    position: relative;
    margin-top: 60px; 
    align-items: center;
    padding:10px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: var(--color-primary);
    transition: background-color 0.3s;
    cursor: pointer;
}
.input-error {
  border-color: red;
}

.error-message {
  color: red;
  font-size: 12px;
  margin-top: 5px;
  position: absolute;
  left: 40px;
  top: 230px;
}
.repeated-error-message{
  color: red;
  font-size: 12px;
  margin-top: 5px;
  position: absolute;
  left: 40px;
  top: 315px;
}
.signup-button {
    position: relative;
    margin-top: 40px;
    left: 50%;
    transform: translateX(-50%);
    width: 20%;
    height: 40px;
    display: flex;
    justify-content: center;
    padding:10px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: var(--color-background);
    color: rgb(0, 0, 0);
    cursor: pointer;
}
.eye-icon {
  position: absolute;
  top: calc(50% - 25px); 
  left: calc(50% + 175px);
  transform: translateY(-50%);
  width: 24px;
  height: 24px;
  cursor: pointer;
  z-index: 10;
}

.signup-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.link{
    color: var(--color-accent);
    text-decoration: none;
}
</style>