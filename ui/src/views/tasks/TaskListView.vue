<template>
  <div class="task-list-view">
    <!-- Table Header -->
    <div class="table-header">
      <div class="header-cell">
        <input type="checkbox" v-model="selectAll" @change="toggleSelectAll" />
      </div>
      <div class="header-cell" @click="sortBy('title')">
        Title
        <span class="sort-icon">{{ sortField === 'title' ? (sortDirection === 'asc' ? '↑' : '↓') : '' }}</span>
      </div>
      <div class="header-cell" @click="sortBy('status')">
        Status
        <span class="sort-icon">{{ sortField === 'status' ? (sortDirection === 'asc' ? '↑' : '↓') : '' }}</span>
      </div>
      <div class="header-cell" @click="sortBy('dueDate')">
        Due Date
        <span class="sort-icon">{{ sortField === 'dueDate' ? (sortDirection === 'asc' ? '↑' : '↓') : '' }}</span>
      </div>
      <div class="header-cell" @click="sortBy('tags')">
        Tags
        <span class="sort-icon">{{ sortField === 'tags' ? (sortDirection === 'asc' ? '↑' : '↓') : '' }}</span>
      </div>
      <div class="header-cell">
        <button @click="addProperty" class="add-property-btn">+ Add Property</button>
      </div>
    </div>

    <!-- Table Body -->
    <div class="table-body">
      <div v-for="task in sortedTasks" :key="task.id" class="table-row" :class="{ 'selected': selectedTaskId === task.id }" @click="selectTask(task.id)">
        <div class="row-cell checkbox-cell">
          <input type="checkbox" v-model="task.selected" @change="toggleTaskSelection(task.id)" />
        </div>
        <div class="row-cell" contenteditable @blur="updateTaskField(task.id, 'title', $event.target.textContent)">
          {{ task.title }}
        </div>
        <div class="row-cell">
          <select v-model="task.status" @change="updateTaskField(task.id, 'status', $event.target.value)">
            <option value="todo">Todo</option>
            <option value="in-progress">In Progress</option>
            <option value="done">Done</option>
          </select>
        </div>
        <div class="row-cell">
          <input type="date" v-model="task.dueDate" @change="updateTaskField(task.id, 'dueDate', $event.target.value)" />
        </div>
        <div class="row-cell">
          <span v-for="tag in task.tags" :key="tag" class="tag">
            {{ tag }}
          </span>
        </div>
        <div class="row-cell actions-cell">
          <button @click.stop="deleteTask(task.id)" class="delete-btn">🗑️</button>
        </div>
      </div>
    </div>

    <!-- Add New Task Button -->
    <button @click="addNewTask" class="add-task-btn">
      + New Task
    </button>

    <!-- Task Sidebar -->
    <div v-if="selectedTask" class="task-sidebar">
      <div class="sidebar-header">
        <h3>Task Details</h3>
        <button @click="closeSidebar" class="close-btn">×</button>
      </div>
      <div class="sidebar-section">
        <label>Title</label>
        <input v-model="selectedTask.title" @change="updateTaskField(selectedTask.id, 'title', selectedTask.title)" />
      </div>
      <div class="sidebar-section">
        <label>Status</label>
        <select v-model="selectedTask.status" @change="updateTaskField(selectedTask.id, 'status', selectedTask.status)">
          <option value="todo">Todo</option>
          <option value="in-progress">In Progress</option>
          <option value="done">Done</option>
        </select>
      </div>
      <div class="sidebar-section">
        <label>Due Date</label>
        <input type="date" v-model="selectedTask.dueDate" @change="updateTaskField(selectedTask.id, 'dueDate', selectedTask.dueDate)" />
      </div>
      <div class="sidebar-section">
        <label>Tags</label>
        <input v-model="tagInput" @keyup.enter="addTag" placeholder="Add a tag and press Enter" />
        <div class="tags-list">
          <span v-for="tag in selectedTask.tags" :key="tag" class="tag">
            {{ tag }}
            <button @click="removeTag(tag)" class="tag-remove">×</button>
          </span>
        </div>
      </div>
      <div class="sidebar-section">
        <label>Notes</label>
        <textarea v-model="selectedTask.notes" @change="updateTaskField(selectedTask.id, 'notes', selectedTask.notes)"></textarea>
      </div>
      <div class="sidebar-section">
        <label>Custom Properties</label>
        <div v-for="(value, key) in selectedTask.properties" :key="key" class="property-row">
          <span class="property-key">{{ key }}:</span>
          <span class="property-value">{{ value }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue';

export default {
  name: 'TaskListView',
  setup() {
    // Task data
    const tasks = ref([
      {
        id: 1,
        title: 'Implement Task List View',
        status: 'in-progress',
        dueDate: '2026-04-20',
        tags: ['frontend', 'vue'],
        notes: 'Create a Notion-like table view for tasks',
        properties: {},
        selected: false
      },
      {
        id: 2,
        title: 'Add Inline Editing',
        status: 'todo',
        dueDate: '2026-04-21',
        tags: ['frontend', 'ux'],
        notes: 'Allow editing task fields directly in the table',
        properties: {},
        selected: false
      },
      {
        id: 3,
        title: 'Integrate with uDOS Vault',
        status: 'todo',
        dueDate: '2026-04-22',
        tags: ['backend', 'api'],
        notes: 'Connect the task list to the uDOS Vault data layer',
        properties: {},
        selected: false
      }
    ]);

    // Sorting
    const sortField = ref('title');
    const sortDirection = ref('asc');

    // Selected task for sidebar
    const selectedTaskId = ref(null);
    const selectedTask = computed(() => {
      return tasks.value.find(task => task.id === selectedTaskId.value) || null;
    });

    // Tag input for sidebar
    const tagInput = ref('');

    // Sort tasks
    const sortedTasks = computed(() => {
      return [...tasks.value].sort((a, b) => {
        const aValue = a[sortField.value];
        const bValue = b[sortField.value];
        
        if (aValue < bValue) return sortDirection.value === 'asc' ? -1 : 1;
        if (aValue > bValue) return sortDirection.value === 'asc' ? 1 : -1;
        return 0;
      });
    });

    // Select all tasks
    const selectAll = computed({
      get: () => tasks.value.every(task => task.selected),
      set: (value) => {
        tasks.value.forEach(task => {
          task.selected = value;
        });
      }
    });

    // Methods
    const toggleSelectAll = () => {
      selectAll.value = !selectAll.value;
    };

    const toggleTaskSelection = (taskId) => {
      const task = tasks.value.find(t => t.id === taskId);
      if (task) {
        task.selected = !task.selected;
      }
    };

    const selectTask = (taskId) => {
      selectedTaskId.value = taskId;
    };

    const closeSidebar = () => {
      selectedTaskId.value = null;
    };

    const sortBy = (field) => {
      if (sortField.value === field) {
        sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc';
      } else {
        sortField.value = field;
        sortDirection.value = 'asc';
      }
    };

    const addNewTask = () => {
      const newTask = {
        id: tasks.value.length + 1,
        title: 'New Task',
        status: 'todo',
        dueDate: '',
        tags: [],
        notes: '',
        properties: {},
        selected: false
      };
      tasks.value.unshift(newTask);
    };

    const deleteTask = (taskId) => {
      const index = tasks.value.findIndex(task => task.id === taskId);
      if (index !== -1) {
        tasks.value.splice(index, 1);
      }
    };

    const updateTaskField = (taskId, field, value) => {
      const task = tasks.value.find(t => t.id === taskId);
      if (task) {
        task[field] = value;
      }
    };

    const addTag = () => {
      if (tagInput.value.trim() && selectedTask.value) {
        selectedTask.value.tags.push(tagInput.value.trim());
        tagInput.value = '';
      }
    };

    const removeTag = (tag) => {
      if (selectedTask.value) {
        selectedTask.value.tags = selectedTask.value.tags.filter(t => t !== tag);
      }
    };

    const addProperty = () => {
      // Implement property addition logic
      console.log('Add property');
    };

    return {
      tasks,
      sortedTasks,
      selectAll,
      toggleSelectAll,
      toggleTaskSelection,
      selectTask,
      closeSidebar,
      sortBy,
      sortField,
      sortDirection,
      selectedTaskId,
      selectedTask,
      tagInput,
      addNewTask,
      deleteTask,
      updateTaskField,
      addTag,
      removeTag,
      addProperty
    };
  }
};
</script>

<style scoped>
.task-list-view {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.table-header {
  display: grid;
  grid-template-columns: 50px 2fr 1fr 1fr 1fr 1fr;
  padding: 10px 0;
  border-bottom: 1px solid #e5e7eb;
  font-weight: 600;
  color: #374151;
  background-color: #f9fafb;
}

.header-cell {
  padding: 0 10px;
  display: flex;
  align-items: center;
  cursor: pointer;
  user-select: none;
}

.header-cell:hover {
  background-color: #f3f4f6;
}

.sort-icon {
  margin-left: 5px;
  font-size: 0.8em;
}

.table-body {
  display: grid;
  grid-template-columns: 50px 2fr 1fr 1fr 1fr 1fr;
}

.table-row {
  padding: 10px 0;
  border-bottom: 1px solid #e5e7eb;
  cursor: pointer;
}

.table-row:hover {
  background-color: #f9fafb;
}

.table-row.selected {
  background-color: #e5e7eb;
}

.row-cell {
  padding: 0 10px;
  display: flex;
  align-items: center;
  word-break: break-word;
}

.checkbox-cell {
  justify-content: center;
}

.actions-cell {
  justify-content: flex-end;
}

.add-task-btn {
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
}

.add-task-btn:hover {
  background-color: #2563eb;
}

.delete-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: #ef4444;
  font-size: 16px;
}

.delete-btn:hover {
  color: #dc2626;
}

.task-sidebar {
  position: fixed;
  top: 0;
  right: 0;
  width: 400px;
  height: 100%;
  background-color: white;
  box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
  z-index: 100;
  overflow-y: auto;
  padding: 20px;
  box-sizing: border-box;
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #e5e7eb;
}

.sidebar-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #111827;
}

