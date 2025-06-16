<?php
require_once 'config.php';

function getCategorias($conn)
{
    $sql = "SELECT * FROM categorias WHERE ativo = 1 ORDER BY nome";
    $result = $conn->query($sql);

    $categorias = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $categorias[] = $row;
        }
    }
    return $categorias;
}

function getProdutosPorCategoria($conn, $categoria_id = null)
{
    if ($categoria_id) {
        $sql = "SELECT p.*, c.nome as categoria_nome 
                FROM produtos p 
                JOIN categorias c ON p.categoria_id = c.id 
                WHERE p.ativo = 1 AND p.categoria_id = ? 
                ORDER BY p.nome";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $categoria_id);
        $stmt->execute();
        $result = $stmt->get_result();
    } else {
        $sql = "SELECT p.*, c.nome as categoria_nome 
                FROM produtos p 
                JOIN categorias c ON p.categoria_id = c.id 
                WHERE p.ativo = 1 
                ORDER BY c.nome, p.nome";
        $result = $conn->query($sql);
    }

    $produtos = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $produtos[] = $row;
        }
    }
    return $produtos;
}

function getTodosProdutos($conn)
{
    return getProdutosPorCategoria($conn);
}

function getProdutoPorId($conn, $id)
{
    $sql = "SELECT p.*, c.nome as categoria_nome 
            FROM produtos p 
            JOIN categorias c ON p.categoria_id = c.id 
            WHERE p.id = ? AND p.ativo = 1";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        return $result->fetch_assoc();
    }
    return null;
}
?>