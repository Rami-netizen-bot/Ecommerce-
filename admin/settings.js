// NOTE: There's no /settings/ endpoint on your backend yet, so these forms
// currently just confirm the save locally. Wire each submit handler to a
// real PUT/PATCH request (e.g. `${API_URL}/settings/store`) once one exists.

const API_URL = "http://127.0.0.1:8000";

document.getElementById("storeForm").addEventListener("submit", function (e) {
  e.preventDefault();
  const name = document.getElementById("storeName").value;
  alert(
    `Store details saved for "${name}". (Connect this to a real /settings endpoint to persist it.)`,
  );
});

document.getElementById("accountForm").addEventListener("submit", function (e) {
  e.preventDefault();
  const password = document.getElementById("adminPassword").value;
  const confirm = document.getElementById("adminPasswordConfirm").value;

  if (password && password !== confirm) {
    alert("Passwords don't match. Please re-enter them.");
    return;
  }

  alert(
    "Account settings saved. (Connect this to a real /settings endpoint to persist it.)",
  );
  document.getElementById("adminPassword").value = "";
  document.getElementById("adminPasswordConfirm").value = "";
});

document
  .querySelectorAll(".switch input[type='checkbox']")
  .forEach((toggle) => {
    toggle.addEventListener("change", function () {
      const label =
        this.closest(".toggle-row").querySelector(".toggle-label").textContent;
      console.log(`${label}: ${this.checked ? "enabled" : "disabled"}`);
    });
  });