.close-btn {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 24px;
  color: #6b7280;
}

.close-btn:hover {
  color: #374151;
}

.sidebar-section {
  margin-bottom: 20px;
}

.sidebar-section label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #111827;
  font-size: 14px;
}

.sidebar-section input,
.sidebar-section select,
.sidebar-section textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
  box-sizing: border-box;
}

.sidebar-section input:focus,
.sidebar-section select:focus,
.sidebar-section textarea:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
}

.sidebar-section textarea {
  min-height: 100px;
  resize: vertical;
}

.tag {
  display: inline-block;
  background-color: #e5e7eb;
  color: #111827;
  padding: 4px 8px;
  border-radius: 4px;
  margin-right: 5px;
  margin-bottom: 5px;
  font-size: 12px;
}

.tag-remove {
  background: none;
  border: none;
  cursor: pointer;
  margin-left: 5px;
  font-size: 12px;
  color: #6b7280;
}

.tag-remove:hover {
  color: #ef4444;
}

.property-row {
  display: flex;
  margin-bottom: 5px;
  font-size: 14px;
}

.property-key {
  font-weight: 600;
  margin-right: 5px;
  color: #6b7280;
}

.add-property-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: #3b82f6;
  font-size: 14px;
}

.add-property-btn:hover {
  text-decoration: underline;
}
</style>