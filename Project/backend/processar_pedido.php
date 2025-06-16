<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$host = 'localhost';
$dbname = 'restaurant_db';
$username = 'root';
$password = '';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['sucesso' => false, 'erro' => 'Método não permitido']);
    exit;
}

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $input = file_get_contents('php://input');
    $dados = json_decode($input, true);

    if (!$dados) {
        throw new Exception('Dados inválidos recebidos');
    }

    $campos_obrigatorios = ['nome', 'telefone', 'endereco', 'itens', 'total'];
    foreach ($campos_obrigatorios as $campo) {
        if (empty($dados[$campo])) {
            throw new Exception("Campo obrigatório não preenchido: $campo");
        }
    }

    if (empty($dados['itens']) || !is_array($dados['itens'])) {
        throw new Exception('Nenhum item no pedido');
    }

    $pdo->beginTransaction();

    $sql_pedido = "INSERT INTO pedidos (nome_cliente, telefone, endereco, observacoes, total, data_pedido, status) 
                   VALUES (:nome, :telefone, :endereco, :observacoes, :total, NOW(), 'pendente')";

    $stmt_pedido = $pdo->prepare($sql_pedido);
    $stmt_pedido->bindParam(':nome', $dados['nome']);
    $stmt_pedido->bindParam(':telefone', $dados['telefone']);
    $stmt_pedido->bindParam(':endereco', $dados['endereco']);
    $stmt_pedido->bindParam(':observacoes', $dados['observacoes']);
    $stmt_pedido->bindParam(':total', $dados['total']);

    $stmt_pedido->execute();

    $pedido_id = $pdo->lastInsertId();

    $sql_item = "INSERT INTO itens_pedido (pedido_id, nome_item, preco_unitario, quantidade, subtotal) 
                 VALUES (:pedido_id, :nome_item, :preco_unitario, :quantidade, :subtotal)";

    $stmt_item = $pdo->prepare($sql_item);

    foreach ($dados['itens'] as $item) {
        $subtotal = $item['preco'] * $item['quantidade'];

        $stmt_item->bindParam(':pedido_id', $pedido_id);
        $stmt_item->bindParam(':nome_item', $item['nome']);
        $stmt_item->bindParam(':preco_unitario', $item['preco']);
        $stmt_item->bindParam(':quantidade', $item['quantidade']);
        $stmt_item->bindParam(':subtotal', $subtotal);

        $stmt_item->execute();
    }

    $pdo->commit();

    echo json_encode([
        'sucesso' => true,
        'pedido_id' => 'PED' . str_pad($pedido_id, 6, '0', STR_PAD_LEFT),
        'mensagem' => 'Pedido processado com sucesso',
        'tempo_entrega' => '45 minutos'
    ]);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollback();
    }

    http_response_code(500);
    echo json_encode([
        'sucesso' => false,
        'erro' => 'Erro no banco de dados: ' . $e->getMessage()
    ]);

} catch (Exception $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollback();
    }

    http_response_code(400);
    echo json_encode([
        'sucesso' => false,
        'erro' => $e->getMessage()
    ]);
}
?>