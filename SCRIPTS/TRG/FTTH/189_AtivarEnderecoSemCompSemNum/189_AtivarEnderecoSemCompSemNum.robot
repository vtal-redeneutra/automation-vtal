*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/189_AtivarEnderecoSemCompSemNum.xlsx


*** Test Cases ***

189.01 - Gerar Token de Acesso 
    Retornar Token Vtal

189.02/03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro com Id Complements

189.04 - Realizar Consulta de Viabilidade com Erro
    Consultar Viabilidade com Erro