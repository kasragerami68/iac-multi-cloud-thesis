// --- Custom login modal handler ---
document.addEventListener("DOMContentLoaded", function () {
    // get modal and controls
    const modalLogin = document.getElementById("loginModal");
    const btnShow = document.getElementById("showLogin");
    const btnClose = document.querySelector(".close");
    const frmLogin = modalLogin.querySelector("form");
    const errBox = document.createElement("div");
    errBox.style.color = "crimson";
    errBox.style.marginTop = "12px";
    errBox.style.textAlign = "center";
    errBox.style.fontSize = "1rem";
    frmLogin.appendChild(errBox);

    // show modal
    btnShow.addEventListener("click", function () {
        modalLogin.style.display = "block";
        errBox.textContent = "";
    });

    // hide modal
    btnClose.addEventListener("click", function () {
        modalLogin.style.display = "none";
        errBox.textContent = "";
    });

    // hide modal on outside click
    window.onclick = function (ev) {
        if (ev.target === modalLogin) {
            modalLogin.style.display = "none";
            errBox.textContent = "";
        }
    };

    // handle login form
    frmLogin.addEventListener("submit", function (e) {
        e.preventDefault();
        errBox.textContent = "";
        const fd = new FormData(frmLogin);
        fetch("php/login.php", {
            method: "POST",
            body: fd
        })
        .then(r => r.text())
        .then(resp => {
            if (resp.trim() === "ok") {
                window.location.href = "admin/manage_event.html";
            } else {
                errBox.textContent = "Login failed!";
            }
        })
        .catch(() => {
            errBox.textContent = "Server error. Try again.";
        });
    });
});
// --- end of file ---