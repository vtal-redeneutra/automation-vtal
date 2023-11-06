*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/056_PreDiagnosticoComOSAbertaEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

56.01 - Gerar o Token de Acesso
    Retornar Token Vtal
    
56.02 - Realizar a Abertura do Trouble Ticket
    Abrir Chamado Tecnico

56.03 - Realizar Validação no SOM
    Valida Evento SOM                       associatedDocument                      In Progress                             Vtal Fibra Chamado Tecnico Ordem              	      

56.04 - Acessar o Citrix
    Alterar Campo no NETQ                   CAMPO=VULTOATIVO                        VALOR=OK                                RESET_JSON=SIM

56.05 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

56.06 - Validar a Notificação do Pré-Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state


