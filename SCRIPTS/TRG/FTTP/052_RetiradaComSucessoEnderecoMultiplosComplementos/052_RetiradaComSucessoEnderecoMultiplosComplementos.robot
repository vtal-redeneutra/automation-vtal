*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/052_RetiradaComSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

52.01 - Gerar token de acesso
    Retornar Token Vtal

52.02 - Realizar abertura de Ordem de Retirada
    Criar Ordem de Retirada                 FTTP                                    400               

52.03 - Realizar validação no SOM
    Validar Ordem SOM Retirada Completa     FTTP                                    400

52.04 - Realizar validação de notificação no FW
    Validacao do FTTP no FW
    Valida StateChangeEvent FTTP
    
   