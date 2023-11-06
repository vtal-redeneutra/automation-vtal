*** Settings ***
Documentation                               Enriquecimento de massa
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

Resource                                    ../../RESOURCE/SOM/PAGE_OBJECTS.robot

*** Variables ***



*** Keywords ***


Enriquecimento De Massa SOM
    [Tags]                                  EnriquecimentoMassaSom
    [Documentation]                         Realizar o enriquecimento da massa no SOM.
    ...                                     \nFaz login no SOM, pesquisa pelo SOM_Order_Id da planilha, e seleciona a opção de Change Task State.

    Login SOM
    Altera Filtro Consulta Order ID


    Click Web Element Is Visible            ${SOM_rb_Editor}
    Right Click Web Element Is Visible      ${SOM_btn_tres_pontos}
    Click Web Element Is Visible            ${SOM_Option_ChangeStatus}
    

#===========================================================================================================================================================================================================
