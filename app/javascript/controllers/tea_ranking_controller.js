document.addEventListener('turbo:load', function() {
  initDragAndDrop();
});

function initDragAndDrop() {
  const container = document.getElementById('tea-ranking-container');
  if (!container) return;
  
  const items = container.querySelectorAll('.tea-rank-item');
  let draggedItem = null;
  
  // Add event listeners to each item
  items.forEach(item => {
    // Drag start
    item.addEventListener('dragstart', function(e) {
      draggedItem = this;
      setTimeout(() => {
        this.classList.add('dragging');
      }, 0);
    });
    
    // Drag end
    item.addEventListener('dragend', function() {
      this.classList.remove('dragging');
      draggedItem = null;
      updateRanks();
    });
    
    // Drag over
    item.addEventListener('dragover', function(e) {
      e.preventDefault();
      if (this === draggedItem) return;
      
      const bounding = this.getBoundingClientRect();
      const offset = bounding.y + (bounding.height / 2);
      
      if (e.clientY - offset > 0) {
        this.parentNode.insertBefore(draggedItem, this.nextSibling);
      } else {
        this.parentNode.insertBefore(draggedItem, this);
      }
    });
  });
  
  // Function to update ranks after drag
  function updateRanks() {
    const teaItems = container.querySelectorAll('.tea-rank-item');
    const totalItems = teaItems.length;
    const teaRanks = {};
    
    // Assign ranks based on position (top item gets highest rank)
    teaItems.forEach((item, index) => {
      const teaId = item.dataset.teaId;
      const rank = totalItems - index; // Highest rank at the top
      teaRanks[teaId] = rank;
      
      // Update the displayed rank
      const rankElement = item.querySelector('.current-rank');
      if (rankElement) {
        rankElement.textContent = rank;
      }
    });
    
    // Send the updated ranks to the server
    fetch('/teas/update_ranks', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ tea_ranks: teaRanks })
    })
    .then(response => {
      if (!response.ok) {
        console.error('Failed to update ranks');
      }
    })
    .catch(error => {
      console.error('Error updating ranks:', error);
    });
  }
}