*** Settings ***
Documentation       Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/022_RealizarDiagnosticoCompletoComSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***
22.1 - Gerar Token de Acesso 
    Retornar Token Vtal

22.02 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   RESET_JSON=SIM

22.03 - Realizar pre-diagnostico 
    Realizando PreDiagnostico

22.04 - Validar retorno do pre-diagnostico no FW
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

22.05 - Realizar Diagnostico
    Realizando Diagnostico

22.06 - Validar retorno do diagnostico no FW                       
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE    subscriberId,startDate,endDate,state,code
