<template>
  <div class="scrollable-container">
    <div class="container">
        <!-- Month Header -->
        <div class="left-right-arrows">
            <img
              src="@/assets/left-arrow.png"
              alt="Previous Month"
              class="left-arrow"
              @click="prevMonth"
            />
            <img
              src="@/assets/right-arrow.png"
              alt="Next Month"
              class="right-arrow"
              @click="nextMonth"
            />
        </div>
        <div class="month-header">
            <h1>{{ currentMonth }}</h1>
        </div>
        <!-- Charts Section -->
        <div class="chart-section">
        <div class="line-chart-container">
            <canvas ref="lineChart"></canvas>
        </div>
    </div>

  </div>
  <!-- Habit Tracker -->

  <div class="habit-container">
        <!-- Pie Chart Section -->
        <div class="pie-section">
          <!-- Pie Chart -->
          <canvas ref="pieChart" class="mb-4"></canvas>
          <div class="transparent-container" v-if="!activeTasks.length"> </div>
          <div class="pie-description" v-if="activeTasks.length">
            <div 
              v-for="(task, index) in visibleTasks"
              :key="index"
            >
              <!-- Colored Box -->
              <div
                class="color-box"
                :style="{ backgroundColor: pieColors[tasks.indexOf(task)] }"
              ></div>
              <!-- Label Text -->
             <span class="text-sm font-medium">{{ task.name }}</span>
          
           </div>
           </div>
       </div> 



        <!-- Bar Chart -->
        <div class="bar-chart">
          <canvas ref="barChart"></canvas>
        </div>


        <!-- Task Tracker -->
        <!-- Matrix Container -->
        <div class="matrix-wrapper">
        <div class="task-matrix-container">
          <!-- Task Rows -->
          <div
            class="matrix-row"
            v-for="(task, taskIndex) in tasks"
            :key="`task-${taskIndex}`"
          >
            <div class="task-label">{{ task.name }}</div>
            <div
              v-for="(day, dayIndex) in dayLabels"
              :key="`checkbox-${taskIndex}-${dayIndex}`"
            >
              <input
                type="checkbox"
                v-model="task.days[dayIndex]"
                @change="updateBarChart"
                class="checkbox-cell"
              />
            </div>
          </div>


        </div>
      </div>
   </div>
  <div class="add-habbit-button" @click="startAddingHabit">
      <span>➕ </span> 
  </div>
  <div v-if="showHabitWindow" class="habit-window">
    <div class="habit-content">
      <input v-model="newHabitText" type="text" placeholder = "Enter the name " class="new-habit-input"/>
      
      <div class="frequency-box">
        <h5>Frequency:</h5>
        <input v-model.number="newHabitFrequency" type="number" min="1" max="7" placeholder="Times per week" class="new-habit-frequency"/>
      </div>

      <div class="task-button">
        <button @click="addHabit" class="add-habit">Add</button>
        <button @click="cancelHabit" class="cancel-habit">Cancel</button>
      </div>
    </div>
  </div>
        
  </div>
</template>


<script>
import {
  Chart,
  LineController, LineElement, PointElement, LinearScale, Title, CategoryScale,
  BarController, BarElement,
  DoughnutController, ArcElement
} from 'chart.js';

Chart.register(
  LineController, LineElement, PointElement, LinearScale, Title, CategoryScale,
  BarController, BarElement,
  DoughnutController, ArcElement
);

