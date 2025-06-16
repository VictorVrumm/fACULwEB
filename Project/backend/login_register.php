<?php
session_start();
require_once 'config.php';

if (isset($_POST['register'])) {
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $senha = password_hash($_POST['senha'], PASSWORD_DEFAULT);
    $funcao = $_POST['funcao'];

    $checkEmail = $conn->query("SELECT email FROM users WHERE email = '$email'");
    if ($checkEmail->num_rows > 0) {
        $_SESSION['register_error'] = 'O e-mail já está registrado!';
        $_SESSION['active_form'] = 'register';
        header("Location: ../index.php");
        exit();
    } else {
        $conn->query("INSERT INTO users (nome, email, senha, funcao) VALUES ('$nome', '$email', '$senha', '$funcao')");
        header("Location: ../index.php");
        exit();
    }
}

if (isset($_POST['login'])) {
    $email = $_POST['email'];
    $senha = $_POST['senha'];

    $result = $conn->query("SELECT * FROM users WHERE email = '$email'");
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        if (password_verify($senha, $user['senha'])) {
            $_SESSION['nome'] = $user['nome'];
            $_SESSION['email'] = $user['email'];
            $_SESSION['funcao'] = $user['funcao'];

            header("Location: ../homepage.php");
            exit();
        }
    }

    $_SESSION['login_error'] = 'E-mail ou senha incorretos';
    $_SESSION['active_form'] = 'login';
    header("Location: ../index.php");
    exit();
}
?>
