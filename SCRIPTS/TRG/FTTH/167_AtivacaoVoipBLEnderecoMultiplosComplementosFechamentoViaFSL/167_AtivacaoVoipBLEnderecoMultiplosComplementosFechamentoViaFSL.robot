*** Settings ***

Suite Setup                                 Setup cenario                           Voip
Suite Teardown                              Salvar Documento Evidencia


Resource                                     ../../../../DATABASE/ROB/DB.robot

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
${DAT_CENARIO}                              ${DIR_DAT}/167_AtivacaoVoipBLEnderecoMultiplosComplementosFechamentoViaFSL.xlsx


*** Test Cases ***
167.01 - Gerar Token de Acesso  
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

167.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Logradouro CPOi

167.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

167.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Retornar Slot Agendamento Voip

167.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento                    cod_activityType=4936

167.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
   Criar Ordem de Agendamento Voip          
   
167.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console      
    [TAGS]                                  SCRIPT_A  
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
   ...                                      XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

167.09 - Validar a Criação da OS de Instalação via SOM
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

167.10/12/14 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H

150.11/13/15 - Validar Mudança de Status do FSL no FW Console
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY                    

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
167.16 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas                    

167.17 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service
   
167.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

167.19 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e VOIP OI<

#===================================================================================================================================================================

167.01 - Gerar Token de Acesso  
    [TAGS]                                  COMPLETO    167_01_Gerar_Token_de_Acesso 
    Inicia CT
    Retornar Token Vtal
    Fecha CT        API                       167_02_03_Realizar_Consulta_de_Logradouro

167.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  COMPLETO    167_02_03_Realizar_Consulta_de_Logradouro 
    Inicia CT
    Consulta Logradouro CPOi
    Fecha CT        API                       167_04_Realizar_Consulta_de_Viabilidade

167.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  COMPLETO    167_04_Realizar_Consulta_de_Viabilidade 
    Inicia CT
    Retorna Viabilidade dos Produtos
    Fecha CT        API                       167_05_Realizar_Consulta_de_Slots

167.05 - Realizar Consulta de Slots
    [TAGS]                                  COMPLETO    167_05_Realizar_Consulta_de_Slots 
    Inicia CT
    Retornar Slot Agendamento Voip
    Fecha CT        API                       167_06_Realizar_o_Agendamento

167.06 - Realizar o Agendamento
    [TAGS]                                  COMPLETO    167_06_Realizar_o_Agendamento 
    Inicia CT
    Realizar Agendamento                    cod_activityType=4936
    Fecha CT        API                       167_07_Realizar_a_Criacao_de_Ordem_OS

167.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  COMPLETO    167_07_Realizar_a_Criacao_de_Ordem_OS
    Inicia CT
    Criar Ordem de Agendamento Voip
    Fecha CT        API     167_08_Validar_a_Notificacao_da_Criacao_da_Ordem_OS_via_FW_Console
   
167.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console      
    [TAGS]                                  COMPLETO    167_08_Validar_a_Notificacao_da_Criacao_da_Ordem_OS_via_FW_Console
    Inicia CT
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
   ...                                      XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]
   Fecha CT        FW             167_09_Validar_a_Criacao_da_OS_de_Instalacao_via_SOM

167.09 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  COMPLETO    167_09_Validar_a_Criacao_da_OS_de_Instalacao_via_SOM
    Inicia CT
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument    
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    Fecha CT        SOM                       XX_XX_Realizar_o_Reagendamento_via_API

XX.XX - Realizar o Reagendamento via API
    [TAGS]                                  COMPLETO    XX_XX_Realizar_o_Reagendamento_via_API
    Inicia CT
    Reagendar Pedido OPM e FSL              
    Fecha CT        API                       XX_XX_Atribuir_tecnico_no_Field_Service

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  COMPLETO    XX_XX_Atribuir_tecnico_no_Field_Service
    Inicia CT
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    Fecha CT        FSL          167_10_12_14_Realizar_o_Encerramento_da_OS_de_Instalacao_via_FSL

167.10/12/14 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  COMPLETO    167_10_12_14_Realizar_o_Encerramento_da_OS_de_Instalacao_via_FSL
    Inicia CT
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H
    Fecha CT        FSL                      150_11_13_15_Validar_Mudanca_de_Status_do_FSL_no_FW_Console

150.11/13/15 - Validar Mudança de Status do FSL no FW Console
    [TAGS]                                  COMPLETO    150_11_13_15_Validar_Mudanca_de_Status_do_FSL_no_FW_Console
    Inicia CT
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY                    
    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
    Fecha CT        FW     167_16_Auditoria_de_Tarefas
167.16 - Auditoria de Tarefas
    [TAGS]                                  COMPLETO    167_16_Auditoria_de_Tarefas
    Inicia CT
    Auditoria de Tarefas                    
    Fecha CT        FW          167_17_Validar_no_Field_Service

167.17 - Validar no Field Service
    [TAGS]                                  COMPLETO    167_17_Validar_no_Field_Service
    Inicia CT
    Valida SA no Field Service
    Fecha CT        FSL     167_18_Realizar_Validacao_de_Retorno_via_SOM
   
167.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  COMPLETO    167_18_Realizar_Validacao_de_Retorno_via_SOM
    Inicia CT
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT
    Fecha CT        SOM         167_19_Validar_a_Notificacao_de_Encerramento_via_FW_Console

167.19 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  COMPLETO    167_19_Validar_a_Notificacao_de_Encerramento_via_FW_Console
    Inicia CT
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e VOIP OI<
    Fecha CT        COMPLETO         COMPLETO