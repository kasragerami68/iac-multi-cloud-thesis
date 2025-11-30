<?php
// --- custom admin login ---
session_start();

// credentials
$admin_user = "admin";
$admin_pass = "admin123";

// get post data
$user = $_POST['username'] ?? '';
$pass = $_POST['password'] ?? '';

// check credentials
if ($user === $admin_user && $pass === $admin_pass) {
    $_SESSION['is_admin'] = true;
    echo "ok";
} else {
    echo "fail";
}
// --- end of file ---
?>