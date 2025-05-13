<template>
    <div class = "mainPage">

        <!-- Banner -->
        <img src = "../assets/image.png" alt="Banner" class="banner" />
        <!-- Profile Picture -->
        <img src = "../assets/image.png" alt="Profile Picture" class="profile-picture" />

        <h2>User's Name Page</h2>

        {{ }}
        <!-- Current Month and Year -->
        <h3>{{ month }} {{ year }}</h3>

        <!-- Task for daily goals -->
        <div class="scrollable-container">
        <div class="daily-goals">
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
                <div class="task-button">
                    <button @click="addTask" class="add-task">Add Task</button>
                    <button @click="cancelTask" class="cancel-task">Cancel</button>
                </div>
                </div>
            <button v-else @click="startAddingTask" class="add-task-button">➕new to-do</button>
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

                    <div v-for="(image,index) in gallery" :key="index" class="gallery-item">
                        <img :src="image.imgUrl" alt="Gallery Image" />
                        <span>Image {{ image.name }}</span>
                    </div>
                    </div>  
                </div>
                <div v-if="showGalleryWindow" class="gallery-item-window">
                    <div class="gallery-item-content">

                        <!-- File Input -->
                        <input type="file" @change="handleFileUpload" accept="image/*" class="file-input" />

                        <input v-model="newGalleryItemText" type="text" placeholder = "Enter the name " class="new-task-input"/>
                        <div class="task-button">
                            <button @click="addGalleryItem" class="add-task">Add</button>
                            <button @click="cancelGalleryItem" class="cancel-task">Cancel</button>
                        </div>
                        <h3>Add Gallery Item</h3>
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
        isActive: false,
        isAddingTask: false,
        selectedImage: null,
        newTaskText: '',
        showGalleryWindow: false,
        checkBoxUnactive: require('@/assets/checkbox-unactive.png'),
        checkBoxActive: require('@/assets/checkbox-active.png'),
        gallery: [
            {        
                id: 1,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {      
                id: 2,  
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 3,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 4,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 5,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
            },
            {        
                id: 6,
                imgUrl: require('@/assets/checkbox-unactive.png'),
                name: "Image 1",
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
        tasks: [ ]
    }
  },
  computed:{
    taskCheckbox(){
        return this.isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
  },
  methods:{
    async postDailyTask(description,status){
        try{
            const response = await fetch("api/dailyTasks",{
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    description: description,
                    status: status,
                }),
            }); 
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
console.log(data);
                console.log(data);
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
        
    },
    async getDailyTasks(){
        try{
            const response = await fetch("api/dailyTasks",{
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
                console.log(data);
                const tasks = JSON.parse(data);
                this.tasks = tasks.map(task => ({
                    id: task.id,
                    text: task.description,
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
    async updateDailyTask(taskId,description,status){

        try{
            const response = await fetch("api/dailyTasks",{
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    id: taskId,
                    description: description,
                    status: status,
                }),
            });
            if(!response.ok){
                throw new Error("Network response was not ok" + response.statusText);
            }
            else {
                const data = await response.text();
                this.getDailyTasks();
                console.log(data);
            }
        }catch(error){
            console.error("There was a problem with the fetch operation:", error);
        }
    },
    async deleteDailyTask(taskId){
        const params = new URLSearchParams();
        params.append('id', taskId);
        try { const response = await fetch(`api/dailyTasks?${params.toString()}`,{
            method: 'DELETE',
            headers: {
                'Content-type': 'application/json'  
            },
            body: JSON.stringify({
                id: taskId,
            }),
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
    toggleTask(taskId){
        this.tasks = this.tasks.map(task => 
            task.id === taskId ? {...task, active: !task.active,isActive: !task.isActive} : task
        );
        this.tasks.sort((a,b) => {
            if(a.active && !b.active) return 1;
            if(!a.active && b.active) return -1;
            return a.id - b.id;
        });
        this.updateDailyTask(taskId,this.tasks[taskId-1].text,!this.tasks[taskId-1].isActive);
    },
    getTaskImage(isActive){
        return isActive ? this.checkBoxActive : this.checkBoxUnactive;
    },
    startAddingTask(){
        this.isAddingTask = true;
    },
    cancelTask(){
        this.deleteDailyTask("2");
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
            const newItem = {
                id: this.gallery.length + 1,
                imgUrl: this.imagePreview,
                name: this.newGalleryItemText,
            };
            this.gallery.push(newItem);
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
    margin-top: 200px;
    margin-left: 60px;
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
    width: 220px;
    height: 40px; 
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    border: 1px solid gray;
    border-radius: 10px;
    margin-top: 10px;
    margin-left: 10px;
    background-color: #f7c4e1;
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
    border: 1px solid gray;
    border-radius: 10px;
    background-color: white;
    transition: background-color 0.3s;
    cursor: pointer;
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
  background: #f3f3f3;
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
  border: 1px solid gray;
  object-fit: cover;
}

.gallery-title {
    width: 675px;
    height: 40px;
    display: flex;
    align-items: center;
    text-align: left;
    justify-content: space-between;
    padding: 0 0 0 10px; 
    background-color: #f6cdcd85;
    border-radius: 8px;
}

.gallery-add-item {
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f7c4e1;
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