export default {
  name: 'DashboardPage',
  data() {
    const today = new Date();
    const monthIndex = today.getMonth();
    const year = today.getFullYear();
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    const daysInMonth = new Date(year, monthIndex + 1, 0).getDate();
    return {
      tasks: [ ],
      selectedPieIndex: null,
      currentMonth: monthNames[monthIndex],
      monthIndex: monthIndex,
      monthNames: monthNames,
      showHabitWindow: false,
      newHabitText: '',
      newHabitFrequency: 1,
      dayLabels: Array.from({ length: daysInMonth }, (_, i) => i + 1),
      pieColors: [],
      leftArrow: require('@/assets/left-arrow.png'),
      rightArrow: require('@/assets/right-arrow.png'),
      label: [],

    };
  },
  mounted() {
    this.generatePieColors();
    this.initLineChart();
    this.initBarChart();
    this.initPieChart();
    this.getMonthLineStatistic();  
},
  computed: {
     activeTasks(){
      return this.tasks.filter(task => task.days.some(day => day));
    },
    visibleTasks(){
      if(this.selectedPieIndex === null) return this.activeTasks;
      return [this.activeTasks[this.selectedPieIndex]];
    },
  },
  methods: {
    getTaskCompletionData() {
    return this.tasks.map(task =>
      task.days.reduce((total, checked) => total + (checked ? 1 : 0), 0)
    );
}
,
    startAddingHabit(){
      this.showHabitWindow = true;
    },
    addHabit (){
      this.cancelHabit();
    },
    cancelHabit (){
      this.showHabitWindow = false;
    },
    prevMonth() {
      this.monthIndex = (this.monthIndex - 1 + 12) % 12;
      this.currentMonth = this.monthNames[this.monthIndex];
      this.updateBarChart();
    },
    nextMonth() {
      this.monthIndex = (this.monthIndex + 1) % 12;
      this.currentMonth = this.monthNames[this.monthIndex];
      this.updateBarChart();
    },
    generatePieColors() {
      this.pieColors = this.tasks.map(() => {
        const hue = Math.floor(Math.random() * 360);
        return `hsl(${hue}, 100%, 80%)`;
      });
    },
    updateBarChart() {
      const newData = this.getDailyTaskCompletionCounts();
      if (this.barChartInstance && this.lineChartInstance && this.pieChartInstance) {
        this.barChartInstance.data.datasets[0].data = newData;
        this.barChartInstance.update();
        this.lineChartInstance.data.datasets[0].data = newData;
        this.lineChartInstance.update();
        this.pieChartInstance.data.datasets[0].data = this.getTaskCompletionData();
        this.pieChartInstance.update();
      }
    },
    getDailyTaskCompletionCounts() {
      return this.dayLabels.map((_, dayIndex) =>
        this.tasks.reduce((count, task) =>
         count + (task.days[dayIndex] ? 1 : 0), 0)
      );
    },
    initLineChart() {
      this.lineChartInstance = new Chart(this.$refs.lineChart, {
        type: 'line',
        data: {
          labels: this.dayLabels,
          datasets: [{
            label: 'Activity Score',
            data: this.getDailyTaskCompletionCounts(),
            borderColor: '#06b6d4',
            backgroundColor: 'rgba(6, 182, 212, 0.1)',
            fill: true
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              min: 0,
              max: this.tasks.length,
              ticks: {
                callback: function(value) {
                  return Number.isInteger(value) ? value : '';
                },
                stepSize: 1
              }
            }
          }
        }
      });
    },
    initBarChart() {
    this.barChartInstance = new Chart(this.$refs.barChart, {
      type: 'bar',
      data: {
        labels: this.dayLabels,
        datasets: [{
          label: 'Tasks Completed',
          data: this.getDailyTaskCompletionCounts(),
          backgroundColor: '#14b8a6'
        }]
      },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              min: 0,
              max: this.tasks.length,
              ticks: { stepSize: 1 }
            },
            x: {
               position: 'top' 
              }
          }
        }
      });
    },
    initPieChart() {
      this.pieChartInstance = new Chart(this.$refs.pieChart, {
        type: 'doughnut',
        data: {
          labels: this.tasks.map(t => t.name),
          datasets: [{
            data: this.getTaskCompletionData(),
            backgroundColor: this.pieColors
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          onClick: (evt, elements) => {
            if(elements.length > 0) {
              const index = elements[0].index;
              this.selectedPieIndex = (this.selectedPieIndex === index)? null: index;
            } else {
              this.selectedPieIndex = null;
            }
          }
        }
      });
    },
    async getMonthLineStatistic(){
      try {
        const response = await fetch(`/api/habitschedule/monthplan`, {
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
        const daysInMonth = new Date(new Date().getFullYear(), this.monthIndex + 1, 0).getDate();

        this.tasks = data.map(habit => {
          const days = Array(daysInMonth).fill(false);
          habit.scheduledDates.forEach(dateStr => {
            const date = new Date(dateStr);
            if (date.getMonth() === this.monthIndex) {
              days[date.getDate() - 1] = true;
            }
          });
          return {
            name: habit.habitName,
            days: days
          };
        });

        this.generatePieColors();
        this.updateBarChart();

      } catch (error) {
        console.error("There was a problem with the fetch operation:", error);
      }
    },
  }
};
</script>


<style scoped>

.scrollable-container {
  overflow: auto;
  scrollbar-color: #f7c4e1 #f3f3f3;
}

.scrollable-container::-webkit-scrollbar-thumb:hover {
  background: #ff4f4f; 
}
.grid-cols-15 {
  grid-template-columns: repeat(15, minmax(0, 1fr));
}

.container{
    width: 98%;
    height: 200px;
    top: 20px;
    display: flex;
    flex-direction: row;
    justify-content: center;
    
    border-radius: 15px;
    border: 3px solid var(--color-accent);
    background-color: var(--color-primary);
}
.month-header {
    margin-left: 0px;
    width: 30%;
    justify-content: center;
    display: flex;
    align-items: center;
    position: relative;
    font-size: 24px;
    font-weight: bold;
    padding: 10px 10px 10px 10px;
    background-color: var(--color-accent);
}
.chart-section {
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
}
.line-chart-container{
    position: relative;
    width: 100%;
    height: 100%;

}
.pie-section {
  max-height: 210px;
  margin-top: 10px;
  margin-left: 85%;
  display: flex;
  flex-direction: column;

}
.transparent-container{
  height: 210px;
  margin-top: 10px;
  margin-left: 85%;
}
.pie-section canvas {
    width: 50% !important;
    height: 50% !important;
    margin-left: 50%;
    transform: translate(-50%);
}
.pie-description {
    width: 100%;
    height: 105px;
    margin-left: 50%;
    transform: translate(-50%);
    color: #000000;
    display: flex;
    flex-direction: column;
    margin-top: 5px;
    overflow: auto;
}
.color-box {
  width: 16px;
  height: 16px;
  display: inline-block;
  border-radius: 4px;
  border: 1px solid #ccc;
}
.bar-chart {
  width: 63%;
  height: 210px;
  margin-left: 20%;
  position: absolute;
  margin-top: 10px;
}
.habit-container {
  margin-top: 20px;
  width: 98%;
  max-height: 480px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  background-color: var(--color-primary);
  border-radius: 15px;
  border: 3px solid var(--color-accent);

}

.task-grid-container {
  display: flex;
  flex-direction: row;
  max-width: 100%;
}

.task-grid-labels {
  display: flex;
  flex-direction: column;
  margin-right: 10px;
  min-width: 150px;
}


.task-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(24px, 1fr));
  overflow-x: auto;
}

