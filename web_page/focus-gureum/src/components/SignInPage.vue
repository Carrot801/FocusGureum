<template>
  <div>
    <div class="sign-in-page">
      <div class="sign-in-header">
        <h1>Welcome back!</h1>
      </div>
      <div class="sign-in-container">
        <input
          v-model="email"
          :class="['email-input', emailError ? 'input-error' : '']"
          type="text"
          placeholder="Enter your email"
        />
        <div v-if="emailError" class="error-message">Login is required.</div>

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
        <div v-if="passwordError" class="error-message">Password is required.      
        
        </div>

      </div>
      <div>
        <button
          class="signup-button"
          @click="handleSignIn"
        >
          Sign In
        </button>
      </div>
      <div>
        <p>
          Don't have an account? <a class="link" href="/signup">Sign Up</a>
        </p>
      </div>
    </div>
  </div>
</template>


<script>
export default {
    name: 'SignInPage',
    data() {
        return {
            password: '',
            login: '',
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
        }
    },
    methods: {
        handleSignIn() {
            this.emailError = this.login.trim() === '';
            this.passwordError = this.password.trim() === '';

            if (this.isFormValid) {
                alert('Logging in...');
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
    height: 400px;
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
  left: 0;
  top: 100%;
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
  top: calc(50% + 5px); 
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