algoritmo "Simulador de Loja Virtual Aprimorado"

// --- Constantes de Limite ---
const
   LIMITE_USUARIOS = 50
   LIMITE_PRODUTOS = 50
   LIMITE_PEDIDOS = 50
   LIMITE_CARRINHO = 20

// --- Definição dos Tipos (Registros) ---
tipo Usuario
   nome: caractere
   email: caractere
   senha: caractere
   tipo: caractere // "cliente" ou "admin"
fimTipo

tipo Produto
   nome: caractere
   preco: real
   estoque: inteiro
fimTipo

// --- OTIMIZAÇÃO: O item do carrinho armazena o ÍNDICE do produto ---
tipo ItemCarrinho
   indiceProduto: inteiro // O índice (posição) do produto no vetor 'produtos'
   quantidade: inteiro
fimTipo

tipo Pedido
   indiceUsuario: inteiro
   itens: vetor[1..LIMITE_CARRINHO] de ItemCarrinho
   totalItens: inteiro // Quantos itens estão neste pedido
   total: real
   status: caractere // "Em andamento", "Concluído"
fimTipo

// --- Variáveis Globais ---
var
   usuarios: vetor[1..LIMITE_USUARIOS] de Usuario
   produtos: vetor[1..LIMITE_PRODUTOS] de Produto
   pedidos: vetor[1..LIMITE_PEDIDOS] de Pedido
   carrinhoAtual: vetor[1..LIMITE_CARRINHO] de ItemCarrinho
   
   totalUsuarios, totalProdutos, totalPedidos, totalItensCarrinho: inteiro
   
   // Armazena o ÍNDICE do usuário logado
   indiceUsuarioLogado: inteiro
   
   opcao, opcaoMenu: inteiro

// --- Procedimento: Pausa a execução ---
procedimento Pausar()
var
   tecla: caractere
inicio
   escreva("\n(Pressione [ENTER] para continuar...)")
   leia(tecla)
fimprocedimento

// --- Funções Auxiliares de Busca ---
funcao buscarUsuarioPorEmail(email: caractere) : inteiro
   var i: inteiro
   para i de 1 até totalUsuarios faca
      se (usuarios[i].email = email) entao
         retorne i
      fimse
   fimpara
   retorne 0
fimfuncao

funcao buscarProdutoPorNome(nome: caractere) : inteiro
   var i: inteiro
   para i de 1 até totalProdutos faca
      se (produtos[i].nome = nome) entao
         retorne i
      fimse
   fimpara
   retorne 0
fimfuncao

// --- Procedimento: Cadastrar Usuário (com validação) ---
procedimento cadastrarUsuario()
var
   novoEmail, novoTipo: caractere
inicio
   limpatela
   escreva("--- Cadastro de Usuário ---\n")
   
   se (totalUsuarios >= LIMITE_USUARIOS) entao
      escreva("[ERRO] Limite de usuários atingido!\n")
      retorne
   fimse
   
   escreva("Digite o E-mail: ")
   leia(novoEmail)
   
   // Validação de duplicidade
   se (buscarUsuarioPorEmail(novoEmail) > 0) entao
      escreva("\n[ERRO] Este e-mail já está cadastrado!\n")
   senao
      totalUsuarios <- totalUsuarios + 1
      usuarios[totalUsuarios].email <- novoEmail
      
      escreva("Nome: ")
      leia(usuarios[totalUsuarios].nome)
      escreva("Senha: ")
      leia(usuarios[totalUsuarios].senha)
      
      novoTipo <- ""
      enquanto (novoTipo <> "cliente") e (novoTipo <> "admin") faca
         escreva("Tipo (cliente/admin): ")
         leia(novoTipo)
         se (novoTipo <> "cliente") e (novoTipo <> "admin") entao
            escreva("[ERRO] Digite 'cliente' ou 'admin'.\n")
         fimse
      fimenquanto
      
      usuarios[totalUsuarios].tipo <- novoTipo
      escreva("\nUsuário cadastrado com sucesso!\n")
   fimse
fimprocedimento

// --- Função: Autenticar Usuário ---
funcao autenticarUsuario() : logico
var
   email, senha: caractere
   indice: inteiro
inicio
   limpatela
   escreva("--- Login ---\n")
   

   escreva("Digite seu e-mail: ")
   leia(email)
   escreva("Digite sua senha: ")
   leia(senha)
   
   indice <- buscarUsuarioPorEmail(email)
   
   se (indice = 0) entao
      escreva("\n[ERRO] Usuário não encontrado.\n")
      retorne falso
   senao se (usuarios[indice].senha = senha) entao
      indiceUsuarioLogado <- indice // Salva o índice do usuário logado
      escreva("\nLogin bem-sucedido! Bem-vindo, ", usuarios[indice].nome, ".\n")
      retorne verdadeiro
   senao
      escreva("\n[ERRO] Senha incorreta.\n")
      retorne falso
   fimse
