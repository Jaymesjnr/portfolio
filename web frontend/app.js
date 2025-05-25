document.addEventListener("DOMContentLoaded", function () {
  const tabs = document.querySelectorAll(".tab-btn");
  const tabContents = document.querySelectorAll(".tab-content");

  tabs.forEach(tab => {
    tab.addEventListener("click", function () {
      // Hide all content
      tabContents.forEach(content => content.classList.add("hidden"));
      // Remove 'active' class from all buttons
      tabs.forEach(button => button.classList.remove("active"));
      
      // Show the clicked tab's content
      const targetContent = document.getElementById(tab.dataset.target);
      targetContent.classList.remove("hidden");
      
      // Add 'active' class to the clicked tab
      tab.classList.add("active");
    });
  });
});
