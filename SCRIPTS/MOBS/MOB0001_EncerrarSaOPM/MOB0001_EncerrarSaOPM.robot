*** Settings ***
Documentation                               Encerrar SA via OPM

Resource                                    ../../RESOURCE/OPM/UTILS.robot

*** Variables ***

${ENTER}                                    66


*** Keywords ***

Colocar SA em execucao
    Abrir Aplicativo OPM
    Selecionar SA 
    Click Element Is Visible                ${btn_atualizar_status}
    Wait Until Page Contains Element        ${btn_fechar_alerta}                    30 seconds
    Click Element Is Visible                ${btn_fechar_alerta}
    Click Element Is Visible                ${btn_atualizar_status}
    Click Element Is Visible                ${btn_voltar}  
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    [Teardown]                              Finalizar Jornada e Sair                CONFIRMACAO=SIM

####################################################################################################################################################################################
Finalizar SA no OPM
    Abrir Aplicativo OPM 
    Selecionar SA
    Preencher Finalizacao                   cod_encerramento=40301
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global    
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Colocar Sa concluida
    [Arguments]                             ${adicionarMaterial}=NAO
    ...                                     ${adicionarAuxilio}=NAO
    Abrir Aplicativo OPM 
    Selecionar SA 
    Preencher Facilidades
    IF    "${adicionarMaterial}" != "NAO"
        Preencher Consumo Materiais         material=Parafuso C/Bucha Plastica S-6
        ...                                 quantidadeMaterial=12
    END
    IF    "${adicionarAuxilio}" != "NAO"
        Preencher Auxiliar                  teveAuxilio=Sim
    END
    Preencher Consumo Equipamento
    Preencher Finalizacao
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global    
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Colocar Sa concluida - Reparo
    Abrir Aplicativo OPM 
    Selecionar SA 
    Preencher Auxiliar - Retirada
    Preencher Matricula Auxiliar - Reparo
    Preencher Finalizacao                   cod_encerramento=10301
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global    
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Colocar Sa Concluida - Retirada
    [Arguments]                             ${Extravio}=False
    Abrir Aplicativo OPM
    Selecionar SA 
    Preencher Consumo Materiais - Retirada
    Preencher Consumo Equipamento - Retirada        ${Extravio}
    Preencher Auxiliar - Retirada
    Preencher Finalizacao
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global    
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Colocar Sa Concluida sem sucesso
    [Arguments]                             ${EquipamentoAssociado}=ONT TIM SAGEM FAST5670 WI-FI 6
    Abrir Aplicativo OPM
    Selecionar SA 
    Preencher Consumo Equipamento - Bitstream                                       pause_equipamento=${EquipamentoAssociado}
    Preencher Facilidades                   cod_cabo_riser=1275                     cod_cabo_drop=1274                      cod_cdoia=1277
    Preencher Auxiliar - Retirada
    Preencher Matricula Auxiliar - Bitstream
    Click Element Is Visible                ${btn_voltar}  
    [Teardown]                              Finalizar Jornada e Sair                CONFIRMACAO=SIM

####################################################################################################################################################################################
Colocar Sa concluida - Reparo Planta Externa
    Abrir Aplicativo OPM 
    Selecionar SA 
    Preencher Auxiliar - Retirada
    Preencher Matricula Auxiliar - Reparo
    Preencher Finalizacao Planta Externa    cod_encerramento=00                     
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global    
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Colocar Sa concluida - Remanejamento de Ponto
    [Arguments]                             ${adicionarMaterial}=NAO
    ...                                     ${adicionarAuxilio}=NAO
    Abrir Aplicativo OPM
    Selecionar SA
    IF    "${adicionarMaterial}" != "NAO"
        Preencher Consumo Materiais         material=PARAFUSO C/BUCHA PLASTICA S-6
        ...                                 quantidadeMaterial=12
    END
    IF    "${adicionarAuxilio}" != "NAO"
        Preencher Auxiliar                  teveAuxilio=Sim
    END
    Preencher Finalizacao
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Encerrar SA sem sucesso OPM
    [Arguments]                             ${codigo_encerramento}
    Abrir Aplicativo OPM
    Selecionar SA 
    Preencher Facilidades                   cod_cabo_riser=1275                     cod_cabo_drop=1274                      cod_cdoia=1277
    Preencher Finalizacao                   cod_encerramento=${codigo_encerramento}
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído sem sucesso                   Estado                                  Global
    [Teardown]                              Finalizar Jornada e Sair