fimfuncao

// --- Procedimento: Adicionar Produto (Admin) ---
procedimento adicionarProduto()
var
   novoNome: caractere
   novoPreco: real
   novoEstoque: inteiro
inicio
   limpatela
   escreva("--- Adicionar Produto (Admin) ---\n")
   
   se (totalProdutos >= LIMITE_PRODUTOS) entao
      escreva("[ERRO] Limite de produtos atingido!\n")
      retorne
   fimse
   
   escreva("Nome do Produto: ")
   leia(novoNome)
   
   se (buscarProdutoPorNome(novoNome) > 0) entao
      escreva("\n[ERRO] Já existe um produto com este nome!\n")
   senao
      totalProdutos <- totalProdutos + 1
      produtos[totalProdutos].nome <- novoNome
      
      novoPreco <- 0
      enquanto (novoPreco <= 0) faca
         escreva("Preço do Produto: R$ ")
         leia(novoPreco)
      fimenquanto
      produtos[totalProdutos].preco <- novoPreco
      
      novoEstoque <- -1
      enquanto (novoEstoque < 0) faca
         escreva("Estoque Inicial: ")
         leia(novoEstoque)
      fimenquanto
      produtos[totalProdutos].estoque <- novoEstoque
      
      escreva("\nProduto '", novoNome, "' cadastrado com sucesso!\n")
   fimse
fimprocedimento

// --- Procedimento: Exibir Produtos (para todos) ---
procedimento exibirProdutos()
var
   i: inteiro
inicio
   limpatela
   escreva("=========================================\n")
   escreva("=         PRODUTOS DISPONÍVEIS        =\n")
   escreva("=========================================\n")
   
   
   se (totalProdutos = 0) entao
      escreva("  (Nenhum produto cadastrado no momento)\n")
   senao
      para i de 1 até totalProdutos faca
         escreva("ID: ", i, "\n")
         escreva("   Nome: ", produtos[i].nome, "\n")
         escreva("   Preço: R$", produtos[i].preco:0:2, "\n")
         
         se (produtos[i].estoque = 0) entao
            escreva("   Estoque: [ESGOTADO]\n")
         senao
            escreva("   Estoque: ", produtos[i].estoque, " un.\n")
         fimse
         escreva("-----------------------------------------\n")
      fimpara
   fimse
fimprocedimento

// --- Procedimento: Adicionar ao Carrinho (Cliente) ---
procedimento adicionarAoCarrinho()
var
   idProduto, quantidade, indiceProduto: inteiro
inicio
   limpatela
   escreva("--- Adicionar ao Carrinho ---\n")
   
   // Mostra a lista para o usuário saber o ID
   exibirProdutos()
   
   se (totalItensCarrinho >= LIMITE_CARRINHO) entao
      escreva("[ERRO] Seu carrinho está cheio!\n")
      retorne
   fimse
   
   escreva("\nDigite o ID do produto que deseja adicionar: ")
   leia(idProduto)
   
   // Valida o ID
   se (idProduto < 1) ou (idProduto > totalProdutos) entao
      escreva("\n[ERRO] ID de produto inválido.\n")
   senao
      // O ID do produto é o seu índice
      indiceProduto <- idProduto
      
      escreva("Produto selecionado: ", produtos[indiceProduto].nome, "\n")
      escreva("Quantidade: ")
      leia(quantidade)
      
      // Validações de quantidade e estoque
      se (quantidade <= 0) entao
         escreva("\n[ERRO] A quantidade deve ser positiva.\n")
      senao se (produtos[indiceProduto].estoque = 0) entao
         escreva("\n[ERRO] Produto esgotado.\n")
      senao se (produtos[indiceProduto].estoque < quantidade) entao
         escreva("\n[ERRO] Estoque insuficiente. Disponível: ", produtos[indiceProduto].estoque, "\n")
      senao
         // --- CORREÇÃO DE LÓGICA ---
         // Não removemos o estoque aqui! Apenas adicionamos ao carrinho.
         totalItensCarrinho <- totalItensCarrinho + 1
         carrinhoAtual[totalItensCarrinho].indiceProduto <- indiceProduto
         carrinhoAtual[totalItensCarrinho].quantidade <- quantidade
         
         escreva("\nProduto adicionado ao carrinho com sucesso!\n")
      fimse
   fimse
fimprocedimento

// --- Procedimento: Exibir Carrinho (Helper) ---
funcao exibirCarrinho() : real
var
   i, idxProd: inteiro
   totalCarrinho: real
   p: Produto // Variável auxiliar
