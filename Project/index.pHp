<?php

session_start();

$errors = [
  'login' => $_SESSION['login_error'] ?? '',
  'register' => $_SESSION['register_error'] ?? ''
];

$activeForm = $_SESSION['active_form'] ?? 'login';

session_unset();

function showError($error)
{
  return !empty($error) ? "<p class='error-message'>$error</p>" : '';
}

function isActiveForm($formName, $activeForm)
{
  return $formName === $activeForm ? 'active' : '';
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>
    Bem Vindo
  </title>
  <link rel="stylesheet" href="css/login-style.css" />
</head>

<body>
  <div class="container">
    <div class="form-box <?= isActiveForm('login', $activeForm); ?>" id="login-form">
      <form action="backend/login_register.php" method="post">
        <h2>Login</h2>
        <?= showError($errors['login']); ?>
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="senha" placeholder="Senha" required />
        <button type="submit" name="login">Login</button>
        <p>
          Não tem uma conta?
          <a href="#" onclick="showForm('register-form')">Registrar</a>
        </p>
      </form>
    </div>

    <div class="form-box <?= isActiveForm('register', $activeForm); ?>" id="register-form">
      <form action="backend/login_register.php" method="post">
        <h2>Registrar</h2>
        <?= showError($errors['register']); ?>
        <input type="text" name="nome" placeholder="Nome" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="senha" placeholder="Senha" required />
        <select name="funcao" required>
          <option value="">--Selecione a função--</option>
          <option value="user">Usuário</option>
          <option value="admin">Administrador</option>
        </select>
        <button type="submit" name="register">Registrar</button>
        <p>
          Já tem uma conta?
          <a href="#" onclick="showForm('login-form')">Login</a>
        </p>
      </form>
    </div>
  </div>

  <script src="backend/login_script.js"></script>
</body>

</html>