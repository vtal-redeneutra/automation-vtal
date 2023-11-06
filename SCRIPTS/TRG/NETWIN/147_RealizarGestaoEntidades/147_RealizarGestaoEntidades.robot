*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot

Suite Setup                                 Setup cenario                           Whitelabel


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/147_RealizarGestaoEntidades.xlsx


*** Test Cases ***
147.01 - Criar Elemento
    Logar Netwin
    Selecionar Georreferenciada

    Pesquisar Elemento                      Elemento_UF=BA - BAHIA
    ...                                     Elemento_Municio=FEIRA DE SANTANA
    ...                                     Elemento_Localidade=FSA - FEIRA DE SANTANA
    ...                                     Elemento_Entidade=Equipamento
    ...                                     Elemento_Tipo=OPT
    ...                                     Elemento_Nome=1

    Selecionar Calçada
    Criar Quadrado

147.02 - Pesquisar elemento
    Logar Netwin
    Selecionar Georreferenciada
    
    Pesquisar Elemento                      Elemento_UF=BA - BAHIA
    ...                                     Elemento_Municio=FEIRA DE SANTANA
    ...                                     Elemento_Localidade=FSA - FEIRA DE SANTANA
    ...                                     Elemento_Entidade=Local
    ...                                     Elemento_Tipo=Caixa Subterrânea
    ...                                     Elemento_Nome=${numero_calcada}

    Alterar Endereço


147.XX - Remover Caixa
    Logar Netwin
    Selecionar Georreferenciada

    Pesquisar Elemento                      Elemento_UF=BA - BAHIA
    ...                                     Elemento_Municio=FEIRA DE SANTANA
    ...                                     Elemento_Localidade=FSA - FEIRA DE SANTANA
    ...                                     Elemento_Entidade=Equipamento
    ...                                     Elemento_Tipo=OPT
    ...                                     Elemento_Nome=1

    Remover Caixa