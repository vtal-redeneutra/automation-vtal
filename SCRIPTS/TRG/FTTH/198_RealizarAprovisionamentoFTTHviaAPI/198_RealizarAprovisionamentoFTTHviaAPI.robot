*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         Cenário realiza aprovisionamento de FTTH via API com encerramento via FSL

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/COMMON/RES_EXCEL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../../RESOURCE/FSL/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0049_ValidarOrdemVendaOuModificacaoNetwin/ROB0049_ValidarOrdemVendaOuModificacaoNetwin.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/198_RealizarAprovisionamentoFTTHviaAPI.xlsx


*** Test Cases ***
198.01 - Gerar Token de Acesso
    Retornar Token Vtal

198.02-3 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

198.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

198.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

198.06 - Realizar o Agendamento
    Realizar Agendamento

198.07 – Validar a o Agendamento via FSL
    Validar Atribuicao Automatica FSL

198.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento                 400
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

198.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar Criação da Ordem                associatedDocument                      code>200<

198.10 - Validar a Criação da OS de Instalação via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress

XX.XX - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL

XX.XX - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

198.11-13-15 - Realizar o Encerramento da OS de Instalação via FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL

198.12-14 - Validar Mudança de Estados no FW
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:name      

198.16 - Auditoria de Tarefas
    Auditoria de Tarefas

198.17 - Realizar Validação de Retorno via SOM
    Valida Ordem SOM Finalizada com sucesso

198.18 - Validar Ordem de Venda ou Modificação
    Validar Ordem Venda ou Modificacao