*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_NETQ}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/023_RealizarDiagnosticoCompletoCorrecaoAutomaticaEnderecoSemComplemento.xlsx


*** Test Cases ***

23.01 - Retornar Token Vtal
    Retornar Token Vtal

23.02 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=GPON_ESTADO_ONT                   VALOR=GPON_03_CAUT                      RESET_JSON=SIM

23.03 - Realizando PreDiagnostico
    Realizando PreDiagnostico

23.04 - Valida Notificacao Pre Diagnostico no FW  
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

23.05 - Realizando Diagnostico
    Realizando Diagnostico

23.06 - Valida Notificacao Diagnostico no FW_2
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state


