-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 17/06/2025 às 00:15
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `restaurant_db`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categorias`
--

INSERT INTO `categorias` (`id`, `nome`, `descricao`, `ativo`) VALUES
(1, 'Massas', 'Deliciosas massas artesanais', 1),
(2, 'Saladas', 'Saladas frescas e saudáveis', 1),
(3, 'Sobremesas', 'Doces irresistíveis', 1),
(4, 'Bebidas', 'Bebidas refrescantes', 1),
(5, 'Carnes', 'Carnes grelhadas e assados', 1),
(6, 'Entradas', 'Entradas espetaculares', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `itens_pedido`
--

CREATE TABLE `itens_pedido` (
  `id` int(11) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `nome_item` varchar(255) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `itens_pedido`
--

INSERT INTO `itens_pedido` (`id`, `pedido_id`, `nome_item`, `preco_unitario`, `quantidade`, `subtotal`, `created_at`) VALUES
(8, 7, 'Bife Grelhado com Arroz, Feijão e Salada', 35.00, 1, 35.00, '2025-06-16 20:49:59'),
(9, 7, 'Medalhões de Carne com Batata Rosti e Palha Crocante', 85.00, 1, 85.00, '2025-06-16 20:49:59'),
(10, 8, 'Bife Grelhado com Arroz, Feijão e Salada', 35.00, 1, 35.00, '2025-06-16 22:09:32'),
(11, 8, 'Martini Vermelho com Gelo Quebrado e Twist de Laranja', 27.00, 1, 27.00, '2025-06-16 22:09:32'),
(12, 8, 'Bruschetta de Tomates Cereja Assados com Pesto ou Espinafre Salteado', 20.00, 1, 20.00, '2025-06-16 22:09:32'),
(13, 8, 'Torta Tres Leches com Frutas Vermelhas', 30.00, 1, 30.00, '2025-06-16 22:09:32'),
(14, 9, 'Torradas Francesas com Banana, Mirtilos e Xarope', 18.00, 1, 18.00, '2025-06-16 22:12:57'),
(15, 9, 'Salada de Queijo Halloumi Grelhado com Frutas e Nozes', 43.00, 1, 43.00, '2025-06-16 22:12:57'),
(16, 9, 'Chá Gelado ou Drink de Cola com Limão e Hortelã', 17.00, 1, 17.00, '2025-06-16 22:12:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `nome_cliente` varchar(255) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `endereco` text NOT NULL,
  `observacoes` text DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `data_pedido` datetime NOT NULL,
  `status` enum('pendente','preparando','pronto','entregue','cancelado') DEFAULT 'pendente',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedidos`
--

