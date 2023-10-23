*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,





Resource                                     ../../../../DATABASE/ROB/DB.robot


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot




*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/002_AtivacaoSemNumResidenciaViaFSL.xlsx



*** Test Cases ***
02.01 - Gerar Token de Acesso 
    [TAGS]                                  COMPLETO    02_01_Gerar_Token_de_Acesso 
    Inicia CT
    Criar Tabela Execucao                   ${RESPONSAVEL}
    Retornar Token Vtal
    Fecha CT  API  02_02_3_Realizar_Consulta_de_Logradouro

02.02-3 - Realizar Consulta de Logradouro
    [TAGS]                                  COMPLETO    02_02_3_Realizar_Consulta_de_Logradouro
    Inicia CT
    Retornar Token Vtal
    Consulta Id Logradouro                  UF=BAHIA	                            Municipio=FEIRA DE SANTANA
    Fecha CT  API  02_04_5_Realizar_Consulta_de_Viabilidade

02.04-5 - Realizar Consulta de Viabilidade
    [TAGS]                                  COMPLETO    02_04_5_Realizar_Consulta_de_Viabilidade
    Inicia CT
    Retornar Token Vtal
    Retorna Viabilidade dos Produtos
    Fecha CT  API  02_06_Realizar_Consulta_de_Slots

02.06 - Realizar Consulta de Slots
    [TAGS]                                  COMPLETO    02_06_Realizar_Consulta_de_Slots
    Inicia CT
    Retornar Token Vtal
    Consulta Slot Agendamento
    Fecha CT  API  02_07_Realizar_o_Agendamento

02.07 - Realizar o Agendamento
    [TAGS]                                  COMPLETO    02_07_Realizar_o_Agendamento
    Inicia CT
    Retornar Token Vtal
    Realizar Agendamento
    Fecha CT  API  02_08_Realizar_a_Consulta_do_Agendamento

02.08 - Realizar a Consulta do Agendamento
    [TAGS]                                  COMPLETO    02_08_Realizar_a_Consulta_do_Agendamento
    Inicia CT
    Retornar Token Vtal
    Consultar Agendamento
    Fecha CT  FW  02_09_Validar_a_Notificacao_do_Agendamento

02.09 - Validar a Notificação do Agendamento
    [TAGS]                                  COMPLETO    02_09_Validar_a_Notificacao_do_Agendamento
    Inicia CT
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<
    Fecha CT  FW  02_10_Realizar_a_Criacao_de_Ordem

02.10 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  COMPLETO    02_10_Realizar_a_Criacao_de_Ordem
    Inicia CT
    Criar Ordem Agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Fecha CT  FW  02_11_Validar_a_Notificacao_da_Criacao_da_Ordem_via_FW_Console

02.11 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  COMPLETO    02_11_Validar_a_Notificacao_da_Criacao_da_Ordem_via_FW_Console
    Inicia CT
    Validar Criação da Ordem                associatedDocument                      >200<
    Fecha CT  SOM  02_12_Validar_a_Criacao_da_OS_de_Instalacao_via_SOM

02.12 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  COMPLETO    02_12_Validar_a_Criacao_da_OS_de_Instalacao_via_SOM
    Inicia CT
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                      ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30
    Fecha CT  API  XX_XX_Atualizacao_da_data_de_agendamento_via_API

XX.XX - Atualização da data de agendamento via API
    [TAGS]                                  COMPLETO    XX_XX_Atualizacao_da_data_de_agendamento_via_API
    Inicia CT
    Retornar Token Vtal
    Reagendar Pedido OPM e FSL
    Fecha CT  FSL  XX_XX_Troca_de_tecnico_via_FSL

XX.XX - Troca de técnico via FSL
    [TAGS]                                  COMPLETO    XX_XX_Troca_de_tecnico_via_FSL
    Inicia CT
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    Fecha CT  FSL  02_13_Realizar_o_Encerramento_da_OS_de_Instalacao_via_FSL

02.13 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  COMPLETO    02_13_Realizar_o_Encerramento_da_OS_de_Instalacao_via_FSL
    Inicia CT
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL
    Fecha CT  FW  02_14_Validar_Mudanca_de_Estados_no_FW

02.14 - Validar Mudança de Estados no FW
    [TAGS]                                  COMPLETO    02_14_Validar_Mudanca_de_Estados_no_FW
    Inicia CT
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:name      
    Fecha CT  FSL  02_15_Validar_no_Field_Service


02.15 - Validar no Field Service
    [TAGS]                                  COMPLETO    02_15_Validar_no_Field_Service
    Inicia CT
    Valida SA no Field Service
    Fecha CT  SOM  02_16_Realizar_Validacao_de_Retorno_via_SOM

02.16 - Realizar Validação de Retorno via SOM
    [TAGS]                                  COMPLETO    02_16_Realizar_Validacao_de_Retorno_via_SOM
    Inicia CT
    Valida Ordem SOM Finalizada com sucesso
    Fecha CT  FW  02_17_Validar_a_Notificacao_de_Encerramento_via_FW_Console

02.17 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  COMPLETO    02_17_Validar_a_Notificacao_de_Encerramento_via_FW_Console
    Inicia CT
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<
    Fecha CT  FSL  02_18_Auditoria_de_Tarefas

02.18 - Auditoria de Tarefas
    [TAGS]                                  COMPLETO    02_18_Auditoria_de_Tarefas
    Inicia CT
    Auditoria de Tarefas
    Fecha CT  COMPLETO  COMPLETO

#===========================================================================================================================#    

# SCRIPT A
XX.XX - Gerar Token de Acesso
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

02.01-3 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Id Logradouro

02.04-5 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

02.06 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Consulta Slot Agendamento

02.07 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento

02.08 - Realizar a Consulta do Agendamento
    [TAGS]                                  SCRIPT_A
    Consultar Agendamento

02.09 - Validar a Notificação do Agendamento
    [TAGS]                                  SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

02.10 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar Ordem Agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

02.11 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  SCRIPT_A
    Validar Criação da Ordem                associatedDocument                      >200<

02.12 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                      ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30
    
XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

#===========================================================================================================================#    

02.13 - Realizar A Validação da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Validar Atribuicao Automatica FSL

02.14 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL

02.15 - Validar Mudança de Estados no FW
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:name      


02.16 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service

02.17 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Valida Ordem SOM Finalizada com sucesso

02.18 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

02.19 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas