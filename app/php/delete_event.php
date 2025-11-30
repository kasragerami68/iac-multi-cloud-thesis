<?php
// --- Custom DB connection ---
require_once 'db.php';

// retrieve event identifier from post
$eid = $_POST['event_id'] ?? null;

// validate event identifier
if (!isset($eid) || !preg_match('/^\d+$/', $eid)) {
    echo "event id not valid";
    exit;
}

try {
    // prepare deletion query
    $query = "DELETE FROM events WHERE id = ?";
    $del = $conn->prepare($query);
    $del->bind_param("i", $eid);
    
    if ($del->execute()) {
        echo "deleted";
    } else {
        echo "could not remove event";
    }
} catch (Throwable $err) {
    echo "db failure";
}

// close resources
if (isset($del)) $del->close();
$conn->close();
// --- end of file --- 