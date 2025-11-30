<?php
// test database connection
require_once 'db.php';

// check if connection is ok
if ($conn) {
    echo "✅ Connection to MySQL inside Docker was successful!";
} else {
    echo "❌ Failed to connect to database.";
}
?>
