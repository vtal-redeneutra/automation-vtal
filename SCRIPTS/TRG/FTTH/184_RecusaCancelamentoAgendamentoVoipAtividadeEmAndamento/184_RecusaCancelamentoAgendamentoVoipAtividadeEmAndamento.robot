*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/184_RecusaCancelamentoAgendamentoVoipAtividadeEmAndamento.xlsx


*** Test Cases ***
# SCRIPT PARTE A

184.01 - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

184.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Logradouro CPOi

184.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

184.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Retornar Slot Agendamento Voip

184.06 - Realizar Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento                    cod_activityType=4936

184.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar Ordem de Agendamento Voip          
   
184.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  SCRIPT_A
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
   ...                                      XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

184.09 - Validar a Abertura da OS via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    
#===================================================================================================================================================================
# SCRIPT PARTE B

184.10/12 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA

184.11/13- Validar Mudança de Status do FSL no FW Console
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                                           

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
184.14 - Realizar o Cancelamento do Agendamento
    [TAGS]                                  SCRIPT_B
    Retornar Token Vtal
    Cancelar Agendamento

#===================================================================================================================================================================
# SCRIPT COMPLETO

184.01 - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Token Vtal

184.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Logradouro CPOi

184.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_COMPLETO
    Retorna Viabilidade dos Produtos

184.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Slot Agendamento Voip

184.06 - Realizar Agendamento
    [TAGS]                                  SCRIPT_COMPLETO
    Realizar Agendamento                    cod_activityType=4936

184.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_COMPLETO
    Criar Ordem de Agendamento Voip          
   
184.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  SCRIPT_COMPLETO
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
   ...                                      XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

184.09 - Validar a Abertura da OS via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Realizar o Reagendamento via API
    [TAGS]                                  SCRIPT_COMPLETO
    Reagendar Pedido OPM e FSL              4936

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  SCRIPT_COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

184.10/12 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA

184.11/13- Validar Mudança de Status do FSL no FW Console
    [TAGS]                                  SCRIPT_COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                                           

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
184.14 - Realizar o Cancelamento do Agendamento
    [TAGS]                                  SCRIPT_COMPLETO
    Cancelar Agendamento