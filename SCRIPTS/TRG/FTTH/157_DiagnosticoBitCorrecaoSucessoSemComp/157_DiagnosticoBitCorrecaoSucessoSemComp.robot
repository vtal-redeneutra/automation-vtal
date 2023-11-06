*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address - Number
...                                         OUTPUT: Type_Logradouro - Address_Name - Address_Id - TypeComplement1 - Value1 - TypeComplement2 - Value2 = TypeComplement3 - Value3 - Inventory_Id - Availability_Description - Catalog_Id - Name - MaxBandWidth - Associated_Document_Date - Appointment_Start - Appointment_Finish - Associated_Document - Work_Order_Id - Correlation_Order - Customer_Name	Phone_Number - Reference - SOM_Order_Id - cancelDate - LyfeCycleStatus - CancelAppointmentReason - CancelAppointmentComments - returnedMessage

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/157_DiagnosticoBitCorrecaoSucessoSemComp.xlsx


*** Test Cases ***
157.01 - Gerar Token de Acesso
    Retornar Token Vtal

157.2 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=GPON_ESTADO_ONT                   VALOR=GPON_03_CAUT                      RESET_JSON=SIM
    
157.3 - Realizar pre-diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

157.4 - Validar retorno do pre-diagnostico no FW
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               preDiagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso
    
157.5 - Realizar Diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

157.6 - Validar retorno do diagnostico no FW
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao diagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               diagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso