*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../../RESOURCE/FW/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/SOM/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/FW/UTILS.robot
Resource                                    ../../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../../RESOURCE/PORTAL/UTILS.robot
Resource                                    ../../../../ROBS/ROB0049_OrdensDeServiçoPortal/ROB0049_OrdensDeServiçoPortal.robot
Resource                                    ../../../../ROBS/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ../../../../ROBS/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ../../../../ROBS/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ../../../../ROBS/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ../../../../ROBS/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ../../../../ROBS/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ../../../../ROBS/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ../../../../ROBS/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ../../../../ROBS/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ../../../../ROBS/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/071_AtivacaoFTTHSemNumero.xlsx

*** Test Cases ***

71.01/02/03/04/05 - Criar Ordem de Instalação sem complementos via PORTAL
    [Tags]                                SCRIPT_A
    [Teardown]                            Logout Portal Operacional
    Login ao Portal Operacional
    Acessar Ordens de Serviço no menu do PORTAL        
    Criar Ordem de Serviço de Instalação com VIABILIDADE TOTAL e velocidade 1000MBPS

# 71.06 - Validar a Notificação da Criação de Ordem no MicroServiços

71.07 - Validar a Criação da OS de Instalação via SOM
    [Tags]                                SCRIPT_B
  
    @{LIST}=                              Create List                             ${SOM_Numero_Pedido}                                           

    @{RETORNO}=                           Create List                             associatedDocument                                                 

    Validar Evento Completo SOM           VALOR_PESQUISA=associatedDocument
    ...                                   TASK_NAME=T017 - Instalar Equipamento
    ...                                   ORDER_TYPE=Vtal Fibra Instalação
    ...                                   ORDER_STATE=In Progress
    ...                                   RETORNO_ESPERADO=${RETORNO}
    ...                                   XPATH_VALIDACOES=${LIST}

71.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_B
    Troca de Tecnico no Field Service
    Browser.Close Browser                           CURRENT

71.08 - Realiza o Encerramento da OS de Instalação
    [TAGS]                                  SCRIPT_B

    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA                      ONT HW - HG8245H
    Validar Estado do pedido FSL
    Browser.Close Browser                           CURRENT

# 71.09 - Validar mudanças de estado no FW 
#     [TAGS]                                  SCRIPT_B
#     ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

#     Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:name      

71.10 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas

71.11 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Valida Ordem SOM Finalizada com sucesso