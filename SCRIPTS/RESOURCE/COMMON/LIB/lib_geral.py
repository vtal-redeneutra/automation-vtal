from robot.api.deco import keyword
from os.path import exists
from robot.running.context import EXECUTION_CONTEXTS
from robot.libraries.BuiltIn import BuiltIn
from win32api import GetSystemMetrics
import os

#Doc Manipulation
index = 0
index_OPM = 0
ROBOT_LISTENER_API_VERSION = 2
ROBOT_LIBRARY_SCOPE = "GLOBAL"

@keyword('Get Function Name')
def get_function_name():
    return EXECUTION_CONTEXTS.current.keywords[-1].name

@keyword('Get Viewport Height')
def get_viewport_height():
    return GetSystemMetrics(1)

@keyword('Get Viewport Width')
def get_viewport_width():
    return GetSystemMetrics(0)

#File Manipulation
@keyword('File Exists')
def file_exist(path):
    file_exists = exists("{}".format(path))
    return file_exists

@keyword('Rename File')
def Rename(File_OldPath, File_newPath):
    os.rename(File_OldPath, File_newPath)

@keyword('Write Doc File Evidencia')
def write_evidencia(string):
    change_margin_API_evidencia()
    document_evidencia.add_paragraph(string)

@keyword('Write Doc File Defect')
def write_defect(string):
    change_margin_API_Defect()
    document_defect.add_paragraph(string)

@keyword('Break page Evidencia')
def breakpage_evidencia():
    document_evidencia.add_page_break()

@keyword('Break page Defect')
def breakpage_defect():
    document_defect.add_page_break()

@keyword('Rename and move File OPM')
def rename_Move_OPM(file_OPM_path):
    global index_OPM
    index_OPM += 1
    os.rename("{}/print.png".format(file_OPM_path), "{}/{}.png".format(file_OPM_path, index_OPM))
    os.replace("{}/{}.png".format(file_OPM_path, index_OPM), "{}/OPM/{}.png".format(file_OPM_path, index_OPM))

@keyword('Write OPM Image in Doc File Evidencia')
def write_OPM_Image_Evidencia(path_results):
    document_evidencia.add_paragraph("\n")
    document_evidencia.add_picture("{}/OPM/{}.png".format(path_results, index_OPM), width=Inches(4), height=Inches(8))

@keyword('Rename and move File CE_MOBILE')
def rename_Move_CE_Mobile(file_OPM_path):
    global index_OPM
    index_OPM += 1
    os.rename("{}/print.png".format(file_OPM_path), "{}/{}.png".format(file_OPM_path, index_OPM))
    os.replace("{}/{}.png".format(file_OPM_path, index_OPM), "{}/CE_MOBILE/{}.png".format(file_OPM_path, index_OPM))

@keyword('Write CE_MOBILE Image in Doc File Evidencia')
def write_CE_Mobile_Image_Evidencia(path_results):
    document_evidencia.add_paragraph("\n")
    document_evidencia.add_picture("{}/CE_MOBILE/{}.png".format(path_results, index_OPM), width=Inches(6), height=Inches(3))

@keyword('Write Image in Doc File Evidencia')
def write_Image_Evidencia(path_results):
    global index
    index += 1
    document_evidencia.add_paragraph("\n")
    document_evidencia.add_picture("{}/browser/screenshot/{}.jpeg".format(path_results, index), width=Inches(7.0), height=Inches(4))

@keyword('Write Image in Doc File Defect')
def write_Image_Defect(path_results):
    global index
    index += 1
    document_defect.add_paragraph("\n")
    document_defect.add_picture("{}/browser/screenshot/{}.jpeg".format(path_results, index), width=Inches(13.3), height=Inches(8.5))

@keyword('Close Doc File Evidencia')
def close_evidencia(path):
    output  = "{}.docx".format(path)
    document_evidencia.save(output)
    convert(output, "{}.pdf".format(path))

@keyword('Close Doc File Defect')
def close_defect(path):
    output  = "{}.docx".format(path)
    document_defect.save(output)
    convert(output, "{}.pdf".format(path))

def change_margin_API_evidencia():
    section = document_evidencia.sections[-1]
    section.left_margin = Cm(2.5)
    section.right_margin = Cm(2.5)
    section.top_margin = Cm(2.5)
    section.bottom_margin = Cm(2.5)
    section.orientation = WD_ORIENT.LANDSCAPE

def change_margin_API_Defect():
    section = document_evidencia.sections[-1]
    section.left_margin = Cm(2.5)
    section.right_margin = Cm(2.5)
    section.top_margin = Cm(2.5)
    section.bottom_margin = Cm(2.5)
    section.orientation = WD_ORIENT.LANDSCAPE

def change_margin_Image_evidencia():
    section = document_evidencia.sections[-1]
    section.page_width = Cm(25.0)
    section.left_margin = Cm(2.5)
    section.right_margin = Cm(2.5)
    section.top_margin = Cm(2.5)
    section.bottom_margin = Cm(2.5)
    section.orientation = WD_ORIENT.LANDSCAPE