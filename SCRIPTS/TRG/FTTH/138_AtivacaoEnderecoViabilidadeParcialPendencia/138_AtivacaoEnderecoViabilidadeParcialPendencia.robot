*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_OPM}/UTILS.robot
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
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0019_ValidarPendenciaSOM/ROB0019_ValidarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0039_AlteracaoCEPNetwin/ROB0039_AlteracaoCEPNetwin.robot
Resource                                    ${DIR_ROBS}/ROB0040_ProcessoObraSOM/ROB0040_ProcessoObraSOM.robot
Resource                                    ${DIR_ROBS}/ROB0041_AbrirPendenciaObraSOM/ROB0041_AbrirPendenciaObraSOM.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/138_AtivacaoEnderecoViabilidadeParcialPendencia.xlsx


*** Test Cases ***
#===========================================================================================================================================================================================================
#    PARTE A
#===========================================================================================================================================================================================================
138.01 - Transformar o CEP de viável para parcial no Netwin
    [TAGS]              SCRIPT_A                   
    Transformar CEP Netwin

138.02 - Gerar token de acesso
    [TAGS]              SCRIPT_A
    Retornar Token Vtal

138.03-04 - Realizar Consulta de Logradouro
    [TAGS]              SCRIPT_A
    Consulta Id Logradouro

138.05 - Realizar Consulta de Viabilidade
    [TAGS]              SCRIPT_A
    Retorna Viabilidade Produtos            Viável com obra - CDO(s) sem porta livre e em célula disponível

138.06 - Realizar a Criação de Ordem OS
    [TAGS]              SCRIPT_A
    Criar ordem sem agendamento             1000
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

138.07 - Validar a Notificação da Criação da Ordem OS via FW Console
    [TAGS]              SCRIPT_A
    Validar Criação da Ordem
    
136.08 - Validar a Criação da OS de Instalação via SOM
    [TAGS]              SCRIPT_A
    Valida Executar Processo de Obra
    Valida Projeto de Rede

138.09 - Abrir pendência de contato de obra 7100
    [TAGS]              SCRIPT_A
    Abrir Pendencia Contato de Obra

138.10 - Realizar resolução da pendência de contato de obra
    [TAGS]              SCRIPT_A
    Resolucao Pendencia 7100

138.11 - Validar no SOM a resolução da pendência de contato de obra
    [TAGS]              SCRIPT_A
    Validar Pendencia Obra Tratada

138.12 - Realizar Validação no FWConsole
    [TAGS]              SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>7100<
    ...                                     XPATH_XML=//*[text()="START - Inicialização do serviço"]/../..//textarea

138.13 - Transformar o CEP de parcial para viavel no Netwin
    [TAGS]              SCRIPT_A
    Transformar CEP Netwin

138.14 - Realizar Processo de Obra - SOM
    [TAGS]              SCRIPT_A
    Realizar Processo de Obra

138.15 - Realizar consulta de slot para agendamento da instalação
    [TAGS]              SCRIPT_A
    Consulta Slot Agendamento

138.16 - Realizar agendamento da instalação
    [TAGS]              SCRIPT_A
    Realizar Agendamento

138.17 - Realizar resolução da pendência
    [TAGS]              SCRIPT_A
    Tratamento da Pendência

138.18 - Validar no SOM a resolução da pendência de agendamento
    [TAGS]              SCRIPT_A
    Validação da Pendência
    
138.19 - Realizar Validação no FWConsole
    [TAGS]              SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

#===========================================================================================================================================================================================================
#    PARTE B
#===========================================================================================================================================================================================================
138.20 - Realizar o Encerramento da Os de instalação via FSL
    [TAGS]              SCRIPT_B
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL
    Close Browser                           CURRENT

138.21 - Validar no SOM o encerramento da OS de instalação
    [TAGS]              SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed

138.22 - Validar Mudança de Estados no FW
    [TAGS]               SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                     ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:name      

138.23 - Validar no Field Service
    [TAGS]              SCRIPT_B
    Valida SA no Field Service

138.24 - Auditoria de Tarefas
    [TAGS]              SCRIPT_B
    Auditoria de Tarefas

138.25 - Validar a Notificação de Encerramento via FW Console
    [TAGS]              SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<  

#===========================================================================================================================================================================================================
#   SCRIPT COMPLETO
#===========================================================================================================================================================================================================
138.01 - Transformar o CEP de viável para parcial no Netwin
    [TAGS]              SCRIPT_COMPLETO
    Transformar CEP Netwin

