*** Settings ***
Documentation                                   Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: 

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/156_DiagnosticoCompletoBitCorrecaoSucessoComComp.xlsx


*** Test Cases ***
156.01 - Gerar Token de Acesso
    Retornar Token Vtal

156.02 - Realizar configuração Mock
    Alterar Campo no NETQ                   RESET_JSON=SIM

156.03 - Realizar Pré Diagnóstico
    Realizando PreDiagnostico

156.04 - Realizar Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

156.05 - Realizar Diagnóstico
    Realizando Diagnostico

156.06 - Realizar Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state