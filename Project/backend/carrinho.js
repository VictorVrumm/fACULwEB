class CarrinhoCompras {
  constructor() {
    this.itens = JSON.parse(localStorage.getItem("carrinho")) || [];
    this.inicializar();
  }

  inicializar() {
    this.atualizarContador();
    this.adicionarEventListeners();
    this.inicializarFiltros();
  }

  adicionarEventListeners() {
    document.querySelectorAll(".btn-adicionar").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const id = parseInt(e.target.dataset.id);
        const nome = e.target.dataset.nome;
        const preco = parseFloat(e.target.dataset.preco);

        this.adicionarItem(id, nome, preco);
        this.mostrarNotificacao(`${nome} adicionado ao carrinho!`);
      });
    });

    const botaoCarrinho = document.getElementById("carrinho");
    if (botaoCarrinho) {
      botaoCarrinho.removeEventListener("click", this.handleCarrinhoClick);
      this.handleCarrinhoClick = (e) => {
        e.preventDefault();
        this.mostrarCarrinho();
      };
      botaoCarrinho.addEventListener("click", this.handleCarrinhoClick);
    }

    this.adicionarEventListenersModal();
  }

  adicionarEventListenersModal() {
    const modal = document.getElementById("carrinhoModal");
    if (modal) {
      modal.addEventListener("click", (e) => {
        if (e.target.id === "finalizar-pedido") {
          this.finalizarPedido();
        }
      });
    }
  }

  inicializarFiltros() {
    document.querySelectorAll(".filtro-categoria").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();

        document
          .querySelectorAll(".filtro-categoria")
          .forEach((b) => b.classList.remove("active"));
        e.target.classList.add("active");

        const categoria = e.target.dataset.categoria;
        this.filtrarPorCategoria(categoria);
      });
    });
  }

  filtrarPorCategoria(categoria) {
    const categorias = document.querySelectorAll(".categoria-section");

    categorias.forEach((section) => {
      if (categoria === "todas") {
        section.style.display = "block";
      } else {
        const nomeCategoria = section.dataset.categoria;
        section.style.display = nomeCategoria === categoria ? "block" : "none";
      }
    });
  }

  adicionarItem(id, nome, preco) {
    const itemExistente = this.itens.find((item) => item.id === id);

    if (itemExistente) {
      itemExistente.quantidade += 1;
    } else {
      this.itens.push({
        id: id,
        nome: nome,
        preco: preco,
        quantidade: 1,
      });
    }

    this.salvarCarrinho();
    this.atualizarContador();
  }

  removerItem(id) {
    this.itens = this.itens.filter((item) => item.id !== id);
    this.salvarCarrinho();
    this.atualizarContador();
    this.atualizarModalCarrinho();
  }

  alterarQuantidade(id, novaQuantidade) {
    const item = this.itens.find((item) => item.id === id);

    if (item) {
      if (novaQuantidade <= 0) {
        this.removerItem(id);
      } else {
        item.quantidade = novaQuantidade;
        this.salvarCarrinho();
        this.atualizarContador();
        this.atualizarModalCarrinho();
      }
    }
  }

  calcularTotal() {
    return this.itens.reduce(
      (total, item) => total + item.preco * item.quantidade,
      0
    );
  }

  atualizarContador() {
    const totalItens = this.itens.reduce(
      (total, item) => total + item.quantidade,
      0
    );
    document.getElementById("itens-carrinho").textContent = totalItens;
  }

  mostrarCarrinho() {
    this.atualizarModalCarrinho();

    const modalElement = document.getElementById("carrinhoModal");
    if (!modalElement) {
      console.error("Modal carrinhoModal não encontrado!");
      return;
    }

    let modal = bootstrap.Modal.getInstance(modalElement);
    if (!modal) {
      modal = new bootstrap.Modal(modalElement);
    }

    modal.show();
  }

  atualizarModalCarrinho() {
    const container = document.getElementById("carrinho-items");
    const totalElement = document.getElementById("total-carrinho");

    if (this.itens.length === 0) {
      container.innerHTML =
        '<p class="text-center text-muted">Seu carrinho está vazio</p>';
      totalElement.textContent = "0,00";
      document.getElementById("finalizar-pedido").disabled = true;
      return;
    }

    document.getElementById("finalizar-pedido").disabled = false;

    let html = "";
    this.itens.forEach((item) => {
      html += `
                <div class="carrinho-item">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h6 class="mb-1">${item.nome}</h6>
                            <small class="text-muted">R$ ${item.preco
                              .toFixed(2)
                              .replace(".", ",")}</small>
                        </div>
                        <div class="col-md-3">
                            <div class="quantidade-controls">
                                <button type="button" onclick="window.carrinho.alterarQuantidade(${
                                  item.id
                                }, ${item.quantidade - 1})">-</button>
                                <span class="mx-2">${item.quantidade}</span>
                                <button type="button" onclick="window.carrinho.alterarQuantidade(${
                                  item.id
                                }, ${item.quantidade + 1})">+</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <strong>R$ ${(item.preco * item.quantidade)
                              .toFixed(2)
                              .replace(".", ",")}</strong>
                        </div>
                        <div class="col-md-1">
                            <button class="btn btn-sm btn-outline-danger" onclick="window.carrinho.removerItem(${
                              item.id
                            })">
                                🗑️
                            </button>
                        </div>
                    </div>
                </div>
            `;
    });

    container.innerHTML = html;
    totalElement.textContent = this.calcularTotal()
      .toFixed(2)
      .replace(".", ",");
  }

  finalizarPedido() {
    if (this.itens.length === 0) {
      alert("Seu carrinho está vazio!");
      return;
    }

    const modalBody = document.querySelector("#carrinhoModal .modal-body");
    modalBody.innerHTML = `
            <h5>Dados para Entrega</h5>
            <form id="form-pedido">
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome Completo *</label>
                    <input type="text" class="form-control" id="nome" required>
                </div>
                <div class="mb-3">
                    <label for="telefone" class="form-label">Telefone *</label>
                    <input type="tel" class="form-control" id="telefone" required>
                </div>
                <div class="mb-3">
                    <label for="endereco" class="form-label">Endereço Completo *</label>
                    <textarea class="form-control" id="endereco" rows="3" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="observacoes" class="form-label">Observações</label>
                    <textarea class="form-control" id="observacoes" rows="2" placeholder="Alguma observação especial?"></textarea>
                </div>
            </form>
            
            <hr>
            <h5>Resumo do Pedido</h5>
            <div id="resumo-pedido"></div>
            <div class="text-end mt-3">
                <h4>Total: R$ <span id="total-final">${this.calcularTotal()
                  .toFixed(2)
                  .replace(".", ",")}</span></h4>
            </div>
        `;

    this.mostrarResumoPedido();

    document.querySelector("#carrinhoModal .modal-footer").innerHTML = `
            <button type="button" class="btn btn-secondary" onclick="window.carrinho.voltarCarrinho()">Voltar ao Carrinho</button>
            <button type="button" class="btn btn-success" onclick="window.carrinho.confirmarPedido()">Confirmar Pedido</button>
        `;
  }

  mostrarResumoPedido() {
    const container = document.getElementById("resumo-pedido");
    let html = "";

    this.itens.forEach((item) => {
      html += `
                <div class="d-flex justify-content-between">
                    <span>${item.quantidade}x ${item.nome}</span>
                    <span>R$ ${(item.preco * item.quantidade)
                      .toFixed(2)
                      .replace(".", ",")}</span>
                </div>
            `;
    });

    container.innerHTML = html;
  }

  voltarCarrinho() {
    const modalBody = document.querySelector("#carrinhoModal .modal-body");
    modalBody.innerHTML = `
      <div id="carrinho-items"></div>
      <hr>
      <div class="text-end">
        <h4>Total: R$ <span id="total-carrinho">0,00</span></h4>
      </div>
    `;

    this.atualizarModalCarrinho();

    document.querySelector("#carrinhoModal .modal-footer").innerHTML = `
      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Continuar Comprando</button>
      <button type="button" class="btn btn-success" id="finalizar-pedido">Finalizar Pedido</button>
    `;
  }

  confirmarPedido() {
    const form = document.getElementById("form-pedido");

    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    const dados = {
      nome: document.getElementById("nome").value,
      telefone: document.getElementById("telefone").value,
      endereco: document.getElementById("endereco").value,
      observacoes: document.getElementById("observacoes").value,
      itens: this.itens,
      total: this.calcularTotal(),
    };

    this.enviarPedido(dados);
  }

  enviarPedido(dados) {
    document.querySelector("#carrinhoModal .modal-body").innerHTML = `
            <div class="text-center p-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Processando...</span>
                </div>
                <p class="mt-3">Processando seu pedido...</p>
            </div>
        `;

    fetch("backend/processar_pedido.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify(dados),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(
            `Erro HTTP: ${response.status} - ${response.statusText}`
          );
        }

        const contentType = response.headers.get("content-type");
        if (!contentType || !contentType.includes("application/json")) {
          throw new Error("Resposta não é um JSON válido");
        }

        return response.json();
      })
      .then((result) => {
        if (result.sucesso) {
          this.mostrarSucesso(result, dados);
        } else {
          throw new Error(result.erro || "Erro desconhecido");
        }
      })
      .catch((error) => {
        console.error("Erro detalhado:", error);
        this.mostrarErro(error.message);
      });
  }

  mostrarSucesso(result, dados) {
    document.querySelector("#carrinhoModal .modal-body").innerHTML = `
            <div class="text-center p-4">
                <div class="text-success mb-3">
                    <svg width="64" height="64" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.061L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>
                </div>
                <h4 class="text-success">Pedido Confirmado!</h4>
                <p>Seu pedido #${
                  result.pedido_id
                } foi recebido e será entregue em aproximadamente ${
      result.tempo_entrega || "45 minutos"
    }.</p>
                <p><strong>Total:</strong> R$ ${dados.total
                  .toFixed(2)
                  .replace(".", ",")}</p>
                <p><strong>Entrega:</strong> ${dados.endereco}</p>
            </div>
        `;

    document.querySelector("#carrinhoModal .modal-footer").innerHTML = `
            <button type="button" class="btn btn-primary" data-bs-dismiss="modal" onclick="window.carrinho.limparCarrinho()">Fechar</button>
        `;
  }

  mostrarErro(mensagemErro) {
    document.querySelector("#carrinhoModal .modal-body").innerHTML = `
            <div class="text-center p-4">
                <div class="text-danger mb-3">
                    <svg width="64" height="64" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/>
                    </svg>
                </div>
                <h4 class="text-danger">Erro ao Processar Pedido</h4>
                <p>Ocorreu um erro ao processar seu pedido. Tente novamente.</p>
                <p class="small text-muted">${mensagemErro}</p>
                <div class="mt-3">
                    <small class="text-muted">
                        <strong>Dicas de solução:</strong><br>
                        • Verifique se a pasta 'backend' existe<br>
                        • Certifique-se de que o arquivo 'processar_pedido.php' está no local correto<br>
                        • Verifique se o servidor PHP está rodando
                    </small>
                </div>
            </div>
        `;

    document.querySelector("#carrinhoModal .modal-footer").innerHTML = `
            <button type="button" class="btn btn-secondary" onclick="window.carrinho.voltarCarrinho()">Tentar Novamente</button>
        `;
  }

  limparCarrinho() {
    this.itens = [];
    this.salvarCarrinho();
    this.atualizarContador();
  }

  salvarCarrinho() {
    localStorage.setItem("carrinho", JSON.stringify(this.itens));
  }

  mostrarNotificacao(mensagem) {
    const notificacao = document.createElement("div");
    notificacao.className = "alert alert-success position-fixed";
    notificacao.style.cssText =
      "top: 20px; right: 20px; z-index: 9999; min-width: 300px;";
    notificacao.innerHTML = `
            <strong>✓</strong> ${mensagem}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

    document.body.appendChild(notificacao);

    setTimeout(() => {
      notificacao.remove();
    }, 3000);
  }
}

document.addEventListener("DOMContentLoaded", function () {
  window.carrinho = new CarrinhoCompras();
});
