// --- Custom event fetcher for homepage ---
document.addEventListener("DOMContentLoaded", function () {
    // get ui elements
    const mainBox = document.getElementById("event-container");
    const inpSearch = document.getElementById("search");
    const selCat = document.getElementById("categoryFilter");

    // load events from server
    function refreshEvents() {
        const q = encodeURIComponent(inpSearch.value.trim());
        const c = encodeURIComponent(selCat.value);
        let url = "php/fetch_events.php";
        let arr = [];
        if (q) arr.push("search=" + q);
        if (c) arr.push("category=" + c);
        if (arr.length) url += "?" + arr.join("&");
        fetch(url)
            .then(r => r.json())
            .then(list => {
                mainBox.innerHTML = "";
                if (!list.length) {
                    mainBox.innerHTML = "<p>No events available.</p>";
                    return;
                }
                list.forEach(ev => {
                    const card = document.createElement("div");
                    card.className = "event-card";
                    card.innerHTML =
                        `<img src='${ev.image}' alt='${ev.title}' class='event-image' />` +
                        `<h2>${ev.title}</h2>` +
                        `<p><strong>Date:</strong> ${ev.start_time}</p>` +
                        `<p><strong>Location:</strong> ${ev.location}</p>` +
                        `<p><strong>Category:</strong> ${ev.category}</p>` +
                        `<p class='description'>${ev.description}</p>`;
                    mainBox.appendChild(card);
                });
            })
            .catch(err => {
                mainBox.innerHTML = "<p>Could not load events.</p>";
                console.error(err);
            });
    }

    // bind events
    inpSearch.addEventListener("input", refreshEvents);
    selCat.addEventListener("change", refreshEvents);
    refreshEvents();
});
// --- end of file ---
