<?php
// --- Custom DB connection ---
require_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // collect form data
    $ev_title = $_POST['title'] ?? '';
    $ev_desc = $_POST['description'] ?? '';
    $ev_time = $_POST['start_time'] ?? '';
    $ev_loc = $_POST['location'] ?? '';
    $ev_cat = $_POST['category'] ?? '';

    // handle image upload
    $imgPath = '';
    if (!empty($_FILES['image']['name']) && $_FILES['image']['error'] === 0) {
        $imgName = uniqid('img_') . '_' . basename($_FILES['image']['name']);
        $imgDir = __DIR__ . '/../images/';
        $imgTarget = $imgDir . $imgName;
        if (move_uploaded_file($_FILES['image']['tmp_name'], $imgTarget)) {
            $imgPath = "images/" . $imgName;
        }
    }
    // insert event
    $ins = $conn->prepare("INSERT INTO events (title, description, start_time, location, category, image) VALUES (?, ?, ?, ?, ?, ?)");
    $ins->bind_param("ssssss", $ev_title, $ev_desc, $ev_time, $ev_loc, $ev_cat, $imgPath);
    if ($ins->execute()) {
        echo "event_created";
    } else {
        echo "db_error: " . $ins->error;
    }
    $ins->close();
    $conn->close();
}
// --- end of file ---
?>