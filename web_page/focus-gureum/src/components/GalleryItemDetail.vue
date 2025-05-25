<template>
  <div>
    <div class="container">
       <div class="banner" >
    <span>
      Focus Gureum
    </span>
    </div>
      <div class="scrollable-container">
      <div class="task-container">
            <h3>{{ name }}</h3>
            <div v-for ="task in tasks" :key="task.id" class="task"
            :class="{active: task.isActive}" @click="toggleTask(task.id)">
            <img :src="getTaskImage(task.isActive)" alt="Task Checkbox" class="toggle-image" />
            <span> {{ task.text }}</span>
            </div>
        </div>
      </div>
      </div>
  </div>
</template>

<script>
export default {
  props: ['name'],
  data(){
    return{
      checkBoxUnactive: require('@/assets/checkbox-unactive.png'),
        checkBoxActive: require('@/assets/checkbox-active.png'),
        tasks: [
            {        
                id: 1,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
                text: "Complete the daily task",
                isActive: false,
            },
            {      
                id: 2,  
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 3,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 4,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
                text: "Complete the sdfdfssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssfds sdffds daily task",
                isActive: false,
            },
            {        
                id: 5,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 6,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 7,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 8,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 9,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 10,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 11,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
        ],
    }
  },
   computed:{
    taskCheckbox(){
        return this.isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
  },
  methods: {
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
            this.postDailyTask(this.newTaskText,false);
            const newTask = {
                id: this.tasks.length + 1,
                text: this.newTaskText,
                isActive: false,
            };
            this.tasks.push(newTask);
            this.cancelTask();
        }
    },

    
  }
}

</script>

<style scoped>

.scrollable-container {
  overflow: auto;
  scrollbar-color: #f7c4e1 #f3f3f3;
}

.scrollable-container::-webkit-scrollbar-thumb:hover {
  background: #ff4f4f; 
}

.container{
  background-color: #ffecf6;
  border-radius: 15px;
  border-color: rgb(142, 91, 190);
  border-width: 3px;
  border-style: solid;
  width: 99%;
  height: 510px;
  overflow-y: auto;
}

.banner {
  position: relative;
  top: 0;
  margin-left: 0;
  background-color: var(--color-primary); 
  color: white;
  font-weight: bold;
  text-align: left;
  padding-left: 1rem;
  display: flex;
  align-items: center;
  height: 50px;
}

.task-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-height: 460px;
  overflow: auto;
  position: relative;
}

.toggle-image{
    width: 25px;
    height: 25px;
    cursor: pointer;
}
.task {
  margin-left: 10px;
  display: flex;                 
  align-items: center;
  padding: 10px 15px;
  text-align: left;
  gap: 10px;
  border: 1px solid gray;
  border-radius: 10px;
  background-color: white;
  transition: background-color 0.3s;
  cursor: pointer;
  width: fit-content;
  max-width: 97%;                 
  white-space: normal;           
  word-break: break-word;        
  box-sizing: border-box;
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

</style>