inicio
   totalCarrinho <- 0
   escreva("\n--- Seu Carrinho Atual (", totalItensCarrinho, " itens) ---\n")
   
   se (totalItensCarrinho = 0) entao
      escreva("  (Carrinho vazio)\n")
      retorne 0
   fimse
   
   para i de 1 até totalItensCarrinho faca
      idxProd <- carrinhoAtual[i].indiceProduto
      p <- produtos[idxProd] // Pega o produto do vetor principal
      
      escreva(i, ". ", p.nome, "\n")
      escreva("   Qtd: ", carrinhoAtual[i].quantidade, " x R$", p.preco:0:2, " = R$", (p.preco * carrinhoAtual[i].quantidade):0:2, "\n")
      totalCarrinho <- totalCarrinho + (p.preco * carrinhoAtual[i].quantidade)
   fimpara
   escreva("-----------------------------------------\n")
   escreva("TOTAL DO CARRINHO: R$", totalCarrinho:0:2, "\n")
   retorne totalCarrinho
fimfuncao

// --- Procedimento: Finalizar Compra (Cliente) ---
procedimento finalizarCompra()
var
   total, i, idxProd, qtd: inteiro
   estoqueOK: logico
inicio
   limpatela
   escreva("--- Finalizar Compra --- \n")
   

   // 1. Exibe o carrinho e pega o total
   total <- exibirCarrinho()
   
   se (totalItensCarrinho = 0) entao
      escreva("\nAdicione itens ao carrinho antes de finalizar!\n")
      retorne
   fimse
   
   // 2. --- CORREÇÃO CRÍTICA (Validação) ---
   // Re-valida o estoque no momento da compra
   estoqueOK <- verdadeiro
   para i de 1 até totalItensCarrinho faca
      idxProd <- carrinhoAtual[i].indiceProduto
      qtd <- carrinhoAtual[i].quantidade
      
      se (produtos[idxProd].estoque < qtd) entao
         escreva("\n[FALHA NA COMPRA] O produto '", produtos[idxProd].nome, "' não tem mais estoque suficiente!\n")
         escreva("Ação: Remova o item ou diminua a quantidade no seu carrinho.\n")
         estoqueOK <- falso
         interrompa // Para o 'para'
      fimse
   fimpara
   
   // 3. Se todo o estoque estiver OK, processa o pedido
   se (estoqueOK) entao
      se (totalPedidos >= LIMITE_PEDIDOS) entao
         escreva("\n[ERRO] Sistema de pedidos está cheio. Tente mais tarde.\n")
         retorne
      fimse
   
      // Cria o novo pedido
      totalPedidos <- totalPedidos + 1
      pedidos[totalPedidos].indiceUsuario <- indiceUsuarioLogado
      pedidos[totalPedidos].total <- total
      pedidos[totalPedidos].status <- "Em andamento"
      pedidos[totalPedidos].totalItens <- totalItensCarrinho
      
      // 4. --- CORREÇÃO CRÍTICA (Cópia e Abate de Estoque) ---
      // Copia os itens do carrinho para o pedido E abate o estoque
      para i de 1 até totalItensCarrinho faca
         
         // Copia o item
         pedidos[totalPedidos].itens[i] <- carrinhoAtual[i] 
         
         // Abate o estoque do produto original
         idxProd <- carrinhoAtual[i].indiceProduto
         qtd <- carrinhoAtual[i].quantidade
         produtos[idxProd].estoque <- produtos[idxProd].estoque - qtd
         
      fimpara
      
      escreva("\nCompra realizada com sucesso! Pedido Nº", totalPedidos, " gerado.\n")
      escreva("Total: R$", total:0:2, "\n")
      
      // 5. Limpa o carrinho
      totalItensCarrinho <- 0
   fimse
fimprocedimento

// --- Procedimento: Exibir Pedidos (Cliente e Admin) ---
procedimento exibirPedidos()
var
   i, j, idxProd: inteiro
   u: Usuario
   p: Produto
inicio
   limpatela
   escreva("=========================================\n")
   escreva("=         HISTÓRICO DE PEDIDOS        =\n")
   escreva("=========================================\n")
   
   para i de 1 até totalPedidos faca
      u <- usuarios[pedidos[i].indiceUsuario] // Pega o usuário do pedido

      // Se o usuário logado for o dono do pedido OU for admin, ele pode ver
      se (pedidos[i].indiceUsuario = indiceUsuarioLogado) ou (usuarios[indiceUsuarioLogado].tipo = "admin") entao
         
         escreva("Pedido Nº: ", i, " | Status: ", pedidos[i].status, "\n")
         escreva("Cliente: ", u.nome, " (", u.email, ")\n")
         escreva("Total do Pedido: R$", pedidos[i].total:0:2, "\n")
         escreva("Itens Comprados (", pedidos[i].totalItens, "):\n")
         
         // Loop para mostrar os itens DENTRO do pedido
         para j de 1 até pedidos[i].totalItens faca
            idxProd <- pedidos[i].itens[j].indiceProduto
            p <- produtos[idxProd] // Pega o produto
            
            escreva("  - ", p.nome, " (Qtd: ", pedidos[i].itens[j].quantidade, ")\n")
         fimpara
         
         escreva("-----------------------------------------\n")
      fimse
   fimpara