138.02 - Gerar token de acesso
    [TAGS]              SCRIPT_COMPLETO
    Retornar Token Vtal

138.03-04 - Realizar Consulta de Logradouro
    [TAGS]              SCRIPT_COMPLETO
    Consulta Id Logradouro

138.05 - Realizar Consulta de Viabilidade
    [TAGS]              SCRIPT_COMPLETO
    Retorna Viabilidade Produtos            Viável com obra - CDO(s) sem porta livre e em célula disponível

138.06 - Realizar a Criação de Ordem OS
    [TAGS]              SCRIPT_COMPLETO
    Criar Ordem Agendamento                 1000
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

138.07 - Validar a Notificação da Criação da Ordem OS via FW Console
    [TAGS]              SCRIPT_COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]
    ...                                     RETORNO_ESPERADO=>200<
136.08 - Validar a Criação da OS de Instalação via SOM
    [TAGS]              SCRIPT_COMPLETO
    Valida Executar Processo de Obra
    Valida Projeto de Rede

138.09 - Abrir pendência de contato de obra 7100
    [TAGS]              SCRIPT_COMPLETO
    Abrir Pendencia Contato de Obra

138.10 - Realizar resolução da pendência de contato de obra
    [TAGS]              SCRIPT_COMPLETO
    Resolucao Pendencia 7100

138.11 - Validar no SOM a resolução da pendência de contato de obra
    [TAGS]              SCRIPT_COMPLETO
    Validar Pendencia Obra Tratada

138.12 - Realizar Validação no FWConsole
    [TAGS]              SCRIPT_COMPLETO
    Validar Evento FW                       VALOR_BUSCA=workOrderId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>7100<
    ...                                     XPATH_XML=//*[text()="START - Inicialização do serviço""]/../..//textarea
    ...                                     DADOS_XML=code

138.13 - Transformar o CEP de parcial para viavel no Netwin
    [TAGS]              SCRIPT_COMPLETO
    Transformar CEP Netwin

138.14 - Realizar Processo de Obra - SOM
    [TAGS]              SCRIPT_COMPLETO
    Realizar Processo de Obra

138.15 - Realizar consulta de slot para agendamento da instalação
    [TAGS]              SCRIPT_COMPLETO
    Consulta Slot Agendamento

138.16 - Realizar agendamento da instalação
    [TAGS]              SCRIPT_COMPLETO
    Realizar Agendamento

138.17 - Realizar resolução da pendência
    [TAGS]              SCRIPT_COMPLETO
    Tratamento da Pendência

138.18 - Validar no SOM a resolução da pendência de agendamento
    [TAGS]              SCRIPT_COMPLETO
    Validação da Pendência

138.19 - Realizar Validação no FWConsole
    [TAGS]              SCRIPT_COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     XPATH_XML=//*[text()="START - Inicialização do serviço""]/../..//textarea
    ...                                     DADOS_XML=observation

XX.XX - Atualização da data de agendamento via API
    [TAGS]              SCRIPT_COMPLETO
    Reagendar Pedido OPM e FSL

XX.XX - Troca de técnico via FSL
    [TAGS]              SCRIPT_COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

138.20 - Realizar o Encerramento da Os de instalação via FSL
    [TAGS]              SCRIPT_COMPLETO
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL
    Close Browser                           CURRENT

    Close Browser                           CURRENT

138.21 - Validar no SOM o encerramento da OS de instalação
    [TAGS]              SCRIPT_COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

138.22 - Validar Mudança de Estados no FW
    [TAGS]               SCRIPT_COMPLETO
    ${state_list}=                          Create List                             Não atribuído                           Atribuído 

    Validar Mudancas de Estado FW           ${state_list}                           WorkOrderManagement.ListenerWorkOrderAttributeValueChangeEvent                  lifeCycleStatus      

    ${state_list}=                          Create List                             Em deslocamento                         Em execução                             Concluído com sucesso

    Validar Mudancas de Estado FW           ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:lifeCycleStatus                                      


138.23 - Validar no Field Service
    [TAGS]              SCRIPT_COMPLETO
    Valida SA no Field Service

138.24 - Auditoria de Tarefas
    [TAGS]              SCRIPT_COMPLETO
    Auditoria de Tarefas

138.25 - Validar a Notificação de Encerramento via FW Console
    [TAGS]              SCRIPT_COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea)[1]
    ...                                     DADOS_XML=description