.task-row {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(24px, 1fr));
  margin-bottom: 8px;
}

.checkbox-cell {
 cursor: pointer;
  accent-color: var(--color-secondary); /* Controls checkmark color and box */
  background-color: var(--color-primary); /* Background doesn't affect checkbox */
  width: 24px;
  height: 24px;
  border-radius: 4px;
  border: 3px solid var(--color-accent);
}

.task-matrix-container {
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  width: 86.5%;
  margin-top: 20px;
}

.matrix-row {
  display: grid;
  grid-template-columns: 25.5% repeat(auto-fit, minmax(24px, 1fr));
  align-items: center;
  min-height: 32px;
}
.matrix-wrapper {
  width: 100%; 
  margin: 0 auto;
  overflow-y: auto;;
}
h5{
  color:#b1b1b1
}


.task-label {
  height: 32px;
  justify-content: flex;
  padding-left: 8px;
  text-align: left;
  font-weight: 500;
  background-color: var(--color-accent);
}

.left-right-arrows {
  left: 17%;
  position: absolute;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 70px;
  padding: 10px;
  z-index: 10;
}
.left-arrow,
.right-arrow {
  width: 24px;
  height: 24px;
  cursor: pointer;

}
.add-habbit-button{
  position: absolute;
  top: 245px;
  left: 25px;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--color-accent);
  border-radius: 8px;
  padding: 10px;
  cursor: pointer;
}

.add-habit,
.cancel-habit{
    margin: 10px 15px;
    width: 100px;
    height: 40px;
    align-items: center;
    cursor: pointer;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: var(--color-secondary);
}
.new-habit-input{
    margin: 20px;
    width: 220px;
    display: flex;
    align-items: center;
    height: 18px;
    padding:10px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: white;
    transition: background-color 0.3s;
    cursor: pointer;
}
.frequency-box{
  display: flex;
  flex-direction: row;
  align-items: center;
  width: 240px;
  margin-left: 20px;
  justify-content: space-between;
}
.new-habit-frequency{
    width: 25px;
    height: 18px;
    padding:10px;
    margin-right: 0px;
    border: 3px solid var(--color-accent);
    border-radius: 10px;
    background-color: white;
    transition: background-color 0.3s;
    cursor: pointer;
}
.habit-window {
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
