<template>
  <div>
    <div class="container">
       <div class="banner" >
    <span>
      <p>Focus Gureum</p>
    </span>
            <div class="task-add-item " @click="startAddingGalleryItem">
              <span>➕ </span> 
            </div>
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
      <div v-if="showGalleryWindow" class="gallery-item-window">
        <div class="gallery-item-content">

            <input v-model="newTaskText" type="text" placeholder = "Enter the name " class="new-task-input"/>
            <div class="task-button">
                <button @click="addTask" class="add-task">Add</button>
                <button @click="cancelGalleryItem" class="cancel-task">Cancel</button>
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
      showGalleryWindow: false,
      newGalleryItemText: '',
      isAddingTask: false,
      newTaskText: '',
      checkBoxUnactive: require('@/assets/checkbox-unactive.png'),
        checkBoxActive: require('@/assets/checkbox-active.png'),
        tasks: [
            {        
                id: 1,
                text: "Complete the daily task",
                isActive: false,
            },
            {      
                id: 2,  
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 3,
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 4,
                text: "Complete the sdfdfssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssfds sdffds daily task",
                isActive: false,
            },
            {        
                id: 5,
                text: "Complete the daily task",
                isActive: false,
            },
            {        
                id: 6,
                text: "Complete the daily task",
                isActive: false,
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
        this.showGalleryWindow = false; 

    },
    addTask(){
        if(this.newTaskText.trim()){
            // this.postDailyTask(this.newTaskText,false);
            const newTask = {
                id: this.tasks.length + 1,
                text: this.newTaskText,
                isActive: false,
            };
            this.tasks.push(newTask);
            this.cancelTask();
        }
    },
     startAddingGalleryItem(){
        this.isAddingTask = true;
        this.showGalleryWindow = true;
        this.newGalleryItemText = '';
        this.imagePreview = null;
        this.selectedImage = null;
    },
    cancelGalleryItem(){
        this.showGalleryWindow = false;
        this.newGalleryItemText = '';
        this.imagePreview = null;
        this.selectedImage = null;
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
  display: flex;
  align-items: center;
  height: 50px;
  justify-content: space-between;
  padding: 0 0 0 10px; 
}


.task-add-item{
  width: 20px;
  height: 20px;
  display: flex;
  margin-right: 5px;
  align-items: center;
  justify-content: center;
  background-color: #ffeaf6;
  border-radius: 8px;
  padding: 10px;
  cursor: pointer;
}
.task-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  height: 460px;
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
.add-task,
.cancel-task{
    margin: 10px 15px;
    width: 100px;
    height: 40px;
    align-items: center;
    cursor: pointer;
    border: 1px solid gray;
    border-radius: 10px;
    background-color: #f7c4e1;
}
.new-task-input{
    margin: 20px;
    width: 220px;
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
.gallery-item-window {
    position: fixed;
    top: 50%;
    left: 50%;
    display: flex;
    flex-direction: column;
    align-items: center;    
    justify-content: center;
    transform: translate(-50%,-50%);
    width: 300px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    padding: 10px;
    background-color: white;
    border-radius: 8px;
    z-index: 1000;
}

</style>

