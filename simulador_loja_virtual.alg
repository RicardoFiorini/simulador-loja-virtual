algoritmo "Simulador de Loja Virtual"

// Estruturas para armazenar dados de usuários, produtos, carrinho e pedidos

variáveis
    tipo Usuario
        nome : caractere
        email : caractere
        senha : caractere
        tipo : caractere // "cliente" ou "admin"
    fimTipo

    tipo Produto
        nome : caractere
        preco : real
        estoque : inteiro
    fimTipo

    tipo ItemCarrinho
        produto : Produto
        quantidade : inteiro
    fimTipo

    tipo Pedido
        usuario : Usuario
        itens : vetor[1..20] de ItemCarrinho
        total : real
        status : caractere // "Em andamento", "Concluído"
    fimTipo

    usuarios : vetor[1..50] de Usuario
    produtos : vetor[1..50] de Produto
    pedidos : vetor[1..50] de Pedido
    carrinhoAtual : vetor[1..20] de ItemCarrinho
    
    totalUsuarios, totalProdutos, totalPedidos, totalItensCarrinho : inteiro
    usuarioLogado : Usuario
    opcao, quantidade : inteiro
    nomeProduto : caractere

início
    totalUsuarios ← 0
    totalProdutos ← 0
    totalPedidos ← 0
    totalItensCarrinho ← 0

    // Função para autenticação de usuários
    funcao autenticarUsuario() : logico
        var email : caractere
        var senha : caractere
        escreva("Digite seu e-mail: ")
        leia(email)
        escreva("Digite sua senha: ")
        leia(senha)

        para i de 1 até totalUsuarios faça
            se usuarios[i].email = email e usuarios[i].senha = senha entao
                usuarioLogado ← usuarios[i]
                retorne verdadeiro
            fimse
        fimpara

        escreva("Usuário não encontrado ou senha incorreta.\n")
        retorne falso
    fimfuncao

    // Função para cadastrar novo usuário
    funcao cadastrarUsuario()
        totalUsuarios ← totalUsuarios + 1
        escreva("Nome: ")
        leia(usuarios[totalUsuarios].nome)
        escreva("E-mail: ")
        leia(usuarios[totalUsuarios].email)
        escreva("Senha: ")
        leia(usuarios[totalUsuarios].senha)
        escreva("Tipo de usuário (cliente/admin): ")
        leia(usuarios[totalUsuarios].tipo)
        escreva("Usuário cadastrado com sucesso!\n")
    fimfuncao

    // Função para adicionar produto
    funcao adicionarProduto()
        totalProdutos ← totalProdutos + 1
        escreva("Nome do Produto: ")
        leia(produtos[totalProdutos].nome)
        escreva("Preço do Produto: ")
        leia(produtos[totalProdutos].preco)
        escreva("Estoque do Produto: ")
        leia(produtos[totalProdutos].estoque)
        escreva("Produto adicionado com sucesso!\n")
    fimfuncao

    // Função para exibir produtos
    funcao exibirProdutos()
        para i de 1 até totalProdutos faça
            escreva(i, ". ", produtos[i].nome, " - R$", produtos[i].preco, " - Estoque: ", produtos[i].estoque, "\n")
        fimpara
    fimfuncao

    // Função para adicionar ao carrinho
    funcao adicionarAoCarrinho()
        escreva("Digite o nome do produto que deseja adicionar ao carrinho: ")
        leia(nomeProduto)
        escreva("Quantidade: ")
        leia(quantidade)

        para i de 1 até totalProdutos faça
            se produtos[i].nome = nomeProduto e produtos[i].estoque >= quantidade entao
                totalItensCarrinho ← totalItensCarrinho + 1
                carrinhoAtual[totalItensCarrinho].produto ← produtos[i]
                carrinhoAtual[totalItensCarrinho].quantidade ← quantidade
                produtos[i].estoque ← produtos[i].estoque - quantidade
                escreva("Produto adicionado ao carrinho com sucesso!\n")
                pare
            fimse
        fimpara
    fimfuncao

    // Função para finalizar compra
    funcao finalizarCompra()
        var total : real
        total ← 0

        para i de 1 até totalItensCarrinho faça
            total ← total + (carrinhoAtual[i].produto.preco * carrinhoAtual[i].quantidade)
        fimpara

        totalPedidos ← totalPedidos + 1
        pedidos[totalPedidos].usuario ← usuarioLogado
        pedidos[totalPedidos].itens ← carrinhoAtual
        pedidos[totalPedidos].total ← total
        pedidos[totalPedidos].status ← "Em andamento"

        escreva("Compra realizada com sucesso! Total: R$", total, "\n")
        
        totalItensCarrinho ← 0 // Limpa o carrinho
    fimfuncao

    // Função para exibir pedidos
    funcao exibirPedidos()
        para i de 1 até totalPedidos faça
            se pedidos[i].usuario.email = usuarioLogado.email ou usuarioLogado.tipo = "admin" então
                escreva("Pedido ", i, " - Total: R$", pedidos[i].total, " - Status: ", pedidos[i].status, "\n")
            fimse
        fimpara
    fimfuncao

    // Menu principal
    escreva("=== Bem-vindo à Loja Virtual ===\n")
    repita
        escreva("\n1. Cadastrar Usuário\n")
        escreva("2. Login\n")
        escreva("0. Sair\n")
        escreva("Escolha uma opção: ")
        leia(opcao)

        escolha opcao
            caso 1
                cadastrarUsuario()
            caso 2
                se autenticarUsuario() então
                    se usuarioLogado.tipo = "cliente" então
                        repita
                            escreva("\n=== Loja Virtual - Cliente ===\n")
                            escreva("1. Exibir Produtos\n")
                            escreva("2. Adicionar ao Carrinho\n")
                            escreva("3. Finalizar Compra\n")
                            escreva("4. Exibir Pedidos\n")
                            escreva("0. Logout\n")
                            escreva("Escolha uma opção: ")
                            leia(opcao)

                            escolha opcao
                                caso 1
                                    exibirProdutos()
                                caso 2
                                    adicionarAoCarrinho()
                                caso 3
                                    finalizarCompra()
                                caso 4
                                    exibirPedidos()
                                caso 0
                                    escreva("Logout realizado.\n")
                                caso contrário
                                    escreva("Opção inválida.\n")
                            fimescolha
                        até opcao = 0
                    senão // Caso seja um admin
                        repita
                            escreva("\n=== Loja Virtual - Admin ===\n")
                            escreva("1. Adicionar Produto\n")
                            escreva("2. Exibir Produtos\n")
                            escreva("3. Exibir Pedidos\n")
                            escreva("0. Logout\n")
                            escreva("Escolha uma opção: ")
                            leia(opcao)

                            escolha opcao
                                caso 1
                                    adicionarProduto()
                                caso 2
                                    exibirProdutos()
                                caso 3
                                    exibirPedidos()
                                caso 0
                                    escreva("Logout realizado.\n")
                                caso contrário
                                    escreva("Opção inválida.\n")
                            fimescolha
                        até opcao = 0
                    fimse
                fimse
            caso 0
                escreva("Saindo da loja virtual...\n")
            caso contrário
                escreva("Opção inválida. Tente novamente.\n")
        fimescolha
    até opcao = 0
fimalgoritmo
