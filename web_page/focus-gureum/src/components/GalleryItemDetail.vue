<template>
  <div class="scrollable-container">
    <div class="container">
       <div class="banner" >
    <span>
      <p>{{ name }}</p>
    </span>
      <div class="task-add-item " @click="startAddingGalleryItem">
        <span>➕ </span> 
      </div>
    </div>
      <div class="scrollable-container">
        <div class="task-container">
            <div v-for ="task in tasks" :key="task.id" class="task"
            :class="{active: task.isActive,
            'swiping-left': task.swipingLeft }"
            :style="swipedTaskId === task.id && dragging ? 'transform: translateX(' + (currentX - touchStartX) + 'px)' : ''"
            @click="toggleTask(task.id)"
            @mousedown="startMouse($event, task.id,true)"
            @mouseup="endMouse($event,true)"
            >
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
  props: ['name','id'],
  data(){
    return{
      showGalleryWindow: false,
      newGalleryItemText: '',
      isAddingTask: false,
      dragging: false,
      swipedTaskId: null,
      currentX: 0,
      newTaskText: '',
      checkBoxUnactive: require('@/assets/checkbox-unactive.png'),
      checkBoxActive: require('@/assets/checkbox-active.png'),
        tasks: [],
    }
  },
   computed(){
    this.taskCheckbox();
    this.getDailyTasks();
  },
  mounted(){
    console.log(this.id);
  },
  methods: {
    taskCheckbox(){
      return this.isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
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
  startMouse(e, habitId,isTask) {
    this.touchStartX = e.clientX;
    this.currentX = e.clientX;
    this.dragging = true;
    if (isTask) {
        this.swipedTaskId = habitId;
    } else {
        this.swipedHabitId = habitId;
    }

    document.addEventListener("mousemove", this.onMouseMove);
    this.boundMouseUp = (e) => this.endMouse(e, isTask);
    document.addEventListener("mouseup", this.boundMouseUp);

    },

    onMouseMove(e) {
    if (this.dragging) {
        this.currentX = e.clientX;
    }
    },

    endMouse(e, isTask) {
    document.removeEventListener("mousemove", this.onMouseMove);
    document.removeEventListener("mouseup", this.boundMouseUp);

    const swipeDistance = this.touchStartX - this.currentX;

    if (isTask && swipeDistance > 100 && this.swipedTaskId !== null) {
        this.deleteDailyTask(this.swipedTaskId);
    } else if (!isTask && swipeDistance > 100 && this.swipedHabitId !== null) {
        this.deleteHabit(this.swipedHabitId);
    }

    this.dragging = false;
    this.swipedHabitId = null;
    this.swipedTaskId = null;
    this.currentX = 0;
    },
    beforeDestroy() {
    document.removeEventListener("mousemove", this.onMouseMove);
    if (this.boundMouseUp) {
        document.removeEventListener("mouseup", this.boundMouseUp);
    }
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
            this.postDailyTask(this.id,this.newTaskText,false);
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
    deleteTask(id) {
      this.tasks = this.tasks.filter(t => t.id !== id);
    },
        async postDailyTask(description,status){
        try{
          const response = await fetch(`/api/tasks/create`, {
            method: 'PATCH',
              headers: {
                  'Content-Type': 'application/json',
                  "Authorization": "Bearer " + localStorage.getItem('authToken'),
              },
              body: JSON.stringify({
                  description: description,
                  status: status,
                  categoryId: this.id,
              }),
            }); 
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
                console.log(data);
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
    },
    async getDailyTasks(){
        try{
          console.log(`/api/tasks/${this.id}`);
            const response = await fetch(`/api/tasks/${this.id}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    "Authorization": "Bearer " + localStorage.getItem('authToken'),
                },
            });
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
                const tasks = JSON.parse(data);
                this.tasks = tasks.map(task => ({
                    id: task.id,
                    text: task.name,
                    isActive: task.status,
                }));
                this.tasks.sort((a,b) => {
                    if(a.isActive && !b.isActive) return 1;
                    if(!a.isActive && b.isActive) return -1;
                    return a.id - b.id;
                });
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
        
    },
    async updateDailyTaskStatus(taskId){

        try{
             const response = await fetch(`api/tasks/${0}/${taskId}/toggle`,{
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    "Authorization": "Bearer " + localStorage.getItem('authToken'),
                },
            });
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
                console.log(data);
                this.getDailyTasks();
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
    },
  }
}

</script>

<style scoped>
p{
  font-size: 16px;
  font-weight: bold;
  color: black
}
.scrollable-container {
  overflow: hidden;
  scrollbar-color: #f7c4e1 #f3f3f3;
}

.scrollable-container::-webkit-scrollbar-thumb:hover {
  background: #ff4f4f; 
}

.container{
  background-color: #ffffff;
  border-radius: 15px;
  border-color: var(--color-accent);
  border-width: 3px;
  border-style: solid;
  width: 99%;
  height: 510px;
}

.banner {
  position: relative;
  top: 0;
  margin-left: 0;
  background: linear-gradient(to right, var(--color-primary), var(--color-secondary));
  color: black;
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
  background-color: var(--color-primary);
  border-radius: 8px;
  padding: 10px;
  cursor: pointer;
}
.task-container {
  margin-top: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  height: 445px;
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
  border: 3px solid var(--color-accent);
  border-radius: 15px;
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
    background-color: var(--color-thridary);
}
.task.active{
    background-color: var(--color-primary);
}
.task.active:hover{
    background-color: var(--color-focus);
}
.add-task,
.cancel-task{
    margin: 10px 15px;
    width: 100px;
    height: 40px;
    align-items: center;
    cursor: pointer;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: var(--color-secondary);
}
.new-task-input{
    margin: 20px;
    width: 220px;
    display: flex;
    align-items: center;
    height: 18px;
    padding:10px;
    gap: 10px;
    border: 3px solid var(--color-accent);
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

