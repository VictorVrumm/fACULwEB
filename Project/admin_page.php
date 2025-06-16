<?php
session_start();
require_once 'backend/config.php';

if (!isset($_SESSION['funcao']) || $_SESSION['funcao'] !== 'admin') {
  header('Location: homepage.php');
  exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['adicionar'])) {
  $nome = $_POST['nome'];
  $descricao = $_POST['descricao'];
  $preco = $_POST['preco'];
  $categoria_id = $_POST['categoria_id'];
  $ativo = isset($_POST['ativo']) ? 1 : 0;

  $fileName = $_FILES["imagem"]["name"];
  $tempName = $_FILES["imagem"]["tmp_name"];
  $ext = pathinfo($fileName, PATHINFO_EXTENSION);
  $allowedTypes = array("jpg", "jpeg", "png", "gif");

  $uploadFolder = "imagens/";
  if (!is_dir($uploadFolder)) {
    mkdir($uploadFolder, 0777, true);
  }

  $targetPath = $uploadFolder . basename($fileName);

  if (in_array($ext, $allowedTypes)) {
    if (move_uploaded_file($tempName, $targetPath)) {
      $stmt = $conn->prepare("INSERT INTO produtos (nome, preco, descricao, imagem, categoria_id, ativo) VALUES (?, ?, ?, ?, ?, ?)");
      $stmt->bind_param("sdssii", $nome, $preco, $descricao, $fileName, $categoria_id, $ativo);

      if ($stmt->execute()) {
        header("Location: admin_page.php?success=1");
        exit();
      } else {
        echo "Erro ao inserir no banco de dados.";
      }
    } else {
      echo "Falha ao mover o arquivo de imagem.";
    }
  } else {
    echo "Tipo de imagem não permitido. Apenas JPG, PNG, JPEG ou GIF.";
  }
}

if (isset($_GET['delete'])) {
  $id = intval($_GET['delete']);
  $conn->query("DELETE FROM produtos WHERE id = $id");
  header('Location: admin_page.php');
  exit();
}

$categorias = $conn->query("SELECT * FROM categorias")->fetch_all(MYSQLI_ASSOC);
$produtos = $conn->query("SELECT p.*, c.nome AS categoria_nome FROM produtos p JOIN categorias c ON p.categoria_id = c.id")->fetch_all(MYSQLI_ASSOC);
$pedidos = $conn->query("SELECT * FROM pedidos ORDER BY created_at DESC")->fetch_all(MYSQLI_ASSOC);
?>

<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <title>Painel Administrativo</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/admin-style.css">
</head>

<body class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h1>Painel Administrativo</h1>
    <a href="homepage.php" class="btn btn-primary">Ir para Homepage</a>
  </div>

  <form method="post" enctype="multipart/form-data" class="mb-5">
    <h4>Adicionar novo item</h4>
    <div class="row g-3">
      <div class="col-md-6">
        <input type="text" name="nome" class="form-control" placeholder="Nome" required>
      </div>
      <div class="col-md-6">
        <input type="text" name="descricao" class="form-control" placeholder="Descrição" required>
      </div>
      <div class="col-md-4">
        <input type="number" step="0.01" name="preco" class="form-control" placeholder="Preço" required>
      </div>
      <div class="col-md-4">
        <select name="categoria_id" class="form-select" required>
          <option value="">Selecione a categoria</option>
          <?php foreach ($categorias as $categoria): ?>
            <option value="<?= $categoria['id'] ?>"><?= $categoria['nome'] ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-md-4">
        <input type="file" name="imagem" class="form-control" required>
      </div>
      <div class="col-md-12">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" name="ativo" id="ativo" checked>
          <label class="form-check-label" for="ativo">Produto ativo</label>
        </div>
      </div>
      <div class="col-12">
        <button type="submit" name="adicionar" class="btn btn-success">Adicionar</button>
      </div>
    </div>
  </form>

  <h4>Produtos cadastrados</h4>
  <table class="table table-striped">
    <thead>
      <tr>
        <th>ID</th>
        <th>Nome</th>
        <th>Descrição</th>
        <th>Preço</th>
        <th>Categoria</th>
        <th>Imagem</th>
        <th>Ativo</th>
        <th>Ações</th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($produtos as $produto): ?>
        <tr>
          <td><?= $produto['id'] ?></td>
          <td><?= $produto['nome'] ?></td>
          <td><?= $produto['descricao'] ?></td>
          <td>R$ <?= number_format($produto['preco'], 2, ',', '.') ?></td>
          <td><?= $produto['categoria_nome'] ?></td>
          <td><img src="images/<?= $produto['imagem'] ?>" alt="<?= $produto['nome'] ?>" width="50"></td>
          <td><?= $produto['ativo'] ? 'Sim' : 'Não' ?></td>
          <td><a href="?delete=<?= $produto['id'] ?>" class="btn btn-danger btn-sm"
              onclick="return confirm('Tem certeza que deseja excluir este item?')">Excluir</a></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>

  <h4>Pedidos recebidos</h4>
  <table class="table table-bordered">
    <thead>
      <tr>
        <th>ID</th>
        <th>Usuário</th>
        <th>Telefone</th>
        <th>Total</th>
        <th>Endereço</th>
        <th>Data</th>
        <th>Observações</th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($pedidos as $pedido): ?>
        <tr>
          <td><?= $pedido['id'] ?></td>
          <td><?= $pedido['nome_cliente'] ?></td>
          <td><?= $pedido['telefone'] ?></td>
          <td>R$ <?= number_format($pedido['total'], 2, ',', '.') ?></td>
          <td><?= $pedido['endereco'] ?></td>
          <td><?= $pedido['data_pedido'] ?></td>
          <td><?= $pedido['observacoes'] ?></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>

</body>

</html>