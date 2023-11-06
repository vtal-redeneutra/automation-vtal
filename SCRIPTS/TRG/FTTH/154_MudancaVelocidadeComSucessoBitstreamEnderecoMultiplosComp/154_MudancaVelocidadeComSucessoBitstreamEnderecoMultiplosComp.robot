*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address - Number
...                                         OUTPUT: Type_Logradouro - Address_Name - Address_Id - TypeComplement1 - Value1 - TypeComplement2 - Value2 = TypeComplement3 - Value3 - Inventory_Id - Availability_Description - Catalog_Id - Name - MaxBandWidth - Associated_Document_Date - Appointment_Start - Appointment_Finish - Associated_Document - Work_Order_Id - Correlation_Order - Customer_Name	Phone_Number - Reference - SOM_Order_Id - cancelDate - LyfeCycleStatus - CancelAppointmentReason - CancelAppointmentComments - returnedMessage

Suite Setup                                 Setup cenario                           Bitstream


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0016_RealizarMudancaVelocidade/ROB0016_RealizarMudancaVelocidade.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/154_MudancaVelocidadeComSucessoBitstreamEnderecoMultiplosComp.xlsx


*** Test Cases ***
154.01 - Gerar Token de Acesso 
    Retornar Token Vtal

154.02 - Realizar a abertura de uma OS de Mudança de Velocidade
    Mudar Velocidade                        true

154.03 - Validar Conclusão da OS de Mudança de Velocidade via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroCOM}                  ${SOM_Ordem_numeroPedido}               ${SOM_infraType}                                                
    ...                                     ${SOM_Ordem_tipo}                       ${SOM_Cliente_idContrato}                                                                                                              

    @{RETORNO}=                             Create List                             somOrderId                              associatedDocument                      infraType                                
    ...                                     Type                                    subscriberId                           
                                                                     
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed	
    ...                                     ORDER_TYPE=Vtal Bitstream Modificacao de Velocidade                
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

154.04 - Validar o Recebimento da Notificação de Mudança de Velocidade via FW Console
    Verificar mudanca de Velocidade