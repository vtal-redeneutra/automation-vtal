*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/148_ReparoComFechamentoDeSAviaOPM.xlsx


*** Test Cases ***
148.01/02 - Realizar configuração na ferramenta de mock
    [TAGS]                                  SCRIPT_A         
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01                           RESET_JSON=SIM                   

148.03 - Gerar Token de Acesso
    [TAGS]                                  SCRIPT_A    
    Retornar Token Vtal

148.04 - Realizar o Pré-Diagnóstico  
    [TAGS]                                  SCRIPT_A    
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

148.05 - Validação do Pré-Diagnóstico no Microserviços
    [TAGS]                                  SCRIPT_A    
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT         XML    INVOKE - Request enviado para a ClienteCo        state                   state
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado para a ClienteCo        type                    preDiagnostic
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço                     msg:Description         Sucesso

148.06 - Realizar o Diagnóstico    
    [TAGS]                                  SCRIPT_A                             
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

148.07 - Validação do Diagnóstico no Microserviços
    [TAGS]                                  SCRIPT_A    
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.PostServiceTest referente ao diagId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     tns:code                                200
    
148.08 - Abrir chamado técnico
    [TAGS]                                  SCRIPT_A    
    Abrir Chamado Tecnico sem complemento   problem_description=Problema de Conectividade                                   problem_origin=Pendência Cliente
    
148.09 - Validar a Criação da OS de Reparo via SOM
    [TAGS]                                  SCRIPT_A    
    Validar Criação de Reparo SOM           SomAgendamento=T070 - Agendamento                            

148.10 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A    
    Retornar Slot Agendamento Reparo

148.11 - Realizar Agendamento de Reparo
    [TAGS]                                  SCRIPT_A    
    Realizar Agendamento de Reparo    

148.12 - Realizar o Tratamento da Pendência  
    [TAGS]                                  SCRIPT_A    
    Tratamento de Pendencia TroubleTicket 

148.13 - Validar no SOM a Resolução da Pendência
    [TAGS]                                  SCRIPT_A    
    Validar a pendencia TroubleTicket no SOM                                        SomAgendamento=T070 - Agendamento
#===================================================================================================================================================================
148.14 - Validar a Atribuição do Técnico Habilitado para Atividade de Encerramento via OPM
    [TAGS]                                  SCRIPT_B
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

148.15 - Realizar o Encerramento do Reparo via OPM
    [TAGS]                                  SCRIPT_B
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Criação do SA de Reparo
    Close Browser 
    Colocar Sa concluida - Reparo

148.16 - Validar Mudança de Estados no Microserviços
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                          associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

148.17 - Validar a Conclusão da Atividade via SOM
    [TAGS]                                  SCRIPT_B
    Valida Evento SOM                       associatedDocument                      Completed                               Vtal Fibra Chamado Tecnico Ordem	

148.18 - Validar a Notificação de Encerramento da Atividade via FW Console
    [TAGS]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por TroubleTicketManagement.NotificarStatusTroubleTicket referente ao troubleTicketId
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado ao API Gateway                                  msg:Description                         Chamado Técnico tratado com sucesso
