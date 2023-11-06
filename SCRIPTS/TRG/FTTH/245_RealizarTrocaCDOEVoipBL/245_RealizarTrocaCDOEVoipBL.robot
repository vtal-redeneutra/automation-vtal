*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0047_RealizarTrocaCDOE/ROB0047_RealizarTrocaCDOE.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/245_RealizarTrocaCDOEVoipBL.xlsx


*** Test Cases ***
245.01 - Gerar Token de Acesso
    Retornar Token Vtal

245.02 - Realizar Consulta de Logradouro
    Consulta Logradouro CPOi

245.03 - Realizar Consulta de Complemento
    Id Consulta Complemento

245.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

245.05 - Realizar Consulta de Slots
    Retornar Slot Agendamento Voip

245.06 - Realizar o Agendamento
    Realizar Agendamento                    cod_activityType=4936

245.07 - Realizar a Criação de Ordem (OS)
    Criar Ordem de Agendamento Voip

245.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
   ...                                      XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

245.09 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroCOM}                  ${SOM_Ordem_numeroPedido}
    ...                                     ${SOM_Cliente_idContrato}               

    @{RETORNO}=                             Create List                             comOrderService                         associatedDocument
    ...                                     subscriberId                            

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

245.10 – Realizar troca de CDOE
    Trocar CDOE via SOM

XX.XX - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL              activityType=4936

XX.XX - Atribuir Técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

245.11/13/15 - Realizar o Encerramento da OS de Instalação via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H

245.12/14/16 - Validar Mudança de Status no FW Console
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY                    

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
245.17- Auditoria de Tarefas
    Auditoria de Tarefas

245.18 - Validar no Field Service
    Valida SA no Field Service

245.19 - Realizar Validação de Retorno via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

245.20 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e VOIP OI<