INSERT INTO `pedidos` (`id`, `nome_cliente`, `telefone`, `endereco`, `observacoes`, `total`, `data_pedido`, `status`, `created_at`, `updated_at`) VALUES
(7, 'Caio Gomes', '(11)00000-0800', 'Rua das Rosas', 'Oi', 120.00, '2025-06-16 17:49:59', 'pendente', '2025-06-16 20:49:59', '2025-06-16 20:49:59'),
(8, 'Caio', '(00)00000-1234', 'Avenida Papa João XXIII', 'Estou com fome', 112.00, '2025-06-16 19:09:32', 'pendente', '2025-06-16 22:09:32', '2025-06-16 22:09:32'),
(9, 'Beth', '(00)12345-6789', 'Rua das Acácias', 'Xadrez', 78.00, '2025-06-16 19:12:57', 'pendente', '2025-06-16 22:12:57', '2025-06-16 22:12:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `produtos`
--

CREATE TABLE `produtos` (
  `id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `descricao` text DEFAULT NULL,
  `imagem` varchar(255) DEFAULT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produtos`
--

INSERT INTO `produtos` (`id`, `nome`, `preco`, `descricao`, `imagem`, `categoria_id`, `ativo`, `created_at`) VALUES
(30, 'Bife Grelhado com Arroz, Feijão e Salada', 35.00, 'Fatias de bife grelhado acompanhadas de arroz soltinho, feijão e salada fresca de folhas e pico de gallo. Um prato completo e reconfortante, típico da culinária caseira brasileira ou de restaurantes casuais.', 'Bife Grelhado com Arroz, Feijão e Salada.jpg', 5, 1, '2025-06-15 23:36:17'),
(31, 'Medalhões de Carne com Batata Rosti e Palha Crocante', 85.00, 'Duas porções generosas de medalhões de carne, possivelmente filé mignon, servidas sobre uma base dourada que parece ser batata rosti ou uma espécie de tortilha de batata. O prato é finalizado com palha crocante por cima e cebolinha picada, acompanhado por um molho agridoce ou de frutas vermelhas e um tomate cereja assado. Um limão fresco ao lado sugere um toque cítrico opcional.', 'bolas-de-carne-com-rodelas-de-batata-frita-no-prato.jpg', 5, 1, '2025-06-16 20:47:33'),
(32, 'Spaghetti Nero di Seppia com Frutos do Mar e Tomates Cereja', 75.00, 'Um prato de massa elegante e vibrante, featuring spaghetti tingido de preto com tinta de lula (nero di seppia). A massa é ricamente acompanhada por uma variedade de frutos do mar frescos, como camarões e anéis de lula, e tomates cereja em tons de vermelho e amarelo. Finalizado com ervas frescas picadas, este prato exala sabor mediterrâneo.', 'Spaghetti Nero di Seppia com Frutos do Mar e Tomates Cereja.png', 1, 1, '2025-06-16 21:14:58'),
(33, 'Bruschetta de Tomates Cereja Assados com Pesto ou Espinafre Salteado', 20.00, 'Uma fatia generosa de pão rústico, levemente tostado, servindo de base para uma cama de vegetais verdes salteados, que pode ser espinafre ou um pesto mais rústico. Por cima, um cacho de tomates cereja assados até ficarem macios e adocicados, guarnecido com ervas frescas. Uma entrada ou petisco mediterrâneo, leve e saboroso.', 'Bruschetta de Tomates Cereja Assados com Pesto ou Espinafre Salteado.png', 6, 1, '2025-06-16 21:16:44'),
(34, 'Nhoque ao Molho Sugo com Parmesão', 40.00, 'Um clássico da culinária italiana, este prato apresenta nhoques macios e caseiros, perfeitamente cozidos. Eles são generosamente cobertos por um molho de tomate sugo vibrante, e finalizados com uma porção farta de queijo parmesão ralado e algumas folhas de manjericão fresco para realçar o sabor.', 'Nhoque ao Molho Sugo com Parmesão.png', 1, 1, '2025-06-16 21:19:18'),
(35, 'Salada de Atum Selado com Gergelim', 35.00, 'Um prato leve e sofisticado que combina fatias de atum fresco selado, com as bordas cobertas por sementes de gergelim, revelando um interior rosado. É servido sobre uma cama de folhas verdes variadas, brotos e vegetais finamente fatiados, como rabanete e cenoura, com um crocante de massa frita por cima. Um molho escuro, provavelmente à base de shoyu, completa o prato.', 'Salada de Atum Selado com Gergelim.png', 2, 1, '2025-06-16 21:21:27'),
(36, 'Magret de Pato com Gratin Dauphinois e Vegetais Assados', 20.00, 'Duas suculentas fatias de magret de pato, seladas e com interior rosado, são o destaque. Elas são acompanhadas por uma torre de gratin dauphinois (batatas fatiadas e assadas em camadas cremosas), vegetais assados como cenouras baby e brócolis, e um tomate cereja confitado, tudo regado por um molho rico e brilhante. Um prato sofisticado de alta gastronomia.', 'Magret de Pato com Gratin Dauphinois e Vegetais Assados.png', 6, 1, '2025-06-16 21:23:26'),
(37, 'Torradas Francesas com Banana, Mirtilos e Xarope', 18.00, 'Uma torre apetitosa de torradas francesas, levemente douradas e polvilhadas com açúcar de confeiteiro. Entre as camadas, há fatias frescas de banana e mirtilos vibrantes. Um fio de xarope, que pode ser bordo ou mel, escorre sobre as frutas, tornando este um café da manhã ou brunch doce e reconfortante.', 'Torradas Francesas com Banana, Mirtilos e Xarope.png', 6, 1, '2025-06-16 21:25:03'),
(38, 'Filé Mignon Grelhado com Aspargos, Batatas Assadas e Molho Rústico', 70.00, 'Um suculento corte de filé mignon, com marcas de grelha evidentes, servido sobre um molho escuro e rico. O prato é elegantemente acompanhado por talos de aspargos verdes vibrantes, batatas assadas rústicas e um pequeno monte de brotos frescos. Ao fundo, um copo de vinho tinto e batatas fritas sugerem um ambiente de restaurante.', 'Filé Mignon Grelhado com Aspargos, Batatas Assadas e Molho Rústico.png', 5, 1, '2025-06-16 21:26:30'),
(39, 'Mousse de Chocolate e Sorvete de Coco com Frutas Tropicais', 37.00, 'Uma sobremesa delicada e artística, apresentando uma porção de mousse de chocolate levemente salpicada com grãos, acompanhada de uma bola de sorvete branco, possivelmente coco ou baunilha. O prato é guarnecido com frutas tropicais frescas como kiwi, pitaia e mamão, um physalis, uma fatia de melancia em formato de coração e um detalhe decorativo que parece uma borboleta.', 'Mousse de Chocolate e Sorvete de Coco com Frutas Tropicais.png', 3, 1, '2025-06-16 21:28:34'),
(40, 'Semiesfera de Frutas Amarelas com Frutas Vermelhas e Crumble', 35.00, 'Uma sobremesa primorosamente apresentada, com uma semiesfera brilhante de cor amarela, que pode ser de maracujá, manga ou damasco, rodeada por pequenas esferas da mesma fruta. O prato é artisticamente decorado com uma variedade de frutas vermelhas frescas (framboesas, mirtilos, amoras, groselhas), flores comestíveis e um crumble crocante', 'Semiesfera de Frutas Amarelas com Frutas Vermelhas e Crumble.png', 3, 1, '2025-06-16 21:30:20'),
(41, 'Torta Tres Leches com Frutas Vermelhas', 30.00, 'Uma fatia de bolo úmido, saturada com uma mistura de três tipos de leite, coberta com um creme branco e leve. É ricamente decorada com morangos frescos, framboesas, raspas de limão e polvilhada com cacau em pó, imersa em uma calda cremosa na base do prato. Ao fundo, churros e guacamole sugerem uma culinária latina.', 'Torta Tres Leches com Frutas Vermelhas.png', 3, 1, '2025-06-16 21:31:57'),
(42, 'Salada de Grãos e Vegetais com Salmão ou Atum em Cubos', 46.00, 'Uma salada colorida e texturizada, montada em forma de torre. Contém uma mistura de grãos (possivelmente quinoa), cubos de abacate, pimentão, cebola roxa e o que parece ser pedaços de salmão ou atum. É coberta com pepino picado e sementes de chia, e o prato é decorado com um molho vermelho.', 'Salada de Grãos e Vegetais com Salmão ou Atum em Cubos.png', 2, 1, '2025-06-16 21:34:06'),
(43, 'Berinjela Grelhada com Salada Fresca e Molho Vibrante', 40.00, 'Fatias de berinjela grelhada, levemente tostadas, servidas sobre um molho amarelo-alaranjado e cremoso. O prato é coroado com uma montanha de folhas verdes frescas, como alface e rúcula, e salpicado com uma vinagrete de tomate e ervas. Parece ser uma opção vegetariana ou um acompanhamento sofisticado.', 'Berinjela Grelhada com Salada Fresca e Molho Vibrante.png', 2, 1, '2025-06-16 21:35:12'),
(44, 'Bolinhos de Frango ou Porco Agridoce com Gergelim sobre Rúcula', 22.00, 'Um prato de aperitivos ou entrada composto por bolinhos empanados e fritos, possivelmente de frango ou porco, generosamente regados com um molho agridoce e salpicados com sementes de gergelim. Servidos sobre uma cama de folhas frescas de rúcula, adicionando um contraste de sabor e frescor.', 'Bolinhos de Frango ou Porco Agridoce com Gergelim sobre Rúcula.png', 6, 1, '2025-06-16 21:38:38'),
(45, 'Pastéis Fritos com Molho', 18.00, 'Um prato de aperitivo com pastéis dourados e crocantes, provavelmente recheados e fritos, dispostos sobre uma superfície escura. São salpicados com cebolinha picada e pequenas flores decorativas, e servidos com um molho escuro para acompanhar, que pode ser shoyu ou agridoce.', 'Pastéis Fritos com Molho.png', 6, 1, '2025-06-16 21:41:00'),
(46, 'Salada de Rúcula, Beterraba e Abacaxi Grelhado', 25.00, 'Uma salada fresca e colorida em uma tigela de madeira, com folhas verdes como rúcula e alface, pedaços de beterraba cozida e fatias de abacaxi grelhado. Há também pedaços de pimentão vermelho e cebola roxa, criando um contraste de sabores doces, terrosos e ligeiramente amargos.', 'Salada de Rúcula, Beterraba e Abacaxi Grelhado.png', 2, 1, '2025-06-16 21:43:11'),
(47, 'Torta de Cereja ou Frutas Vermelhas', 40.00, 'Uma fatia generosa de torta com uma base de massa crocante e um recheio abundante de cerejas ou outras frutas vermelhas, brilhantes e suculentas, possivelmente com um leve molho agridoce. É uma sobremesa clássica, com cores vibrantes e um aspecto convidativo.', 'Torta de Cereja ou Frutas Vermelhas.png', 3, 1, '2025-06-16 21:44:59'),
(48, 'Mil-folhas de Morango com Creme e Pistache', 36.00, 'Uma fatia elegante de mil-folhas, com camadas de massa folhada crocante e um creme suave, intercaladas com fatias frescas de morango. A sobremesa é decorada com pedacinhos de pistache ou outras nozes e morangos frescos por cima, polvilhada com açúcar de confeiteiro para finalizar.', 'Mil-folhas de Morango com Creme e Pistache.png', 3, 1, '2025-06-16 21:46:41'),
(49, 'Cheesecake de Caramelo com Raspas de Chocolate', 40.00, 'Uma fatia tentadora de cheesecake cremoso, generosamente coberta com calda de caramelo escorrida pela lateral. Por cima, uma cascata de raspas de chocolate adiciona textura e sabor. A base crocante e o contraste de sabores tornam esta uma sobremesa rica e indulgente.', 'Cheesecake de Caramelo com Raspas de Chocolate.png', 3, 1, '2025-06-16 21:48:04'),
(50, 'Salada de Queijo Halloumi Grelhado com Frutas e Nozes', 43.00, 'Um prato visualmente atraente, apresentando fatias triangulares de queijo halloumi grelhado, com suas marcas caramelizadas. O queijo é disposto sobre fatias finas de frutas (como caqui ou manga) e acompanhado por mirtilos vermelhos e nozes. Uma opção leve e saborosa, perfeita como entrada ou prato principal para vegetarianos.', 'Salada de Queijo Halloumi Grelhado com Frutas e Nozes.png', 2, 1, '2025-06-16 21:49:34'),
(51, 'Chá Gelado ou Drink de Cola com Limão e Hortelã', 17.00, 'Um copo alto e transparente repleto de gelo e uma bebida escura e refrescante, que pode ser chá gelado ou um drink à base de cola. É guarnecido com uma rodela de limão e folhas de hortelã, e servido sobre uma tábua de madeira com gomos de limão ao lado.', 'Chá Gelado ou Drink de Cola com Limão e Hortelã.png', 4, 1, '2025-06-16 21:54:03'),
(52, 'Martini Vermelho com Gelo Quebrado e Twist de Laranja', 27.00, 'Um coquetel vibrante de coloração vermelha intensa, servido em uma taça de martini, com uma montanha de gelo quebrado no topo. É guarnecido com um twist elegante de casca de laranja, e a imagem é dramática com um spray de algo branco, possivelmente açúcar ou sal, criando um efeito de neve.', 'Martini Vermelho com Gelo Quebrado e Twist de Laranja.png', 4, 1, '2025-06-16 21:55:29'),
(53, 'Coquetel Sunrise', 25.00, 'Um drink visualmente impactante com camadas distintas: uma inferior amarela vibrante (provavelmente suco de laranja ou abacaxi) e uma superior escura (café ou cold brew). Completo com gelo e uma fatia de laranja desidratada na borda, este coquetel oferece uma experiência refrescante e única.', 'Coquetel Sunrise.png', 4, 1, '2025-06-16 21:57:06'),
(54, 'Fusilli ao Molho de Tomate Rústico com Manjericão', 35.00, 'Um prato de massa simples e apetitoso, apresentando fusilli perfeitamente cozidos e envoltos em um molho de tomate rústico, com pedaços de vegetais, como pimentão. É guarnecido com folhas frescas de manjericão e tomates cereja, sugerindo um sabor fresco e caseiro. Ideal para uma refeição rápida e saborosa.', 'Fusilli ao Molho de Tomate Rústico com Manjericão.png', 1, 1, '2025-06-16 22:00:26'),
(55, 'Massa Mafalda com Frango ao Molho de Tomate', 40.00, 'Um prato reconfortante featuring massa tipo mafalda (ou reginette), com suas bordas onduladas, coberta por pedaços de frango em um molho vibrante de tomate. É finalizado com uma pitada de pimenta e servido em uma tigela rústica sobre um pano de mesa xadrez verde e branco.', 'Massa Mafalda com Frango ao Molho de Tomate.png', 1, 1, '2025-06-16 22:02:18'),
(56, 'Lomo Saltado com Arroz e Batatas Fritas', 45.00, 'Um prato clássico da culinária peruana, este Lomo Saltado apresenta tiras de carne bovina salteadas com cebola roxa e pimentões coloridos, envoltas em um molho saboroso. É servido com um montinho de arroz branco soltinho e uma porção generosa de batatas fritas crocantes.', 'Lomo Saltado com Arroz e Batatas Fritas.png', 5, 1, '2025-06-16 22:04:13'),
(57, 'Lasanha à Bolonhesa com Salada Verde', 45.00, 'Uma generosa porção de lasanha, com suas camadas visíveis de massa, molho de carne e queijo, coberta por um molho de tomate e abundantemente polvilhada com queijo parmesão ralado. Acompanha uma salada fresca de folhas verdes e é guarnecida com folhas de manjericão.', 'Lasanha à Bolonhesa com Salada Verde.png', 1, 1, '2025-06-16 22:05:56'),
(58, 'Bowl de Carne Grelhada com Arroz, Feijão e Salada', 39.00, 'Um prato completo e substancioso, servido em um bowl, contendo fatias de carne grelhada. Acompanha arroz, uma mistura de feijão com pico de gallo e uma porção de folhas verdes frescas, possivelmente coentro ou salsa. Um molho ou guacamole é visível ao fundo.', 'Bowl de Carne Grelhada com Arroz, Feijão e Salada.png', 5, 1, '2025-06-16 22:07:19');

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `senha` varchar(200) NOT NULL,
  `funcao` enum('user','admin') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `nome`, `email`, `senha`, `funcao`) VALUES
(14, 'Victor Henrique', 'vitor002@gmail.com', '$2y$10$8yj9ApKL64MJnlgq282Jn.2A508k9XT8yLPdlWlHs0o0duq938iIS', 'admin'),
(15, 'Caio Gomes', 'caioG@gmail.com', '$2y$10$whyUmvyVBR9Bby2Aa96azuCd.IA6PNYDZ9nZdRfPOWuhU4z66PumW', 'user'),
(16, 'Gabriel Martinelli', 'gabs@gmail.com', '$2y$10$tm2yG1gWt4qsc9iAYHSMDu0C3Y/GFPGMDVe4D5PnOjPmPGCgLZsdu', 'user'),
(17, 'Estevão', 'est@gmail.com', '$2y$10$cNG8d/WmtYreB1KZpC5g2eaYVyeKSUFSbcqpxankxE4CT8a5eEUqa', 'user'),
(18, 'Beth Harmon', 'bh@gmail.com', '$2y$10$kGfgHobyWhwaBjiZsfgUEuszeKQp/52UiMTuac3SW9dQi.9SOaKp6', 'user');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `itens_pedido`
--
ALTER TABLE `itens_pedido`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pedido_id` (`pedido_id`);

--
-- Índices de tabela `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_unique` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `itens_pedido`
--
ALTER TABLE `itens_pedido`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de tabela `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `itens_pedido`
--
ALTER TABLE `itens_pedido`
  ADD CONSTRAINT `itens_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