####################################################################################################################################################################################
Selecionar SA 
    Click Element Is Visible                ${btn_start_journey}
    ${ba}=                                  Ler Variavel na Planilha                workOrderId                             Global
    Click Element Is Visible                //*[contains(@text,'${ba}')]
    Click Element Is Visible                ${btn_menu_acoes}

####################################################################################################################################################################################
Preencher Facilidades
    [Arguments]                             ${cod_cabo_riser}=10                    ${cod_cabo_drop}=11                     ${cod_cdoia}=12
    Click Element Is Visible                ${btn_atualizar_facilidades}
    Input Text Element Is Visible           ${input_cabo_riser}                     ${cod_cabo_riser}
    Input Text Element Is Visible           ${input_cabo_drop}                      ${cod_cabo_drop}
    Input Text Element Is Visible           ${input_cdoia}                          ${cod_cdoia}
    Click Element Is Visible                ${btn_salvar_facilidades}

####################################################################################################################################################################################
Preencher Consumo Materiais
    [Arguments]                             ${material}=10815_FECHO AÇO INOX 3/4
    ...                                     ${quantidadeMaterial}=2

    Click Element Is Visible                ${btn_consumo_materiais}
    Sleep                                   3s
    Click Element Is Visible                ${btn_adicionar_materiais}
    #Acao
    Click Element Is Visible                ${select_acao}
    Click Element Is Visible                ${radio_acao_adicionar}

    #Grupo
    Click Element Is Visible                ${btn_adicionar_grupo}
    Pause execution                         Selecione "ACESSORIOS".
    # Click Element Is Visible                ${input_pesquisa_grupo}
    # Input Text Element Is Visible           ${input_pesquisa_grupo}                 ACESSORIOS
    # Click Element Is Visible                ${select_grupo}

    #Material
    Click Element Is Visible                ${btn_adicionar_material}
    Pause Execution                         Selecione "${material}"
    # Click Element Is Visible                ${input_pesquisa_material}
    # Sleep                                   2s
    # Input Text Element Is Visible           ${input_pesquisa_material}              ${material}
    # Sleep                                   2s
    # Click Element Is Visible                xpath=//android.widget.TextView[@text="${material}"]

    #Quantidade
    # Click Element Is Visible                ${input_material_quantidade}
    # Sleep                                   2s
    Input Text Element Is Visible           ${input_material_quantidade}            ${quantidadeMaterial}
    
    #Salvar
    Take Screenshot App                     ${btn_salvar_materiais}
    Click Element Is Visible                ${btn_salvar_materiais}
    Sleep                                   2s
    Click Element Is Visible                ${btn_voltar}


####################################################################################################################################################################################
Preencher Consumo Equipamento - Retirada
    [Arguments]                             ${Extravio}=False

    Click Element Is Visible                ${btn_consumo_equipamentos}
    Sleep                                   5s
    Click Element Is Visible                ${btn_editar_equipamento}
    Sleep                                   3s
    Click Element Is Visible                ${btn_extraviado}
    Sleep                                   3s
    IF      ${Extravio}
        Click Element Is Visible            ${radio_extraviado_sim}
        Sleep                               3s
        Input Text Element Is Visible       ${input_extraviado}                     Extravio do equipamento
        Sleep                               3s
    ELSE
        Click Element Is Visible            ${radio_extraviado_nao}
        Sleep                               3s
    END
    Click Element Is Visible                ${btn_salvar_equipamento}
    Sleep                                   3s
    Click Element Is Visible                ${btn_voltar}

