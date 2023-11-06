*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_069_AbrirTTSuporteAtivacaoSemPendenciaEnderecoSemComplemento.xlsx


*** Test Cases ***

69.01 - Gerar Token de Acesso
    Retornar Token Vtal

69.02 - Realizar abertura de Trouble Ticket
    Abrir Chamado Tecnico sem complemento                                           Sem conexão                             CDO Não construída