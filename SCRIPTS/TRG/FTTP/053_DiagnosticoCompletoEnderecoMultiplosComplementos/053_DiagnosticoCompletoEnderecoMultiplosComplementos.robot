*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/053_DiagnosticoCompletoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

53.1 - Gerar Token de Acesso
    Retornar Token Vtal

53.2 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   RESET_JSON=SIM
    
53.3 - Realizar pre-diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

53.4 - Validar retorno do pre-diagnostico no FW
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state
    
53.5 - Realizar Diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
53.6 - Validar retorno do diagnostico no FW
    Escrever Variavel na Planilha           diagnostic                              type                                    Global
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,code
    