####################################################################################################################################################################################
Preencher Consumo Materiais - Retirada
    Click Element Is Visible                ${btn_consumo_materiais}
    Click Element Is Visible                ${btn_adicionar_materiais}
    #Acao
    Click Element Is Visible                ${select_acao}
    Click Element Is Visible                ${radio_acao_retirar}
    #Grupo
    Click Element Is Visible                ${btn_adicionar_grupo}
    Pause Execution                         Selecione "ACESSORIOS".

    # Click Element Is Visible                ${input_pesquisa_grupo}
    # Input Text Element Is Visible           ${input_pesquisa_grupo}                 ACESSORIOS
    # Click Element Is Visible                ${select_grupo}

    #Material
    Click Element Is Visible                ${btn_adicionar_material}
    Pause Execution                         Selecione "ADAPTADOR DE TOMADA NOVA X ANTIGA 20A".

    # Click Element Is Visible                ${input_pesquisa_material}
    # Sleep                                   2s
    # Input Text Element Is Visible           ${input_pesquisa_material}              ADAPTADOR DE TOMADA NOVA X ANTIGA 20A
    # Sleep                                   2s
    # Click Element Is Visible                ${select_material_retirada}
    
    # #Quantidade
    Input Text Element Is Visible           ${input_material_quantidade}            1

    #Salvar
    Click Element Is Visible                ${btn_salvar_materiais}
    Sleep                                   2s
    Click Element Is Visible                ${btn_voltar}

####################################################################################################################################################################################
Preencher Auxiliar
    [Arguments]                             ${teveAuxilio}=Sim      # Sim ou Não

    Click Element Is Visible                ${btn_auxiliar}
    Click Element Is Visible                ${select_auxiliar}
    Click Element Is Visible                xpath=//android.widget.RadioButton[@text="${teveAuxilio}"]
    IF    "${teveAuxilio}" == "Sim"
        Input Text Element Is Visible       ${matricula_auxiliar01}                 TR741061 
        Input Text Element Is Visible       ${observacao01}                         AUXILIAR TÉCNICO
    END
    Take Screenshot App                     ${btn_salvar_auxiliar}
    Click Element Is Visible                ${btn_salvar_auxiliar}

####################################################################################################################################################################################
Preencher Auxiliar - Retirada
    Click Element Is Visible                ${btn_auxiliar}
    Click Element Is Visible                ${select_ajuda}
    Click Element Is Visible                ${select_ajuda_sim}
    Take Screenshot App                     ${btn_salvar_auxiliar}
    Click Element Is Visible                ${btn_salvar_auxiliar}

####################################################################################################################################################################################
Preencher Matricula Auxiliar - Reparo
    Input Text Element Is Visible           ${matricula_auxiliar01}                 TR741061
    Input Text Element Is Visible           ${observacao01}                         AUXILIAR TÉCNICO
    Input Text Element Is Visible           ${matricula_auxiliar02}                 TR771377    
    Input Text Element Is Visible           ${observacao02}                         REPARO
    Click Element Is Visible                ${btn_salvar_auxiliar}

####################################################################################################################################################################################
Preencher Matricula Auxiliar - Bitstream
    Input Text Element Is Visible           ${matricula_auxiliar01}                 TR741061
    Input Text Element Is Visible           ${observacao01}                         ENCERRAMENTO COM PENDÊNCIA
    Click Element Is Visible                ${btn_salvar_auxiliar}

####################################################################################################################################################################################
Preencher Consumo Equipamento
    [Arguments]                             ${pause_equipamento}=ONT INTEGRADA_617617_HG8145-V5 HUAWEI 2GHZ E 5GHZ

    Click Element Is Visible                ${btn_consumo_equipamentos}
    Click Element Is Visible                ${btn_editar_equipamento}

    #Equipamento
    Click Element Is Visible                ${btn_equipamento}
    Click Element Is Visible                ${select_equipamento_opm}

    Pause Execution                         Selecione o equipamento "${pause_equipamento}" e então clique em OK para continuar o script.

    # Click Element Is Visible                ${input_pesquisa_equipamento}
    # Input Text Element Is Visible           ${input_pesquisa_equipamento}           ONT G-1425-GA NOKIA 2GHZ/5GHZ
    # Click Element Is Visible                ${select_equipamento_opm}

    #Numero de Serie
    Gerar Nr de Serie
    Input Text Element Is Visible           ${numero_serie_OPM}                     ${nr_serie}
    
    #Comodo
    Click Element Is Visible                ${btn_comodo}
    Click Element Is Visible                ${select_comodo}
    Take Screenshot App                     ${btn_associar}
    Click Element Is Visible                ${btn_associar}
    Click Element Is Visible                ${btn_ok}
    Click Element Is Visible                ${btn_voltar}

