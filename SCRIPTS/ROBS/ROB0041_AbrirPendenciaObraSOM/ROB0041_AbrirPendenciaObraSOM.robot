*** Settings ***
Documentation                               Scripts relacionados ao processo de abrir pendência de contrato de obra.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

Resource                                    ${DIR_SOM}/UTILS.robot


*** Keywords ***
Abrir Pendencia Contato de Obra
    [Documentation]                         Realiza abertura de pendência do contrato de obra.
    
    Login SOM
    
    #Pesquisa pelo preview
    Click Web Element Is Visible            ${SOM_rb_Editor}
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    Input Text Web Element Is Visible       ${SOM_Ref_Input}                        *${Associated_Document}* 
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_refresh}


    ${SOM_Quantia_linha}=                   Get Element Count is Visible            (//td[contains(text(),"Vtal")]/..)
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    ${order_type_Des}=                      Get Text Element is Visible             (//td[contains(text(),"T073U01 - Projeto de Rede - Atendimento Solicitado")]/..//td[contains(text(),"Vtal Fibra Obra")])       


    Click Web Element Is Visible            (//td[contains(text(),"T073U01 - Projeto de Rede - Atendimento Solicitado")]/..//input[@value="..."])
    Select Element is Visible               (//form[@name="orderEditorMenu"]//select[@id="completionStatusList"])           Abrir pendência
    
    ${CURRENT_CONTEXT}=                     Get Page Ids


    #Seleciona pendencia 7100
    Click Web Element Is Visible            //label[normalize-space()="Pendência"]/../../../../..//tr[2]//a
    Sleep    2s
    Switch Page    NEW
    Click Web Element Is Visible            //a[text()="6"]
    Sleep    5s
    Click Web Element Is Visible            //td[starts-with(text(),"7100")]/..//input[@value="..."]
    Switch Page                             id=${CURRENT_CONTEXT}[0]

    
    #Seleciona Motivo 
    Click Web Element Is Visible            //label[normalize-space()="Motivo"]/../../../..//img[@alt="Find"]/..
    Switch Page    NEW
    Click Web Element Is Visible            //a[text()="2"]
    Sleep    5s
    Click Web Element Is Visible            //td[starts-with(text(),"Outros")]/..//input[@value="..."]
    Switch Page                             id=${CURRENT_CONTEXT}[0]


    #Preenche Motivo Complementar
    Sleep    5s
    Input Text Web Element Is Visible       //label[normalize-space()="Motivo Complementar"]/../../../../tr[3]//textarea        Comunicar o cliente a necessidade da liberação de acesso junto a Administração do prédio/ Condomínio para a realização de visita técnica no seu endereço de modo a avaliar a possibilidade de implantação da fibra.
    Sleep    2s

    Click Web Element Is Visible            ${SOM_btnUpdate}
    Sleep    5s
    Close Browser                           CURRENT

   
#===================================================================================================================================================================