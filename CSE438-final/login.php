<?php
    require 'database.php';

    // 需要替换
    $username = "andrew";
    $password = "123";

    $stmt = $mysqli->prepare("INSERT INTO user(username, password) VALUES (?, ?)");
    if(!$stmt){
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }
    $stmt->bind_param('ss', $username, $password);

    $stmt->execute();
    $stmt->close();
?>