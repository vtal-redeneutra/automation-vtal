*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_055_PreDiagnosticoComFalhaEnderecoMultiplosComplementos.xlsx


*** Test Cases ***
55.01 - Gerar Token de Acesso 
    Retornar Token Vtal

55.02 - Realizar configuração na ferramenta de mock
    Alterar Campo no NETQ                   CAMPO=VULTOATIVO                        VALOR=INVENTORY_18                      RESET_JSON=SIM                   

55.03 - Realizar pre-diagnostico 
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

55.04 - Validar retorno do pre-diagnostico no FW
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID  
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state
