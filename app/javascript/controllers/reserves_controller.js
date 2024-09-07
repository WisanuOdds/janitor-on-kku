import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cell"];
  dragging = false;
  selectedCells = [];
  startRow = null;

  startTime = null;
  endTime = null;

  
  
  generateTimeSlots(startTime, endTime) {
    const timeSlots = [];
    let currentTime = new Date(`1970-01-01T${startTime}:00`);
    const endTimeDate = new Date(`1970-01-01T${endTime}:00`);

    while (currentTime <= endTimeDate) {
        const hours = String(currentTime.getHours()).padStart(2, '0');
        const minutes = String(currentTime.getMinutes()).padStart(2, '0');
        timeSlots.push(`${hours}:${minutes}`);
        currentTime.setMinutes(currentTime.getMinutes() + 30);
    }
    return timeSlots;
  }


  handleStart(event) {
    event.preventDefault();
    this.dragging = true;
    this.removeHighlightCell(); // ลบ row ที่เลือกไว้ก่อนหน้า ก่อนลากใหม่
    this.startRow = this.getRowIndex(event.currentTarget); // ลาก row เปลี่ยนสี
    this.highLightCell(event.currentTarget); // ตัวเปลี่ยนสี

    this.startTime = event.currentTarget.dataset.startTime;
    console.log('startTime: ' + this.startTime);
  }
  
  handleMove(event) {
    if (!this.dragging) return;
    event.preventDefault();
    const element = event.currentTarget;
    
    if (element && element.matches("[data-reserves-target='cell']")) {
      const currentRow = this.getRowIndex(element);
      
      // Check if the current row is the same as the start row
      if (currentRow === this.startRow) {
        this.highLightCell(element);
      } else {
        // If dragging across a different row, stop and end the drag
        console.log("Dragged across rows, stopping the selection.");
        this.handleEnd(event); // Call handleEnd to finish the selection process
      }
    }
  }

  handleEnd(event) {
    event.preventDefault();
    if (!this.dragging) return;
    this.dragging = false;
    this.endTime = event.currentTarget.dataset.endTime;
    console.log('endTime: ' + this.endTime);
    this.option();
    this.openModal();
  
  }

  option() {
    console.log('option function');
    const timeSlots = this.generateTimeSlots(this.startTime, this.endTime);
    console.log(timeSlots);

    const optionStartTime = document.getElementById('optionStartTime');
    optionStartTime.innerHTML = '';
    const option = document.createElement("option");
    const option2 = document.createElement("option");
    option.value = "10:00";
    option.text = "10:00";
    option2.value = "11:00";
    option2.text = "11:00";
    optionStartTime.appendChild(option);
    optionStartTime.appendChild(option2);

    const optionEndTime = document.getElementById('optionEndTime');
    optionEndTime.innerHTML = '';
    const option3 = document.createElement("option");
    const option4 = document.createElement("option");
    option3.value = "11:00";
    option3.text = "11:00";
    option4.value = "12:00";
    option4.text = "12:00";
    optionEndTime.appendChild(option3);
    optionEndTime.appendChild(option4);

  }

  highLightCell(cell) {
    if (!this.selectedCells.includes(cell)) {
      this.selectedCells.push(cell);
      cell.classList.add("bg-blue-300");
    }
  }
  
  removeHighlightCell() {
    this.selectedCells.forEach(cell => cell.classList.remove("bg-blue-300"));
    this.selectedCells = [];
  }

  getRowIndex(cell) {
    return cell.closest('tr').rowIndex;
  }

  openModal() {
      const modal = document.getElementById('reservesModal');
    if (modal) {
      modal.classList.add('flex');
      modal.classList.remove('hidden');
    }
  }

  closeModal() {
    const modal = document.getElementById('reservesModal');
    if (modal) {
        modal.classList.add('hidden');
    }
  }

}



