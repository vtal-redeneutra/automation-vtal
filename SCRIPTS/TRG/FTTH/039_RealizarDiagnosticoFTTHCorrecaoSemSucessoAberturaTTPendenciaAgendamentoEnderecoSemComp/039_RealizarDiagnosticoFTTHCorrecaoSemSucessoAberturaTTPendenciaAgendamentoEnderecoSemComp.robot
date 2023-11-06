*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
                                   


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/039_RealizarDiagnosticoFTTHCorrecaoSemSucessoAberturaTTPendenciaAgendamentoEnderecoSemComp.xlsx


*** Test Cases ***

## SCRIPT A 

39.01 - Gerar Token de Acesso
    [Tags]                                  SCRIPT_A
    Retornar Token Vtal

39.02 - Criar massa para não cair em Trouble Ticket (diagnóstico sem falha)
    [Tags]                                  SCRIPT_A
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01                           RESET_JSON=SIM 

39.03 - Realizar Pré Diagnóstico
    [Tags]                                  SCRIPT_A
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

39.04 - Realizar Validação do Pré diagnóstico no Microserviços
    [Tags]                                  SCRIPT_A                          
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT         XML    INVOKE - Request enviado para a ClienteCo        state                   state
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado para a ClienteCo        type                    preDiagnostic
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço                     msg:Description         Sucesso

39.05 - Realizar Diagnóstico
    [Tags]                                  SCRIPT_A
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

39.06 - Realizar Validação do Diagnóstico no Microserviços
    [Tags]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.PostServiceTest referente ao diagId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     tns:code                                200
    
39.07 - Abrir chamado técnico
    [Tags]                                  SCRIPT_A
    Abrir Chamado Tecnico                   Problema de conectividade                                                                                       

39.08 - Validar abertura de repararo com pendência
    [Tags]                                  SCRIPT_A
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem	
    ...                                     ORDER_STATE=In Progress

39.09 - Consultar slot para agendamento do reparo 
    [Tags]                                  SCRIPT_A
    Retornar Slot Agendamento Reparo

39.10 - Realizar agendamento de reparo
    [Tags]                                  SCRIPT_A
    Realizar Agendamento de Reparo                                                  

39.11 - Realizar tratamento de pendência
    [Tags]                                  SCRIPT_A
    Tratamento de Pendencia TroubleTicket                                           

39.12 - Validar tratamento da Pendência
    [Tags]                                  SCRIPT_A

    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Ordem_tipo}                                        
    
    @{RETORNO}=                             Create List                             associatedDocument                      Type

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T088 - Executar BA Planta Externa Chamado Tecnico
    ...                                     ORDER_STATE=In Progress	
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

####################################################################################

## SCRIPT B

XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_B
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

39.13 - Realizar o encerramento da pendência via FSL
    [Tags]                                  SCRIPT_B
    Atualiza Status SA
    Encerrar a Pendencia do Agendamento
    Close Browser                           CURRENT

39.14 - Validar Encerramento Trouble Ticket
    [Tags]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem	
    ...                                     ORDER_STATE=Completed

39.15 - Valida encerramento de pendência no Microserviços
    [Tags]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por TroubleTicketManagement.NotificarStatusTroubleTicket referente ao troubleTicketId
    Validar dado do Bloco com a DAT         XML    INVOKE - Request enviado ao API Gateway                                  associatedDocument                      associatedDocument

39.16 - Auditoria de Tarefas
    [Tags]                                  SCRIPT_B
    Auditoria de Tarefas