####################################################################################################################################################################################
Preencher Consumo Equipamento - Bitstream
    [Arguments]                             ${pause_equipamento}=ONT TIM SAGEM FAST5670 WI-FI 6

    Click Element Is Visible                ${btn_consumo_equipamentos}
    Click Element Is Visible                ${btn_editar_equipamento}

    #Equipamento
    Click Element Is Visible                ${btn_equipamento}
    Click Element Is Visible                xpath=//android.view.View[@text="${pause_equipamento}"]/..

    Pause Execution                         Selecione o primeiro equipamento "${pause_equipamento}" e então clique em OK para continuar o script.

    #Numero de Serie
    Gerar Nr de Serie
    Input Text Element Is Visible           ${numero_serie_OPM}                       ${nr_serie}
    
    #Comodo
    Click Element Is Visible                ${btn_comodo}
    Click Element Is Visible                ${select_comodo}
    Take Screenshot App                     ${btn_associar}
    Click Element Is Visible                ${btn_associar}
    Click Element Is Visible                ${btn_ok}
    Click Element Is Visible                ${btn_voltar}

####################################################################################################################################################################################
Preencher Finalizacao
    [Arguments]                             ${cod_encerramento}=00

    Click Element Is Visible                ${btn_atualizar_status}
    Input Text Element Is Visible           ${input_codigo_encerramento_opm}        ${cod_encerramento}
    Input Text Element Is Visible           ${input_RSR_opm}                        12345
    ${senha_encerramento}=                  Ler Variavel na Planilha                senhaFsl                                Global
    Input Text Element Is Visible           ${input_senha_encerramento_opm}         ${senha_encerramento}
    Input Text Element Is Visible           ${input_obs_encerramento_opm}           Encerramento via OPM
    Click Element Is Visible                ${btn_overview_finaliza}
    Click Element Is Visible                ${dialog_encerrar_sim}

####################################################################################################################################################################################
Preencher Finalizacao Planta Externa
    [Arguments]                             ${cod_encerramento}

    Click Element Is Visible                ${btn_atualizar_status}
    Input Text Element Is Visible           ${input_RSR_opm}                        123
    Input Text Element Is Visible           ${input_codigo_encerramento_opm}        ${cod_encerramento}
    Click Element Is Visible                ${btnProcurarCodigo}
    Click Element Is Visible                ${btnTodosOsProdutos}

    Click Element Is Visible                ${btnCodPlatExt}
    Click Element Is Visible                ${btnCodOutrosSub}

    ${senha_encerramento}=                  Ler Variavel na Planilha                senhaFsl                                Global
    Input Text Element Is Visible           ${input_senha_encerramento_opm}         ${senha_encerramento}
    Input Text Element Is Visible           ${input_obs_encerramento_opm}           Encerramento Reparo Voip via OPM
    Click Element Is Visible                ${btn_overview_finaliza}
    Click Element Is Visible                ${dialog_encerrar_sim}
#===================================================================================================================================================================
Colocar SA concluida VOIP
    [Arguments]                             ${adicionarMaterial}=NAO
    ...                                     ${adicionarAuxilio}=NAO
    ...                                     ${codCaboRiser}=1275                    ${codCaboDrop}=1274                     ${codCdoia}=1277
    ...                                     ${equipamento}=ONT HW - HG8245H
    ...                                     ${codEncerramento}=0058


    Abrir Aplicativo OPM 
    Selecionar SA 
    Preencher Consumo Equipamento           pause_equipamento=${equipamento}
    Preencher Facilidades                   cod_cabo_riser=${codCaboRiser}          cod_cabo_drop=${codCaboDrop}            cod_cdoia=${codCdoia}
    IF    "${adicionarMaterial}" != "NAO"
        Preencher Consumo Materiais         material=Parafuso C/Bucha Plastica S-6
        ...                                 quantidadeMaterial=12
    END
    IF    "${adicionarAuxilio}" != "NAO"
        Preencher Auxiliar                  teveAuxilio=Sim
    END
    Preencher Finalizacao                   cod_encerramento=${codEncerramento}
    Sleep                                   3s
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global    
    [Teardown]                              Finalizar Jornada e Sair
#===================================================================================================================================================================