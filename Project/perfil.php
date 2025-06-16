<?php
session_start();
require_once 'backend/config.php';

if (!isset($_SESSION['email'])) {
    header("Location: login.php");
    exit();
}

$email = $_SESSION['email'];
$result = $conn->query("SELECT * FROM users WHERE email = '$email'");
$user = $result->fetch_assoc();

$mensagem = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $novoNome = $_POST['nome'];
    $novoEmail = $_POST['email'];

    $stmt = $conn->prepare("UPDATE users SET nome = ?, email = ? WHERE id = ?");
    $stmt->bind_param("ssi", $novoNome, $novoEmail, $user['id']);

    if ($stmt->execute()) {
        $_SESSION['nome'] = $novoNome;
        $_SESSION['email'] = $novoEmail;
        $mensagem = '<div class="alert alert-success">Perfil atualizado com sucesso!</div>';
    } else {
        $mensagem = '<div class="alert alert-danger">Erro ao atualizar o perfil.</div>';
    }

    $result = $conn->query("SELECT * FROM users WHERE id = {$user['id']}");
    $user = $result->fetch_assoc();
}
?>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil do Usuário</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/perfil-style.css">
</head>

<body>
    <div class="container">
        <div class="profile-header">
            <h2>Meu Perfil</h2>
            <p>Gerencie suas informações pessoais</p>
        </div>

        <div class="profile-card">->
            <div class="profile-avatar">
                <div class="avatar-circle">
                    <i class="fas fa-user avatar-icon"></i>
                </div>
                <p class="welcome-text">Bem-vindo, <?= htmlspecialchars($user['nome']) ?>!</p>
            </div>

            <?= $mensagem ?>

            <form method="POST" class="profile-form">
                <div class="form-group">
                    <label for="nome" class="form-label">
                        <i class="fas fa-user"></i> Nome Completo
                    </label>
                    <input type="text" id="nome" class="form-control" name="nome"
                        value="<?= htmlspecialchars($user['nome']) ?>" placeholder="Digite seu nome completo" required>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i> Email
                    </label>
                    <input type="email" id="email" class="form-control" name="email"
                        value="<?= htmlspecialchars($user['email']) ?>" placeholder="Digite seu email" required>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Salvar Alterações
                    </button>
                    <a href="homepage.php" class="btn btn-secondary">
                        <i class="fas fa-home"></i> Voltar
                    </a>
                    <a href="logout.php" class="btn btn-danger"
                        onclick="return confirm('Tem certeza que deseja sair?')">
                        <i class="fas fa-sign-out-alt"></i> Sair
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.querySelector('form').addEventListener('submit', function () {
            const submitBtn = this.querySelector('.btn-primary');
            submitBtn.classList.add('loading');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Salvando...';
        });

        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-20px)';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });

        const inputs = document.querySelectorAll('.form-control');
        inputs.forEach(input => {
            input.addEventListener('input', function () {
                if (this.checkValidity()) {
                    this.style.borderColor = '#28a745';
                } else {
                    this.style.borderColor = '#dc3545';
                }
            });
        });
    </script>
</body>

</html>