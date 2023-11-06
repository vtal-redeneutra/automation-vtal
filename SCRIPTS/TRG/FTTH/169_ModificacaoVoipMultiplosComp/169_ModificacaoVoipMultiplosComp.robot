*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
    ...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/SOM/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0044_ModificacaoVoip/ROB0044_ModificacaoVoip.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/169_ModificacaoVoipMultiplosComp.xlsx


*** Test Cases ***
169.01 - Gerar Token de Acesso
    Retornar Token Vtal

169.02 - Realizar Modificação BL+Voip 
    Realizar Modificacao Voip

169.03 - Validar Notificação FW Console
    Buscar OS Start XML                     associatedDocument                      (//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]     

    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]
    ...                                     RETORNO_ESPERADO=>200<

169.04 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Header_OrderID}
                                   
    @{RETORNO}=                             Create List                             associatedDocument                      somOrderId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Modificação
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}