<?php
// --- Custom DB connection ---
require_once 'db.php';

// get post data
$eid = $_POST['eventId'] ?? null;
$ttl = $_POST['title'] ?? '';
$desc = $_POST['description'] ?? '';
$dt = $_POST['start_time'] ?? '';
$loc = $_POST['location'] ?? '';
$cat = $_POST['category'] ?? '';

// validate event id
if (!is_numeric($eid)) {
    echo "bad id";
    exit;
}

try {
    // update event
    $q = "UPDATE events SET title=?, description=?, start_time=?, location=?, category=? WHERE id=?";
    $st = $conn->prepare($q);
    $st->bind_param("sssssi", $ttl, $desc, $dt, $loc, $cat, $eid);
    if ($st->execute()) {
        echo "updated";
    } else {
        echo "update_failed";
    }
} catch (Throwable $e) {
    echo "db_fail";
}
if (isset($st)) $st->close();
$conn->close();
// --- end of file --- 