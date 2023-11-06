*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address - Number
...                                         OUTPUT: Type_Logradouro - Address_Name - Address_Id - TypeComplement1 - Value1 - TypeComplement2 - Value2 = TypeComplement3 - Value3 - Inventory_Id - Availability_Description - Catalog_Id - Name - MaxBandWidth - Associated_Document_Date - Appointment_Start - Appointment_Finish - Associated_Document - Work_Order_Id - Correlation_Order - Customer_Name	Phone_Number - Reference - SOM_Order_Id - cancelDate - LyfeCycleStatus - CancelAppointmentReason - CancelAppointmentComments - returnedMessage

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/159_PreDiagnosticoBitEnderecoSemComp.xlsx


*** Test Cases ***
159.01 - Gerar Token de Acesso 
    Retornar Token Vtal

159.02 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=VULTOATIVO                        VALOR=OK                                RESET_JSON=SIM
    
159.03 - Realizar Pré Diagnóstico
    Realizando PreDiagnostico

159.04 - Realizar Validação do Pré diagnóstico no FW Console
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               preDiagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso