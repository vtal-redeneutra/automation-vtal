*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot

Suite Setup                                 Setup cenario                           Whitelabel

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_NETWIN_DAT_145_GerirCatalogoRecurso.xlsx


*** Test Cases ***

145.01 - Realizar a Criacao do Bastidor
    [TAGS]              SCRIPT_A
    Logar Netwin
    Realizar a Criacao do Bastidor

145.02 - Realizar a Criação do Módulo
    [TAGS]              SCRIPT_A
    Logar Netwin
    Criar Modulo

#===================================================================================================================================================================
# /\ PARTE FEITA MANUALMENTE
# \/ PARTE AUTOMATIZADA
#===================================================================================================================================================================

145.03 - Realizar Limpeza de placa
    [TAGS]              SCRIPT_B
    Logar Netwin
    Limpar Placa

145.04 - Realizar a Criação da Placa
    [TAGS]              SCRIPT_B
    Logar Netwin
    Criar Placa