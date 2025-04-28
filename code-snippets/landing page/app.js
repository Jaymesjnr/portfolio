
document.querySelectorAll(".tab-btn").forEach(btn => {
  btn.addEventListener("click", e => {
    const allTabs = document.querySelectorAll(".tab-content");
    const targetId = e.target.dataset.target;

    allTabs.forEach(tab => tab.classList.add("hidden"));
    document.getElementById(targetId).classList.remove("hidden");
  });
});
