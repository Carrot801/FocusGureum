<template>
    <div class = "mainPage">

        <div id="app">
            <router-view />
        </div>
        <!-- Banner -->
        <img src = "../assets/image.png" alt="Banner" class="banner" />
        <!-- Profile Picture -->
        <img src = "../assets/image.png" alt="Profile Picture" class="profile-picture" />

        <h2>User's Name Page</h2>

        <!-- Current Month and Year -->
        <h3>{{ month }} {{ year }}</h3>

        <!-- Task for daily goals -->
        <div class="scrollable-container">
        <div class="daily-goals">
        <div class="task-container">
            <h3>Daily Goals</h3>
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
        <!-- Add new task -->
            <div v-if="isAddingTask" class="new-task">
                <input v-model="newTaskText" type="text" placeholder="Enter task..." class="new-task-input"/>
                <div class="task-button">
                    <button @click="addTask" class="add-task">Add Task</button>
                    <button @click="cancelTask" class="cancel-task">Cancel</button>
                </div>
                </div>
            <button v-else @click="startAddingTask" class="add-task-button">➕new to-do</button>
            </div>
        </div>

        <!-- Habit for daily goals -->
        <div class="scrollable-container">
        <div class="habit-goals">
            <div class="habit-container">
                <h3>Habit Goals</h3>
                <div
                v-for="habit in habits"
                :key="habit.id"
                class="habit"
                :class="{ active: habit.isActive, 'swiping-left': habit.swipingLeft }"
                :style="swipedHabitId === habit.id && dragging ? 'transform: translateX(' + (currentX - touchStartX) + 'px)' : ''"
                @click="toggleHabit(habit.id)"
                @mousedown="startMouse($event, habit.id,false)"
                @mouseup="endMouse($event,false)"
                >
                <img :src="getHabitImage(habit.isActive)" alt="Habit Checkbox" class="toggle-image" />
                <span> {{ habit.text }}</span>
                </div>
            </div>    
        <!-- Add new habit -->
            <div v-if="isAddingHabit" class="new-habit">
                <input v-model="newHabitText" type="text" placeholder="Enter habit..." class="new-habit-input"/>
                <div class="habit-button">
                    <button @click="addHabit" class="add-habit">Add Habbit</button>
                    <button @click="cancelHabit" class="cancel-habit">Cancel</button>
                </div>
                </div>
            <button v-else @click="startAddingHabit" class="add-habit-button">➕new habit</button>
            </div>
        </div>
            <!-- Gallery -->
            <div class="gallery-container">
                <div class="gallery-title">
                    <p>Gallery view</p>
                    <div class="gallery-add-item " @click="startAddingGalleryItem">
                        <span>➕ </span> 
                    </div>
                </div>
                <div class="scrollable-container">
                <div class="gallery">
                   <router-link
                      v-for="(item,index) in gallery"
                      :key="index"
                      :to="item.id === 0
                      ? {name: 'HabbitTracker' }
                      : { name: 'GalleryItemDetail', params: { name: item.name, id: item.id } }"
                      class="gallery-item"
                    >
                  <img :src="item.imgUrl" alt="Gallery Image" />
                  <span>{{ item.name }}</span>
                </router-link>

                    </div>  
                </div>
                
                <div v-if="showGalleryWindow" class="gallery-item-window">
                    <div class="gallery-item-content">

                        File Input 
                         <input type="file" @change="handleFileUpload" accept="image/*" class="file-input" />

                        <input v-model="newGalleryItemText" type="text" placeholder = "Enter the name " class="new-task-input"/>
                        <div class="task-button">
                            <button @click="addGalleryItem" class="add-task">Add</button>
                            <button @click="cancelGalleryItem" class="cancel-task">Cancel</button>
                        </div>
                    </div>
                </div>

            </div> 

            
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
        touchEndX: 0,
        touchStartX: 0,
        currentX: 0,
        dragging: false,
        swipedHabitId: null,
        swipedTaskId: null,
        isActive: false,
        isAddingTask: false,
        newTaskText: '',
        isAddingHabit: false,
        selectedImage: null,
        newHabitText: '',
        showGalleryWindow: false,
        checkBoxUnactive: require('@/assets/checkbox-unactive.png'),
        checkBoxActive: require('@/assets/checkbox-active.png'),
        gallery: [],
        tasks: [ ],
        habits: [
            { id: 0,name: "Habits",imgUrl: require('@/assets/checkbox-active.png'),}
         ],

    }
  },
  computed:{
    habitCheckbox(){
        return this.isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
    taskCheckbox(){
        return this.isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
  },
  methods:{
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
                    categoryId: 2,
                }),
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
    async getDailyTasks(){
        try{
            const response = await fetch(`/api/tasks/2`, {
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
    async updateDailyTaskName(taskId){

        try{
             const response = await fetch(`/api/tasks/${taskId}/name`,{
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    "Authorization": "Bearer " + localStorage.getItem('authToken'),
                },
                body: JSON.stringify({
                    name: this.tasks[taskId-1].text,
                })
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
    async deleteDailyTask(taskId){
        try { const response = await fetch(`/api/tasks/1/${taskId}/delete`,{
            method: 'DELETE',
            headers: {
                'Content-type': 'application/json',
                "Authorization": "Bearer " + localStorage.getItem('authToken'),
            }
        });
        if(!response.ok){
            console.error("Netwrork response was not ok " + response.statusText);
        }else {
            const data = await response.text();
            console.log(data);
            this.getDailyTasks();
        }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
    },
    async getGalleryItem() {
    try {
        const response = await fetch("/api/categories", {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer " + localStorage.getItem('authToken'),
        },
        });

        if (!response.ok) {
        throw new Error("Network response was not ok: " + response.statusText);
        }

        const data = await response.json();
        console.log(data);
        const gallery = data.map(item => ({
            id: item.id + 1,
            name: item.name,
            imgUrl: require('@/assets/checkbox-unactive.png')
            }));
             this.gallery = [
            {
                id: 0,
                name: "Habits",
                imgUrl: require('@/assets/checkbox-active.png'),
            },
            ...gallery
            ];

    } catch (error) {
        console.error("There was a problem with the fetch operation:", error);
    }
    },
    async postGalleryItem(name,imageUrl){
        try{
            const response = await fetch("/api/categories/create",{
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    "Authorization": "Bearer " + localStorage.getItem('authToken'),
                },
                body: JSON.stringify({
                    name: name,
                    imagePath: imageUrl,
                    userId: 1,
                }),
            }); 
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
                this.getGalleryItem();
                console.log(data);
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
        
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
        this.updateDailyTaskStatus(taskId);
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
            this.cancelTask();
        }
    },
     toggleHabit(habitId){
        this.habits = this.habits.map(habit => 
            habit.id === habitId ? {...habit, active: !habit.active,isActive: !habit.isActive} : habit
        );
        this.habits.sort((a,b) => {
            if(a.active && !b.active) return 1;
            if(!a.active && b.active) return -1;
            return a.id - b.id;
        });
        this.updateHabitStatus(habitId);
    },
    getHabitImage(isActiveHabit){
        return isActiveHabit ? this.checkBoxActive : this.checkBoxUnactive;
    },
    startAddingHabit(){
        this.isAddingHabit = true;
    },
    cancelHabit(){
        this.isAddingHabit = false;
        this.newHabitText = '';
    },
    addHabit(){
        if(this.newHabitText.trim()){
            this.postHabit(this.newHabitText,false);
            this.cancelHabit();
        }
    },
    
    async postHabit(description){
        try{
            const response = await fetch("api/habits/create",{
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    "Authorization": "Bearer " + localStorage.getItem('authToken'),
                },
                body: JSON.stringify({
                    name: description,
                    createdAt: new Date().toISOString().slice(0, 19),
                    active: true,
                    user: 1,
                }),
            }); 
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                this.getDailyHabit();
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
        
    },
     async getDailyHabit(){
        try{
            const response = await fetch(`/api/habitschedule/today`, {
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
                const data = await response.json(); 
                this.habits = data.map((name, index) => ({
                id: index,
                text: name,
                isActive: false,
                swipingLeft: false,
                }));
                this.habits.sort((a,b) => {
                    if(a.isActive && !b.isActive) return 1;
                    if(!a.isActive && b.isActive) return -1;
                    return a.id - b.id;
                });
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
        
    },
     async deleteHabit(habitId){
        try { const response = await fetch(`api/habits/${habitId}/delete`,{
            method: 'DELETE',
            headers: {
                'Content-type': 'application/json',
                "Authorization": "Bearer " + localStorage.getItem('authToken'),
            }
        });
        if(!response.ok){
            console.error("Netwrork response was not ok " + response.statusText);
        }else {
            const data = await response.text();
            console.log(data);
            this.getDailyHabit();
        }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
    },
    async updateHabitStatus(habitId){

        try{
             const response = await fetch(`api/habits/${habitId}/toggle`,{
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
                const data = await response.json();
                console.log(data);
                this.getDailyHabit();
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
    },    
    startAddingGalleryItem(){
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
    addGalleryItem(){
        if(this.newGalleryItemText.trim() && this.imagePreview){
            this.postGalleryItem(this.newGalleryItemText, this.imagePreview,);
            this.cancelGalleryItem();
        }else {
            alert("Please select an image and enter a name.");
        }
    },
    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            this.selectedImage = file;
            this.imagePreview = URL.createObjectURL(file);
            this.$nextTick(() => {
            console.log("Image Preview Updated:", this.imagePreview);
        });
        } else {
            this.imagePreview = null;
        }
    }
    
  },
  mounted() {
    this.getDailyTasks();
    this.getGalleryItem();
    this.getDailyHabit();
  },
}
</script>

<style scoped>
.scrollable-container {
  overflow: auto;
  scrollbar-color: #f7c4e1 #f3f3f3; /* Thumb | Track */
}

.scrollable-container::-webkit-scrollbar-thumb:hover {
  background: #ff4f4f; /* Darker color on hover */
}

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
.daily-goals {
    margin-left: 60px;
    top: 450px;
    position: absolute;
}
.task-container{
    width: 270px;
    display: flex;
    flex-direction: column;
    align-items: left;
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
.task:hover{
    background-color: var(--color-thridary);
}
.task.active{
    background-color: var(--color-primary);
}
.task.active:hover{
    background-color: var(--color-focus);
}
.add-task-button{
    width: 220px;
    height: 40px; 
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    margin-top: 10px;
    margin-left: 10px;
    background-color: var(--color-secondary);
}
.new-task{
    width: 250px;
    display: flex;
    flex-direction: column;
    align-items: left;
    margin-top: 10px;
    gap:10px;
    max-height: 300px;
    position: relative;
}
.task-button{
    width: 250px;
    display: flex;
    align-items: center;
    gap: 10px;
    margin-left: 15px;
}
.new-task-input{
    width: 220px;
    display: flex;
    align-items: center;
    height: 18px;
    padding:10px;
    gap: 10px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: var(--color-primary);
    transition: background-color 0.3s;
    cursor: pointer;
}
.add-task,
.cancel-task{
    width: 100px;
    height: 40px;
    align-items: center;
    cursor: pointer;
    border: 3px solid var(--color-accent)b;
    border-radius: 10px;
    background-color: var(--color-secondary);
}


/* habit container */
.habit-goals {
    margin-left: 1110px;
    top: 450px;
    position: absolute;
}
.habit-container{
    width: 360px;
    display: flex;
    flex-direction: column;
    align-items: left;
    gap:10px;
    max-height: 300px;
    overflow: auto;
    position: relative;
}
.habit{
    width: 310px;
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
.habit:hover{
    background-color: var(--color-thridary);
}
.habit.active{
    background-color: var(--color-primary);
}
.habit.active:hover{
    background-color: var(--color-focus);
}
.add-habit-button{
    width: 220px;
    height: 40px; 
    cursor: pointer;
    display: flex;
    left: 50%;
    transform: translate(25%);
    justify-content: center;
    align-items: center;
    padding: 10px;
    border: 3px solid  var(--color-accent);
    border-radius: 10px;
    margin-top: 10px;
    background-color: var(--color-secondary);
}
.new-habit{
    width: 250px;
    display: flex;
    flex-direction: column;
    align-items: left;
    margin-top: 10px;
    gap:10px;
    max-height: 300px;
    position: relative;
}
.habit-button{
    width: 250px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 30px;
    gap: 10px;
}
.new-habit-input{
    width: 310px;
    display: flex;
    align-items: center;
    height: 18px;
    padding:10px;
    gap: 10px;
    border: 1px solid  var(--color-accent);
    border-radius: 10px;
    background-color:  var(--color-primary);
    transition: background-color 0.3s;
    cursor: pointer;
}
.add-habit,
.cancel-habit{
    width: 100px;
    height: 40px;
    align-items: center;
    cursor: pointer;
    border: 1px solid  var(--color-accent);
    border-radius: 10px;
    background-color:  var(--color-secondary)
}
.habit.swiping-left {
  transform: translateX(-100px);
  transition: transform 0.3s ease;
  opacity: 0.5;
}
.scrollable-gallery-container {
  overflow-x: auto; 
  white-space: nowrap; 
  width: 700px; 
  border: 2px solid #ddd;
  padding: 10px;
}
.gallery-container{
    margin-left: 350px;
    top: 300px;
    position: absolute;
    width: 710px;
}
.gallery{
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: repeat(2, auto);
    padding-top: 10px;
    gap: 10px;
    padding-right: 10px;
    overflow: auto;
    max-width: 700px;
    max-height: 420px;
}
.gallery-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: var(--color-primary);
  padding: 10px;
  border-radius: 8px;
  cursor: pointer;
  width: 200px;
  height: 180px;
}

.gallery-item img {
  width: 200px;
  height: 165px;
  border-radius: 10px;
  border: 1px solid var(--color-accent);
  object-fit: cover;
}

.gallery-title {
    width: 675px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 0 0 10px; 
    background: linear-gradient(to right, var(--color-primary), var(--color-secondary));
    color: black;
    border-radius: 8px;
}

.gallery-add-item {
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: var(--color-primary);
    border-radius: 8px;
    padding: 10px;
    cursor: pointer;
}
/* .gallery-add-item img {
  width: 30px;
  height: 30px;
  margin-right: 5px;
} */

.gallery-item-window {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    width: 300px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    padding: 10px;
    background-color: white;
    border-radius: 8px;
    z-index: 1000;
}
.gallery-item-content{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 10px;
}
</style>
