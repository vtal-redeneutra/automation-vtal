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
${DAT_CENARIO}                              ${DIR_DAT}/050_AssociarONTComSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***
50.01 - Gerar token de acesso
    Retornar Token Vtal

50.02 - Realizar o Associação de ONT
    Realizar Associação de ONT

50.03 - Realizar Validação no SOM
    Valida Evento SOM                       associatedDocument                      Completed                               Vtal Fibra Associação de Equipamento Parceiro                        	      

50.04 - Validar o Recebimento da Notificação via FW Console
    Validar Associação de ONT
