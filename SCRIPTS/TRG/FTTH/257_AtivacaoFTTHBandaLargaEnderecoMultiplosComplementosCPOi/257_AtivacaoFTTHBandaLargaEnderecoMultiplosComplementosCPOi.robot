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
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/257_AtivacaoFTTHBandaLargaEnderecoMultiplosComplementosCPOi.json


*** Test Cases ***
257.01 - Gerar Token de Acesso
    [Tags]                                  SCRIPT_A
    Retornar Token Vtal

257.02 - Realizar Consulta de Logradouro
    [Tags]                                  SCRIPT_A
    Consulta Logradouro CPOi

257.03 - Realizar Consulta de Complemento
    [Tags]                                  SCRIPT_A
    Id Consulta Complemento

257.04 - Realizar Consulta de Viabilidade
    [Tags]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

257.05 - Realizar Consulta de Slots
    [Tags]                                  SCRIPT_A
    Retornar Slot Agendamento V2            productType=Banda Larga

257.06 - Realizar o Agendamento
    [Tags]                                  SCRIPT_A
    Realizar Agendamento V2                 appointmentReason=Instalacao de Fibra

257.07 - Realizar a Criação de Ordem (OS)
    [Tags]                                  SCRIPT_A
    Criar Ordem Agendamento                 VELOCIDADE_DOWN=400

257.08 - Validar a Notificação da Criação de Ordem no MicroServiços 
    [Tags]                                  SCRIPT_A  
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]

257.09 - Validar a Criação da OS de Instalação via SOM
    [Tags]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument                                                       

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=20

XX.XX - Atribuir técnico no Field Service 
    [Tags]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

257.10/12/14 - Realizar o Encerramento da OS de Instalação via FSL
    [Tags]                                  SCRIPT_B
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H

257.11/13/16 - Validar Mudança de Status do FSL no Micro Serviços
    [Tags]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY                    

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
257.15 - Auditoria de Tarefas
    [Tags]                                  SCRIPT_B
    Auditoria de Tarefas  

257.17 - Validar o Encerramento da OS via SOM
    [Tags]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

257.18 - Validar a Notificação de Encerramento via SOA
    [Tags]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e VOIP OI<

