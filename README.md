# 🛒 Simulador de Loja Virtual (Portugol)

Este é um algoritmo de console extremamente complexo e robusto que simula uma plataforma de e-commerce completa, implementada em Portugol (VisualG).

Este projeto é o mais avançado da série, demonstrando o uso de múltiplos **Registros Aninhados** (`tipo`), **gerenciamento de estado** (sessão de login), **menus contextuais** (Cliente vs. Admin) e **lógica de negócios** crítica para transações de estoque e pedidos.



## ✨ Funcionalidades Principais

O sistema possui dois "modos" de operação, dependendo do tipo de usuário que faz o login:

### 👨‍💼 Painel de Admin
* **Adicionar Produtos:** Cadastra novos produtos com nome, preço e estoque inicial.
* **Validação de Cadastro:** Impede o cadastro de produtos com nomes duplicados ou valores inválidos.
* **Visualização Geral:** Pode ver todos os produtos e **todos os pedidos** de **todos os clientes**.

### 🙍 Painel de Cliente
* **Exibir Produtos:** Vê a lista de produtos disponíveis, seus preços e estoque.
* **Adicionar ao Carrinho:** Adiciona produtos ao carrinho. O sistema valida se a quantidade pedida está disponível em estoque.
* **Finalizar Compra:** Processa o checkout. O sistema re-valida o estoque de todos os itens do carrinho no momento da compra (para evitar conflitos) e, se bem-sucedido, cria um `Pedido`.
* **Meus Pedidos:** O cliente pode visualizar apenas o *seu* histórico de pedidos, incluindo os itens comprados em cada um.

## 🏛️ Estrutura e Lógica Avançada (As Melhorias)

Este algoritmo foi refatorado para corrigir falhas críticas de lógica de negócios e otimizar a estrutura de dados.

### 1. `tipo` (Registros) Interconectados
* `Usuario`: Armazena dados de login.
* `Produto`: Armazena dados do catálogo.
* **`ItemCarrinho` (Otimização):** Este registro é leve. Ele armazena apenas o `indiceProduto` (um inteiro) e a `quantidade`. Isso é muito mais eficiente do que copiar o registro `Produto` inteiro para o carrinho.
* `Pedido`: O registro mestre que "amarra" tudo, armazenando o `indiceUsuario` e um *vetor* de `ItemCarrinho`.

### 2. Correção Crítica da Lógica de Estoque
A melhoria mais importante foi na lógica de quando o estoque é abatido (removido).
* **Lógica Antiga (Errada):** O estoque era removido ao "Adicionar ao Carrinho".
* **Lógica Nova (Correta):** O estoque **NÃO** é tocado quando o item é adicionado ao carrinho. O sistema apenas verifica se a quantidade está disponível. O estoque é **somente** abatido (removido) no exato momento em que o usuário clica em `finalizarCompra`. Isso previne inconsistências graves causadas por "carrinhos abandonados".

### 3. Correção Crítica da Lógica de Pedidos
* **Lógica Antiga (Errada):** O pedido "apontava" para o carrinho (`pedidos.itens ← carrinhoAtual`), o que fazia o pedido ficar vazio assim que o carrinho era limpo.
* **Lógica Nova (Correta):** O procedimento `finalizarCompra` executa um *loop* que **copia** cada `ItemCarrinho` do `carrinhoAtual` para dentro do vetor `pedidos[i].itens`. Isso cria um **histórico permanente** e independente, permitindo que o carrinho seja limpo com segurança.

## 🚀 Como Executar

Para executar este algoritmo, você precisará de um interpretador de Portugol.

1.  **VisualG (Recomendado):**
    * Baixe e instale o [VisualG](http://visualg.com.br/cli/).
    * Copie o código-fonte (`.alg`) do arquivo.
    * Abra o VisualG e cole o código.
    * Pressione **F9** (ou clique em "Rodar") para executar.

> **Login Padrão:** Para facilitar os testes, um usuário `admin` é criado automaticamente.
> * **Email:** `admin`
> * **Senha:** `admin`
