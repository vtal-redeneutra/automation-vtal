*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/051_SuporteRecusaAssociacaoONTAtivaEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

51.01 - Gerar token de acesso
    Retornar Token Vtal

51.02/03 - Realizar o Associação de ONT
    Realizar Associação de ONT

51.04 - Realizar Validação no SOM
    Valida Evento SOM                       associatedDocument                      Completed                               Vtal Fibra Associação de Equipamento Parceiro                        	      

51.05 - Validar o Recebimento da Notificação a recusa a realização da ONT via FW Console 
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=description>O Equipamento já está em uso por outro cliente<