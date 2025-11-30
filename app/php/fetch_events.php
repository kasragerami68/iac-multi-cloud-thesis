<?php
// --- custom db connection ---
require_once 'db.php';

header('Content-Type: application/json');

// get filters
$kw = $_GET['search'] ?? '';
$cat = $_GET['category'] ?? '';

// build query
$q = "SELECT id, title, description, start_time, location, category, image FROM events WHERE 1=1";
$vals = [];
$typs = '';
if ($kw !== '') {
    $q .= " AND title LIKE ?";
    $vals[] = "%$kw%";
    $typs .= 's';
}
if ($cat !== '') {
    $q .= " AND category = ?";
    $vals[] = $cat;
    $typs .= 's';
}
$q .= " ORDER BY start_time ASC";

$stmt = $conn->prepare($q);
if (!empty($vals)) {
    $stmt->bind_param($typs, ...$vals);
}
$stmt->execute();
$res = $stmt->get_result();

$evs = [];
if ($res && $res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        $evs[] = $row;
    }
}
echo json_encode($evs);
$stmt->close();
$conn->close();
// --- end of file ---