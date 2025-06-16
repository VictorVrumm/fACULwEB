<?php
session_start();

require_once 'backend/functions.php';

$categorias = getCategorias($conn);
$produtos = getTodosProdutos($conn);



$produtosPorCategoria = [];
foreach ($produtos as $produto) {
  $produtosPorCategoria[$produto['categoria_nome']][] = $produto;
}
?>



<!DOCTYPE html>
<html lang="pt-br">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Restaurante - Cardápio</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="css/homepage-style.css" />
</head>

<body>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
      <a class="navbar-brand" href="#">🍽️ Meu Restaurante</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link active" href="#cardapio">Cardápio</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" id="carrinho">🛒 Carrinho (<span id="itens-carrinho">0</span>)</a>
          </li>
          <?php if (isset($_SESSION['funcao']) && $_SESSION['funcao'] === 'admin'): ?>
            <li class="nav-item">
              <a class="nav-link text-warning" href="admin_page.php">Painel Admin</a>
            </li>
          <?php endif; ?>
          <div>
            <a href="perfil.php" class="btn btn-outline-primary">Meu Perfil</a>
            <a href="logout.php" class="btn btn-outline-danger ml-2">Sair</a>
          </div>
        </ul>

      </div>
    </div>
  </nav>

  <section class="hero bg-primary text-white text-center py-5">
    <div class="container">
      <h1 class="display-4">Bem-vindo ao Nosso Restaurante</h1>
      <p class="lead">
        Sabores únicos, ingredientes frescos, experiência inesquecível
      </p>
      <a href="#cardapio" class="btn btn-light btn-lg">Ver Cardápio</a>
    </div>
  </section>

  <section id="cardapio" class="py-5">
    <div class="container">
      <h2 class="text-center mb-5">Nosso Cardápio</h2>

      <div class="text-center mb-4">
        <button class="btn btn-outline-primary me-2 filtro-categoria active" data-categoria="todas">
          Todas
        </button>
        <?php foreach ($categorias as $categoria): ?>
          <button class="btn btn-outline-primary me-2 filtro-categoria" data-categoria="<?= $categoria['nome'] ?>">
            <?= $categoria['nome'] ?>
          </button>
        <?php endforeach; ?>
      </div>

      <?php foreach ($produtosPorCategoria as $nomeCategoria =>
        $produtosCategoria): ?>
        <div class="categoria-section mb-5" data-categoria="<?= $nomeCategoria ?>">
          <h3 class="mb-4 text-primary"><?= $nomeCategoria ?></h3>
          <div class="row">
            <?php foreach ($produtosCategoria as $produto): ?>
              <div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 produto-card">


                  <img src="imagens/<?= $produto['imagem'] ?: 'placeholder.jpg' ?>" class="card-img-top"
                    alt="<?= $produto['nome'] ?>" style="height: 200px; object-fit: cover" />

                  <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><?= $produto['nome'] ?></h5>
                    <p class="card-text flex-grow-1">
                      <?= $produto['descricao'] ?>
                    </p>
                    <div class="mt-auto">
                      <div class="d-flex justify-content-between align-items-center">
                        <span class="h5 text-success mb-0">R$
                          <?= number_format($produto['preco'], 2, ',', '.') ?></span>
                        <button class="btn btn-primary btn-adicionar" data-id="<?= $produto['id'] ?>"
                          data-nome="<?= $produto['nome'] ?>" data-preco="<?= $produto['preco'] ?>">
                          Adicionar
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            <?php endforeach; ?>
          </div>
        </div>
      <?php endforeach; ?>
    </div>
  </section>

  <div class="modal fade" id="carrinhoModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Seu Carrinho</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div id="carrinho-items"></div>
          <div class="text-end mt-3">
            <h4>Total: R$ <span id="total-carrinho">0,00</span></h4>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
            Continuar Comprando
          </button>
          <button type="button" class="btn btn-success" id="finalizar-pedido">
            Finalizar Pedido
          </button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="backend/carrinho.js"></script>
</body>

</html>