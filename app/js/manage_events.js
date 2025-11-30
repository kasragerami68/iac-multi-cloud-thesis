// --- custom admin event manager ---
document.addEventListener("DOMContentLoaded", function () {
    // debug: JS loaded
    console.log("admin event script active");

    // get dom elements
    const eventForm = document.getElementById("eventForm");
    const modalBox = document.getElementById("successModal");
    const okBtn = document.getElementById("closeSuccess");
    const hiddenId = document.getElementById("eventId");
    const titleLabel = document.getElementById("formTitle");
    let isEdit = false;

    if (!eventForm || !modalBox || !okBtn) {
        console.error("missing elements in admin panel");
        return;
    }

    // handle form submit (add/edit)
    eventForm.addEventListener("submit", function (ev) {
        ev.preventDefault();
        const fd = new FormData(eventForm);
        if (isEdit && hiddenId.value) {
            fd.append("eventId", hiddenId.value);
            fetch("../php/update_event.php", {
                method: "POST",
                body: fd,
            })
            .then(r => r.text())
            .then(resp => {
                console.log("update resp:", resp);
                if (resp.trim() === "updated") {
                    modalBox.style.display = "block";
                    eventForm.reset();
                    hiddenId.value = "";
                    isEdit = false;
                    titleLabel.textContent = "Add New Event";
                    reloadEvents();
                } else {
                    alert("Update failed: " + resp);
                }
            })
            .catch(err => {
                console.error("update error:", err);
                alert("server error!");
            });
        } else {
            fetch("../php/create_event.php", {
                method: "POST",
                body: fd,
            })
            .then(r => r.text())
            .then(resp => {
                console.log("create resp:", resp);
                if (resp.trim() === "event_created") {
                    modalBox.style.display = "block";
                    eventForm.reset();
                    reloadEvents();
                } else {
                    alert("Create failed: " + resp);
                }
            })
            .catch(err => {
                console.error("create error:", err);
                alert("server error!");
            });
        }
    });

    // modal close
    okBtn.addEventListener("click", function () {
        modalBox.style.display = "none";
    });
    window.onclick = function(e) {
        if (e.target === modalBox) {
            modalBox.style.display = "none";
        }
    }

    // remove event
    function removeEvent(eid) {
        if (!confirm("Delete this event?")) return;
        const fd = new FormData();
        fd.append("event_id", eid);
        fetch("../php/delete_event.php", {
            method: "POST",
            body: fd
        })
        .then(r => r.text())
        .then(resp => {
            if (resp.trim() === "deleted") {
                reloadEvents();
            } else {
                alert("Delete error: " + resp);
            }
        })
        .catch(err => {
            console.error("delete error:", err);
            alert("server error!");
        });
    }

    // load events
    function reloadEvents() {
        fetch("../php/fetch_events.php")
            .then(r => r.json())
            .then(list => {
                const tbody = document.getElementById("eventTableBody");
                tbody.innerHTML = "";
                if (!list.length) {
                    tbody.innerHTML = "<tr><td colspan='8'>No events found</td></tr>";
                    return;
                }
                list.forEach(ev => {
                    const tr = document.createElement("tr");
                    tr.innerHTML = `
                        <td>${ev.title}</td>
                        <td>${ev.description}</td>
                        <td>${ev.start_time}</td>
                        <td>${ev.location}</td>
                        <td>${ev.category}</td>
                        <td>
                            <button class="edit-button" data-id="${ev.id}">Edit</button>
                            <button class="delete-button" data-id="${ev.id}">Delete</button>
                        </td>
                    `;
                    tbody.appendChild(tr);
                    tr.querySelector(".delete-button").addEventListener("click", function() {
                        removeEvent(ev.id);
                    });
                    tr.querySelector(".edit-button").addEventListener("click", function() {
                        hiddenId.value = ev.id;
                        eventForm.title.value = ev.title;
                        eventForm.description.value = ev.description;
                        eventForm.start_time.value = ev.start_time.replace(' ', 'T');
                        eventForm.location.value = ev.location;
                        eventForm.category.value = ev.category;
                        isEdit = true;
                        titleLabel.textContent = "Edit Event";
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    });
                });
            })
            .catch(err => {
                document.getElementById("eventTableBody").innerHTML = "<tr><td colspan='8'>Load error</td></tr>";
                console.error("load error:", err);
            });
    }

    // initial load
    reloadEvents();
});
// --- end of file ---