fimprocedimento

// --- Procedimentos de Menu (UX) ---
procedimento menuCliente()
inicio
   repita
      limpatela
      escreva("=========================================\n")
      escreva("=      LOJA VIRTUAL - BEM-VINDO!      =\n")
      escreva("=========================================\n")
      escreva("Usuário: ", usuarios[indiceUsuarioLogado].nome, "\n")
      escreva("Itens no Carrinho: ", totalItensCarrinho, "\n")
      escreva("-----------------------------------------\n")
      escreva("1. Exibir Produtos\n")
      escreva("2. Adicionar ao Carrinho\n")
      escreva("3. Ver Carrinho / Finalizar Compra\n")
      escreva("4. Meus Pedidos\n")
      escreva("0. Logout\n")
      escreva("-----------------------------------------\n")
      escreva("Escolha uma opção: ")
      leia(opcaoMenu)

      escolha opcaoMenu
         caso 1
            exibirProdutos()
            Pausar()
         caso 2
            adicionarAoCarrinho()
            Pausar()
         caso 3
            finalizarCompra()
            Pausar()
         caso 4
            exibirPedidos()
            Pausar()
         caso 0
            escreva("\nLogout realizado.\n")
         padrão
            escreva("\n[ERRO] Opção inválida.\n")
            Pausar()
      fimescolha
   até (opcaoMenu = 0)
fimprocedimento

procedimento menuAdmin()
inicio
   repita
      limpatela
      escreva("=========================================\n")
      escreva("=        PAINEL DE ADMINISTRAÇÃO        =\n")
      escreva("=========================================\n")
      escreva("Usuário: ", usuarios[indiceUsuarioLogado].nome, " (Admin)\n")
      escreva("-----------------------------------------\n")
      escreva("1. Adicionar Produto\n")
      escreva("2. Exibir Todos os Produtos\n")
      escreva("3. Exibir Todos os Pedidos\n")
      escreva("0. Logout\n")
      escreva("-----------------------------------------\n")
      escreva("Escolha uma opção: ")
      leia(opcaoMenu)

      escolha opcaoMenu
         caso 1
            adicionarProduto()
            Pausar()
         caso 2
            exibirProdutos()
            Pausar()
         case 3
            exibirPedidos() // O admin vê todos os pedidos
            Pausar()
         caso 0
            escreva("\nLogout realizado.\n")
         padrão
            escreva("\n[ERRO] Opção inválida.\n")
            Pausar()
      fimescolha
   até (opcaoMenu = 0)
fimprocedimento

// --- Bloco Principal (Início da Execução) ---
inicio
   // Inicializa contadores
   totalUsuarios <- 0
   totalProdutos <- 0
   totalPedidos <- 0
   totalItensCarrinho <- 0
   indiceUsuarioLogado <- 0
   
   // Cria um usuário Admin padrão para testes
   totalUsuarios <- 1
   usuarios[1].nome <- "Admin"
   usuarios[1].email <- "admin"
   usuarios[1].senha <- "admin"
   usuarios[1].tipo <- "admin"

   // Menu principal
   repita
      limpatela
      escreva("=== Bem-vindo à Loja Virtual ===\n")
      
      escreva("\n1. Cadastrar Novo Usuário\n")
      escreva("2. Login\n")
      escreva("0. Sair\n")
      escreva("Escolha uma opção: ")
      leia(opcao)

      escolha opcao
         caso 1
            cadastrarUsuario()
            Pausar()
         caso 2
            // Se o login for bem-sucedido
            se (autenticarUsuario()) entao
               Pausar()
               
               // Reseta o carrinho do usuário anterior
               totalItensCarrinho <- 0 
               
               se (usuarios[indiceUsuarioLogado].tipo = "cliente") entao
                  menuCliente()
               senao
                  menuAdmin()
               fimse
               
               // Quando faz logout, zera o usuário logado
               indiceUsuarioLogado <- 0 
            senao
               Pausar() // Pausa na mensagem de "senha incorreta"
            fimse
         caso 0
            escreva("\nSaindo da loja virtual... Obrigado!\n")
         padrão
            escreva("\n[ERRO] Opção inválida. Tente novamente.\n")
            Pausar()
      fimescolha
   até (opcao = 0)
fimalgoritmo
