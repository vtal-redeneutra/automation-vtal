*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0043_CriacaoRede/ROB0043_CriacaoRede.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_NETWIN_DAT_142_CriarRede.xlsx


*** Test Cases ***
142.01 - Validar Viabilidade de Endereço
    Consultar Viabilidade Netwin

142.02 - Criação do OPT
    Criacao OPT

# 142.03 - Criação da Caixa Subterrânea

# 142.04 - Criação do Poste

# 142.05 - Criação de Surveys

# 142.06 - Importação do Survey para o Netwin

# 142.07 - Exportação do Survey para o CE- Mobile

# 142.08 - Equipamento Rede Externa - Criação CDOI 

# 142.09 - Criação do Traçado - Survey até o OPT

# 142.10 - Criação do Traçado - Survey até o Poste

# 142.11 - Criação do Traçado - Caixa Subterrânea até o Poste

# 142.12 - Criação da CEO - Equipamento Rede Externa

# 142.13 - Criação da CEOS - Equipamento Rede Externa 

# 142.14 - Criação do Splitter na CEOS

# 142.15 - Criação CDOE - Equipamento Rede Externa

# 142.16 - Criação do Splitter - CDOI

# 142.17 - Criação dos Cabos

# 142.18 - Área de Influência

# 142.19 - Validar o Abastecimento

# 142.20 - Criação do Nó Optico

# 142.21 - Mudança de Estado Equipamentos - Caixa Subterrânea

# 142.22 - Mudança de Estado Equipamentos Rede Externa - Poste CEOS

# 142.23 - Mudança de Estado Rede Externa - Poste CDOE

# 142.24 - Mudança de Estado Rede Externa - Survey

# 142.25 - Criação de Equipamento - CDOE

# 142.26 - Criação de Equipamento Lógico - CDOI

# 142.27 - Criação Equipamento Planta Interna - MSAN

# 142.28 - Criação do Bastidor - MSAN

# 142.29 - Criação do Shelf - Módulo - MSAN

# 142.30 - Criação do ICX

# 142.31 - Criação do Bastidor - ICX

# 142.32 - Criação do Shelf - Módulo - ICX

# 142.33 - Criação do BSP

# 142.34 - Criação do Bastidor - BSP

# 142.35 - Criação do Shelf - Módulo - BSP

# 142.36 - Criação do DGO

# 142.37 - Criação do Bastidor - DGO

# 142.38 - Criação do Shelf - Módulo - DGO

# 142.39 - Criação - BNG

# 142.40 - Criação do Bastidor - BNG

# 142.41 - Criação do Shelf - Módulo - BNG

# 142.42 - Conectividade

# 142.43 - Aceitação da CDO

# 142.44 - Criação Rede de Edifício

# 142.45 - Consulta de Viabilidade
