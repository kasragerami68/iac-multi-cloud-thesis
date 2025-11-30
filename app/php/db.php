<?php
// --- custom db config ---
$db_host = 'db';
$db_user = 'kasra';
$db_pass = 'test1234';
$db_name = 'community_db';

// create connection
$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

// check connection
if ($conn->connect_error) {
    die("DB connect error: " . $conn->connect_error);
}
// --- end of file ---
?>
