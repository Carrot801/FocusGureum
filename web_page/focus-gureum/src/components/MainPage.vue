<template>
    <div class = "mainPage">

        <!-- Banner -->
        <img src = "../assets/image.png" alt="Banner" class="banner" />
        <!-- Profile Picture -->
        <img src = "../assets/image.png" alt="Profile Picture" class="profile-picture" />

        <h2>User's Name Page</h2>

        <!-- Current Month and Year -->
        <h3>{{ month }} {{ year }}</h3>


        <!-- Task for daily goals -->
        <div class="task-container">
            <h3>Daily Goals</h3>
            <div v-for ="task in tasks" :key="task.id" class="task"
            :class="{active: task.active}" @click="toggleTask(task.id)">
            <img :src="getTaskImage(task.isActive)" alt="Task Checkbox" class="toggle-image" />
            <span> {{ task.text }}</span>
            </div>

        </div>
        <!-- Add new task -->
        <div v-if="isAddingTask" class="new-task">
                <input v-model="newTaskText" type="text" placeholder="Enter task..." class="new-task-input"/>
                <button @click="addTask" class="add-task">Add Task</button>
                <button @click="cancelTask" class="cancel-task">Cancel</button>
            </div>
            <button v-else @click="startAddingTask" class="add-task-button">➕new to-do</button>

        <p>
           Focus Gureum is designed to help users focus on their work by providing a simple and clean user interface.
        </p>
    </div>
</template>

<script>
export default {
  name: 'MainPage',
  data() {
    const currentDate = new Date();
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return {
        month: months[currentDate.getMonth()],
        year: currentDate.getFullYear(),
        isActive: false,
        isAddingTask: false,
        newTaskText: '',
        checkBoxUnactive: require('@/assets/checkbox-unactive.png'),
        checkBoxActive: require('@/assets/checkbox-active.png'),
        tasks: [
        {
          id: 1,
          text: "Task 1",
          isActive: false,
        },
        {
          id: 2,
          text: "Task 2",
          isActive: false,
        },
        {
          id: 3,
          text: "Task 3",
          isActive: false,
        },  {
          id: 4,
          text: "Task 4",
          isActive: false,
        }
      ]
    }
  },
  computed:{
    taskCheckbox(){
        return this.isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
  },
  methods:{
    toggleTask(taskId){
        this.tasks = this.tasks.map(task => 
            task.id === taskId ? {...task, active: !task.active,isActive: !task.isActive} : task
        );
        this.tasks.sort((a,b) => {
            if(a.active && !b.active) return 1;
            if(!a.active && b.active) return -1;
            return a.id - b.id;
        });
    },
    getTaskImage(isActive){
        return isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
    startAddingTask(){
        this.isAddingTask = true;
    },
    cancelTask(){
        this.isAddingTask = false;
        this.newTaskText = '';
    },
    addTask(){
        if(this.newTaskText.trim()){
            const newTask = {
                id: this.tasks.length + 1,
                text: this.newTaskText,
                isActive: false,
            };
        this.tasks.push(newTask);
        this.cancelTask();
    }
    }
  }
}
</script>

<style scoped>
.mainPage {
    text-align: center;
    margin-top: 0px;
}
.banner {
    width: 100%;
    height: 150px;;
    object-fit: cover;
    margin: 0;
    padding: 0;
}
h2 {
    text-align: left;
    margin-left: 200px;
}
.profile-picture {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    border: 4px solid white;
    position: absolute;
    top: 100px;
    left: 30px;
    padding: 0;
}
.task-container{
    width: 200px;
    display: flex;
    flex-direction: column;
    align-items: left;
    margin-top: 160px;
    margin-left: 10px;
    gap:10px;
    max-height: 300px;
    overflow: auto;
    position: relative;
}
.toggle-image{
    width: 25px;
    height: 25px;
    cursor: pointer;
}
.task{
    width: 160px;
    display: flex;
    align-items: center;
    height: 18px;
    padding:10px;
    gap: 10px;
    border: 1px solid gray;
    border-radius: 10px;
    background-color: white;
    transition: background-color 0.3s;
    cursor: pointer;
}
.task:hover{
    background-color: #f27bbe;
}
.task.active{
    background-color: #f7c4e1;
}
.task.active:hover{
    background-color: #a28f9a;
}
.add-task-button{
    width: 160px;
    height: 40px; 
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    border: 1px solid gray;
    border-radius: 10px;
    margin-top: 10px;
    margin-left: 20px;
    background-color: #f7c4e1;
}
.new-task{
    width: 200px;
    align-items: center;
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 10px;
    margin-left: 0px;
}
.new-task-input{
    width: 175px;
    height: 35px;
    border: 1px solid gray;
    border-radius: 10px;
}
.add-task,
.cancel-task{
    width: 100px;
    height: 40px;
    align-items: center;
    cursor: pointer;
    border: 1px solid gray;
    border-radius: 10px;
    background-color: #f7c4e1;
}

</style>
