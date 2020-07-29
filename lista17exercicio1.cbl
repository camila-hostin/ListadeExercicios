      $set sourceformat"free"
      *> divisão de identificação do programa
       identification division.
       program-id. "lista17exercicio1".
       author. "Camila da Rosa Hostin".
       installation. "PC".
       date-written. 28/07/2020.
       date-compiled. 28/07/2020.


      *> divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----declaração dos recursos externos
       input-output section.
       file-control.

           select arqCadastroAlunos assign to "arqCadastroAlunos.txt"
           organization is indexed
           access mode is dynamic
           lock mode is automatic
           record key is fd-cod-aluno
           file status is ws-fs-arqCadastroAlunos.

       i-o-control.

      *> declaração de variáveis
       data division.

      *>----variaveis de arquivos
       file section.

       fd arqCadastroAlunos.

       01 fd-alunos.
           05 fd-cod-aluno                         pic  9(03).
           05 fd-aluno                             pic  x(25).
           05 fd-endereco                          pic  x(35).
           05 fd-mae                               pic  x(25).
           05 fd-pai                               pic  x(25).
           05 fd-telefone                          pic  x(15).
           05 fd-notas.
               10 fd-nota1                         pic  9(02)v99.
               10 fd-nota2                         pic  9(02)v99.
               10 fd-nota3                         pic  9(02)v99.
               10 fd-nota4                         pic  9(02)v99.
               10 fd-media                         pic  9(02)v99.

      *>----variaveis de trabalho
       working-storage section.

       77 ws-fs-arqCadastroAlunos                  pic  9(02).

      *>  variáveis do cadastro do aluno
       01 ws-alunos.
           05 ws-nome-aluno                        pic  x(25).
           05 filler                               pic  x(03)
                                                  value ' | '.
           05 ws-endereco-aluno                    pic  x(35).
           05 filler                               pic  x(03)
                                                  value ' | '.
           05 ws-nome-mae                          pic x(15).
           05 filler                               pic x(03)
                                                 value ' | '.
           05 ws-nome-pai                          pic x(15).
           05 filler                               pic x(03)
                                                 value ' | '.
           05 ws-tel-pais                          pic x(15).
           05 filler                               pic x(03)
                                                 value ' | '.
      *>  variáveis nota
           05 ws-notas.
               10 filler                           pic x(3)
                                                value ' | '.
               10 ws-nota1                         pic 9(2)v99
                                                    value 0.
               10 filler                           pic x(3)
                                                value ' | '.
               10 ws-nota2                         pic 9(2)v99
                                                    value 0.
               10 filler                           pic x(3)
                                                value ' | '.
               10 ws-nota3                         pic 9(2)v99
                                                    value 0.
               10 filler                           pic x(3)
                                                value ' | '.
               10 ws-nota4                         pic 9(2)v99
                                                    value 0.
               10 filler                           pic x(3)
                                                value ' | '.
               10 ws-media                         pic  9(02)v99.

       77 ws-ind                                   pic  9(03).
       77 ws-menu                                  pic  x(02).
       77 ws-opcao                                 pic  x(02).

      *>  variáveis de mensagem de erro
       01 ws-msn-erro.
           05 ws-msn-erro-ofsset                   pic 9(04).
           05 filler                               pic x(01) value "-".
           05 ws-msn-erro-cod                      pic 9(02).
           05 filler                               pic x(01) value space.
           05 ws-msn-erro-text                     pic x(42).

      *>----variaveis para comunicação entre programas
       linkage section.

      *>----declaração de tela
       screen section.

      *>declaração do corpo do programa
       procedure division.

      *>----------------- apresentação do problema ----------------------<*
      *>  Crie um programa para gerenciar as notas dos alunos de
      *>uma escola.
      *>- Crie um vetor para armazenar o nome dos alunos.
      *>- Crie um vetor para armazenar o endereço dos alunos.
      *>- Crie um vetor para armazenar o nome da mãe dos alunos.
      *>- Crie um vetor para armazenar o nome do pai dos alunos.
      *>- Crie um vetor para armazenar o telefone dos pais dos alunos.
      *>- Crie 4 vetores para armazenar 4 notas por aluno.
      *>- As informações nos vetores se relacionarão através dos
      *>indexadores dos vetores.
      *>- Crie uma tela para cadastrar os alunos (nome, endereço,
      *>nome dos pais, telefone).
      *>- Crie uma tela para cadastrar as notas dos alunos.
      *>- Crie uma tela para consultar o cadastro e situação
      *>dos alunos.
      *>-----------------------------------------------------------------<*

           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.

       *>  open i-o abre o arquivo para leitura e escrita
           open i-o arqCadastroAlunos
      *>       tratamento de erro
               if ws-fs-arqCadastroAlunos  <> 00
               and ws-fs-arqCadastroAlunos <> 05 then
      *>           mensagem de erro
                   move 1 to ws-msn-erro-ofsset
                   move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                   move "Erro ao abrir arq. arqTemp " to ws-msn-erro-text
      *>           finalizar programa por erro
                   perform finaliza-anormal
               end-if

      *>   inicializando as variáveis
           move 'S' to ws-menu
           .
       inicializa-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  processamento principal
      *>------------------------------------------------------------------------
       processamento section.

           perform until ws-menu <> 'S'

      *>       menu de consulta
               display 'Digite:'
               display 'A - Cadastro de Alunos'
               display 'B - Cadastro de Notas'
               display 'C - Consulta Cadastro Indexada'
               display 'D - Consulta Cadastro Sequencial'
               display 'E - Deletar Cadastro'
               display 'F - Alterar Cadastro'
               accept ws-opcao
               move function upper-case (ws-opcao) to ws-opcao

      *>       evaluate p/ mandar o programa p/ as sections
               evaluate ws-opcao
                   when = 'A'
                       perform cadastro-aluno
                   when = 'B'
                       perform cadastro-notas
                   when = 'C'
                       perform consulta-cadastro-indexada
                   when = 'D'
                       perform consulta-cadastro-seq
                   when = 'E'
                       perform deletar-aluno
                   when = 'F'
                       perform alterar-aluno
                   when other
                       display 'Opcao Invalida'
               end-evaluate

      *>       condição de saída
               display 'Quer continuar? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform

           .
       processamento-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  cadastro de aluno
      *>------------------------------------------------------------------------
       cadastro-aluno section.

           display erase

           perform until ws-menu <> 'S'

               display '---------- Cadastro de Alunos ----------'

      *>       cadastro do nome do aluno
               display 'Informe o Codigo do Aluno: '
               accept ws-ind
               display 'Informe o Nome do Aluno: '
               accept ws-nome-aluno
      *>       cadastro endereço
               display 'Informe o Endereco: '
               accept ws-endereco-aluno
      *>       cadastro informações dos pais
               display 'Informe o Nome do Pai: '
               accept ws-nome-pai
               display 'Informe o Nome da Mae: '
               accept ws-nome-mae
               display 'Telefone dos Pais: '
               accept ws-tel-pais

      *> -------------  salvar dados no arquivo

               move ws-alunos to fd-alunos

      *>       escreve os dados no arquivo
               write fd-alunos

      *>       tratamento de erro
               if ws-fs-arqCadastroAlunos <> 0
               and ws-fs-arqCadastroAlunos <> 23 then
                   move 2 to ws-msn-erro-ofsset
                   move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                   move 'Erro ao escrever arq. arqCadastroAlunos' to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

      *> -------------

               display '  '
      *>       condição de saída
               display 'Continuar Cadastrando? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform

           .
       cadastro-aluno-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  cadastro de notas
      *>------------------------------------------------------------------------
       cadastro-notas section.

           display erase

           perform until ws-menu <> 'S'

               display '---------- Cadastro de Notas ----------'
               display 'Informe o Codigo do Aluno: '
               accept ws-ind

               if ws-ind = space then
                   display 'Aluno nao Cadastrado'
               end-if

      *>   cadastro das notas
               display 'Informe a nota 1: '
               accept ws-nota1
               display 'Informe a nota 2: '
               accept ws-nota2
               display 'Informe a nota 3: '
               accept ws-nota3
               display 'Informe a nota 4: '
               accept ws-nota4

               compute ws-media =
                      (ws-nota1 + ws-nota2 + ws-nota3 + ws-nota4) / 4

      *> -------------  salvar dados no arquivo
      *>       preenche o fd-cod-aluno
               move ws-ind to fd-cod-aluno

      *>       ler arquivo
               read arqCadastroAlunos

               move ws-notas to fd-notas


               if ws-fs-arqCadastroAlunos <> 0 then
                   if ws-fs-arqCadastroAlunos = 23 then
                       display 'Dado Inválido'
                   else
                       move 3 to ws-msn-erro-ofsset
                       move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                       move 'Erro ao Cadastrar arq. arqCadastroAlunos' to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               else
                   if ws-fs-arqCadastroAlunos <> 0 then
                       move 4 to ws-msn-erro-ofsset
                       move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                       move 'Erro ao Gravar arq. arqCadastroAlunos' to ws-msn-erro-text
                       perform finaliza-anormal

                   end-if
               end-if

      *> -------------

               display 'Continuar Cadastrando? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform
           .
       cadastro-notas-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  consultar cadastro - indexada
      *>------------------------------------------------------------------------
       consulta-cadastro-indexada section.

           perform until ws-menu <> 'S'

               display '---------- Consultar Cadastro ----------'

               display 'Informe o Codigo do Aluno: '
               accept ws-ind

      *> -------------  ler dados no arquivo - indexada
               move ws-ind to fd-cod-aluno

      *>       ler arquivo
               read arqCadastroAlunos

               if ws-fs-arqCadastroAlunos <> 0
               and ws-fs-arqCadastroAlunos <> 10 then
                   if ws-fs-arqCadastroAlunos = 23 then
                       display 'Codigo Invalido!'
                   else
                       move 5 to ws-msn-erro-ofsset
                       move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                       move 'Erro ao Ler arq. arqCadastroAlunos' to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

               move fd-alunos to ws-alunos

      *> -------------

               display '  '
               display 'Codigo do Aluno: ' ws-ind
               display 'Nome do Aluno: ' ws-nome-aluno
               display 'Endereço: ' ws-endereco-aluno
               display 'Nome do Pai: ' ws-nome-pai
               display 'Nome da Mae: ' ws-nome-mae
               display 'Telefone dos Pais: ' ws-tel-pais
               display 'Nota 1 ' ws-nota1
               display 'Nota 2 ' ws-nota2
               display 'Nota 3 ' ws-nota3
               display 'Nota 4 ' ws-nota4
               display 'Media ' ws-media

               display 'Deseja Continuar Consultando? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform

          .
       consulta-cadastro-indexada-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  consultar cadastro - de forma sequencial - next
      *>------------------------------------------------------------------------
       consulta-cadastro-seq section.

      *>   para saber o ponto de início
           perform consulta-cadastro-indexada

           perform until ws-menu <> 'S'

               display '---------- Consultar Cadastro ----------'
               display 'Informe o Codigo do Aluno: '
               accept ws-ind

      *> -------------  ler dados no arquivo de forma sequencial - next

               move ws-ind to fd-cod-aluno

      *>       ler arquivo de forma sequencial
               read arqCadastroAlunos next into ws-alunos

      *>        tratamento de erro
               if ws-fs-arqCadastroAlunos <> 0 then
                   if ws-fs-arqCadastroAlunos = 10 then
                       perform consulta-cadastro-seq
                   else
                       move 6 to ws-msn-erro-ofsset
                       move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                       move 'Erro ao Ler arq. arqCadastroAlunos' to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

      *> -------------
               display 'Codigo do Aluno: ' ws-ind
               display 'Nome do Aluno: ' ws-nome-aluno
               display 'Endereço: ' ws-endereco-aluno
               display 'Nome do Pai: ' ws-nome-pai
               display 'Nome da Mae: ' ws-nome-mae
               display 'Telefone dos Pais: ' ws-tel-pais
               display 'Nota 1' ws-nota1
               display 'Nota 2' ws-nota2
               display 'Nota 3' ws-nota3
               display 'Nota 4' ws-nota4
               display 'Media ' ws-media

               display 'Deseja Continuar Consultando? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform


           .
       consulta-cadastro-seq-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  consultar cadastro - previous
      *>------------------------------------------------------------------------
       consulta-cadastro-seq-prev section.

           perform until ws-menu <> 'S'

               display '---------- Consultar Cadastro ----------'
               display 'Informe o Codigo do Aluno: '
               accept ws-ind

      *> -------------  ler dados no arquivo de forma sequencial - previous

           move ws-ind to fd-cod-aluno

           read arqCadastroAlunos previous

           if ws-fs-arqCadastroAlunos <> 0 then
               if ws-fs-arqCadastroAlunos = 10 then
                   perform consulta-cadastro-seq
               else
                   move 7 to ws-msn-erro-ofsset
                   move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                   move 'Erro ao Ler arq. arqCadastroAlunos' to ws-msn-erro-text
                   perform finaliza-anormal
               end-if
           end-if
      *> -------------

               move fd-alunos to ws-alunos

               display 'Codigo do Aluno: ' ws-ind
               display 'Nome do Aluno: ' ws-nome-aluno
               display 'Endereço: ' ws-endereco-aluno
               display 'Nome do Pai: ' ws-nome-pai
               display 'Nome da Mae: ' ws-nome-mae
               display 'Telefone dos Pais: ' ws-tel-pais
               display 'Nota 1' ws-nota1
               display 'Nota 2' ws-nota2
               display 'Nota 3' ws-nota3
               display 'Nota 4' ws-nota4
               display 'Media ' ws-media

               display 'Deseja Continuar Consultando? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform
           .
       consulta-cadastro-seq-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  deletar cadastro
      *>------------------------------------------------------------------------
       deletar-aluno section.

           display erase

           perform consulta-cadastro-indexada

           perform until ws-menu <> 'S'

               display 'Informe o Codigo do Aluno a Ser Excluído: '
               accept ws-ind

      *> -------------  deletar dados no arquivo de forma sequencial

               move ws-ind to fd-cod-aluno

      *>       deletar arquivo
               delete arqCadastroAlunos

               if ws-fs-arqCadastroAlunos = 0 then
                   display 'Aluno ' ws-ind ' apagado com sucesso'
               else
                   if ws-fs-arqCadastroAlunos = 23 then
                       display 'Aluno Informado Invalido'
                   else
                       move 8 to ws-msn-erro-ofsset
                       move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                       move 'Erro ao apagar arq. arqCadastroAlunos' to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

      *> -------------

      *>       condição de saída
               display 'Deseja Deletar Mais Algum Cadastro? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform

           .
       deletar-aluno-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  alterar cadastro
      *>------------------------------------------------------------------------
       alterar-aluno section.

           display erase

           perform consulta-cadastro-indexada

           perform until ws-menu <> 'S'

      *>       informar o código do aluno
               display 'Informe o Codigo do Aluno a Ser Alterado: '
               accept ws-ind

               display 'Altere o Cadastro'

               display 'Nome do Aluno: '
               accept ws-nome-aluno
               display 'Endereço: '
               accept ws-endereco-aluno
               display 'Nome do Pai: '
               accept ws-nome-pai
               display 'Nome da Mae: '
               accept ws-nome-mae
               display 'Telefone dos Pais: '
               accept ws-tel-pais

               display 'Altere as Notas'

               display 'Nota 1: '
               accept ws-nota1
               display 'Nota 2: '
               accept ws-nota2
               display 'Nota 3: '
               accept ws-nota3
               display 'Nota 4: '
               accept ws-nota4

      *> -------------  alterar dados no arquivo de forma sequencial

               move ws-alunos to fd-alunos

      *>       alterando os dados
               rewrite fd-alunos

               if ws-fs-arqCadastroAlunos = 0 then
                   display 'Aluno ' ws-ind ' alterado com sucesso'
               else
                   move 9 to ws-msn-erro-ofsset
                   move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
                   move 'Erro ao alterar arq. arqCadastroAlunos' to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

      *> -------------

      *>       condição de saída
               display 'Deseja Alterar Mais Algum Cadastro? S/N'
               accept ws-menu
               move function upper-case(ws-menu) to ws-menu

           end-perform

           .
       alterar-aluno-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  finalização anormal - erro
      *>------------------------------------------------------------------------
       finaliza-anormal section.

           display erase
           display ws-msn-erro.

           stop run
           .

       finaliza-anormal-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  finalização
      *>------------------------------------------------------------------------
       finaliza section.

      *>   fechar arquivo
           close arqCadastroAlunos

      *>   quando dá erro
           if ws-fs-arqCadastroAlunos <> 0 then
               move 10 to ws-msn-erro-ofsset
               move ws-fs-arqCadastroAlunos to ws-msn-erro-cod
               move "Erro ao fechar arq. arqCadastroAlunos " to ws-msn-erro-text
      *>       fechar arquivo quando dá erro
               perform finaliza-anormal
           end-if
           stop run
           .

       finaliza-exit.
           exit.

