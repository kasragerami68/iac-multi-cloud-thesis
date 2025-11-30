document.addEventListener("DOMContentLoaded", function () {
    const logoutBtn = document.getElementById("logoutBtn");
    if (logoutBtn) {
        logoutBtn.addEventListener("click", function () {
            fetch("../php/logout.php")
                .then(res => res.text())
                .then(data => {
                    if (data.trim() === "success") {
                        document.body.innerHTML = `
                            <div style="display:flex;justify-content:center;align-items:center;height:100vh;">
                                <h2 style="font-size:2rem;color:#007bff;">user has loged out</h2>
                            </div>
                        `;
                    }
                });
        });
    }
});