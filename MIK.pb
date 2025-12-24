;--> НАЧАЛО Кода

; Proga.s = GetFilePart(ProgramFilename()) ; Только одна копия программы
; a = CreateSemaphore_(#Null,0,1,Proga) 
; If a<>0 And GetLastError_()=#ERROR_ALREADY_EXISTS 
;   CloseHandle_(a) 
;   End
; EndIf

Declare FatalError()

CompilerIf #PB_Compiler_Debugger=#False
	OnErrorCall(@FatalError())
	;PokeS(10, "Привет мир") ; Вызовет ошибку #PB_OnError_InvalidMemory
CompilerEndIf

CompilerIf #PB_Compiler_Thread=#False
  CompilerError "Threadsafe needed!" ; Включите поддержку многопоточности в настройках компиляции!
CompilerEndIf

Import "user32.lib"
  OemToCharBuffA(*Buff,*Buff1,SizeBuff)
EndImport

Import ""
  GetNativeSystemInfo(*info)
EndImport

Global Text$
Global ThreadActions
Global ThreadAutoExit
Global NewList ListParam.s()
Global lpOldWndProc
Global ErrorsCount=0
Global Blocks.l

Global Dim Lng.s(187) ; number of translation strings and correspondingly array
;XIncludeFile "Lng.pbi"

Macro DragAcceptFiles(GadgetNumber)
  DragAcceptFiles_(GadgetID(GadgetNumber), 1)
  lpOldWndProc = SetWindowLongPtr_(GadgetID(GadgetNumber), #GWL_WNDPROC, @WndProc())
EndMacro

Macro DragAcceptFree(GadgetNumber)
  SetWindowLongPtr_(GadgetID(GadgetNumber), #GWL_WNDPROC, lpOldWndProc)
EndMacro

Macro IgnoreUAC()
  If OSVersion() >= #PB_OS_Windows_Vista
    user32_dll = OpenLibrary(#PB_Any, "user32.dll")
    CallFunction(user32_dll, "ChangeWindowMessageFilter", #WM_DROPFILES, #MSGFLT_ADD)
    CallFunction(user32_dll, "ChangeWindowMessageFilter", #WM_COPYDATA, #MSGFLT_ADD)
    CallFunction(user32_dll, "ChangeWindowMessageFilter", $0049, #MSGFLT_ADD)
    CloseLibrary(user32_dll)
  EndIf
EndMacro

DeclareModule Directory
  Global Desktop.s
EndDeclareModule

Module Directory
  Prototype Prot_SHGetKnownFolderPath(rfid,dwFlags,hToken,*pppszPath) 
  Define shell32dll=OpenLibrary(#PB_Any, "shell32.dll")
  Global SHGetKnownFolderPath_.Prot_SHGetKnownFolderPath=GetFunction(shell32dll, "SHGetKnownFolderPath")
  Procedure.s GetPath(*FOLDERID)
    Protected Path
    Protected ret.s        
    If SHGetKnownFolderPath_(*FOLDERID,0,0,@Path)=#S_OK And Path
      ret=PeekS(Path,-1,#PB_Unicode)+"\"
      CoTaskMemFree_(path)
    EndIf
    ProcedureReturn ret
  EndProcedure
  Macro _Create(xx,cc,d1,d2,d3,d4,d5)
    DataSection
      cc:
      Data.l $d1
      Data.w $d2,$d3
      Data.b ($d4>>8)&$ff,($d4)&$ff
      Data.b ($d5>>(5*8))&$FF,($d5>>(4*8))&$FF,($d5>>(3*8))&$FF,($d5>>(2*8))&$FF,($d5>>(1*8))&$FF,$d5&$FF
    EndDataSection
    xx=GetPath(?cc)
  EndMacro
  _Create(Desktop,FOLDERID_Desktop,B4BFCC3A,DB2C,424C,B029,7FE99A87C641)
  CloseLibrary(shell32dll)
EndModule

Declare.s GetProgramVersion()
Declare CheckAppPath(Path$)
Declare GetUILanguage()
Declare SetLanguage(UserIntLang)
Declare EditorCreateResize()
Declare Highlight()
Declare WindowMain()
Declare IsWin64()
Declare Out(text.s="")
Declare Recent(NewFilename.s)
Declare RecycleFile(file$)
;Declare MenuRight(WindowID, Index)
Declare CreateRecentMenu()
Declare ico2bmp(nIco)
Declare SystemMenuAddItems()
Declare MakeMenuBar()
Declare MenuGadgetState()
Declare MakeToolBar()
Declare SetWinOpacity(hwnd.l, Opacity.l)
Declare HookProc(nCode, wParam, lParam)
Declare MessageRequesterEx(title$, body$, flags=0)
Declare.s ReadProgramStringOem(iPid)
Declare.s Cn(Str$)
Declare EditorEndLine(Gadget)
Declare Message(string$, empty=0)
Declare.s GetExePath()
Declare.s OemToChar(String.s)
Declare.s OemToCharEx(str$)
Declare RunConsole(Filename$, Parameter$, WorkingDirectory$, Flags=0)
Declare.s SizeIt(Value.q)
Declare.q GetFolderSize(Path.s, State.b = 1)
Declare IsEmptyFolder(Path$)
Declare CreateShortcut_all(Path.s, LINK.s, Argument.s, DESCRIPTION.s, WorkingDirectory.s, ShowCommand.l, IconFile.s, IconIndexInFile.l) 
Declare.s ExitStr(number=-500)
Declare Exit()
Declare ReadLog(Parameter$)
Declare.s Decoder(String.s)
Declare CheckCharacters(Parameter$)
Declare AutoExit(*Value)
Declare Actions(*Value)
Declare RunActions()
Declare GadgetFromGadgetID(GadgetID)
Declare WinCallback(hWnd,Message,wParam,lParam)
Declare WndProc(hWnd,Message,wParam,lParam)
Declare GetUsbTool()
Declare ChoiceFramework()
Declare WindowSettings()
Declare WindowAbout()
Declare.s ReadStr(ID, Key$ , StrValue$="", put=1, startPhrase$="", endPhrase$="!@#")
;Declare.s ReadStr(ID, Key$ , StrValue$="")
Declare FirmwareUnpack(Parameter$)
Declare.s NewFileName(WorkingDirectory$, DirectoryName$)
Declare FirmwarePack(Parameter$)
Declare PayloadDumper(Parameter$)
Declare CheckJava()
Declare PartUnpack(Parameter$)
Declare PartPack(Parameter$)
Declare ZipUnpack(Parameter$)
Declare ZipPack(Parameter$)
Declare SevenZipUnpack(Parameter$)
Declare AttributesList(Parameter$)
Declare Cleaning(Parameter$, CreateFolder=1)
Declare LogoUnpack(Parameter$)
Declare LogoPack(Parameter$)
Declare ImgRKUnpack(Parameter$)
Declare ImgRKPack(Parameter$)
Declare ImgAllUnpack(Parameter$)
Declare ImgAllPack(Parameter$)
Declare ImgPacUnpack(Parameter$)
Declare DtbSingleUnpack(Parameter$)
Declare DtbMultiUnpack(Parameter$,Sign$)
Declare DtbPack(Parameter$)
Declare BootRecoveryUnpack(Parameter$)
Declare BootRecoveryPack(Parameter$)
Declare BrUnpack(Parameter$)
Declare BrPack(Parameter$)
Declare DatUnpack(Parameter$)
Declare DatPack(Parameter$)
Declare tarUnpack(Parameter$)
Declare tarPack(Parameter$)
Declare ustarUnpack(Parameter$)
Declare ustarPack(Parameter$)
Declare lz4Unpack(Parameter$)
Declare lz4Pack(Parameter$)
Declare ext4Unpack(Parameter$)
Declare gzUnpack(Parameter$)
Declare MainUnpack(Parameter$)
Declare MainPack(Parameter$)
Declare ErofsPack(Parameter$)
Declare SuperUnpack(Parameter$)
Declare SuperPack(Parameter$)
Declare ApkUnpack(Parameter$)
Declare ApkPack(Parameter$)
Declare.s OSVersionEx()

Declare ListFill(FullPath.s)

Declare.q HexVal(a$)
Declare.l HexFind(*File, SearchHex$, Offset$="0")
Declare.s CheckSignature(ImageFile$)

;--- Назначаем константы
Enumeration Window; Окна программы
  #WIN_MAIN
  #WIN_SETTING
EndEnumeration

Enumeration 100 ;Gadget; Окна программы Winwow
  #Editor
  #Progress
  #Panel
  #CheckBox_Main_Top
  #Text_Transparency
  #TrackBar_Transparency
  #Text_Transparency_Level
  #Button_Color_Window
  #Button_Font_Window
  #Button_Color_Font
  #TrackBar_Font_Size
  #Text_Font_Size
  #Text_Font_Level
  #Option_Horizontally
  #Option_Vertical
  #Option_None
  #CheckBox_Auto_Exit
  #ComboBox_AutoExit_Time
  #CheckBox_Unpack_Super
  #CheckBox_Unpack_System
  #CheckBox_Unpack_Vendor
  #CheckBox_Unpack_Product
  #CheckBox_Unpack_Odm
  #CheckBox_Open_Folder
  #Option_Version_Six
  #Option_Version_Seven
  #CheckBox_Pack_Super
  #CheckBox_Pack_System
  #CheckBox_Pack_Vendor
  #CheckBox_Pack_Product
  #CheckBox_Pack_Odm
  #CheckBox_Open_UsbTool
  #CheckBox_Sound
  #CheckBox_Not_Delete
  #Button_Open_UsbTool
  #CheckBox_Finish_Sound
  #Text_Volume
  #TrackBar_Volume_level
  #Text_Volume_level
  #CheckBox_Play_Sound
  #CheckBox_Index
  #Text_LCID
  #ComboBox_Language
  #CheckBox_Transfer
  #String_Decompress
  #String_Compress
  #ComboBox_Compress_Level
  #Text_Compress_Level
  #CheckBox_Signature
  #CheckBox_Expand_Size
  #Text_Expand_Size
  #String_Expand_Size
  #CheckBox_Resize
  #CheckBox_No_Backup
  #CheckBox_No_Org
  #CheckBox_Framework
  #Button_Framework
  #CheckBox_SignatureApk
  #CheckBox_Alignment
  #CheckBox_Get_Hash
  #CheckBox_Seven_Pack
  #CheckBox_Seven_UnPack
  #CheckBox_Subfolder
  #CheckBox_Delete_Archive
  #ComboBox_Seven_Level
  #String_Size_Part
  #CheckBox_Delete_Image
  ;#YM
  #QN
EndEnumeration

Enumeration Other
  #Sound
  #Font
EndEnumeration

Enumeration MenuStatusBar
  #ImageMenu
  #Unpack
  #Pack
  #Recent
  #Container
  #ToolBar
  #ToolBarRecentFiles
  #ClearList
  #Settings
  #Exit
  #Undo
  #LogClear
  #Copy
  #Paste
  #SetSel
  #SaveAs
  #Highlight
  #SearchGoogle
  #SearchPda
  #GoogleTranslate
  #OnTop
  #ToolbarShow
  #VerticalPanel
  #OpenSettings
  #CreateShortcut
  #Help
  #Pda
  #News
  #Discussion
  #AuthorChannel
  #About
  #CmdLine
  #StatusBar
  #RecentMenu
  #EditMenu
EndEnumeration

; --> Structure for formatting EditorGadget 
Structure myCHARFORMAT2 
  cbSize.l 
  dwMask.l 
  dwEffects.l 
  yHeight.l 
  yOffset.l 
  crTextColor.l 
  bCharSet.b 
  bPitchAndFamily.b 
  szFaceName.b[#LF_FACESIZE] 
  nullPad.w 
  wWeight.w 
  sSpacing.w 
  crBackColor.l 
  LCID.l 
  dwReserved.l 
  sStyle.w 
  wKerning.w 
  bUnderlineType.b 
  bAnimation.b 
  bRevAuthor.b 
  bReserved1.b 
EndStructure 

Structure SetName ; Создаём шаблон структуры
  Desktop_Width.l
  Desktop_Height.l
  Main_X.l
  Main_Y.l
  Main_Width.l
  Main_Height.l
  Main_Maximize.l
  Main_Top.l
  Open_Settings.l
  Setting_X.l
  Setting_Y.l
  Setting_Width.l
  Setting_Height.l
  Window_Transparency.l
  Editor_BackColor.l
  Editor_FontName.s
  Editor_FontSize.l
  Editor_FontColor.l
  Editor_FontStyle.l
  Unpack_Super.l
  Unpack_System.l
  Unpack_Vendor.l
  Unpack_Product.l
  Unpack_Odm.l
  Open_Folder.l
  Ver.s
  Pack_Super.l
  Pack_System.l
  Pack_Vendor.l
  Pack_Product.l
  Pack_Odm.l
  Open_UsbTool.l
  Path_UsbTool.s
  Finish_Sound.l
  Volume_Level.l
  Index_Add.l
  Locale_ID.l
  Not_Delete.l
  Transfer.l
  Decompress.s
  Compress.s
  Compress_Level.s
  Signature.l
  Free_Space.l
  Expand_Size.l
  Resize.l
  No_Backup.l
  No_Org.l
  Toolbar_Set.l
  Setting_Stage.l
  Framework.l
  SignatureApk.l
  Alignment.l
  Get_Hash.l
  Seven_Pack.l
  Seven_UnPack.l
  Subfolder.l
  Delete_Archive.l
  Seven_Level.s
  Size_Part.s
  Delete_Image.l
  AutoExit_Time.l
  Auto_Exit.l
  Pack_Folder.s
  Unpack_Folder.s
EndStructure

#EN_LINK = $70B
#ENM_LINK = $4000000

Global st.SetName
Global bin$ = GetExePath()+"bin\"

;--> Чтение настроек из файла или установка значений "По умолчанию" ------
OpenPreferences(bin$+"config\settings.ini") 
PreferenceGroup("Settings")
st\Desktop_Width = ReadPreferenceLong("Desktop_Width",#PB_Ignore)
st\Desktop_Height = ReadPreferenceLong("Desktop_Height",#PB_Ignore)
st\Main_X = ReadPreferenceLong("Main_X",0)
st\Main_Y = ReadPreferenceLong("Main_Y",0)
st\Main_Width = ReadPreferenceLong("Main_Width",473)
st\Main_Height = ReadPreferenceLong("Main_Height",308)
st\Main_Maximize = ReadPreferenceLong("Main_Maximize",0)
st\Main_Top = ReadPreferenceLong("Main_Top",0)
st\Open_Settings = ReadPreferenceLong("Open_Settings",#False)
st\Setting_X = ReadPreferenceLong("Setting_X",#PB_Ignore)
st\Setting_Y = ReadPreferenceLong("Setting_Y",#PB_Ignore)
st\Setting_Width = ReadPreferenceLong("Setting_Width",395);500
st\Setting_Height = ReadPreferenceLong("Setting_Height",383);300
st\Setting_Stage=ReadPreferenceLong("Setting_Stage",0)
st\Window_Transparency = ReadPreferenceLong("Window_Transparency",245)
st\Editor_BackColor = ReadPreferenceLong("Editor_BackColor",3618615)
st\Editor_FontName = ReadPreferenceString("Editor_FontName", "")
st\Editor_FontSize = ReadPreferenceLong("Editor_FontSize",14)
st\Editor_FontColor = ReadPreferenceLong("Editor_FontColor",11842740)
st\Editor_FontStyle = ReadPreferenceLong("Editor_FontStyle",0)
st\Unpack_Super = ReadPreferenceLong("Unpack_Super",#PB_Checkbox_Checked)
st\Unpack_System = ReadPreferenceLong("Unpack_System",#PB_Checkbox_Checked)
st\Unpack_Vendor = ReadPreferenceLong("Unpack_Vendor",#PB_Checkbox_Checked)
st\Unpack_Product = ReadPreferenceLong("Unpack_Product",#PB_Checkbox_Checked)
st\Unpack_Odm = ReadPreferenceLong("Unpack_Odm",#PB_Checkbox_Checked)
st\Open_Folder = ReadPreferenceLong("Open_Folder",#PB_Checkbox_Checked)
st\Ver = ReadPreferenceString("Ver", "106")
st\Pack_Super = ReadPreferenceLong("Pack_Super",#PB_Checkbox_Checked)
st\Pack_System = ReadPreferenceLong("Pack_System",#PB_Checkbox_Checked)
st\Pack_Vendor = ReadPreferenceLong("Pack_Vendor",#PB_Checkbox_Checked)
st\Pack_Product = ReadPreferenceLong("Pack_Product",#PB_Checkbox_Checked)
st\Pack_Odm = ReadPreferenceLong("Pack_Odm",#PB_Checkbox_Checked)
st\Index_Add = ReadPreferenceLong("Index_Add",#PB_Checkbox_Unchecked)
st\Open_UsbTool = ReadPreferenceLong("Open_UsbTool",#PB_Checkbox_Unchecked)
st\Framework = ReadPreferenceLong("Framework",#PB_Checkbox_Unchecked)
st\SignatureApk = ReadPreferenceLong("SignatureApk",#PB_Checkbox_Checked)
st\Alignment = ReadPreferenceLong("Alignment",#PB_Checkbox_Checked)
st\Locale_ID = ReadPreferenceLong("Locale_ID", 0)
st\Not_Delete = ReadPreferenceLong("Not_Delete",#PB_Checkbox_Unchecked)
st\Transfer = ReadPreferenceLong("Transfer",#PB_Checkbox_Unchecked)
st\Decompress = ReadPreferenceString("Decompress","--verbose")
st\Compress = ReadPreferenceString("Compress","--force --quality 7 --verbose")
st\Compress_Level = ReadPreferenceString("Compress_Level","0")
st\Signature = ReadPreferenceLong("Signature",#PB_Checkbox_Checked)
st\Toolbar_Set = ReadPreferenceLong("Toolbar_Set",1)
st\Free_Space = ReadPreferenceLong("Free_Space",100)
st\Expand_Size = ReadPreferenceLong("Expand_Size",#PB_Checkbox_Checked)
st\Resize = ReadPreferenceLong("Resize",#PB_Checkbox_Checked)
st\No_Backup = ReadPreferenceLong("No_Backup",#PB_Checkbox_Checked)
st\No_Org = ReadPreferenceLong("No_Org",#PB_Checkbox_Checked)
st\Get_Hash = ReadPreferenceLong("Get_Hash",#PB_Checkbox_Unchecked)
st\Seven_Pack = ReadPreferenceLong("Seven_Pack",#PB_Checkbox_Unchecked)
st\Delete_Archive = ReadPreferenceLong("Delete_Archive",#PB_Checkbox_Unchecked)
st\Seven_UnPack = ReadPreferenceLong("Seven_UnPack",#PB_Checkbox_Unchecked)
st\Subfolder = ReadPreferenceLong("Subfolder",#PB_Checkbox_Checked)
st\Seven_Level = ReadPreferenceString("Seven_Level","0")
st\Size_Part = ReadPreferenceString("Size_Part","")
st\Delete_Image = ReadPreferenceLong("Delete_Image",#PB_Checkbox_Unchecked)
st\Auto_Exit = ReadPreferenceLong("Auto_Exit",#PB_Checkbox_Checked)
st\AutoExit_Time = ReadPreferenceLong("AutoExit_Time",10)
st\Path_UsbTool = ReadPreferenceString("Path_UsbTool", "")
st\Finish_Sound = ReadPreferenceLong("Finish_Sound",#PB_Checkbox_Checked)
st\Volume_Level = ReadPreferenceLong("Volume_Level",20)
st\Pack_Folder = ReadPreferenceString("Pack_Folder", "")
st\Unpack_Folder = ReadPreferenceString("Unpack_Folder", "")
ClosePreferences()

;  PathLang$ = bin$+"language\1049.lng"
;  
;  If CreateFile(0, PathLang$) ; If the file descriptor was opened, then ...
;    ;Debug "Hello"
;    i=0
;    While  #CountStrLang         ; Loop until end of file is reached.
;      i+1
;      If i > #CountStrLang ; the Lng() array is already set, but if there are more rows than you need, then we do not allow unnecessary ones
;        Break
;      EndIf
;      tmp$ =  Lng(i)
;      ;Debug tmp$
;      ;tmp$ = ReplaceString(tmp$ , #CR$ , "") ; correction if in windows
;      WriteStringN(0 , tmp$)
;    Wend
;    CloseFile(0)
;  EndIf

 

;--> Присваиваем картинкам индекс
CatchImage(0, ?img0)
CatchImage(1, ?img1)
CatchImage(2, ?img2)
CatchImage(3, ?img3)
CatchImage(4, ?img4)
CatchImage(5, ?img5)
CatchImage(6, ?img6)
CatchImage(7, ?img7)
CatchImage(8, ?img8)
CatchImage(9, ?img9)
CatchImage(10, ?img10)
CatchImage(11, ?img11)
CatchImage(12, ?img12)
CatchImage(14, ?img14)
CatchImage(15, ?img15)
CatchImage(16, ?img16)
CatchImage(17, ?img17)
CatchImage(18, ?img18)
CatchImage(19, ?img19)
CatchImage(20, ?img20)
CatchImage(21, ?img21)
CatchImage(22, ?img22)
CatchImage(23, ?img23)
CatchImage(24, ?img24)


Global InSound =InitSound() 
If InSound; Включает подержку звука
	LoadSound(#Sound, bin$+"Complete.wav") ; Загружаем звуковой файл в память
EndIf

  
Global ProgramName$ = "Multi Image Kitchen v"+GetProgramVersion()+"β";+"  Build:"+#PB_Editor_BuildCount ;Left(#PB_Editor_FileVersionNumeric, 3)
;If Not IsWin64() : ProgramName$+" (support Windows x86)" : EndIf

CreateDirectory(bin$+"config")
Global Recentfilename.s=bin$+"config\recent.ini" ;This holds the filename for the recentlist
Global NewList Files.s();Linked List to hold RecentFiles
#FP=99;Filepointer
#MenuRecentFiles=100;Start where Entrys are beginning in Menu

#PBM_SETSTATE = $410
#PBST_NORMAL = $0001;Green
#PBST_ERROR = $0002 ;Red
#PBST_PAUSED = $0003;Yellow

WindowMain() ; Создаём основное окно

If st\Open_Settings = #True
	WindowSettings() ;Показ меню настроек
EndIf

; >>>>
  ;WindowAbout()
; >>>>

IgnoreUAC() ; Для перетаскивания в окно программы

;Переменное окружение
SetEnvironmentVariable("PATH", bin$+";"+bin$+"erofs;"+bin$+"resize2fs;"+bin$+"makesuper;"+GetEnvironmentVariable("PATH"))
;Debug GetEnvironmentVariable("PATH")

SetWindowCallback(@WinCallback())

;-- Считываем все параметры запуска из командной строки в список
If CountProgramParameters() 
  For i = 0 To CountProgramParameters() - 1
    If ProgramParameter(i) = "-total"
      If Not GetAsyncKeyState_(#VK_CONTROL)
        Break
      EndIf
    Else 
      ListFill(ProgramParameter(i))
    EndIf
  Next  
EndIf

If FileSize(bin$+"framework")<>-2 : CreateDirectory(bin$+"framework") : EndIf

ProgramPath$ = ProgramFilename()
CheckAppPath(ProgramPath$)
If GetFileAttributes(ProgramPath$) & #PB_FileSystem_ReadOnly
  ;Debug "Файл только для чтения!"
  Message("Readonly file:: "+ Str(SetFileAttributes(ProgramPath$, #PB_FileSystem_Normal)))
  ;Debug SetFileAttributes(ProgramPath$, #PB_FileSystem_Normal)
  SetGadgetState(#Progress , 100)
  SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_ERROR, 0)
  CreateThread(@AutoExit(), 0)
Else
  ThreadActions = CreateThread(@Actions(), 0)
EndIf

;-- Запускаем поток Action
;ThreadActions = CreateThread(@Actions(), 0)

;--- ЦИКЛ ОПРОСА изменения состояния всех элементов окна программы
While #True
	Event = WaitWindowEvent()
	If EventWindow() < 5000	
		Select Event
			Case #PB_Event_Menu ;-- Действия в menubar
				MenuID=EventMenu() 
				If MenuID>=#MenuRecentFiles And MenuID<#MenuRecentFiles+10
					SelectElement(Files(), MenuID-#MenuRecentFiles)
					FullPath$ = Files()
					If FileSize(FullPath$)=-2 
						Select MessageRequesterEx("MIK", FullPath$+Chr(10)+Chr(10)+Lng(173)+" [ "+Lng(177)+" ]"+Chr(10)+Lng(174)+" [ "+Lng(178)+" ]"+Chr(10)+Lng(175)+" [ "+Lng(179)+" ]", #PB_MessageRequester_YesNoCancel|#MB_ICONQUESTION) ;Собрать в файл? Да Открыть папку в проводнике Нет Закрыть данное окно Отмена
							Case 6
								ListFill(FullPath$)
								RunActions()
							Case 7
								ShellExecute_(0,@OpInfo,@FullPath$,0,0,#SW_SHOW)
						EndSelect
					ElseIf FileSize(FullPath$)>0
						If MessageRequesterEx("MIK", FullPath$+Chr(10)+Chr(10)+Lng(176), #PB_MessageRequester_YesNoCancel|#MB_ICONQUESTION) = 6 ;Хотите распаковать файл?
							ListFill(FullPath$)
							RunActions()
						EndIf
					Else 
						If GetExtensionPart(FullPath$) <> ""
							MessageRequesterEx("MIK", Lng(110)+" "+Chr(34)+FullPath$+Chr(34)+" ("+Lng(112)+")", #PB_MessageRequester_Info) ;Не найден файл: ... возможно что он был удален или перемещен
						Else
							MessageRequesterEx("MIK", Lng(111)+" "+Chr(34)+FullPath$+Chr(34)+" ("+Lng(113)+")", #PB_MessageRequester_Info) ;Не найдена папка: ... возможно что она была удалена или перемещена
						EndIf
					EndIf
				Else
					Select MenuID
						Case #Unpack
							Filename$ = OpenFileRequester(Lng(1), st\Unpack_Folder, Lng(2)+"(*.img,*.partition,*.fex,*.zip,*.dat,*.br,*.apk)|*.img;*.partition;*.fex;*.zip;*.dat;*.br;*.apk|All files (*.*)|*.*", 0, #PB_Requester_MultiSelection) ;"Пожалуйста выберите файл(ы) образа прошивки или раздела"
							If Filename$
								st\Unpack_Folder = GetPathPart(Filename$)
								While Filename$
									ListFill(Filename$)
									Filename$ = NextSelectedFileName()
								Wend
								RunActions()
							EndIf
						Case #Pack
							Path$ = PathRequester(Lng(3), st\Pack_Folder) ; Пожалуйста выберите папку распакованного образа или раздела
							If Path$ And FileSize(Path$)=-2
								st\Pack_Folder = Path$
								ListFill(Path$)
								RunActions()
							EndIf
						Case #ToolBarRecentFiles
							If CreatePopupImageMenu(#RecentMenu)
								CreateRecentMenu()
								DisplayPopupMenu(#RecentMenu,WindowID(#WIN_MAIN))
							EndIf
						Case #ClearList
							DeleteFile(Recentfilename)
							ClearList(Files())
							Recent("")
						Case #Settings
							WindowSettings() ; Открыть окно настроек
						Case #CmdLine
							RunProgram("cmd")
						Case #Exit
							If Exit()=6
								Break
							EndIf
						Case #OnTop
							If st\Main_Top=#True : st\Main_Top=#False : Else : st\Main_Top=#True : EndIf
							MenuGadgetState()
							StickyWindow(#WIN_MAIN, st\Main_Top); Поверх всех окон
						Case #ToolbarShow
							If st\Toolbar_Set=#False : st\Toolbar_Set=#True : Else : st\Toolbar_Set=#False : EndIf
							MenuGadgetState()
							MakeToolBar()
							EditorCreateResize()
						Case #VerticalPanel
							If st\Toolbar_Set=#False Or st\Toolbar_Set=#True
								st\Toolbar_Set=2
							ElseIf st\Toolbar_Set=2
								st\Toolbar_Set=#True
							EndIf
							MenuGadgetState()
							MakeToolBar()
							EditorCreateResize()
						Case #OpenSettings
							If st\Open_Settings=#False : WindowSettings() : st\Open_Settings=#True : Else : st\Open_Settings=#False : EndIf
							MenuGadgetState()
						Case #CreateShortcut
							CreateShortcut_all(ProgramFilename(),Directory::Desktop+GetFilePart(ProgramFilename(), #PB_FileSystem_NoExtension)+".lnk","","Multi Image Kitchen","",#SW_SHOWNORMAL,"",0)
						Case #CmdLine
							RunProgram("cmd")
						Case #Help 
							OpenHelp(bin$+"Help.chm", "")
						Case #AuthorChannel
							RunProgram("https://www.youtube.com/channel/UCW4P2Eb49-15phyn_T0i0Fg")
						Case #About
							WindowAbout()
						Case #Undo
							SetGadgetText(#Editor,Text$)
						Case #LogClear
							If IsThread(ThreadAutoExit)
								KillThread(ThreadAutoExit)
							EndIf
							SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_NORMAL, 0)
							SetGadgetState(#Progress , 0)
							Text$=""
							SetGadgetText(#Editor,Text$)
						Case #Copy
							SendMessage_(GadgetID(#Editor),#WM_COPY,#Null,#Null)
							SendMessage_(GadgetID(#Editor), #EM_SETSEL, -1, 0)
						Case #Paste
							If GetClipboardText() <> ""
								SetGadgetText(#Editor,Text$+Chr(10)+" --->> Get Clipboard Text <<---"+Chr(10)+GetClipboardText()+Chr(10)+" --->> End Clipboard Text <<---"+Chr(10)+Chr(10))
								EditorEndLine(#Editor)
							EndIf
						Case #SetSel
							SendMessage_(GadgetID(#Editor),#EM_SETSEL,0,-1)
						Case #Highlight
							Highlight()
						Case #SearchGoogle
							SendMessage_(GadgetID(#Editor), #EM_GETSELTEXT, 0, @text$) ; get selected text
							RunProgram("https://www.google.com/search?q="+URLEncoder(text$, #PB_UTF8))
						Case #SearchPda
							SendMessage_(GadgetID(#Editor), #EM_GETSELTEXT, 0, @text$) ; get selected text
							If text$ =""
								RunProgram("https://4pda.to/forum/index.php?act=search")
							Else
								RunProgram("https://4pda.to/forum/index.php?act=search&query="+URLEncoder(text$, #PB_Ascii)+"&username=&forums%5B%5D=all&subforums=1&source=all&sort=rel&result=posts")
							EndIf
						Case #GoogleTranslate
							SendMessage_(GadgetID(#Editor), #EM_GETSELTEXT, 0, @text$) ; get selected text
							RunProgram("https://translate.google.com/?sl=auto&tl=auto&text="+URLEncoder(text$, #PB_UTF8)+"&op=translate")
						Case #SaveAs
							File$ = SaveFileRequester(Lng(98), "LogFile.txt", "(*.txt)|*.txt", 0) ;Пожалуйста выберите путь сохранения:
							If File$
								If  (FileSize(File$) > 0 And MessageRequesterEx( "","Файл: "+File$+" существует, перезаписать?", #MB_OKCANCEL|#MB_ICONQUESTION) = 1) Or FileSize(File$) = -1
									If CreateFile(0, File$)
										WriteStringN(0, "MIK version: "+GetProgramVersion()+" build: "+#PB_Editor_BuildCount)
										WriteStringN(0, "Path: "+ProgramFilename())
										WriteStringN(0, "")
										WriteStringN(0, "CPU Name: "+CPUName()+" ("+CountCPUs(#PB_System_CPUs )+" core)")
										WriteStringN(0, "Full Memory: "+SizeIt(MemoryStatus(#PB_System_TotalPhysical))+"     Free Memory: "+SizeIt(MemoryStatus(#PB_System_FreePhysical)))
										WriteStringN(0, "OS Version: "+OSVersionEx())
										WriteStringN(0, "Computer Name: "+ComputerName())
										WriteStringN(0, "User Name: "+UserName())
										WriteStringN(0, "")
										WriteString(0, Text$)
										CloseFile(0)
									EndIf
								EndIf
							EndIf 
						Case #Pda
							;RunProgram("https://4pda.to/forum/index.php?showtopic=1017768")
						Case #News
							RunProgram("https://t.me/IMG_TOOLS_NEWS")
						Case #Discussion
							RunProgram("https://t.me/IMG_Tools")
					EndSelect
				EndIf
			Case #PB_Event_Gadget ;-- Действия на гаджетах
				Select EventGadget()
					Case #CheckBox_Main_Top
						st\Main_Top = GetGadgetState(#CheckBox_Main_Top)
						MenuGadgetState()
						StickyWindow(#WIN_MAIN, st\Main_Top); Поверх всех окон
					Case #TrackBar_Transparency
						st\Window_Transparency = GetGadgetState(#TrackBar_Transparency)
						SetGadgetText(#Text_Transparency_Level, Str(st\Window_Transparency))
						SetWinOpacity(WindowID(#WIN_MAIN), st\Window_Transparency)
					Case #Button_Font_Window
						If FontRequester(st\Editor_FontName, st\Editor_FontSize, 0, st\Editor_FontColor, st\Editor_FontStyle);
							st\Editor_FontName = SelectedFontName()
							st\Editor_FontSize = SelectedFontSize()
							st\Editor_FontStyle = SelectedFontStyle()
							SetGadgetFont(#Editor, LoadFont(#Font, st\Editor_FontName, st\Editor_FontSize, st\Editor_FontStyle))
							If IsFont(#Font) : FreeFont(#Font) : EndIf
						EndIf
					Case #Button_Color_Window
						Color_Window = ColorRequester()
						If Color_Window > -1
							st\Editor_BackColor = Color_Window
							SetGadgetColor(#Editor , #PB_Gadget_BackColor , st\Editor_BackColor)
						EndIf
					Case #Button_Color_Font
						Color_Font = ColorRequester()
						If Color_Font > -1
							st\Editor_FontColor = Color_Font
							SetGadgetColor(#Editor, #PB_Gadget_FrontColor,  st\Editor_FontColor)
						EndIf
					Case #TrackBar_Font_Size
						;Debug "ggg"
						st\Editor_FontSize = GetGadgetState(#TrackBar_Font_Size)
						SetGadgetText(#Text_Font_Level, Str(st\Editor_FontSize))
						SetGadgetFont(#Editor, LoadFont(#Font, st\Editor_FontName, st\Editor_FontSize, st\Editor_FontStyle))
						If IsFont(#Font) : FreeFont(#Font) : EndIf
					Case #Option_Horizontally
						st\Toolbar_Set = #True
						MenuGadgetState()
						MakeToolBar()
						EditorCreateResize()
					Case #Option_Vertical
						st\Toolbar_Set = 2
						MenuGadgetState()
						MakeToolBar()
						EditorCreateResize()
					Case #Option_None
						st\Toolbar_Set = #False
						MenuGadgetState()
						MakeToolBar()
						EditorCreateResize()
					Case #CheckBox_Auto_Exit
						st\Auto_Exit = GetGadgetState(#CheckBox_Auto_Exit)
						If st\Auto_Exit = #PB_Checkbox_Unchecked
							DisableGadget(#ComboBox_AutoExit_Time, #True)
						Else
							DisableGadget(#ComboBox_AutoExit_Time, #False)
						EndIf
					Case #ComboBox_AutoExit_Time
						st\AutoExit_Time = Val(GetGadgetText(#ComboBox_AutoExit_Time))
					Case #CheckBox_Unpack_Super
						st\Unpack_Super = GetGadgetState(#CheckBox_Unpack_Super)
					Case #CheckBox_Unpack_System
						st\Unpack_System = GetGadgetState(#CheckBox_Unpack_System)
					Case #CheckBox_Unpack_Vendor
						st\Unpack_Vendor = GetGadgetState(#CheckBox_Unpack_Vendor)
					Case #CheckBox_Unpack_Product
						st\Unpack_Product = GetGadgetState(#CheckBox_Unpack_Product)
					Case #CheckBox_Unpack_Odm
						st\Unpack_Odm = GetGadgetState(#CheckBox_Unpack_Odm)
					Case #CheckBox_Open_Folder
						st\Open_Folder = GetGadgetState(#CheckBox_Open_Folder)
					Case #Option_Version_Six
						st\Ver = "106"
					Case #Option_Version_Seven
						st\Ver = "107"
					Case #CheckBox_Pack_Super
						st\Pack_Super = GetGadgetState(#CheckBox_Pack_Super)
					Case #CheckBox_Pack_System
						st\Pack_System = GetGadgetState(#CheckBox_Pack_System)
					Case #CheckBox_Pack_Vendor
						st\Pack_Vendor = GetGadgetState(#CheckBox_Pack_Vendor)
					Case #CheckBox_Pack_Product
						st\Pack_Product = GetGadgetState(#CheckBox_Pack_Product)
					Case #CheckBox_Pack_Odm
						st\Pack_Odm = GetGadgetState(#CheckBox_Pack_Odm)
					Case #CheckBox_Open_UsbTool
						st\Open_UsbTool = GetGadgetState(#CheckBox_Open_UsbTool)
						If st\Open_UsbTool = #PB_Checkbox_Checked And FileSize(st\Path_UsbTool)=-1
							GetUsbTool()
							If FileSize(st\Path_UsbTool)=-1
								SetGadgetState(#CheckBox_Open_UsbTool, #PB_Checkbox_Unchecked)
								st\Open_UsbTool = #PB_Checkbox_Unchecked
							EndIf
						EndIf
					Case #Button_Open_UsbTool
						GetUsbTool()
					Case #CheckBox_Get_Hash
						st\Get_Hash = GetGadgetState(#CheckBox_Get_Hash)
					Case #CheckBox_Seven_Pack
						st\Seven_Pack = GetGadgetState(#CheckBox_Seven_Pack)
						If st\Seven_Pack = #PB_Checkbox_Unchecked
							DisableGadget(#ComboBox_Seven_Level, #True)
							DisableGadget(#String_Size_Part, #True)
							DisableGadget(#CheckBox_Delete_Image, #True)
						Else
							DisableGadget(#ComboBox_Seven_Level, #False)
							DisableGadget(#String_Size_Part, #False)
							DisableGadget(#CheckBox_Delete_Image, #False)
						EndIf
					Case #CheckBox_Seven_UnPack
						st\Seven_UnPack = GetGadgetState(#CheckBox_Seven_UnPack)
					Case #CheckBox_Subfolder
						st\Subfolder = GetGadgetState(#CheckBox_Subfolder)
						If st\Subfolder = #PB_Checkbox_Unchecked
							DisableGadget(#CheckBox_Seven_UnPack, #True)
						Else
							DisableGadget(#CheckBox_Seven_UnPack, #False)
						EndIf
					Case #CheckBox_Delete_Archive
						st\Delete_Archive = GetGadgetState(#CheckBox_Delete_Archive)
					Case #CheckBox_Framework
						st\Framework = GetGadgetState(#CheckBox_Framework)
						If st\Framework = #PB_Checkbox_Checked And FileSize(bin$+"framework\framework-res.apk")=-1
							ChoiceFramework()
							If FileSize(bin$+"framework\framework-res.apk")=-1
								SetGadgetState(#CheckBox_Framework, #PB_Checkbox_Unchecked)
							EndIf
						EndIf
					Case #Button_Framework
						ChoiceFramework()
					Case #CheckBox_SignatureApk
						st\SignatureApk = GetGadgetState(#CheckBox_SignatureApk)
					Case  #CheckBox_Alignment
						st\Alignment = GetGadgetState(#CheckBox_Alignment)
					Case #CheckBox_Finish_Sound
						st\Finish_Sound = GetGadgetState(#CheckBox_Finish_Sound)
					Case #TrackBar_Volume_level
						st\Volume_level = GetGadgetState(#TrackBar_Volume_level)
						SetGadgetText(#Text_Volume_level, Str(st\Volume_level))
						If InSound And IsSound(#Sound) : SoundVolume(#Sound, st\Volume_level) : EndIf
					Case #CheckBox_Play_Sound
						If GetGadgetState(#CheckBox_Play_Sound) = #PB_Checkbox_Checked
							If InSound And IsSound(#Sound) : PlaySound(#Sound, #PB_Sound_Loop, st\Volume_level) : EndIf
						Else
							If InSound And IsSound(#Sound) : StopSound(#Sound) : EndIf
						EndIf 
					Case #CheckBox_Index
						st\Index_Add = GetGadgetState(#CheckBox_Index)
					Case #ComboBox_Language
						Old_ID=st\Locale_ID
						Select GetGadgetState(#ComboBox_Language)
							Case 0
								st\Locale_ID = 0
							Case 1
								st\Locale_ID = 1033
							Case 2
								st\Locale_ID = 1049
							Case 3
								st\Locale_ID = 1028
							Case 4
								st\Locale_ID = 2052
							Case 5
								st\Locale_ID = 1059
							Case 6
								st\Locale_ID = 1058
							Case 7
								st\Locale_ID = 1046
							Case 8
								st\Locale_ID = 1066
							Case 9
								st\Locale_ID = 1055
							Case 10
								st\Locale_ID = 1031
						EndSelect    	
						If Old_ID<>st\Locale_ID
							SetLanguage(st\Locale_ID)
							st\Setting_X=WindowX(#WIN_SETTING)
							st\Setting_Y=WindowY(#WIN_SETTING)
							st\Setting_Width = WindowWidth(#WIN_SETTING) 
							st\Setting_Height=WindowHeight(#WIN_SETTING)
							CloseWindow(#WIN_SETTING)
							WindowSettings()
							If IsWindow(#WIN_SETTING)
								SetGadgetState(#Panel, 6)
							EndIf
							If Not IsThread(ThreadActions)
								Text$=""
								SetGadgetText(#Editor,Text$)
								Message(Lng(68)+" (*.img), "+Lng(100)+" (*.zip), "+Lng(66)+" (*.img, *.PARTITION, *.fex, *.new.dat, *.new.dat.br) "+Lng(67))
								StatusBarText(#StatusBar, 1, Lng(71), #PB_StatusBar_BorderLess) ;Нет активных действий.
							Else 
								StatusBarText(#StatusBar, 1, Lng(21), #PB_StatusBar_BorderLess) ;Ожидайте выполнения действий...
							EndIf
							MakeMenuBar()
							MakeToolBar()
						EndIf
					Case #CheckBox_Not_Delete
						st\Not_Delete = GetGadgetState(#CheckBox_Not_Delete)
					Case #CheckBox_Transfer
						st\Transfer = GetGadgetState(#CheckBox_Transfer)   
					Case #ComboBox_Compress_Level
						st\Compress_Level = GetGadgetText(#ComboBox_Compress_Level)
					Case #CheckBox_Signature
						st\Signature= GetGadgetState(#CheckBox_Signature)
					Case #String_Expand_Size
						st\Free_Space = Val(GetGadgetText(#String_Expand_Size))
					Case #CheckBox_Expand_Size
						st\Expand_Size = GetGadgetState(#CheckBox_Expand_Size)
						DisableGadget(#String_Expand_Size, st\Expand_Size)
						DisableGadget(#CheckBox_Resize, st\Expand_Size)
					Case #CheckBox_Resize
						st\Resize = GetGadgetState(#CheckBox_Resize)
					Case #CheckBox_No_Backup
						st\No_Backup = GetGadgetState(#CheckBox_No_Backup)
					Case #CheckBox_No_Org
						st\No_Org = GetGadgetState(#CheckBox_No_Org)
					Case #ComboBox_Seven_Level 
						st\Seven_Level = GetGadgetText(#ComboBox_Seven_Level)
					Case #String_Size_Part
						st\Size_Part = GetGadgetText(#String_Size_Part)
					Case  #CheckBox_Delete_Image
						st\Delete_Image = GetGadgetState(#CheckBox_Delete_Image)
						;---------------------
						
					Case #Panel
						If EventType() = #PB_EventType_Change; And GetGadgetState(#Panel)<>3
							SetGadgetState(#CheckBox_Play_Sound, #PB_Checkbox_Unchecked)
							If InSound And IsSound(#Sound) : StopSound(#Sound) : EndIf
						EndIf
				EndSelect
			Case #PB_Event_CloseWindow ;-- Закрытие окон
				Select GetActiveWindow()
					Case #WIN_MAIN
						If Exit()=6
							Break
						EndIf
					Case #WIN_SETTING
						st\Setting_Stage=GetGadgetState(#Panel)
						st\Setting_X=WindowX(#WIN_SETTING)
						st\Setting_Y=WindowY(#WIN_SETTING)
						st\Setting_Width = WindowWidth(#WIN_SETTING) 
						st\Setting_Height=WindowHeight(#WIN_SETTING)
						;Debug st\Setting_Width
						;Debug st\Setting_Height
						DragAcceptFree(#Panel)
						If InSound And IsSound(#Sound) : StopSound(#Sound) : EndIf
						If IsFont(Font) : FreeFont(Font) : EndIf
						CloseWindow(#WIN_SETTING)
				EndSelect
		EndSelect
	EndIf
Wend

;--> ПРОЦЕДУРЫ
Procedure.s GetProgramVersion() ;Получаем версию программы, без номера сборки.
  Protected i, thisFind$, pv$
  For i = 1 To CountString(#PB_Editor_FileVersionNumeric, ".")
    thisFind$ = StringField(#PB_Editor_FileVersionNumeric, i, ".")
    If i=1
      pv$ = thisFind$
    ElseIf i=2
      pv$+"."+thisFind$
    ElseIf i=3 And thisFind$ <> "0"
      pv$+"."+thisFind$
    EndIf
  Next i 
  ProcedureReturn pv$
EndProcedure

Procedure IsWin64(); is the OS bit;
  Protected Info.SYSTEM_INFO
  GetNativeSystemInfo(Info)
  ProcedureReturn info\wProcessorArchitecture
EndProcedure

Procedure Out(text.s="")
  OutputDebugString_("PURE: "+text)
EndProcedure

; Procedure MenuRight(WindowID, Index)
;   Protected hMenu, info.MENUITEMINFO
;   hMenu = GetMenu_(WindowID)
;   With info
;     \cbSize = SizeOf(MENUITEMINFO)
;     \fMask = #MIIM_FTYPE
;     GetMenuItemInfo_(hMenu, index, #True, info)
;     \fType | #MFT_RIGHTJUSTIFY
;   EndWith
;   SetMenuItemInfo_(hMenu, index, #True, info)
;   DrawMenuBar_(WindowID)
; EndProcedure

Procedure ListFill(FullPath.s)
  AddElement(ListParam())
  ListParam() = RTrim(FullPath, "\")
EndProcedure

Procedure ReadLog(Parameter$)
  Protected Expansion$ = GetExtensionPart(Parameter$) ;расширение файла
  Protected FileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  If ReadFile(7,Parameter$, #PB_UTF8)
    Text$+"--->> Read "+FileName$+"."+Expansion$+" <<--- "+Chr(10)+ReadString(7, #PB_File_IgnoreEOL)+" --->> End "+FileName$+"."+Expansion$+" <<--- "+Chr(10)+Chr(10)
    CloseFile(7)  
  EndIf
EndProcedure

; Procedure.s GetSelectedText(gad)
; 	Protected t$=Space(999)
; 	SendMessage_(GadgetID(gad),#EM_GETSEL, @startPos, @endPos)
; 	t$ = Mid(GetGadgetText(gad), startPos+1, endPos-startPos)
; 	ProcedureReturn t$
; EndProcedure

; Procedure.s GetSelectedText(gad)
; 	Protected t$=Space(999)
; 	SendMessage_(GadgetID(gad),#EM_GETSELTEXT,0,@t$)
;   ProcedureReturn t$
; EndProcedure

Procedure.s Decoder(String.s)
  Protected *DecodedBuffer = AllocateMemory(1024)
  Base64Decoder(String, *DecodedBuffer, 1024)
  Protected Text.s = PeekS(*DecodedBuffer, -1, #PB_UTF8)
  FreeMemory(*DecodedBuffer)
  ProcedureReturn Text
EndProcedure

Procedure CheckAppPath(Path$)
    ;Path$="Я не понимаю что киррилица и пробелы в пути, это зло и программе не нравятся скобки()"+Path$
    Protected i, value, text$, Length
    #nByte = SizeOf(Character)
    Protected nSize = (Len(Path$)*#nByte)-2 ;NUL
    For i=0 To nSize Step #nByte
        value = PeekC(@Path$+i)
        If value=32 ;space
            text$+" space "
        ElseIf value=38 Or value=40 Or value=41 Or value=61 Or value=59 Or value=94  ; & ( ) = ; ^
            text$+Chr(value) 
        ElseIf value>127 ;киррилица
            text$+Chr(value)
        EndIf
    Next
    
    If Len(text$)<>0
        text$= Lng(151)+": "+text$ ;Недопустимые символы Unacceptable symbols
    EndIf
    
    Length = Len(Path$)
    If Length>120
        If Len(text$)<>0 : text$+Chr(10) : EndIf
        text$+Lng(152)+": "+Str(Length) +" "+Lng(153) ;Длинный путь ... символ Long path: ... symbols
    EndIf
    
    If Len(text$)<>0
        text$=Lng(154)+": "+Path$+Chr(10)+text$ ;Путь Path
        Message(text$, 1)
    EndIf
EndProcedure

Procedure CheckCharacters(Parameter$)
  Protected i, value, str$, space, Latin, notLatin, Length,ret
  Message(Lng(154)+": "+Parameter$) ;Путь Path
  #nByte = SizeOf(Character)
  Protected nSize = (Len(Parameter$)*#nByte)-2 ;NUL
  For i=0 To nSize Step #nByte
    value = PeekC(@Parameter$+i)
    str$+Chr(value)
    If value=32 : space+1 : ElseIf value<=127 And value<>32 : Latin+1 : ElseIf value>127 : notLatin+1 : EndIf
  Next
  Length = Len(Parameter$)
  Message(Lng(159)+": "+Str(Length)+"  "+Lng(156)+": "+Str(latin)+"  "+Lng(157)+": "+Str(notLatin)+"  "+Lng(158)+": "+Str(space)) ;Символы: ... Латинские ... не Латинские ... Пробелы
  ret= notLatin+space
  If ret>0
    Message(">< !!! "+Lng(151)+": "+ret) ;Недопустимые символы Unacceptable symbols
  EndIf
  If Length>120
    Message(">< !!! "+Lng(152)+" "+Str(Length) +" "+Lng(153)) ;Длинный путь ... символ Long path: ... symbols
  EndIf
  ProcedureReturn ret
EndProcedure

Procedure.q HexVal(a$)
	Protected result.q, t.s
	a$=Trim(UCase(a$)) 
	If Asc(a$)='$' 
		a$=Trim(Mid(a$,2,Len(a$)-1)) 
	EndIf
	If LCase(Left(a$,2))="0x"
		a$=Mid(a$, 3)
	EndIf
	result=0 
	For i=1 To Len(a$) 
		t=Mid(a$,i,1)
		result <<4 
		Select t 
			Case "0" 
			Case "1" :result+1 
			Case "2" :result+2 
			Case "3" :result+3 
			Case "4" :result+4 
			Case "5" :result+5 
			Case "6" :result+6 
			Case "7" :result+7 
			Case "8" :result+8 
			Case "9" :result+9 
			Case "A" :result+10 
			Case "B" :result+11 
			Case "C" :result+12 
			Case "D" :result+13 
			Case "E" :result+14 
			Case "F" :result+15 
			Default:i=Len(a$) 
		EndSelect 
		;*adr+1 
	Next 
	ProcedureReturn  result
EndProcedure

Procedure.l HexFind(*File, SearchHex$, Offset$="0")
	Protected Size.l, *Buffer, ReadBytes.l, i, dump$
	Protected Position.q = HexVal(Offset$)
	If LCase(Left(SearchHex$,2))="0x"
		SearchHex$=Mid(SearchHex$, 3)
	EndIf
	Size = Len(SearchHex$)/2
	*Buffer = AllocateMemory(Size)
	If *Buffer
		SetFilePointer_(*File, Position, 0, #FILE_BEGIN)
		ReadFile_(*File, *Buffer, Size, @ReadBytes, #Null)
		For i = 0 To  Size-1
			dump$ + RSet(Hex(PeekB(*Buffer + i), #PB_Byte),2,"0")
		Next
		;Debug dump$
		FreeMemory(*Buffer)
		If dump$=SearchHex$
			ProcedureReturn 1
		Else
			ProcedureReturn 0
		EndIf
	Else
		ProcedureReturn -2
	EndIf
EndProcedure

Procedure.s CheckSignature(ImageFile$)
	If FileSize(ImageFile$)
		Protected Result$
		Protected *File = CreateFile_(@ImageFile$, #GENERIC_READ, #FILE_SHARE_READ, #Null, #OPEN_EXISTING, #FILE_ATTRIBUTE_NORMAL, 0)
		If (*File = #INVALID_HANDLE_VALUE)
			ProcedureReturn "Invalid_Handle"
		Else
			If HexFind(*File, "0x3AFF26ED01") ; :я&н
				Result$ = "Sparse"
			ElseIf HexFind(*File, "0xE2E1F5E0", "0x400") ;вбха
				Result$ = "Erofs"
			ElseIf HexFind(*File, "0x1020F5F2", "0x400") ;вбха
				Result$ = "F2FS"	
			ElseIf HexFind(*File, "0x53EF", "0x438") ; Sп
				Result$ = "Raw"
			ElseIf HexFind(*File, "0x0000000000")
				Result$ = "Raw"
			ElseIf HexFind(*File, "0x524B465766")  ; RKFWf
				Result$ = "Rockchip"
			ElseIf HexFind(*File, "0x494D414745") ; IMAGE
				Result$ = "Allwinner"
			ElseIf HexFind(*File, "0x5619B527", "0x08") ; Vµ'
				Result$ = "Amlogic"
			ElseIf HexFind(*File, "0x414D4C5F52455321", "0x08") ; AML_RES!
				Result$ = "AmlLogo"
			ElseIf HexFind(*File, "0x414D4C5F02") ;AML_
				Result$ = "DtbMulti"
			ElseIf HexFind(*File, "0xD00DFEED") ;Р юн  
				Result$ = "DtbSingle"
			ElseIf HexFind(*File, "0x504B0304")
				Result$ = "Zip"
			ElseIf HexFind(*File, "0x377ABCAF271C")
				Result$ = "SevenZip"
			ElseIf HexFind(*File, "0x52617221")  ; Rar!
				Result$ = "SevenZip"
			ElseIf HexFind(*File, "0x7573746172") ; ustar
				Result$ = "Tar"
			ElseIf HexFind(*File, "0x7573746172", "0x101") ; ustar
				Result$ = "UsTar"
			ElseIf HexFind(*File, "0x1F8B08")
				Result$ = "Gzip"
			ElseIf HexFind(*File, "0x414E44524F494421") ; ANDROID!
				Result$ = "BootRec"
			ElseIf HexFind(*File, "0x52534345")  
				Result$ = "RkRes"
			ElseIf HexFind(*File, "0x4C4F41444552") ; LOADER
				Result$ = "RkUboot"
			ElseIf HexFind(*File, "0x43724155") ; CrAU 
				Result$ = "PayLoad"
			ElseIf HexFind(*File, "0x42005000") ; B.P.
				Result$ = "Pac"
			ElseIf HexFind(*File, "0xCFFFFF") ; Пяя
				Result$ = "Br" 
			ElseIf HexFind(*File, "0x04224D18") ; "M (184D2204)
				Result$ = "Lz4"  
			ElseIf HexFind(*File, "0xEB3C904D") ; л<ђM
				Result$ = "Fat32"
			ElseIf HexFind(*File, "0x424D") ; BM
				Result$ = "bmp" 	
			Else
				Result$ = "Signature not found"
			EndIf
			CloseHandle_(*File)
			ProcedureReturn Result$
		EndIf
		
	Else
		ProcedureReturn "File_not_found"
	EndIf
	
	;Protected SignatureLen = 1082;16 ;!!!
	;Protected dump$
	;   If FileSize(ImageFile$) <= 0
	;     ProcedureReturn "Amlogic"
	;   EndIf
	;   Protected *File = CreateFile_(@ImageFile$, #GENERIC_READ, #FILE_SHARE_READ, #Null, 
	;                       #OPEN_EXISTING, #FILE_FLAG_BACKUP_SEMANTICS, #Null)
	;   If (*File = #INVALID_HANDLE_VALUE)
	;     ProcedureReturn "Amlogic"
	;   EndIf
	;   Protected Size = SizeOf(ascii) * SignatureLen
	;   Protected *Buffer = AllocateMemory(Size)
	;   Protected ReadBytes.l
	; ;  For pos = StartPoint To EndPoint
	; ;   SetFilePointer_(handle, pos, 0, #FILE_BEGIN)
	; ;   ReadFile_(handle, *Buffer, 512, @Count, 0)
	; ;   dump$ + RSet(Hex(PeekB(*Buffer + pos), #PB_Byte),2,"0")
	; ;  Next pos
	;   SetFilePointer_(*File, pos, 0, #FILE_BEGIN)
	;   ReadFile_(*File, *Buffer, Size, @ReadBytes, #Null)
	;   CloseHandle_(*File)
	;   
	; ;   Protected Signature$ = PeekS(*Buffer, SignatureLen, #PB_Ascii)
	; ;   If LCase(Signature$) = "rkfwf"
	; ;     ProcedureReturn "Rockchip"
	; ;   ElseIf LCase(Signature$) = "image"
	; ;     ProcedureReturn "Allwinner"
	; ;   Else
	; ;     ProcedureReturn "Amlogic"
	; ;   EndIf
	;   
	;   For i = 0 To  SignatureLen-1
	;   	dump$ + RSet(Hex(PeekB(*Buffer + i), #PB_Byte),2,"0")
	;   	;Debug i
	;   Next
	;   Debug dump$
	;   
	;   FreeMemory(*Buffer)
	
	;Debug FindString(dump$, "5619B527")
	
	;   If FindString(dump$, "53EF")=2161; 
	;   	ProcedureReturn "Raw"
	;   Else 
	;   	dump$ = Left(dump$, 16)
	;   EndIf
	
	
	;   If FindString(dump$, "0000000000")=1 ; 
	;     ProcedureReturn "Raw"
	; Else
	
	;   If FindString(dump$, "3AFF26ED01")=1 ; :я&н
	;   	ProcedureReturn "Sparse"
	;   ElseIf FindString(dump$, "524B465766")=1  ; RKFWf
	;   	ProcedureReturn "Rockchip"
	;   ElseIf FindString(dump$, "494D414745")=1 ; IMAGE
	;   	ProcedureReturn "Allwinner"
	;   ElseIf FindString(dump$, "5619B527")=17 ; Vµ'
	;     ProcedureReturn "Amlogic"
	;   ElseIf FindString(dump$, "414D4C5F52455321")=17 ; AML_RES!
	;     ProcedureReturn "AmlLogo"
	;   ElseIf FindString(dump$, "414D4C5F02")=1 ;AML_
	;     ProcedureReturn "DtbMulti"
	;   ElseIf FindString(dump$, "D00DFEED")=1 ;Р юн  
	;     ProcedureReturn "DtbSingle"
	;   ElseIf FindString(dump$, "504B0304")=1
	;     ProcedureReturn "Zip"
	;   ElseIf FindString(dump$, "377ABCAF271C")=1
	;     ProcedureReturn "SevenZip"
	;   ElseIf FindString(dump$, "52617221")=1  ; Rar!
	;     ProcedureReturn "SevenZip"
	;   ElseIf FindString(dump$, "7573746172")=1
	;     ProcedureReturn "Tar"
	;   ElseIf FindString(dump$, "1F8B08")=1
	;     ProcedureReturn "Gzip"
	;   ElseIf FindString(dump$, "414E44524F494421")=1 ; ANDROID!
	;     ProcedureReturn "BootRec"
	;   ElseIf FindString(dump$, "52534345")=1  
	;     ProcedureReturn "RkRes"
	;   ElseIf FindString(dump$, "4C4F41444552")=1 ; LOADER
	;     ProcedureReturn "RkUboot"
	;   ElseIf FindString(dump$, "43724155")=1 ; CrAU 
	;     ProcedureReturn "PayLoad"
	;   ElseIf FindString(dump$, "42005000")=1 ; B.P.
	;     ProcedureReturn "Pac"
	;   ElseIf FindString(dump$, "CFFFFF")=1 ; Пяя
	;     ProcedureReturn "Br" 
	;   ElseIf FindString(dump$, "04224D18")=1 ; "M (184D2204)
	;     ProcedureReturn "Lz4"  
	;   ElseIf FindString(dump$, "EB3C904D")=1 ; л<ђM
	;       ProcedureReturn "Fat32"
	;   ElseIf FindString(dump$, "424D")=1 ; BM
	;       ProcedureReturn "bmp"   
	;   Else
	;     ProcedureReturn dump$
	;   EndIf
	
EndProcedure

Procedure AutoExit(*Value)
  Delay(1000)
  SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_PAUSED, 0)
  SetGadgetAttribute(#Progress, #PB_ProgressBar_Maximum, st\AutoExit_Time)
  For k = st\AutoExit_Time To 0 Step -1 
    SetGadgetText(#Editor,Text$+Lng(168)+": "+Str(k)) ;Авто закрытие через:
    EditorEndLine(#Editor)
    SetGadgetState(#Progress , k-1)
    If k=0
      Delay(300)
    Else
      Delay(1000)
    EndIf
  Next
  If Exit()=6
    End
  EndIf
EndProcedure

Procedure Actions(*Value)
  Protected Parameter$, Expansion$, FileName$, LowerFileName$, FolderName$
  Protected Count = ListSize(ListParam())
  If Count
    If IsThread(ThreadAutoExit)
      KillThread(ThreadAutoExit)
    EndIf

    While Count
      If Count > 1
        Message(Lng(19)+" "+Str(Count)+" "+Lng(20), 1) ;Пакетная обработка: ... действий(я)
      EndIf
      
      FirstElement(ListParam()) 
      Parameter$ = RTrim(ListParam(), "\") ;Переданный параметр
      DeleteElement(ListParam())           ;Удаляем полученный ранее параметр из списка
      
      Expansion$ = LCase(GetExtensionPart(Parameter$)) ;расширение файла
      FileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension) ;имя файла без расширения
      LowerFileName$ = LCase(FileName$)                               ;имя файла без расширения (маленькими буквами)
      FolderName$ = GetFilePart(Parameter$)                           ;Имя целевой папки
      
      ;MessageRequesterEx("Параметр", "Parameter$= "+Parameter$+Chr(10)+"Expansion$= "+Expansion$+Chr(10)+"FileName$= "+FileName$+Chr(10)+"FolderName$= "+FolderName$+Chr(10)+"HomeFolder$= "+HomeFolder$)
      ;MessageRequesterEx("", "Expansion$= "+Expansion$)
      ;MessageRequesterEx("", "FileName$= "+FileName$)
      ;MessageRequesterEx("", "FolderName$= "+FolderName$)
      ;MessageRequesterEx("", "HomeFolder$= "+HomeFolder$)
      
      StatusBarImage(#StatusBar, 0, ImageID(0), #PB_StatusBar_BorderLess)
      StatusBarText(#StatusBar, 1, Lng(21), #PB_StatusBar_BorderLess) ;Ожидайте выполнения действий...
      
      ;RunConsole("Notepad", "", "", #PB_Program_Wait) ;Применяется во время тестирования, для преостановки цикла
      
;       If Expansion$ = "img" ;--> РАСПАКОВКА  IMG (1)
;         If LowerFileName$ = "vendor" Or LowerFileName$ = "system" Or LowerFileName$ = "product" Or LowerFileName$ = "odm" Or LowerFileName$ = "elable" Or LowerFileName$ = "socko"
;           MainUnpack(Parameter$)
;         ElseIf LowerFileName$ = "super"
;           SuperUnpack(Parameter$)
;         ElseIf LowerFileName$ = "resource" Or LowerFileName$ = "boot" Or LowerFileName$ = "recovery" Or LowerFileName$ = "uboot" Or LowerFileName$ = "bootloader"
;           ImgRKUnpack(Parameter$)
;         ElseIf  FindString(LowerFileName$, "logo")>0 ;LowerFileName$ = "logo"
;           LogoUnpack(Parameter$)
;         Else
;           FirmwareUnpack(Parameter$)
;         EndIf
;       ElseIf Expansion$ = "ext4" ;--> РАСПАКОВКА  ext4
;         ext4Unpack(Parameter$)
;       ElseIf Expansion$ = "md5" Or Expansion$ = "tar";--> РАСПАКОВКА  md5\tar
;         tarUnpack(Parameter$)
;       ElseIf Expansion$ = "lz4" ;--> РАСПАКОВКА  lz4
;         lz4Unpack(Parameter$)
;       ElseIf Expansion$ = "pac" ;--> РАСПАКОВКА  PAC
;         ImgPacUnpack(Parameter$)
;       ElseIf Expansion$ = "bin" And LowerFileName$ = "payload" ;--> РАСПАКОВКА  payload.bin
;         PayloadDumper(Parameter$)
;       ElseIf Expansion$ = "zip" ;--> РАСПАКОВКА  ZIP
;         ZipUnpack(Parameter$)
;       ElseIf Expansion$ = "7z" ;--> РАСПАКОВКА  7z
;         SevenZipUnpack(Parameter$)
;       ElseIf Expansion$ = "dat" ;--> РАСПАКОВКА  DAT
;         DatUnpack(Parameter$)
;       ElseIf Expansion$ = "br" ;--> РАСПАКОВКА  BR
;         BrUnpack(Parameter$)
;       ElseIf Expansion$ = "gz" ;--> РАСПАКОВКА  GZ
;         gzUnpack(Parameter$)
;       ElseIf Expansion$ = "fex" ;--> РАСПАКОВКА FEX
;         If LowerFileName$ = "system" Or LowerFileName$ = "vendor" Or LowerFileName$ = "product" Or LowerFileName$ = "odm"
;           MainUnpack(Parameter$)
;         ElseIf LowerFileName$ = "super"
;           SuperUnpack(Parameter$)
;         ElseIf LowerFileName$ = "boot" Or LowerFileName$ = "recovery"
;           ImgAllUnpack(Parameter$)
;         Else
;           Message(Lng(23)+" "+FolderName$) ;Программа не умеет распаковывать:
;         EndIf
;       ElseIf Expansion$ = "partition" ;--> РАСПАКОВКА PARTITION
; 
;         If LowerFileName$ = "boot" Or LowerFileName$ = "recovery" ;--> Распаковка раздела boot или recovery
;           BootRecoveryUnpack(Parameter$)
;           
;         ElseIf LowerFileName$ = "vendor" Or LowerFileName$ = "system" Or LowerFileName$ = "product" Or LowerFileName$ = "odm";--> Распаковка раздела vendor, system, product, odm
;           MainUnpack(Parameter$)
;         ElseIf  LowerFileName$ = "logo"
;           LogoUnpack(Parameter$)
;         ElseIf LowerFileName$ = "_aml_dtb"
;           DtbUnpack(Parameter$)
;         ElseIf LowerFileName$ = "ce_flash"
;           Message(Lng(23)+" "+FolderName$) ;Программа не умеет распаковывать:
;           Message(Lng(24)+" UltraISO", 1)  ;Попробуйте редактировать данный образ раздела с помощью:
;         Else
;           Message(Lng(23)+" "+FolderName$, 1) ;Программа не умеет распаковывать:
;         EndIf
;         
;         If IsEmptyFolder(HomeFolder$) = 1
;           DeleteDirectory(HomeFolder$, "")
;         EndIf
;       ElseIf Expansion$ = "apk"
;         ApkUnpack(Parameter$)
      String$ = Parameter$
      If FileSize(Parameter$) > 0 
        SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_NORMAL, 0)
        SetWindowLong_(GadgetID(#Progress), #GWL_STYLE, GetWindowLong_(GadgetID(#Progress), #GWL_STYLE) | #PBS_MARQUEE)
        SendMessage_(GadgetID(#Progress), #WM_USER+10, #True, 30)
        CheckCharacters(Parameter$)
        Protected Signature$ = CheckSignature(Parameter$)
        ;Debug Signature$
        If Expansion$ = "dat" ;--> РАСПАКОВКА  DAT
          DatUnpack(Parameter$)
        ElseIf Expansion$ = "ext4" ;--> РАСПАКОВКА  ext4
          ext4Unpack(Parameter$)
        ElseIf Expansion$ = "br"  ;--> РАСПАКОВКА BR (нет сигнатуры в заголовке файла!)
          BrUnpack(Parameter$)
        ElseIf Expansion$ = "txt" And FindString(LowerFileName$, "logfile")>0
          ReadLog(Parameter$)
        ElseIf Expansion$ = "log" And FindString(LowerFileName$, "lastaction")>0
        	ReadLog(Parameter$)
        ElseIf Signature$ = "Sparse"
        	If FindString(LowerFileName$, "super")>0
        		SuperUnpack(Parameter$)  ;--> РАСПАКОВКА SUPER
        	Else
        		MainUnpack(Parameter$)  ;--> РАСПАКОВКА РАЗДЕЛА
        	EndIf
        ElseIf Signature$ = "Erofs"
        	MainUnpack(Parameter$)  ;--> РАСПАКОВКА РАЗДЕЛА
        ElseIf Signature$ = "Raw" And (Expansion$ = "img" Or Expansion$ = "fex" Or Expansion$ = "partition" Or Expansion$ = "org" Or Expansion$ = "bin" Or Expansion$ = "bak")
        	If FindString(LowerFileName$, "super")>0
        		SuperUnpack(Parameter$)  ;--> РАСПАКОВКА SUPER
        	Else
        		MainUnpack(Parameter$)  ;--> РАСПАКОВКА РАЗДЕЛА
        	EndIf
        ElseIf Signature$="Rockchip" Or Signature$="Allwinner" Or Signature$="Amlogic"
        	FirmwareUnpack(Parameter$)  ;--> РАСПАКОВКА ПРОШИВКИ
        ElseIf Signature$="DtbSingle"	;--> РАСПАКОВКА DTB Single
        	DtbSingleUnpack(Parameter$)
        ElseIf Signature$="DtbMulti"  ;--> РАСПАКОВКА DTB Multi
        	DtbMultiUnpack(Parameter$,Signature$)
        ElseIf Signature$="Tar"  Or Expansion$ = "tar" Or (Expansion$ = "md5" And LCase(GetExtensionPart(FileName$)) = "tar");--> РАСПАКОВКА TAR
        	tarUnpack(Parameter$)
        ElseIf Signature$="UsTar"
        	tarUnpack(Parameter$)
        	;ustarUnpack(Parameter$)
        ElseIf Signature$="SevenZip" Or Expansion$ = "7z" Or Expansion$ = "rar";--> РАСПАКОВКА 7Z
          SevenZipUnpack(Parameter$)
        ElseIf Signature$="Zip" And Expansion$ = "zip"  ;--> РАСПАКОВКА ZIP
          ZipUnpack(Parameter$)
        ElseIf Signature$="Zip" And Expansion$ = "apk"  ;--> РАСПАКОВКА APK
          ApkUnpack(Parameter$)
        ElseIf Signature$="Gzip" And FindString(LowerFileName$, "_aml_dtb")>0  ;--> РАСПАКОВКА DTB Multi Gzip
          DtbMultiUnpack(Parameter$,Signature$)
        ElseIf Signature$="Gzip" And Expansion$ = "gz"  ;--> РАСПАКОВКА GZ
          gzUnpack(Parameter$)
        ElseIf Signature$="Gzip" And Expansion$ = "img"
          ImgRKUnpack(Parameter$)
        ElseIf Signature$="AmlLogo"   ;--> РАСПАКОВКА Amlogic LOGO
          LogoUnpack(Parameter$)
        ElseIf Signature$="RkRes"   ;--> РАСПАКОВКА Rockchip resource
          ImgRKUnpack(Parameter$)
        ElseIf Signature$="RkUboot"   ;--> РАСПАКОВКА Rockchip  UBoot
          ImgRKUnpack(Parameter$)
        ElseIf Signature$="BootRec"   ;--> РАСПАКОВКА Boot Recovery
          If  Expansion$ = "fex"
            ImgAllUnpack(Parameter$)
          ElseIf Expansion$ = "partition"
            BootRecoveryUnpack(Parameter$)
          Else
            ImgRKUnpack(Parameter$)
          EndIf
        ElseIf Signature$="PayLoad"  ;--> РАСПАКОВКА PayLoad.bin
          PayloadDumper(Parameter$)
        ElseIf Signature$="Pac"  ;--> РАСПАКОВКА PAC
          ImgPacUnpack(Parameter$) 
;         ElseIf Signature$="Br"  ;--> РАСПАКОВКА BR
;           BrUnpack(Parameter$) 
        ElseIf Signature$="Lz4" Or Expansion$ = "lz4" ;--> РАСПАКОВКА LZ4
          lz4Unpack(Parameter$)
          
        ElseIf Signature$="Fat32"  Or FindString(LowerFileName$, "ce_flash")>0 ;--> РАСПАКОВКА FAT32
          Message(Lng(23)+" "+FolderName$) ;Программа не умеет распаковывать:
          Message(Lng(24)+" UltraISO; WinImage", 1)  ;Попробуйте редактировать данный образ раздела с помощью:
        Else
          Message(Lng(23)+" "+FolderName$) ;Программа не умеет распаковывать:
          Message(Lng(155)+": "+Signature$, 1) ;Заголовок Header
        EndIf
        ;-------------------------------
    ElseIf FileSize(Parameter$) = -2 ;--> УПАКОВКА ПАПКИ В ОБРАЗ
        SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_NORMAL, 0)
        SetWindowLong_(GadgetID(#Progress), #GWL_STYLE, GetWindowLong_(GadgetID(#Progress), #GWL_STYLE) | #PBS_MARQUEE)
        SendMessage_(GadgetID(#Progress), #WM_USER+10, #True, 30)
        CheckCharacters(Parameter$)
        If IsEmptyFolder(Parameter$)=0 And FileSize(Parameter$+"\config\"+FolderName$+"_fs_options.txt") > 0 ;--> Сборка разделов
        	MainPack(Parameter$)
        	;ReadFile(0, Parameter$+"\config\"+FolderName$+"_fs_options.txt", #PB_File_SharedRead|#PB_File_SharedWrite)>0
    		;If ReadStr(0, "mkfs.erofs options") = "" : CloseFile(0) : MainPack(Parameter$) : Else : CloseFile(0) : ErofsPack(Parameter$) : EndIf
        ElseIf FileSize(GetPathPart(Parameter$)+FileName$+".cfg") > 0 ;new
            If FileName$ = "resource.img" Or FileName$ = "boot.img" Or FileName$ = "recovery.img" Or FileName$ = "uboot.img" Or FileName$ = "bootloader.img"
                ImgRKPack(Parameter$)
            ElseIf FileName$ = "boot.fex" Or FileName$ = "recovery.fex"
                ImgAllPack(Parameter$)
            EndIf
        ElseIf FileSize(Parameter$+".cfg") > 0 ;old
            If FileName$ = "resource.img" Or FileName$ = "boot.img" Or FileName$ = "recovery.img" Or FileName$ = "uboot.img" Or FileName$ = "bootloader.img"
                ImgRKPack(Parameter$)
            ElseIf FileName$ = "boot.fex" Or FileName$ = "recovery.fex"
                ImgAllPack(Parameter$)
            EndIf
        ElseIf FileSize(Parameter$+"\image.cfg") > 0 ;--> Сборка прошивки в файл (img)
            FirmwarePack(Parameter$)
        ElseIf FileSize(Parameter$+"\zipFileList.cfg")>0
            ZipPack(Parameter$)
        ElseIf FileSize(Parameter$+"\tarFileList.cfg") > 0 
          tarPack(Parameter$)
        ElseIf FileSize(Parameter$+"\config.ini") > 0 ;--> Упаковка раздела boot или recovery
          BootRecoveryPack(Parameter$)
        ElseIf FileSize(Parameter$+"\AndroidManifest.xml") > 0 ;--> Сборка приложения apk
          ApkPack(Parameter$)
        ElseIf FindString(LowerFileName$, "logo")>0 ;LowerFileName$ = "logo"
          LogoPack(Parameter$) 
        ElseIf LowerFileName$ = "_aml_dtb"
          DtbPack(Parameter$)
        ElseIf LowerFileName$ = "add" ;--> Создание файла атрибутов для папки add
        	AttributesList(Parameter$)
        ElseIf FindString(LowerFileName$, "super")>0 
        	SuperPack(Parameter$)
        Else
          Message(Lng(25)+" "+Chr(34)+FolderName$+Chr(34)+" "+Lng(26), 1) ;В каталоге: ... не найдена инструкция для сборки образа!
        EndIf
      Else
        ;Message(Lng(65)+" (*.img), "+Lng(100)+" (*.zip), "+Lng(66)+" (*.img, *.PARTITION, *.fex, *.new.dat, *.new.dat.br) "+Lng(67)+Chr(10)+"* "+Lng(64)+": "+FileName$+"."+Expansion$, 1) ;На значок программы можно переносить только образ(ы) образ раздела(ов) прошивки или папку с распакованной прошивкой, папку с распакованным образом раздела. Неподдерживаемый формат
        Message("* "+Lng(64)+": "+FileName$+"."+Expansion$, 1) ;Неподдерживаемый формат
      EndIf
      Count = ListSize(ListParam())
      If Count = 0
        
        If Not st\Main_Top
          StickyWindow(#WIN_MAIN, #True) ; Поверх всех окон
          StickyWindow(#WIN_MAIN, #False)   ; Убрать поверх всех окон                   
        EndIf
        
        ClearList(ListParam())
        SetWindowLong_(GadgetID(#Progress), #GWL_STYLE, GetWindowLong_(GadgetID(#Progress), #GWL_STYLE) & ~#PBS_MARQUEE)
        If ErrorsCount>0
          Message(">< !!! "+Lng(74)+" !!! >< "+Lng(133)+" ("+ErrorsCount+")",1); Внимание Имеются ошибки выполнения
        EndIf
        Message(">< !!! "+Lng(80)) ;Понравился проект? Хотите что бы он развивался? Окажите материальную помощь. Переведите любую сумму на один из этих кошельков:
        Message(Lng(27)+" "+Lng(28)) ;Активных действий больше нет. Можно закрыть данное окно.
        If ErrorsCount>0 : Highlight() : Else : SetGadgetState(#Progress , 100) : EndIf
        StatusBarImage(#StatusBar, 0, ImageID(1), #PB_StatusBar_BorderLess)
        StatusBarText(#StatusBar, 1, Lng(27), #PB_StatusBar_BorderLess) ;Активных действий больше нет.
        If st\Finish_Sound And InSound And IsSound(#Sound) : PlaySound(#Sound, 0, st\Volume_level) : EndIf
        If st\Auto_Exit = #PB_Checkbox_Checked And Not ErrorsCount And Not IsThread(ThreadAutoExit)
        	ThreadAutoExit = CreateThread(@AutoExit(), 0)
        EndIf
        ErrorsCount=0
      EndIf
    Wend
  Else
    Message(Lng(68)+" (*.img), "+Lng(100)+" (*.zip), "+Lng(66)+" (*.img, *.PARTITION, *.fex, *.new.dat, *.new.dat.br) "+Lng(67)) ;Перенесите на  данное окно или на значок программы образ(ы) прошивки образ раздела(ов) прошивки или папку с распакованной прошивкой, папку с распакованным образом раздела.   
EndIf
EndProcedure

Procedure RunActions()
  If Not IsThread(ThreadActions)
    ThreadActions = CreateThread(@Actions(), 0)
  Else
    Message(">< !!! "+Lng(29)+" !!! ><") ;Запланированы дополнительные действия
  EndIf 
EndProcedure

Procedure.s ReadStr(ID, Key$ , StrValue$="", put=1, startPhrase$="", endPhrase$="!@#")
	Protected text$, position, parameter$, value$, draw=1, go=0
	If  IsFile(ID)
		While Eof(ID) = 0
			text$ =  ReadString(ID)
			position    = FindString(text$,":",1)
			If position>0
				parameter$ = Trim(Mid(text$,1,position-1))
				value$ =          Trim(Mid(text$, position+1))
				
				If startPhrase$ = "" Or LCase(parameter$) = LCase(startPhrase$)
					go=1
				EndIf
				
				If go And LCase(Key$)=LCase(parameter$)
					StrValue$=value$
					If draw=put
						Break
					EndIf
					draw+1
				EndIf
				
				If LCase(parameter$) = LCase(endPhrase$)
					StrValue$ = "Break"
					Break
				EndIf
				
			EndIf
		Wend
		FileSeek(ID, 0)
	EndIf
	ProcedureReturn StrValue$
EndProcedure

; Procedure.s ReadStr(ID, Key$ , StrValue$="")
; 	Protected text$, position, parameter$, value$
; 	If  IsFile(ID)
; 		While Eof(ID) = 0
; 			text$ =  ReadString(ID)
; 			;Debug text$
; 			position    = FindString(text$,":",1)
; 			If position>0
; 				parameter$= Trim(Mid(text$,1,position-1))
; 				value$=     Trim(Mid(text$, position+1))
; 				;Debug "PARAMETER:-"+parameter$+" VALUE:-"+value$
; 				If LCase(Key$)=LCase(parameter$)
; 					StrValue$=value$
; 					Break
; 				EndIf
; 			EndIf
; 		Wend
; 		FileSeek(ID, 0)
; 	EndIf
; 	ProcedureReturn StrValue$
; EndProcedure

Procedure FirmwareUnpack(Parameter$)
	Protected Err
	Protected NameCPU.s = CheckSignature(Parameter$)
	Protected FileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
	Protected ExtractionPath$ = GetPathPart(Parameter$)+FileName$
	Protected FileNameExpansion$ = GetFilePart(Parameter$)
	Protected WorkingDirectory$ = GetPathPart(Parameter$)
	
	If FileSize(WorkingDirectory$+FileName$+".md5")>0
		Message(Lng(160)+":md5 "+Lng(30)) ;Проверка контрольной суммы
		Err = RunConsole(bin$+"md5sum.exe", "-c "+Chr(34)+FileName$+".md5"+Chr(34)+" 2>nul", WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(42)+" md5sum: " + Str(Err)+ExitStr(Err)) ;Exitcode
	EndIf
	
	If Err = 0
		If NameCPU = "Rockchip" Or NameCPU = "Allwinner"
			ExtractionPath$ = Parameter$+".dump"
		EndIf
		
		If IsEmptyFolder(ExtractionPath$) = 0
			Message(Lng(31)+" "+Lng(30)) ;Обнаружена папка с распакованным образом прошивки, удаляем! Подождите...
			Err = RunConsole("rmdir", "/q /s "+Chr(34)+ExtractionPath$+Chr(34), "", #PB_Program_Wait)
			Message(Lng(42)+" rmdir: " + Str(Err)+ExitStr(Err)) ;Exitcode
																; DeleteDirectory (ExtractionPath$, "" ,  #PB_FileSystem_Recursive | #PB_FileSystem_Force)
		EndIf
		
		;RunConsole("mkdir", Chr(34)+ExtractionPath$+Chr(34), "", #PB_Program_Wait)
		
		If NameCPU = "Amlogic"
			Message(Lng(32)+" "+FileNameExpansion$+" |CPU-Amlogic| "+Lng(30)) ;Выполняется распаковка образа прошивки: Подождите...
			CreateDirectory(ExtractionPath$)
			Err = RunConsole(bin$+"AmlImagePack.exe", "-d "+Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+FileName$+Chr(34), WorkingDirectory$, #PB_Program_Wait) 
			Message(Lng(42)+" AmlImagePack: " + Str(Err)+ExitStr(Err)) ;Exitcode
		ElseIf NameCPU = "Sparse" Or NameCPU = "Raw"
			MainUnpack(Parameter$)
		ElseIf NameCPU = "Rockchip"
			Message(Lng(32)+" "+FileNameExpansion$+" |CPU-Rockchip| "+Lng(30)) ;Выполняется распаковка образа прошивки: Подождите...
			Err = RunConsole(bin$+"imgRePackerRK"+st\Ver, Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
			If Err <> 0
				If st\Ver= "106" : st\Ver= "107" : ElseIf st\Ver= "107" : st\Ver= "106" : EndIf
				Message(Lng(94)+": imgRepackerRK v."+st\Ver+" "+Lng(30)) ;Попытка распаковки другой версией: ... Подождите...
				If IsWindow(#WIN_SETTING)
					If st\Ver = "107"
						SetGadgetState(#Option_Version_Seven, #True)  ; сделать активной опцию
					Else 
						SetGadgetState(#Option_Version_Six, #True)  ; сделать активной опцию
					EndIf
				EndIf
				Err = RunConsole(bin$+"imgRePackerRK"+st\Ver, Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
			EndIf
			Message(Lng(42)+" ImgRePackerRK: " + Str(Err)+ExitStr(Err)) ;Exitcode
		ElseIf NameCPU = "Allwinner"
			Message(Lng(32)+" "+FileNameExpansion$+" |CPU-Allwinner| "+Lng(30)) ;Выполняется распаковка образа прошивки: Подождите...
			Err = RunConsole(bin$+"imgRePacker.exe", Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
			Message(Lng(42)+" ImgRePacker: " + Str(Err)+ExitStr(Err)) ;Exitcode
		EndIf
		
		Message(Lng(36)+" "+FileNameExpansion$+" "+Lng(35), 1)     ;Действие по распаковки прошивки: ... завершено.
		
		If IsEmptyFolder(ExtractionPath$) = 1 ;Если папка пуста, удаляем
			DeleteDirectory(ExtractionPath$, "")
		Else
			Recent(ExtractionPath$)
			Recent(Parameter$)
			
			
			If st\Unpack_Super = #PB_Checkbox_Checked
				If FileSize(ExtractionPath$+"\super.PARTITION")>0 : SuperUnpack(ExtractionPath$+"\super.PARTITION") 
				ElseIf FileSize(ExtractionPath$+"\super.fex")>0 : SuperUnpack(ExtractionPath$+"\super.fex") 
				ElseIf FileSize(ExtractionPath$+"\super.img")>0 : SuperUnpack(ExtractionPath$+"\super.img")
				ElseIf FileSize(ExtractionPath$+"\Image\super.img")>0 : SuperUnpack(ExtractionPath$+"\Image\super.img")
				Else
					PartUnpack(ExtractionPath$)	
				EndIf
			Else
				PartUnpack(ExtractionPath$)	
			EndIf

		EndIf
	EndIf
EndProcedure

Procedure.s NewFileName(WorkingDirectory$, DirectoryName$)
  Protected FileName$, index$
  If st\Index_Add = #PB_Checkbox_Checked
    For i = 1 To 100
      If FileSize(WorkingDirectory$+DirectoryName$+index$+".img")=-1
        Break
      EndIf
      index$="("+Str(i)+")"
    Next
  EndIf
  ProcedureReturn DirectoryName$+index$+".img"
EndProcedure

Procedure FirmwarePack(Parameter$)
	Protected Err
	Protected DirectoryName$ = GetFilePart(Parameter$)
	Protected WorkingDirectory$ = GetPathPart(Parameter$)
	Protected NewFileName$ = NewFileName(WorkingDirectory$, DirectoryName$)
	Protected Group$, NameCPU.s
	
	If OpenPreferences(Parameter$+"\image.cfg")
		ExaminePreferenceGroups()
		While NextPreferenceGroup() ; Пока находит группы
			Group$ = LCase(PreferenceGroupName())
			If Group$ = "list_normal"
				NameCPU = "Amlogic"
				Break
			ElseIf Group$ = "rkfw"
				NameCPU = "Rockchip"
				NewFileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
				Break
			ElseIf Group$ = "filelist"
				NameCPU = "Allwinner"
				NewFileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
				Break
			EndIf
		Wend
		ClosePreferences()
	Else
		NameCPU = "Amlogic"
	EndIf
	
	If st\Pack_Super = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\super") = 0
	    SuperPack(Parameter$+"\super")
	ElseIf st\Pack_Super = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\Image\super") = 0
	    SuperPack(Parameter$+"\Image\super")
	Else 
		PartPack(Parameter$)
	EndIf
	
	;BackUp Start
	If FileSize(WorkingDirectory$+NewFileName$)>0 And FileSize(WorkingDirectory$+DirectoryName$+".org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
		Message(Lng(148)+": "+NewFileName$+" => "+DirectoryName$+".org") ;Создаётся резервная копия оригинала
		If CopyFile(WorkingDirectory$+NewFileName$, WorkingDirectory$+DirectoryName$+".org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
	EndIf
	;BackUp Finish
	
	Message(Lng(33)+" "+NewFileName$+" "+Lng(30)) ;Выполняется сборка образа прошивки: ... Подождите...
	If NameCPU = "Amlogic"
		Err = RunConsole(bin$+"AmlImagePack.exe", "-r "+Chr(34)+DirectoryName$+"\image.cfg"+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34)+" "+Chr(34)+NewFileName$+Chr(34), WorkingDirectory$, #PB_Program_Wait) 
		Message(Lng(42)+" AmlImagePack: " + Str(Err)+ExitStr(Err)) ;Exitcode
	ElseIf NameCPU = "Rockchip"
		Err = RunConsole(bin$+"imgRePackerRK"+st\Ver, Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(42)+" ImgRePackerRK: " + Str(Err)+ExitStr(Err)) ;Exitcode
	ElseIf NameCPU = "Allwinner"
		Err = RunConsole(bin$+"imgRePacker.exe", Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(42)+" ImgRePacker: " + Str(Err)+ExitStr(Err)) ;Exitcode
	EndIf
	Message(Lng(34)+" "+NewFileName$+" "+Lng(35), 1) ;Действие по сборке прошивки: ... завершено.
	If Err=0
		Recent(Parameter$)
		If st\Get_Hash = #PB_Checkbox_Checked
			Message(Lng(161)+":md5 "+Lng(30)) ;Создание контрольной суммы
			Err = RunConsole(bin$+"md5sum.exe", "-t "+Chr(34)+NewFileName$+Chr(34)+" > "+Chr(34)+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".md5"+Chr(34)+" 2>nul", WorkingDirectory$, #PB_Program_Wait)
			If  Err = 0 And ReadFile(5, WorkingDirectory$+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".md5")
				Message("MD5 Hash: "+ReadString(5, #PB_UTF8))
				CloseFile(5)
			EndIf 
			Message(Lng(42)+" md5sum: " + Str(Err)+ExitStr(Err), 1) ;Exitcode
		Else
			DeleteFile(WorkingDirectory$+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".md5",  #PB_FileSystem_Force)
		EndIf
		
		If st\Seven_Pack = #PB_Checkbox_Checked
			Protected Seven_Command$= Chr(34)+NewFileName$+Chr(34)
			
			If FileSize(WorkingDirectory$+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".md5")>0
				Seven_Command$+" "+Chr(34)+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".md5"+Chr(34)
			EndIf
			
			If st\Size_Part <> ""
				Seven_Command$+" -v"+st\Size_Part+"m"
			EndIf
			
			DeleteFile(WorkingDirectory$+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".7z",  #PB_FileSystem_Force)
			Message(Lng(162)+": "+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".7z |"+Lng(163)+":"+st\Seven_Level+"| "+Lng(30)) ;Создание архива ... Уровень сжатия
			Err = RunConsole(bin$+"7z.exe", "a "+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".7z "+Seven_Command$+" -mx"+st\Seven_Level+" -y", WorkingDirectory$, #PB_Program_Wait)
			Message(Lng(42)+" 7z: " + Str(Err)+ExitStr(Err)) ;Exitcode 
			If Err = 0 And st\Delete_Image = #PB_Checkbox_Checked
				DeleteFile(WorkingDirectory$+GetFilePart(NewFileName$, #PB_FileSystem_NoExtension)+".md5")
				
				Message(Lng(164)+": "+NewFileName$+" "+Lng(165)+".") ;Удаляем файл образа прошивки ... в корзину
				If RecycleFile(WorkingDirectory$+NewFileName$) : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
				
			EndIf
		EndIf
		
		If st\Open_UsbTool = #PB_Checkbox_Checked And FileSize(st\Path_UsbTool)>0 And NameCPU = "Amlogic"
			RunProgram(st\Path_UsbTool, Chr(34)+WorkingDirectory$+NewFileName$+Chr(34), "")
		EndIf
	EndIf
EndProcedure

Procedure Cleaning(Parameter$, CreateFolder=1)
  Protected Err
  Protected HomeFolder$ = GetPathPart(Parameter$)+GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  If IsEmptyFolder(HomeFolder$) = 0
    Message(Lng(22)+" "+Lng(30)) ;Обнаружена папка с распакованным образом раздела, удаляем! Подождите...
    Err = RunConsole("rmdir", "/s /q "+Chr(34)+HomeFolder$+Chr(34), "", #PB_Program_Wait)
    Message(Lng(42)+" rmdir: " + Str(Err)+ExitStr(Err)) ;Exitcode
  EndIf
  If CreateFolder=1
    CreateDirectory(HomeFolder$)
  EndIf
EndProcedure

Procedure PayloadDumper(Parameter$)
	Protected Err
	Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
	Protected FileNameExpansion$ = GetFilePart(Parameter$)
	Protected WorkingDirectory$ = GetPathPart(Parameter$)
	Protected ExtractionPath$ = WorkingDirectory$+DirectoryName$
	;If IsWin64()
		;Err = RunConsole(bin$+"x64\"+"otadump.exe", Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		;Message(Lng(42)+" otadump: " + Str(Err)+ExitStr(Err))		 ;Exitcode 
		;Message(Lng(132)+" "+FileNameExpansion$+" "+Lng(35), 1)		 ;Действие по распаковки файла: ... завершено.
	;Else
		Cleaning(Parameter$)
		Message(Lng(131)+" "+FileNameExpansion$+" "+Lng(30))		;Выполняется распаковка файла: ... Подождите...
		Err = RunConsole(bin$+"payload_dumper.exe", "--out "+Chr(34)+DirectoryName$+Chr(34)+" "+Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(42)+" payload_dumper: " + Str(Err)+ExitStr(Err)) ;Exitcode 
		Message(Lng(132)+" "+FileNameExpansion$+" "+Lng(35), 1)		 ;Действие по распаковки файла: ... завершено.
		If Err=0 : PartUnpack(ExtractionPath$) : EndIf
	;EndIf
EndProcedure 

Procedure PartUnpack(Parameter$)
	;Debug Parameter$

	If st\Unpack_System = #PB_Checkbox_Checked
		;---- system
		If FileSize(Parameter$+"\system.img")>0 : MainUnpack(Parameter$+"\system.img") : EndIf
		If FileSize(Parameter$+"\Image\system.img")>0 : MainUnpack(Parameter$+"\Image\system.img") : EndIf
		If FileSize(Parameter$+"\system.PARTITION")>0 : MainUnpack(Parameter$+"\system.PARTITION") : EndIf
		If FileSize(Parameter$+"\system.fex")>0 : MainUnpack(Parameter$+"\system.fex") : EndIf
		;---- system_a   system_b
		If FileSize(Parameter$+"\system_a.img")>0 : MainUnpack(Parameter$+"\system_a.img") : EndIf
		If FileSize(Parameter$+"\system_b.img")>0 : MainUnpack(Parameter$+"\system_b.img") : EndIf
		If FileSize(Parameter$+"\Image\system_a.img")>0 : MainUnpack(Parameter$+"\Image\system_a.img") : EndIf
		If FileSize(Parameter$+"\Image\system_b.img")>0 : MainUnpack(Parameter$+"\Image\system_b.img") : EndIf
		If FileSize(Parameter$+"\system_a.PARTITION")>0 : MainUnpack(Parameter$+"\system_a.PARTITION") : EndIf
		If FileSize(Parameter$+"\system_b.PARTITION")>0 : MainUnpack(Parameter$+"\system_b.PARTITION") : EndIf
		If FileSize(Parameter$+"\system_a.fex")>0 : MainUnpack(Parameter$+"\system_a.fex") : EndIf
		If FileSize(Parameter$+"\system_b.fex")>0 : MainUnpack(Parameter$+"\system_b.fex") : EndIf
		;---- system_ext_a     system_ext_b
		If FileSize(Parameter$+"\system_ext_a.img")>0 : MainUnpack(Parameter$+"\system_ext_a.img") : EndIf
		If FileSize(Parameter$+"\system_ext_b.img")>0 : MainUnpack(Parameter$+"\system_ext_b.img") : EndIf
		If FileSize(Parameter$+"\Image\system_ext_a.img")>0 : MainUnpack(Parameter$+"\Image\system_ext_a.img") : EndIf
		If FileSize(Parameter$+"\Image\system_ext_b.img")>0 : MainUnpack(Parameter$+"\Image\system_ext_b.img") : EndIf
		If FileSize(Parameter$+"\system_ext_a.PARTITION")>0 : MainUnpack(Parameter$+"\system_ext_a.PARTITION") : EndIf
		If FileSize(Parameter$+"\system_ext_b.PARTITION")>0 : MainUnpack(Parameter$+"\system_ext_b.PARTITION") : EndIf
		If FileSize(Parameter$+"\system_ext_a.fex")>0 : MainUnpack(Parameter$+"\system_ext_a.fex") : EndIf
		If FileSize(Parameter$+"\system_ext_b.fex")>0 : MainUnpack(Parameter$+"\system_ext_b.fex") : EndIf
	EndIf
	
	If st\Unpack_Vendor = #PB_Checkbox_Checked
		;---- vendor
		If FileSize(Parameter$+"\vendor.img")>0 : MainUnpack(Parameter$+"\vendor.img") : EndIf
		If FileSize(Parameter$+"\Image\vendor.img")>0 : MainUnpack(Parameter$+"\Image\vendor.img") : EndIf
		If FileSize(Parameter$+"\vendor.PARTITION")>0 : MainUnpack(Parameter$+"\vendor.PARTITION") : EndIf
		If FileSize(Parameter$+"\vendor.fex")>0 : MainUnpack(Parameter$+"\vendor.fex") : EndIf
		;---- vendor_a   vendor_b
		If FileSize(Parameter$+"\vendor_a.img")>0 : MainUnpack(Parameter$+"\vendor_a.img") : EndIf
		If FileSize(Parameter$+"\vendor_b.img")>0 : MainUnpack(Parameter$+"\vendor_b.img") : EndIf
		If FileSize(Parameter$+"\Image\vendor_a.img")>0 : MainUnpack(Parameter$+"\Image\vendor_a.img") : EndIf
		If FileSize(Parameter$+"\Image\vendor_b.img")>0 : MainUnpack(Parameter$+"\Image\vendor_b.img") : EndIf
		If FileSize(Parameter$+"\vendor_a.PARTITION")>0 : MainUnpack(Parameter$+"\vendor_a.PARTITION") : EndIf
		If FileSize(Parameter$+"\vendor_b.PARTITION")>0 : MainUnpack(Parameter$+"\vendor_b.PARTITION") : EndIf
		If FileSize(Parameter$+"\vendor_a.fex")>0 : MainUnpack(Parameter$+"\vendor_a.fex") : EndIf
		If FileSize(Parameter$+"\vendor_b.fex")>0 : MainUnpack(Parameter$+"\vendor_b.fex") : EndIf
	EndIf
	
	If st\Unpack_Product = #PB_Checkbox_Checked
		;---- product
		If FileSize(Parameter$+"\product.img")>0 : MainUnpack(Parameter$+"\product.img") : EndIf
		If FileSize(Parameter$+"\Image\product.img")>0 : MainUnpack(Parameter$+"\Image\product.img") : EndIf
		If FileSize(Parameter$+"\product.PARTITION")>0 : MainUnpack(Parameter$+"\product.PARTITION") : EndIf
		If FileSize(Parameter$+"\product.fex")>0 : MainUnpack(Parameter$+"\product.fex") : EndIf
		;---- product_a   product_b
		If FileSize(Parameter$+"\product_a.img")>0 : MainUnpack(Parameter$+"\product_a.img") : EndIf
		If FileSize(Parameter$+"\product_b.img")>0 : MainUnpack(Parameter$+"\product_b.img") : EndIf
		If FileSize(Parameter$+"\Image\product_a.img")>0 : MainUnpack(Parameter$+"\Image\product_a.img") : EndIf
		If FileSize(Parameter$+"\Image\product_b.img")>0 : MainUnpack(Parameter$+"\Image\product_b.img") : EndIf
		If FileSize(Parameter$+"\product_a.PARTITION")>0 : MainUnpack(Parameter$+"\product_a.PARTITION") : EndIf
		If FileSize(Parameter$+"\product_b.PARTITION")>0 : MainUnpack(Parameter$+"\product_b.PARTITION") : EndIf
		If FileSize(Parameter$+"\product_a.fex")>0 : MainUnpack(Parameter$+"\product_a.fex") : EndIf
		If FileSize(Parameter$+"\product_b.fex")>0 : MainUnpack(Parameter$+"\product_b.fex") : EndIf	
	EndIf
	
	If st\Unpack_Odm = #PB_Checkbox_Checked
		;---- odm
		If FileSize(Parameter$+"\odm.img")>0 : MainUnpack(Parameter$+"\odm.img") : EndIf
		If FileSize(Parameter$+"\Image\odm.img")>0 : MainUnpack(Parameter$+"\Image\odm.img") : EndIf
		If FileSize(Parameter$+"\odm.PARTITION")>0 : MainUnpack(Parameter$+"\odm.PARTITION") : EndIf
		If FileSize(Parameter$+"\odm.fex")>0 : MainUnpack(Parameter$+"\odm.fex") : EndIf
		;---- odm_a   odm_b
		If FileSize(Parameter$+"\odm_a.img")>0 : MainUnpack(Parameter$+"\odm_a.img") : EndIf
		If FileSize(Parameter$+"\odm_b.img")>0 : MainUnpack(Parameter$+"\odm_b.img") : EndIf
		If FileSize(Parameter$+"\Image\odm_a.img")>0 : MainUnpack(Parameter$+"\Image\odm_a.img") : EndIf
		If FileSize(Parameter$+"\Image\odm_b.img")>0 : MainUnpack(Parameter$+"\Image\odm_b.img") : EndIf
		If FileSize(Parameter$+"\odm_a.PARTITION")>0 : MainUnpack(Parameter$+"\odm_a.PARTITION") : EndIf
		If FileSize(Parameter$+"\odm_b.PARTITION")>0 : MainUnpack(Parameter$+"\odm_b.PARTITION") : EndIf
		If FileSize(Parameter$+"\odm_a.fex")>0 : MainUnpack(Parameter$+"\odm_a.fex") : EndIf
		If FileSize(Parameter$+"\odm_b.fex")>0 : MainUnpack(Parameter$+"\odm_b.fex") : EndIf
	EndIf
	
	
	; 	If NameCPU = "Amlogic"
	;         If st\Unpack_System = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\system.PARTITION")>0
	;           MainUnpack(ExtractionPath$+"\system.PARTITION")
	;         EndIf
	;         If st\Unpack_Vendor = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\vendor.PARTITION")>0
	;           MainUnpack(ExtractionPath$+"\vendor.PARTITION")
	;         EndIf
	;         If st\Unpack_Product = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\product.PARTITION")>0
	;           MainUnpack(ExtractionPath$+"\product.PARTITION")
	;         EndIf
	;         If st\Unpack_Odm = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\odm.PARTITION")>0
	;           MainUnpack(ExtractionPath$+"\odm.PARTITION")
	;         EndIf
	;       ElseIf NameCPU = "Rockchip"
	;         If st\Unpack_System = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\Image\system.img")>0
	;           MainUnpack(ExtractionPath$+"\Image\system.img")
	;         EndIf
	;         If st\Unpack_Vendor = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\Image\vendor.img")>0
	;           MainUnpack(ExtractionPath$+"\Image\vendor.img")
	;         EndIf
	;       ElseIf NameCPU = "Allwinner"  
	;         If st\Unpack_System = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\system.fex")>0
	;           MainUnpack(ExtractionPath$+"\system.fex")
	;         EndIf
	;         If st\Unpack_Vendor = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\vendor.fex")>0
	;           MainUnpack(ExtractionPath$+"\vendor.fex")
	;         EndIf
	;       EndIf
	;       
	;       If st\Open_Folder = #PB_Checkbox_Checked
	;         RunProgram("file://"+ExtractionPath$)
	;         ;RunProgram("explorer.exe", "/n,/root,"+ExtractionPath$, "")
	;         ;RunProgram("file://c:\git\")
	;         ;ShellExecute_(0,"explore",ExtractionPath$,0,0,#SW_SHOW)
	;         ;ShellExecute_(0,"explore","C:\Users\CryptoNick\Desktop\Ic85.6.1.12",0,0,#SW_SHOW)
	;         ;ShellExecute_(0,"open","Explorer.exe","/Select," + ExtractionPath$,0,#SW_SHOWNORMAL)
	;       EndIf
	;     EndIf
	; 	
	; 	
	; 	If st\Unpack_System = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\system."+Expansion$)>0
	; 		MainUnpack(ExtractionPath$+"\system."+Expansion$)
	; 	EndIf
	; 	If st\Unpack_Vendor = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\vendor."+Expansion$)>0
	; 		MainUnpack(ExtractionPath$+"\vendor."+Expansion$)
	; 	EndIf
	; 	If st\Unpack_Product = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\product."+Expansion$)>0
	; 		MainUnpack(ExtractionPath$+"\product."+Expansion$)
	; 	EndIf
	; 	If st\Unpack_Odm = #PB_Checkbox_Checked And FileSize(ExtractionPath$+"\odm."+Expansion$)>0
	; 		MainUnpack(ExtractionPath$+"\odm."+Expansion$)
	; 	EndIf
	
	If st\Open_Folder = #PB_Checkbox_Checked
		RunProgram("file://"+Parameter$)
	EndIf
EndProcedure 

Procedure PartPack(Parameter$)
	
	If st\Pack_System = #PB_Checkbox_Checked 
		If IsEmptyFolder(Parameter$+"\system") = 0 : MainPack(Parameter$+"\system") : EndIf
		If IsEmptyFolder(Parameter$+"\Image\system") = 0 : MainPack(Parameter$+"\Image\system") : EndIf
		If IsEmptyFolder(Parameter$+"\system_a") = 0 : MainPack(Parameter$+"\system_a") : EndIf
		If IsEmptyFolder(Parameter$+"\system_b") = 0 : MainPack(Parameter$+"\system_b") : EndIf
		If IsEmptyFolder(Parameter$+"\system_ext") = 0 : MainPack(Parameter$+"\system_ext") : EndIf
		If IsEmptyFolder(Parameter$+"\system_ext_a") = 0 : MainPack(Parameter$+"\system_ext_a") : EndIf
		If IsEmptyFolder(Parameter$+"\system_ext_b") = 0 : MainPack(Parameter$+"\system_ext_b") : EndIf
	EndIf
	
	If st\Pack_Vendor = #PB_Checkbox_Checked
		If IsEmptyFolder(Parameter$+"\vendor") = 0 : MainPack(Parameter$+"\vendor") : EndIf
		If IsEmptyFolder(Parameter$+"\Image\vendor") = 0 : MainPack(Parameter$+"\Image\vendor") : EndIf
		If IsEmptyFolder(Parameter$+"\vendor_a") = 0 : MainPack(Parameter$+"\vendor_a") : EndIf
		If IsEmptyFolder(Parameter$+"\vendor_b") = 0 : MainPack(Parameter$+"\vendor_b") : EndIf
	EndIf
	
	If st\Pack_Product = #PB_Checkbox_Checked 
		If IsEmptyFolder(Parameter$+"\product") = 0 : MainPack(Parameter$+"\product") : EndIf
		If IsEmptyFolder(Parameter$+"\product_a") = 0 : MainPack(Parameter$+"\product_a") : EndIf
		If IsEmptyFolder(Parameter$+"\product_b") = 0 : MainPack(Parameter$+"\product_b") : EndIf
	EndIf
	
	If st\Pack_Odm = #PB_Checkbox_Checked
		If IsEmptyFolder(Parameter$+"\odm") = 0 : MainPack(Parameter$+"\odm") : EndIf
		If IsEmptyFolder(Parameter$+"\odm_a") = 0 : MainPack(Parameter$+"\odm_a") : EndIf
		If IsEmptyFolder(Parameter$+"\odm_b") = 0 : MainPack(Parameter$+"\odm_b") : EndIf
	EndIf
	
EndProcedure

Procedure ZipUnpack(Parameter$)
  Protected Err, res$
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected ExtractionPath$ = WorkingDirectory$+DirectoryName$
  Cleaning(Parameter$)
  Message(Lng(32)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка файла обновления: Подождите...
  Err = RunConsole(bin$+"7z.exe", "x "+Chr(34)+FileNameExpansion$+Chr(34)+" -o"+Chr(34)+DirectoryName$+Chr(34)+" -y", WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" 7z: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  
  If Err=0
    If ExamineDirectory(0, WorkingDirectory$+DirectoryName$, "") And CreateFile(1, WorkingDirectory$+DirectoryName$+"\zipFileList.cfg")
      While NextDirectoryEntry(0)
        res$ = DirectoryEntryName(0)
        If res$ = ".." Or res$ = "." Or res$ = "zipFileList.cfg" : Continue : EndIf
        If FileSize(WorkingDirectory$+DirectoryName$+"\"+res$) = -2 : res$+"\" : EndIf
        WriteStringN(1, res$)
      Wend
      FinishDirectory(0)
      CloseFile(1)
    EndIf
    Recent(ExtractionPath$)
    Recent(Parameter$)
    
    If st\Unpack_Super = #PB_Checkbox_Checked
    	If FileSize(ExtractionPath$+"\super.PARTITION")>0 : SuperUnpack(ExtractionPath$+"\super.PARTITION") 
    	ElseIf FileSize(ExtractionPath$+"\super.fex")>0 : SuperUnpack(ExtractionPath$+"\super.fex") 
    	ElseIf FileSize(ExtractionPath$+"\super.img")>0 : SuperUnpack(ExtractionPath$+"\super.img")
    	ElseIf FileSize(ExtractionPath$+"\Image\super.img")>0 : SuperUnpack(ExtractionPath$+"\Image\super.img")
    	EndIf
    EndIf
    
    If st\Unpack_System = #PB_Checkbox_Checked
      If FileSize(ExtractionPath$+"\system.new.dat")>0
        DatUnpack(ExtractionPath$+"\system.new.dat")
      ElseIf FileSize(ExtractionPath$+"\system.new.dat.br")>0
        BrUnpack(ExtractionPath$+"\system.new.dat.br")
      EndIf
    EndIf
    If st\Unpack_Vendor = #PB_Checkbox_Checked 
      If FileSize(ExtractionPath$+"\vendor.new.dat")>0
        DatUnpack(ExtractionPath$+"\vendor.new.dat")
      ElseIf FileSize(ExtractionPath$+"\vendor.new.dat.br")>0
        BrUnpack(ExtractionPath$+"\vendor.new.dat.br")
      EndIf
    EndIf
    If st\Unpack_Product = #PB_Checkbox_Checked 
      If FileSize(ExtractionPath$+"\product.new.dat")>0
        DatUnpack(ExtractionPath$+"\product.new.dat")
      ElseIf FileSize(ExtractionPath$+"\product.new.dat.br")>0
        BrUnpack(ExtractionPath$+"\product.new.dat.br")
      EndIf
    EndIf
    If st\Unpack_Odm = #PB_Checkbox_Checked 
      If FileSize(ExtractionPath$+"\odm.new.dat")>0
        DatUnpack(ExtractionPath$+"\odm.new.dat")
      ElseIf FileSize(ExtractionPath$+"\odm.new.dat.br")>0
        BrUnpack(ExtractionPath$+"\odm.new.dat.br")
      EndIf
    EndIf
  EndIf
  Message(Lng(36)+" "+FileNameExpansion$+" "+Lng(35), 1)     ;Действие по распаковки файла обновления: ... завершено.
  If st\Open_Folder = #PB_Checkbox_Checked : RunProgram("file://"+ExtractionPath$) : EndIf
EndProcedure

Procedure ZipPack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected Exp$ = ".zip"
  
  If st\Pack_Super = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\super") = 0
  	SuperPack(Parameter$+"\super")
  ElseIf st\Pack_Super = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\Image\super") = 0
  	SuperPack(Parameter$+"\Image\super")
  EndIf

  If st\Pack_System = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\system") = 0
    MainPack(Parameter$+"\system")
  EndIf
  If st\Pack_Vendor = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\vendor") = 0
    MainPack(Parameter$+"\vendor")
  EndIf
  If st\Pack_Product = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\product") = 0
    MainPack(Parameter$+"\product")
  EndIf
  If st\Pack_Odm = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\odm") = 0
    MainPack(Parameter$+"\odm")
  EndIf
  
  If FileSize(Parameter$+Exp$)>0
    Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+Exp$+".bak") ;Переименовываем ...в...
    DeleteFile(Parameter$+Exp$+".bak", #PB_FileSystem_Force)
    If RenameFile(Parameter$+Exp$, Parameter$+Exp$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  Message(Lng(101)+" "+DirectoryName$+Exp$+" "+Lng(30)) ;Выполняется сборка файла обновления: ... Подождите...
  Err = RunConsole(bin$+"7z.exe", "a -tzip "+Chr(34)+Parameter$+"~"+Exp$+Chr(34)+" @zipFileList.cfg -mx"+st\Compress_Level, Parameter$, #PB_Program_Wait)
  Message(Lng(42)+" 7z: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  If Err=0 : Recent(Parameter$) : EndIf
  If Err=0 And st\Signature = #PB_Checkbox_Checked And CheckJava()=0
    Message(Lng(102)+" "+DirectoryName$+Exp$) ;Выполняется подпись файла:
    Err = RunConsole("java", "-jar "+Chr(34)+"zipsigner.jar"+Chr(34)+" "+Chr(34)+"testkey.x509.pem"+Chr(34)+" "+Chr(34)+"testkey.pk8"+Chr(34)+" "+Chr(34)+Parameter$+"~"+Exp$+Chr(34)+" "+Chr(34)+Parameter$+Exp$+Chr(34), bin$, #PB_Program_Wait)
    Message(Lng(42)+" zipsigner: " + Str(Err)+ExitStr(Err)) ;Exitcode 
    If Err=0
      DeleteFile(Parameter$+"~"+Exp$, #PB_FileSystem_Force)
    Else
      RenameFile(Parameter$+"~"+Exp$, Parameter$+Exp$)
    EndIf
  Else
    RenameFile(Parameter$+"~"+Exp$, Parameter$+Exp$)
  EndIf
  Message(Lng(103)+" "+DirectoryName$+Exp$+" "+Lng(35), 1) ;Действие по сборке файла обновления: ... завершено.
EndProcedure

Procedure SevenZipUnpack(Parameter$)
  Protected Err, Seven_Command$, res$
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  
  If st\Subfolder = #PB_Checkbox_Checked
    If GetExtensionPart(Parameter$) = "001"
      DirectoryName$=GetFilePart(DirectoryName$, #PB_FileSystem_NoExtension)
  EndIf
    Cleaning(WorkingDirectory$+FileNameExpansion$)
    Seven_Command$= " -o"+Chr(34)+DirectoryName$+Chr(34)
  EndIf
  
  Err = RunConsole(bin$+"7z.exe", "x "+Chr(34)+FileNameExpansion$+Chr(34)+Seven_Command$+" -y", WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" 7z: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  If Err=0
    
    If st\Seven_UnPack = #PB_Checkbox_Checked And ExamineDirectory(2, WorkingDirectory$+DirectoryName$, "") ; Распаковывать содержимое, после извлечения из архива
      While NextDirectoryEntry(2)
        res$ = DirectoryEntryName(2)
        If res$ = ".." Or res$ = "." : Continue : EndIf
        ListFill(WorkingDirectory$+DirectoryName$+"\"+res$)
      Wend
      FinishDirectory(2)
    EndIf
    
    If st\Delete_Archive = #PB_Checkbox_Checked
      Message("Удаляем файл архива: "+FileNameExpansion$+" в корзину.")
      If RecycleFile(Parameter$) : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
    EndIf
    
  EndIf
  
EndProcedure

Procedure CheckJava()
  Protected Err = RunConsole("java", " -version", "", #PB_Program_Wait)
  If Err<>0
    Message(">< !!! "+Lng(149)+": https://www.java.com  "+Lng(150),1) ;Please install Java from the official website ... and reboot the computer
  EndIf
  ProcedureReturn Err
EndProcedure

Procedure ApkUnpack(Parameter$)
  Protected Err
  Protected FileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  ;Protected StartTime, ElapsedTime
  If CheckJava() = 0
    ;StartTime = ElapsedMilliseconds()
    If st\Framework= #PB_Checkbox_Checked And FileSize(bin$+"framework\framework-res.apk")>0
      Message(Lng(126)+" framework-res.apk") ;Установка фрейворка: framework-res.apk.
      RunConsole("java", "-jar "+Chr(34)+"apktool.jar"+Chr(34)+" If -p "+Chr(34)+RTrim(bin$,"\")+Chr(34)+" "+Chr(34)+"framework\framework-res.apk"+Chr(34), bin$, #PB_Program_Wait)
    EndIf
    Message(Lng(121)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется декодирование приложения: Подождите...
    Err = RunConsole("java", "-jar "+Chr(34)+bin$+"apktool.jar"+Chr(34)+" d -f -b --keep-broken-res -s -o "+Chr(34)+FileName$+Chr(34)+" -p "+Chr(34)+RTrim(bin$,"\")+Chr(34)+" "+Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" apktool: " + Str(Err)+ExitStr(Err)) ;Exitcode
    If Err<>0
      ;Message("")
    EndIf
    DeleteFile(bin$+"1.apk", #PB_FileSystem_Force)
    ;ElapsedTime = (ElapsedMilliseconds()-StartTime);/1000
    ;Message(Str(ElapsedTime))
    Message(Lng(122)+" "+FileNameExpansion$+" "+Lng(35), 1)     ;Действие по декодированию приложения: ... завершено.
  EndIf
EndProcedure

Procedure ApkPack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$)
  Protected Exp$ = ".apk"
  Protected FileNameExpansion$ = DirectoryName$+Exp$
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  If CheckJava() = 0
    ;Сделать резервную копию apk bak
    If FileSize(Parameter$+Exp$)>0
      Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+Exp$+".bak") ;Переименовываем ...в...
      DeleteFile(Parameter$+Exp$+".bak", #PB_FileSystem_Force)
      If RenameFile(Parameter$+Exp$, Parameter$+Exp$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
    EndIf
    If st\Framework= #PB_Checkbox_Checked And FileSize(bin$+"framework\framework-res.apk")>0
      Message(Lng(126)+" framework-res.apk") ;Установка фрейворка: framework-res.apk
      RunConsole("java", "-jar "+Chr(34)+"apktool.jar"+Chr(34)+" If -p "+Chr(34)+RTrim(bin$,"\")+Chr(34)+" "+Chr(34)+"framework\framework-res.apk"+Chr(34), bin$, #PB_Program_Wait)
    EndIf
    Message(Lng(123)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется сборка приложения: Подождите...
    ;java  -jar "bin\apktool_2.5.0.jar" b  -p "bin\framework" "_INPUT_APK\CastReceiver" 
    ;java  -Xms128m -jar apktool.jar --force --verbose --output recompiled.apk b CastReceiver1/3
    Err = RunConsole("java", "-jar "+Chr(34)+bin$+"apktool.jar"+Chr(34)+" b -p "+Chr(34)+RTrim(bin$,"\")+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34)+" -o "+Chr(34)+DirectoryName$+"~~"+Exp$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" apktool: " + Str(Err)+ExitStr(Err)) ;Exitcode 
    If Err=0                                              ;apktool
      If st\SignatureApk = #PB_Checkbox_Checked
        ;java  -jar "bin\signapk.jar" -w "bin\testkey.x509.pem" "bin\testkey.pk8" "bin\temp\CastReceiver_.apk" "bin\temp\CastReceiver__.apk"  
        Message(Lng(102)+" "+DirectoryName$+Exp$) ;Выполняется подпись файла:
        Err = RunConsole("java", "-jar "+Chr(34)+"zipsigner.jar"+Chr(34)+" "+Chr(34)+"testkey.x509.pem"+Chr(34)+" "+Chr(34)+"testkey.pk8"+Chr(34)+" "+Chr(34)+Parameter$+"~~"+Exp$+Chr(34)+" "+Chr(34)+Parameter$+"~"+Exp$+Chr(34), bin$, #PB_Program_Wait)
        Message(Lng(42)+" zipsigner: " + Str(Err)+ExitStr(Err)) ;Exitcode
      Else
        RenameFile(Parameter$+"~~"+Exp$, Parameter$+"~"+Exp$)
      EndIf
      If Err=0 ;zipsigner or apktool
        If st\Alignment = #PB_Checkbox_Checked
          Message(Lng(125)+" "+DirectoryName$+Exp$) ;Выполняется выравнивание файла:
                                                    ;zipalign  -f -p 4 "_INPUT_APK\CastReceiver.apk" "_OUT_APK\CastReceiver.apk"
          Err = RunConsole(bin$+"zipalign.exe", "-f -p 4 "+Chr(34)+DirectoryName$+"~"+Exp$+Chr(34)+" "+Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
          Message(Lng(42)+" zipalign: " + Str(Err)+ExitStr(Err)) ;Exitcode
          If Err<>0                                              ;zipalign
            RenameFile(Parameter$+Exp$+".bak", Parameter$+Exp$)
          EndIf 
        Else
          RenameFile(Parameter$+"~"+Exp$, Parameter$+Exp$)
        EndIf
      Else
        RenameFile(Parameter$+Exp$+".bak", Parameter$+Exp$)
      EndIf
    Else
      RenameFile(Parameter$+Exp$+".bak", Parameter$+Exp$)
    EndIf
    
    If FileSize(Parameter$+Exp$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
      DeleteFile(Parameter$+Exp$+".bak")
    EndIf
    
    DeleteFile(Parameter$+"~~"+Exp$, #PB_FileSystem_Force)
    DeleteFile(Parameter$+"~"+Exp$, #PB_FileSystem_Force)
    DeleteFile(bin$+"1.apk", #PB_FileSystem_Force)
    Message(Lng(124)+" "+FileNameExpansion$+" "+Lng(35), 1);Действие по сборке приложения: ... завершено.
  EndIf
EndProcedure

Procedure LogoUnpack(Parameter$)
    Protected Err, res$, Sign$
    Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
    Protected FileNameExpansion$ = GetFilePart(Parameter$)
    Protected WorkingDirectory$ = GetPathPart(Parameter$)
    Protected Target$ = WorkingDirectory$+DirectoryName$
    Cleaning(Parameter$)
    Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
    Err = RunConsole(bin$+"imgpack.exe", "-d "+Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" ImgPack: " + Str(Err)+ExitStr(Err)) ;Exitcode 
    If Err=0
        Recent(Target$)
        Recent(Parameter$)
;         If ExamineDirectory(0, Target$, "*")
;             While NextDirectoryEntry(0)
;                 res$ = DirectoryEntryName(0)
;                 If res$ = ".." Or res$ = "." : Continue : EndIf
;                 If GetExtensionPart(Target$+"\"+res$) = ""
;                     Sign$ = CheckSignature(Target$+"\"+res$)
;                     If Sign$ = "Gzip"
;                         RenameFile(Target$+"\"+res$, Target$+"\"+res$+".gz")
;                     ElseIf Sign$ = "bmp"
;                         RenameFile(Target$+"\"+res$, Target$+"\"+res$+".bmp") 
;                     EndIf
;                 EndIf
;                 
;             Wend
;             FinishDirectory(0)
;         EndIf
    EndIf
    Message(Lng(38)+" "+FileNameExpansion$+" "+Lng(35), 1);Действие по распаковки образа раздела: ... завершено.
EndProcedure

Procedure LogoPack(Parameter$)
  Protected Err, Exp$
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  If FileSize(Parameter$+".PARTITION")>0
    Exp$ =".PARTITION"
  Else
    Exp$ =".img"
  EndIf
  
  If FileSize(Parameter$+Exp$)>0 And FileSize(Parameter$+".org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+DirectoryName$+Exp$+" => "+DirectoryName$+".org") ;Создаётся резервная копия оригинала
    If CopyFile(Parameter$+Exp$, Parameter$+".org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(Parameter$+Exp$)>0
    Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+".bak") ;Переименовываем ...в...
    DeleteFile(Parameter$+".bak", #PB_FileSystem_Force)
    If RenameFile(Parameter$+Exp$, Parameter$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  Message(Lng(39)+" "+DirectoryName$+Exp$+" "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"imgpack.exe", "-r "+Chr(34)+DirectoryName$+Chr(34)+" "+Chr(34)+DirectoryName$+Exp$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" ImgPack: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  If Err=0 : Recent(Parameter$) : EndIf
  If Err <> 0 And FileSize(Parameter$+".bak")>0
    Message(Lng(70)+" "+DirectoryName$+".bak "+Lng(87)+" "+DirectoryName$+Exp$) ;Переименовываем ...в...
    DeleteFile(Parameter$+Exp$, #PB_FileSystem_Force)
    If RenameFile(Parameter$+".bak", Parameter$+Exp$)>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  ElseIf FileSize(Parameter$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(Parameter$+".bak")
  EndIf
  Message(Lng(40)+" "+DirectoryName$+Exp$+" "+Lng(35), 1)    ;Действие по сборке образа раздела: ... завершено."
EndProcedure

Procedure ImgRKUnpack(Parameter$)
    Protected Err
    Protected FileNameExpansion$ = GetFilePart(Parameter$)
    Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
    Err = RunConsole(bin$+"imgRePackerRK"+st\Ver+".exe", Chr(34)+Parameter$+Chr(34), "", #PB_Program_Wait)
    Message(Lng(42)+" ImgRePackerRK: " + Str(Err)+ExitStr(Err)) ;Exitcode 
    If Err=0 : Recent(Parameter$+".dump") : Recent(Parameter$) : EndIf
    Message(Lng(38)+" "+FileNameExpansion$+" "+Lng(35), 1) ;Действие по распаковки образа раздела: ... завершено.
EndProcedure

Procedure ImgRKPack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected Config$ = GetPathPart(Parameter$)+DirectoryName$+".cfg"
  Message(Lng(39)+" "+DirectoryName$+" "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"imgRePackerRK"+st\Ver, Chr(34)+Parameter$+Chr(34)+" "+Chr(34)+Config$+Chr(34), "", #PB_Program_Wait)
  Message(Lng(42)+" ImgRePackerRK: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Err=0 : Recent(Parameter$) : EndIf
  Message(Lng(40)+" "+DirectoryName$+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
EndProcedure

Procedure ImgAllUnpack(Parameter$)
  Protected Err
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"imgRePacker", Chr(34)+Parameter$+Chr(34), "", #PB_Program_Wait)
  Message(Lng(42)+" ImgRePacker: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  If Err=0 : Recent(Parameter$+".dump") : Recent(Parameter$) : EndIf
  Message(Lng(38)+" "+FileNameExpansion$+" "+Lng(35), 1) ;Действие по распаковки образа раздела: ... завершено.
EndProcedure

Procedure ImgAllPack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected Config$ = GetPathPart(Parameter$)+DirectoryName$+".cfg"
  Message(Lng(39)+" "+DirectoryName$+" "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"imgRePacker", Chr(34)+Parameter$+Chr(34)+" "+Chr(34)+Config$+Chr(34), "", #PB_Program_Wait)
  Message(Lng(42)+" ImgRePacker: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Err=0 : Recent(Parameter$) : EndIf
  Message(Lng(40)+" "+DirectoryName$+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
EndProcedure

Procedure ImgPacUnpack(Parameter$)
  Protected Err
  Protected FileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected ExtractionPath$ = GetPathPart(Parameter$)+FileName$
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  If CheckJava() = 0
    If IsEmptyFolder(ExtractionPath$) = 0
      Message(Lng(31)+" "+Lng(30)) ;Обнаружена папка с распакованным образом прошивки, удаляем! Подождите...
      Err = RunConsole("rmdir", "/q /s "+Chr(34)+ExtractionPath$+Chr(34), "", #PB_Program_Wait)
      Message(Lng(42)+" rmdir: " + Str(Err)+ExitStr(Err)) ;Exitcode
    EndIf
    
    Message(Lng(32)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа прошивки: Подождите...
    Err = RunConsole("java", "-jar "+Chr(34)+bin$+"PacExtractor.jar"+Chr(34)+" "+Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+ExtractionPath$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" PacExtractor: " + Str(Err)+ExitStr(Err)) ;Exitcode
    Message(Lng(36)+" "+FileNameExpansion$+" "+Lng(35), 1)     ;Действие по распаковки прошивки: ... завершено.
    If IsEmptyFolder(ExtractionPath$) = 1                      ;Если папка пуста, удаляем
      DeleteDirectory(ExtractionPath$, "")
    Else
      Recent(Parameter$)
      If st\Open_Folder = #PB_Checkbox_Checked
        RunProgram("file://"+ExtractionPath$)
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure DtbSingleUnpack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Cleaning(Parameter$)
  Message(Lng(37)+" "+FileNameExpansion$+" |Single| "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"dtc.exe", "-I dtb -O dts -o "+Chr(34)+DirectoryName$+Chr(34)+"\single.dts "+Chr(34)+FileNameExpansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  If FileSize(WorkingDirectory$+DirectoryName$+"\single.dts")>0 : Message("Extract: single.dts") : EndIf
  Message(Lng(42)+" dtc: " + Str(Err)+ExitStr(Err)) ;Exitcode
EndProcedure

Procedure DtbMultiUnpack(Parameter$,Sign$)
  Protected Err, res$, resdts$
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected Target$ = WorkingDirectory$+DirectoryName$
  
  Cleaning(Parameter$)
  
  If Sign$ = "Gzip"
    CopyFile(Parameter$, Parameter$+".tmp") ;Копируем оригинал со сжатинм Gzip
    Message(Lng(37)+" "+FileNameExpansion$+" |Gzip| "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
    RenameFile(Parameter$, Parameter$+".gz")
    Err = RunConsole(bin$+"gzip.exe", "-d "+Chr(34)+Parameter$+".gz"+Chr(34), WorkingDirectory$, #PB_Program_Wait) ;распаковывает в тот же файл!
    ;Message(Lng(42)+" gzip: " + Str(Err)+ExitStr(Err)) ;Exitcode 
    RenameFile(Parameter$+".gz", Parameter$)
  Else
    Message(Lng(37)+" "+FileNameExpansion$+" |Multi| "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  EndIf
  
  Err = RunConsole(bin$+"dtbSplit.exe", Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34)+"\", WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" dtbSplit: " + Str(Err)+ExitStr(Err),1) ;Exitcode  
  
  If Err = 0 And ExamineDirectory(0, Target$, "*.dtb") ; Конвертер dtb в dts
    While NextDirectoryEntry(0)
      res$ = DirectoryEntryName(0)
      If res$ = ".." Or res$ = "." : Continue : EndIf
      resdts$ = GetFilePart(res$, #PB_FileSystem_NoExtension)+".dts"
      Err + RunConsole(bin$+"dtc.exe", "-I dtb -O dts -o "+Chr(34)+resdts$+Chr(34)+" "+Chr(34)+res$+Chr(34), Target$, #PB_Program_Wait)
      If FileSize(Target$+"\"+resdts$)>0 : Message("Extract: "+resdts$) : EndIf
      DeleteFile(Target$+"\"+res$, #PB_FileSystem_Force)
    Wend
    FinishDirectory(0)
    Message(Lng(42)+" dtc: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  EndIf
  
  If FileSize(Parameter$+".tmp")>0 ; Возвращаем оригинал со сжатинм Gzip
    DeleteFile(Parameter$, #PB_FileSystem_Force)
    RenameFile(Parameter$+".tmp", Parameter$)
  EndIf
  
  If Err=0 : Recent(Target$) : Recent(Parameter$) : EndIf
  
  Message(Lng(38)+" "+FileNameExpansion$+" "+Lng(35), 1) ;Действие по распаковки образа раздела: ... завершено."
EndProcedure

Procedure DtbPack(Parameter$)
  Protected Exp$, Sign$, Err, dts$, dtb$
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  
  If FileSize(Parameter$+".PARTITION")>0
    Exp$ = ".PARTITION" 
  Else
    Exp$ = ".img"
  EndIf
  
  Sign$ = CheckSignature(Parameter$+Exp$)
  
  ;----------BackUp----------------
  If FileSize(Parameter$+Exp$)>0 And FileSize(Parameter$+".org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+DirectoryName$+Exp$+" => "+DirectoryName$+".org") ;Создаётся резервная копия оригинала
    If CopyFile(Parameter$+Exp$, Parameter$+".org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(Parameter$+Exp$)>0
    Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+".bak") ;Переименовываем ...в...
    DeleteFile(Parameter$+".bak", #PB_FileSystem_Force)
    If RenameFile(Parameter$+Exp$, Parameter$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  ;---------------------------------
  
  If Sign$ = "DtbSingle" Or FileSize(Parameter$+"\single.dts")>0
    
    Message(Lng(39)+" "+DirectoryName$+Exp$+" |Single| "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
    Err = RunConsole(bin$+"dtc.exe", "-I dts -O dtb -o "+Chr(34)+DirectoryName$+Exp$+Chr(34)+" "+Chr(34)+DirectoryName$+"\single.dts"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" dtc: " + Str(Err)+ExitStr(Err)) ;Exitcode 
    
  Else ;If Sign$ = "DtbMulti" Or Sign$ = "Gzip" Or FileSize(Parameter$)=-2
    
      Message(Lng(39)+" "+DirectoryName$+Exp$+" |Multi| "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
      CopyDirectory(Parameter$, Parameter$+"_", "", #PB_FileSystem_Recursive)
      If ExamineDirectory(0, Parameter$+"_", "\*.dts")
        While NextDirectoryEntry(0)
          dts$ = DirectoryEntryName(0)
          If dts$ = ".." Or dts$ = "." : Continue : EndIf
          dtb$ = GetFilePart(dts$, #PB_FileSystem_NoExtension)+".dtb"
          Message("Pack: "+dts$+" --> "+dtb$)
          Err + RunConsole(bin$+"dtc.exe", "-I dts -O dtb -f "+Chr(34)+dts$+Chr(34)+" -o "+Chr(34)+dtb$+Chr(34), Parameter$+"_", #PB_Program_Wait)
          If FileSize(Parameter$+"_"+"\"+dtb$)=-1 : Err+1 : EndIf
          Message(Lng(42)+" dtc: " + Str(Err)+ExitStr(Err)) ;Exitcode 
          DeleteFile(Parameter$+"_"+"\"+dts$, #PB_FileSystem_Force)
        Wend
        FinishDirectory(0)
        
        Err + RunConsole(bin$+"dtbTool.exe", "--verbose -p "+bin$+" -o "+Chr(34)+DirectoryName$+Exp$+Chr(34)+" "+Chr(34)+DirectoryName$+"_"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
        If FileSize(Parameter$+Exp$)=-1 : Err+1 : EndIf
        Message(Lng(42)+" dtbTool: " + Str(Err)+ExitStr(Err),1) ;Exitcode
        DeleteDirectory(Parameter$+"_", "", #PB_FileSystem_Recursive)
        
        ;----------gzip-------
        If Sign$ = "Gzip" Or FileSize(Parameter$+Exp$) > 196607 ; >191 KB
          RenameFile(Parameter$+Exp$, Parameter$+"_"+Exp$)
          Message("Packing in: multi/gzipped")
          Err = RunConsole(bin$+"gzip.exe", "-nc "+Chr(34)+DirectoryName$+"_"+Exp$+Chr(34)+" > "+Chr(34)+DirectoryName$+Exp$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
          Message(Lng(42)+" gzip: " + Str(Err)+ExitStr(Err),1) ;Exitcode 
          DeleteFile(Parameter$+"_"+Exp$, #PB_FileSystem_Force)
        EndIf 
        ;----------gzip--------
      EndIf 
      
    EndIf
  
   If Err=0 : Recent(Parameter$) : EndIf
  ;----------Pecovery----
  If FileSize(Parameter$+Exp$)=-1 Or Err <> 0
    Message(Lng(70)+" "+DirectoryName$+".bak "+Lng(87)+" "+DirectoryName$+Exp$) ;Переименовываем ...в...
    DeleteFile(Parameter$+Exp$)
    RenameFile(Parameter$+".bak", Parameter$+Exp$)
  ElseIf FileSize(Parameter$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
      DeleteFile(Parameter$+".bak")
  EndIf
  ;----------------------
  Message(Lng(40)+" "+DirectoryName$+".PARTITION "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
EndProcedure

Procedure BootRecoveryUnpack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Cleaning(Parameter$)
  Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"AndImgTool.exe", Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" AndImgTool: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Err=0 : Recent(WorkingDirectory$+DirectoryName$) : Recent(Parameter$) : EndIf
  ;Err = RunConsole(bin$+"unpackbootimg.exe", "-i "+Chr(34)+FileNameExpansion$+Chr(34)+" -o "+Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  ;Message(Lng(42)+" UnpackBootImg: " + Str(Err)+ExitStr(Err)) ;Exitcode
  Message(Lng(38)+" "+FileNameExpansion$+" "+Lng(35), 1)   ;Действие по распаковки образа раздела: ... завершено.
EndProcedure

Procedure BootRecoveryPack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected Exp$ = ".PARTITION"
  
  If FileSize(Parameter$+Exp$)>0
    Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+Exp$+".bak") ;Переименовываем ...в...
    DeleteFile(Parameter$+Exp$+".bak", #PB_FileSystem_Force)
    If RenameFile(Parameter$+Exp$, Parameter$+Exp$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  Message(Lng(39)+" "+DirectoryName$+Exp$+" "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"AndImgTool.exe", Chr(34)+DirectoryName$+Chr(34)+" "+Chr(34)+DirectoryName$+Exp$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" AndImgTool: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Err=0 : Recent(Parameter$) : EndIf
  
  If FileSize(Parameter$+Exp$) = 0 Or Err <> 0
    Message(Lng(70)+" "+DirectoryName$+Exp$+".bak "+Lng(87)+" "+DirectoryName$+Exp$) ;Переименовываем ...в...
    DeleteFile(Parameter$+Exp$)
    If RenameFile(Parameter$+Exp$+".bak", Parameter$+Exp$)>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  ElseIf FileSize(Parameter$+Exp$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(Parameter$+Exp$+".bak")
  EndIf
  
  Message(Lng(40)+" "+DirectoryName$+".PARTITION "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
EndProcedure

Procedure BrUnpack(Parameter$)
  Protected Err, Ret
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension) ;vendor
  Protected FileNameExpansion$ = GetFilePart(Parameter$)                         ;vendor.PARTITION
  Protected FileName$ = GetFilePart(DirectoryName$, #PB_FileSystem_NoExtension)
  FileName$ = GetFilePart(FileName$, #PB_FileSystem_NoExtension)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)                          ;D:\X3\ATV_X3_0.3.8.1\
  Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  If FileSize(WorkingDirectory$+FileName$+".transfer.list") = -1
    Message(">< !!! Not found file: "+FileName$+".transfer.list")
    Message(Lng(4)+": "+FileNameExpansion$+" "+Lng(69), 1) ;Файл ... не может быть распакован!
    Ret = 1
  Else
    DeleteFile(WorkingDirectory$+DirectoryName$)
    Err = RunConsole(bin$+"brotli.exe", "--decompress --in "+Chr(34)+FileNameExpansion$+Chr(34)+" --out "+Chr(34)+DirectoryName$+Chr(34)+" "+st\Decompress, WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" brotli: " + Str(Err)+ExitStr(Err)) ;Exitcode
    If Err <> 0
      Ret = 1
    Else
      DatUnpack(WorkingDirectory$+DirectoryName$)
    EndIf
  EndIf
  ProcedureReturn Ret
EndProcedure

Procedure BrPack(Parameter$)
  ;Debug Parameter$
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension) ;vendor
  Protected FileNameExpansion$ = GetFilePart(Parameter$)                         ;vendor.PARTITION
  Protected WorkingDirectory$ = GetPathPart(Parameter$)                          ;D:\X3\ATV_X3_0.3.8.1\
  
  If FileSize(WorkingDirectory$+FileNameExpansion$+".br")>0 And FileSize(WorkingDirectory$+FileNameExpansion$+".br.org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+FileNameExpansion$+".br => "+FileNameExpansion$+".br.org") ;Создаётся резервная копия оригинала
    If CopyFile(WorkingDirectory$+FileNameExpansion$+".br", WorkingDirectory$+FileNameExpansion$+".br.org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(WorkingDirectory$+FileNameExpansion$+".br")>0
    Message(Lng(70)+" "+FileNameExpansion$+".br "+Lng(87)+" "+FileNameExpansion$+".br.bak") ;Переименовываем ...в...
    DeleteFile(WorkingDirectory$+FileNameExpansion$+".br.bak", #PB_FileSystem_Force)
    If RenameFile(WorkingDirectory$+FileNameExpansion$+".br", WorkingDirectory$+FileNameExpansion$+".br.bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf

  Message(Lng(39)+" "+FileNameExpansion$+".br "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"brotli.exe", "--in "+Chr(34)+FileNameExpansion$+Chr(34)+" --out "+Chr(34)+FileNameExpansion$+".br"+Chr(34)+" "+st\Compress, WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" brotli: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Err=0 : Recent(Parameter$) : EndIf
  If st\Not_Delete = #PB_Checkbox_Unchecked            ;Если разрешено, удаляем промежуточный образ
    DeleteFile(WorkingDirectory$+FileNameExpansion$, #PB_FileSystem_Force)
    DeleteFile(WorkingDirectory$+FileNameExpansion$+".bak", #PB_FileSystem_Force)
  EndIf
  
  If FileSize(WorkingDirectory$+FileNameExpansion$+".br.bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(WorkingDirectory$+FileNameExpansion$+".br.bak")
  EndIf
  
  Message(Lng(40)+" "+FileNameExpansion$+".br"+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
EndProcedure

Procedure DatUnpack(Parameter$)
  Protected Err, Ret
  Protected Expansion$ = LCase(GetExtensionPart(Parameter$)) ;расширение файла
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension) ;vendor
  Protected FileNameExpansion$ = GetFilePart(Parameter$)                         ;vendor.PARTITION
  Protected FileName$ = GetFilePart(DirectoryName$, #PB_FileSystem_NoExtension)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)                          ;D:\X3\ATV_X3_0.3.8.1\
  Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  If FileSize(WorkingDirectory$+FileName$+".transfer.list") = -1
    Message(">< !!! Not found file: "+FileName$+".transfer.list")
    Message(Lng(4)+": "+FileNameExpansion$+" "+Lng(69), 1) ;Файл ... не может быть распакован!
    Ret = 1
  Else
    DeleteFile(WorkingDirectory$+FileName$+".img")
    Err = RunConsole(bin$+"sdat2img.exe", Chr(34)+FileName$+".transfer.list"+Chr(34)+" "+Chr(34)+DirectoryName$+"."+Expansion$+Chr(34)+" "+Chr(34)+FileName$+".img"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    Message(Lng(42)+" sdat2img: " + Str(Err)+ExitStr(Err)) ;Exitcode
    If Err <> 0
      Ret = 1
    Else
      MainUnpack(WorkingDirectory$+FileName$+".img")
    EndIf
  EndIf
  ProcedureReturn Ret
EndProcedure

Procedure DatPack(Parameter$)
	Debug "Parameter$: "+Parameter$
  Protected Err, trList$="4"
  Protected Expansion$ = LCase(GetExtensionPart(Parameter$)) ;расширение файла
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension) ;vendor
  Protected FileNameExpansion$ = GetFilePart(Parameter$)                         ;vendor.PARTITION
  Protected FileName$ = GetFilePart(DirectoryName$, #PB_FileSystem_NoExtension)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)                          ;D:\X3\ATV_X3_0.3.8.1\
  
  If FileSize(WorkingDirectory$+FileName$+".new.dat")>0 And FileSize(WorkingDirectory$+FileName$+".new.dat.org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+FileName$+".new.dat => "+FileName$+".new.dat.org") ;Создаётся резервная копия оригинала
    If CopyFile(WorkingDirectory$+FileName$+".new.dat", WorkingDirectory$+FileName$+".new.dat.org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(WorkingDirectory$+FileName$+".transfer.list")>0 And FileSize(WorkingDirectory$+FileName$+".transfer.list.org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+FileName$+".transfer.list => "+FileName$+".transfer.list.org") ;Создаётся резервная копия оригинала
    If CopyFile(WorkingDirectory$+FileName$+".transfer.list", WorkingDirectory$+FileName$+".transfer.list.org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(WorkingDirectory$+FileName$+".new.dat")>0
    Message(Lng(70)+" "+DirectoryName$+".new.dat "+Lng(87)+" "+DirectoryName$+".new.dat.bak") ;Переименовываем ...в...
    DeleteFile(WorkingDirectory$+FileName$+".new.dat.bak", #PB_FileSystem_Force)
    If RenameFile(WorkingDirectory$+FileName$+".new.dat", WorkingDirectory$+FileName$+".new.dat.bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(WorkingDirectory$+FileName$+".transfer.list")>0
    If ReadFile(0, WorkingDirectory$+FileName$+".transfer.list") : trList$=Trim(ReadString(0)) : CloseFile(0) : EndIf
    Message(Lng(70)+" "+DirectoryName$+".transfer.list "+Lng(87)+" "+DirectoryName$+".transfer.list.bak") ;Переименовываем ...в...
    DeleteFile(WorkingDirectory$+FileName$+".transfer.list.bak", #PB_FileSystem_Force)
    If RenameFile(WorkingDirectory$+FileName$+".transfer.list", WorkingDirectory$+FileName$+".transfer.list.bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf

  If Val(trList$)<=0 Or Val(trList$)>10 Or st\Transfer = #PB_Checkbox_Checked : trList$="4" : EndIf
  Message(Lng(39)+" "+DirectoryName$+".new.dat "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"img2sdat.exe", Chr(34)+FileNameExpansion$+Chr(34)+" -v "+trList$+" -p "+Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" img2sdat: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Err=0 : Recent(Parameter$) : EndIf
  
  If st\Not_Delete = #PB_Checkbox_Unchecked ;Если разрешено, удаляем промежуточный образ
    DeleteFile(WorkingDirectory$+FileName$+".img", #PB_FileSystem_Force)
  EndIf
  
  DeleteFile(WorkingDirectory$+FileName$+".bak", #PB_FileSystem_Force)
  DeleteFile(WorkingDirectory$+FileName$+".org", #PB_FileSystem_Force)
  
  If FileSize(WorkingDirectory$+FileName$+".new.dat.bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(WorkingDirectory$+FileName$+".new.dat.bak")
  EndIf
  
  If FileSize(WorkingDirectory$+FileName$+".transfer.list.bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(WorkingDirectory$+FileName$+".transfer.list.bak")
  EndIf
  
  If FileSize(WorkingDirectory$+FileName$+".new.dat.br")>=0
    BrPack(WorkingDirectory$+FileName$+".new.dat")
  Else
    Message(Lng(40)+" "+FileName$+".new.dat"+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
  EndIf
  
EndProcedure

Procedure tarUnpack(Parameter$)
  Protected Err, res$
  Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  If LCase(GetExtensionPart(DirectoryName$)) ="tar"
    DirectoryName$ = GetFilePart(DirectoryName$, #PB_FileSystem_NoExtension)
  EndIf
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected ExtractionPath$ = WorkingDirectory$+DirectoryName$
  Cleaning(ExtractionPath$)
  Message(Lng(32)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа прошивки: Подождите...
  Err = RunConsole(bin$+"tar.exe", "-xvf "+Chr(34)+FileNameExpansion$+Chr(34)+" -C "+Chr(34)+DirectoryName$+Chr(34)+" 2>nul", WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" tar: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  Err = RunConsole(bin$+"ls.exe", "-l 2>nul", ExtractionPath$, #PB_Program_Wait)
  Message(Lng(42)+" ls: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  If Err=0
    ;Err = RunConsole(bin$+"tar.exe", "-tf "+Chr(34)+FileNameExpansion$+Chr(34)+" > "+Chr(34)+DirectoryName$+"\tarFileList.cfg"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
    If ExamineDirectory(0, WorkingDirectory$+DirectoryName$, "") And CreateFile(1, WorkingDirectory$+DirectoryName$+"\tarFileList.cfg")
      While NextDirectoryEntry(0)
        res$ = DirectoryEntryName(0)
        If res$ = ".." Or res$ = "." Or res$ = "tarFileList.cfg" : Continue : EndIf
        If FileSize(WorkingDirectory$+DirectoryName$+"\"+res$) = -2 : res$+"\" : EndIf
        WriteString(1, res$+Chr(10))
      Wend
      FinishDirectory(0)
      CloseFile(1)
    EndIf
    Recent(ExtractionPath$)
    Recent(Parameter$)
    If st\Unpack_System = #PB_Checkbox_Checked
      If FileSize(ExtractionPath$+"\system.img.ext4.lz4")>0
        lz4Unpack(ExtractionPath$+"\system.img.ext4.lz4")
      ElseIf FileSize(ExtractionPath$+"\system.img.lz4")>0
        lz4Unpack(ExtractionPath$+"\system.img.lz4")
      ElseIf FileSize(ExtractionPath$+"\system.img.ext4")>0
        ext4Unpack(ExtractionPath$+"\system.img.ext4")  
      ElseIf FileSize(ExtractionPath$+"\system.img")>0
        MainUnpack(ExtractionPath$+"\system.img")
      EndIf
    EndIf
    If st\Unpack_Vendor = #PB_Checkbox_Checked 
      If FileSize(ExtractionPath$+"\vendor.img.ext4.lz4")>0
        lz4Unpack(ExtractionPath$+"\vendor.img.ext4.lz4")
      ElseIf FileSize(ExtractionPath$+"\vendor.img.lz4")>0
        lz4Unpack(ExtractionPath$+"\vendor.img.lz4")
      ElseIf FileSize(ExtractionPath$+"\vendor.img.ext4")>0
        ext4Unpack(ExtractionPath$+"\vendor.img.ext4")  
      ElseIf FileSize(ExtractionPath$+"\vendor.img")>0
        MainUnpack(ExtractionPath$+"\vendor.img")
      EndIf
    EndIf
    If st\Unpack_Product = #PB_Checkbox_Checked 
      If FileSize(ExtractionPath$+"\product.img.ext4.lz4")>0
        lz4Unpack(ExtractionPath$+"\product.img.ext4.lz4")
      ElseIf FileSize(ExtractionPath$+"\product.img.lz4")>0
        lz4Unpack(ExtractionPath$+"\product.img.lz4")
      ElseIf FileSize(ExtractionPath$+"\product.img.ext4")>0
        ext4Unpack(ExtractionPath$+"\product.img.ext4")  
      ElseIf FileSize(ExtractionPath$+"\product.img")>0
        MainUnpack(ExtractionPath$+"\product.img")
      EndIf
    EndIf
    If st\Unpack_Odm = #PB_Checkbox_Checked 
      If FileSize(ExtractionPath$+"\odm.img.ext4.lz4")>0
        lz4Unpack(ExtractionPath$+"\odm.img.ext4.lz4")
      ElseIf FileSize(ExtractionPath$+"\odm.img.lz4")>0
        lz4Unpack(ExtractionPath$+"\odm.img.lz4")
      ElseIf FileSize(ExtractionPath$+"\odm.img.ext4")>0
        ext4Unpack(ExtractionPath$+"\odm.img.ext4")  
      ElseIf FileSize(ExtractionPath$+"\odm.img")>0
        MainUnpack(ExtractionPath$+"\odm.img")
      EndIf
    EndIf
  EndIf
  ;Message(Lng(36)+" "+FileNameExpansion$+" "+Lng(35), 1)     ;Действие по распаковки файла обновления: ... завершено.
  If st\Open_Folder = #PB_Checkbox_Checked : RunProgram("file://"+ExtractionPath$) : EndIf
EndProcedure

Procedure tarPack(Parameter$)
  Protected Err
  Protected DirectoryName$ = GetFilePart(Parameter$)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected Exp$ = ".tar"
  
  If st\Pack_System = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\system") = 0
    MainPack(Parameter$+"\system")
  EndIf
  If st\Pack_Vendor = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\vendor") = 0
    MainPack(Parameter$+"\vendor")
  EndIf
  If st\Pack_Product = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\product") = 0
    MainPack(Parameter$+"\product")
  EndIf
  If st\Pack_Odm = #PB_Checkbox_Checked And IsEmptyFolder(Parameter$+"\odm") = 0
    MainPack(Parameter$+"\odm")
  EndIf
  
  If FileSize(Parameter$+Exp$)>0 And FileSize(Parameter$+Exp$+".org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+DirectoryName$+Exp$+" => "+DirectoryName$+Exp$+".org") ;Создаётся резервная копия оригинала
    If CopyFile(Parameter$+Exp$, Parameter$+Exp$+".org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(Parameter$+Exp$)>0
    Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+Exp$+".bak") ;Переименовываем ...в...
    DeleteFile(Parameter$+Exp$+".bak", #PB_FileSystem_Force)
    If RenameFile(Parameter$+Exp$, Parameter$+Exp$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  Message(Lng(33)+" "+DirectoryName$+Exp$+" "+Lng(30)) ;Выполняется сборка образа прошивки: ... Подождите...
                                                       ;tar.exe -cvf ~/backup.tgz -T tarFileList.cfg
  Err = RunConsole(bin$+"tar.exe", "-cvf "+Chr(34)+"..\"+DirectoryName$+Exp$+Chr(34)+" -T "+Chr(34)+"tarFileList.cfg"+Chr(34)+" 2>nul", Parameter$, #PB_Program_Wait)
  Message(Lng(42)+" tar: " + Str(Err)+ExitStr(Err)) ;Exitcode 
  If Err=0
    Recent(Parameter$)
    If FileSize(WorkingDirectory$+DirectoryName$+Exp$+".md5")>=0 
      ;..\bin\md5sum.exe -t %file% >> %file% 2>nul
      Err = RunConsole(bin$+"md5sum.exe", "-t "+Chr(34)+DirectoryName$+Exp$+Chr(34)+" >> "+Chr(34)+DirectoryName$+Exp$+Chr(34)+" 2>nul", WorkingDirectory$, #PB_Program_Wait)
      Message(Lng(42)+" md5sum: " + Str(Err)+ExitStr(Err)) ;Exitcode
      If Err=0 
        If FileSize(Parameter$+Exp$+".md5")>0 And FileSize(Parameter$+Exp$+".md5.org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
          Message(Lng(148)+": "+DirectoryName$+Exp$+".md5 => "+DirectoryName$+Exp$+".md5.org") ;Создаётся резервная копия оригинала
          If CopyFile(Parameter$+Exp$+".md5", Parameter$+Exp$+".md5.org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
        EndIf
        
        Message(Lng(70)+" "+DirectoryName$+Exp$+".md5 "+Lng(87)+" "+DirectoryName$+Exp$+".md5.bak") ;Переименовываем ...в...
        DeleteFile(WorkingDirectory$+DirectoryName$+Exp$+".md5.bak", #PB_FileSystem_Force)
        If RenameFile(WorkingDirectory$+DirectoryName$+Exp$+".md5", WorkingDirectory$+DirectoryName$+Exp$+".md5.bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
        Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+Exp$+".md5") ;Переименовываем ...в...
        If RenameFile(WorkingDirectory$+DirectoryName$+Exp$, WorkingDirectory$+DirectoryName$+Exp$+".md5")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
      Else
        
        If st\Not_Delete = #PB_Checkbox_Unchecked            ;Если разрешено, удаляем промежуточный образ
          DeleteFile(WorkingDirectory$+DirectoryName$+Exp$, #PB_FileSystem_Force)
        EndIf
        
      EndIf
      Message(Lng(34)+" "+DirectoryName$+Exp$+".md5 "+Lng(35), 1) ;Действие по сборке прошивки: ... завершено.
    Else
      Message(Lng(34)+" "+DirectoryName$+Exp$+" "+Lng(35), 1) ;Действие по сборке прошивки: ... завершено.
    EndIf
  Else
    
    If FileSize(Parameter$+Exp$+".bak")>0
      Message(Lng(70)+" "+DirectoryName$+Exp$+".bak "+Lng(87)+" "+DirectoryName$+Exp$) ;Переименовываем ...в...
      DeleteFile(Parameter$+Exp$)
      If RenameFile(Parameter$+Exp$+".bak", Parameter$+Exp$)>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
    EndIf
    
  EndIf
  
  If FileSize(Parameter$+Exp$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(Parameter$+Exp$+".bak")
  EndIf
  
  If FileSize(Parameter$+Exp$+".md5.bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(Parameter$+Exp$+".md5.bak")
  EndIf
  
EndProcedure

Procedure ustarUnpack(Parameter$)
	Debug "ustar "+Parameter$
EndProcedure

Procedure ustarPack(Parameter$)
	Debug "ustar "+Parameter$
EndProcedure

Procedure lz4Unpack(Parameter$)
  Protected Err
  Protected WorkingDirectory$ = GetPathPart(Parameter$) 
  Protected OutFileName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension) ;vendor
  Protected Extension$ = LCase(GetExtensionPart(WorkingDirectory$+OutFileName$))
  Protected LowerFileName$ = LCase(GetFilePart(WorkingDirectory$+OutFileName$, #PB_FileSystem_NoExtension)) 
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  DeleteFile(WorkingDirectory$+OutFileName$, #PB_FileSystem_Force)
  Message(Lng(37)+" "+FileNameExpansion$+" "+Lng(30)) ;Выполняется распаковка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"lz4.exe", "-d "+Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+OutFileName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" lz4: " + Str(Err)+ExitStr(Err)) ;Exitcode
  If Extension$ = "ext4"
    ext4Unpack(WorkingDirectory$+OutFileName$)
  ElseIf Extension$ = "img"
    If LowerFileName$ = "super"
      SuperUnpack(WorkingDirectory$+OutFileName$)
    ElseIf LowerFileName$ = "resource" Or LowerFileName$ = "boot" Or LowerFileName$ = "recovery" Or LowerFileName$ = "uboot" Or LowerFileName$ = "bootloader"
      ImgRKUnpack(WorkingDirectory$+OutFileName$)
    Else
      MainUnpack(WorkingDirectory$+OutFileName$)
    EndIf
  EndIf
  
  If st\Not_Delete = #PB_Checkbox_Unchecked And FileSize(WorkingDirectory$+OutFileName$)>0
    If Extension$ = "ext4" Or Extension$ = "img"
      DeleteFile(WorkingDirectory$+OutFileName$, #PB_FileSystem_Force)
    EndIf
  EndIf
EndProcedure

Procedure lz4Pack(Parameter$)
  Protected Err
  Protected WorkingDirectory$ = GetPathPart(Parameter$) 
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected OutFileName$ = FileNameExpansion$+".lz4"
  
  If FileSize(Parameter$+".lz4")>0 And FileSize(Parameter$+".lz4.org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
    Message(Lng(148)+": "+OutFileName$+" => "+OutFileName$+".org") ;Создаётся резервная копия оригинала
    If CopyFile(Parameter$+".lz4", Parameter$+".lz4.org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
  EndIf
  
  If FileSize(Parameter$+".lz4")>=0
    Message(Lng(70)+" "+OutFileName$+" "+Lng(87)+" "+OutFileName$+".bak") ;Переименовываем ...в...
    DeleteFile(Parameter$+".lz4.bak", #PB_FileSystem_Force)
    If RenameFile(Parameter$+".lz4", Parameter$+".lz4.bak") : Else : Message(Lng(136)) : EndIf
  EndIf
  
  Message(Lng(39)+" "+FileNameExpansion$+".lz4 "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите...
  Err = RunConsole(bin$+"lz4.exe", "-B6 --content-size "+Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+OutFileName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" lz4: " + Str(Err)+ExitStr(Err)) ;Exitcode
  
  If FileSize(Parameter$+".lz4") <= 0 Or Err <> 0
    If FileSize(Parameter$+".lz4.bak") >0
      Message(Lng(70)+" "+OutFileName$+".bak "+Lng(87)+" "+OutFileName$) ;Переименовываем ...в...
      DeleteFile(Parameter$+".lz4")
      If RenameFile(Parameter$+".lz4.bak", Parameter$+".lz4") : Else : Message(Lng(136)) : EndIf
    EndIf
  EndIf
  
  If st\Not_Delete = #PB_Checkbox_Unchecked ;Если разрешено, удаляем промежуточный образ
    DeleteFile(Parameter$, #PB_FileSystem_Force)
    DeleteFile(Parameter$+".bak", #PB_FileSystem_Force)
  EndIf
  
  If FileSize(Parameter$+".lz4.bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
    DeleteFile(Parameter$+".lz4.bak")
  EndIf
  
EndProcedure

Procedure ext4Unpack(Parameter$)
  Protected Err
  Protected FileNameExpansion$ = GetFilePart(Parameter$)
  Protected NewFileNameExpansion$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Protected LowerFileName$ = LCase(GetFilePart(WorkingDirectory$+NewFileNameExpansion$, #PB_FileSystem_NoExtension))
  Message(Lng(166)+" "+FileNameExpansion$+" "+Lng(167)+" "+NewFileNameExpansion$) ;Конвертируем ... в ...
  Err = CopyFile(Parameter$, WorkingDirectory$+NewFileNameExpansion$)
  Message(Lng(42)+" Convert: " + Str(1)+ExitStr(1)) ;Exitcode
  If Err<>0
    If LowerFileName$ = "super"
      SuperUnpack(WorkingDirectory$+NewFileNameExpansion$)
    ElseIf LowerFileName$ = "resource" Or LowerFileName$ = "boot" Or LowerFileName$ = "recovery" Or LowerFileName$ = "uboot" Or LowerFileName$ = "bootloader"
      ImgRKUnpack(WorkingDirectory$+NewFileNameExpansion$)
    Else
      MainUnpack(WorkingDirectory$+NewFileNameExpansion$)
    EndIf
  EndIf
  DeleteFile(WorkingDirectory$+NewFileNameExpansion$, #PB_FileSystem_Force)
EndProcedure

Procedure gzUnpack(Parameter$)
  Protected Err
  Protected WorkingDirectory$ = GetPathPart(Parameter$)
  Err = RunConsole(bin$+"gzip.exe", "-d "+Chr(34)+Parameter$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
  Message(Lng(42)+" gzip: " + Str(Err)+ExitStr(Err)) ;Exitcode
EndProcedure

Procedure MainUnpack(Parameter$)
	;Debug Parameter$
	Protected Err, f_size$, f_journal$="No", str$, strN$, Length.l
	Protected Expansion$ = LCase(GetExtensionPart(Parameter$)) ;расширение файла
	Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension);vendor
	Protected BadFolder$ = DirectoryName$
	Protected ExtractionPath$ = GetPathPart(Parameter$)+DirectoryName$ ;D:\X3\ATV_X3_0.3.8.1\vendor
	Protected FileNameExpansion$ = GetFilePart(Parameter$)			   ;vendor.PARTITION
	Protected WorkingDirectory$ = GetPathPart(Parameter$)			   ;D:\X3\ATV_X3_0.3.8.1\
	Protected PartType$ = CheckSignature(Parameter$), FolderName$
	Debug PartType$
	If PartType$ <> "Sparse" : PartType$ = "Raw": EndIf
	Cleaning(Parameter$)
	CreateDirectory(ExtractionPath$+"\config")
	
; 	If Expansion$ <> "img"
; 		RenameFile(Parameter$, ExtractionPath$+".img")
; 	EndIf
	
	;	If FileSize(ExtractionPath$+".img")>0
	If FileSize(Parameter$)>0
		Message(Lng(37)+" "+FileNameExpansion$+" |"+PartType$+ "| "+Lng(30), 1) ;Выполняется распаковка образа раздела: ... Подождите...
		
		If PartType$ = "Sparse"
				Message(Lng(166)+" "+FileNameExpansion$+" |Sparse| "+Lng(87)+" |Raw|") ;Конвертируем в
				Message(Lng(30))
				DeleteFile(ExtractionPath$+"_sparse."+Expansion$, #PB_FileSystem_Force)
				RenameFile(ExtractionPath$+"."+Expansion$, ExtractionPath$+"_sparse."+Expansion$)
				;simg2img.exe -i super.img -o super.raw.img
				Err = RunConsole(bin$+"simg2img.exe", Chr(34)+DirectoryName$+"_sparse."+Expansion$+Chr(34)+" "+Chr(34)+DirectoryName$+"."+Expansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
				Message(Lng(42)+" simg2img: " + Str(Err)+ExitStr(Err),1) ;Exitcode
		EndIf	

		;Message("Erofs detect...")
		If CheckSignature(ExtractionPath$+"."+Expansion$) = "Erofs"
			;RunConsole(bin$+"erofs\dump.erofs.exe", "-s "+Chr(34)+DirectoryName$+"."+Expansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)=0
			RunConsole(bin$+"erofs\dump.erofs.exe", "-s "+Chr(34)+DirectoryName$+"."+Expansion$+Chr(34)+" >"+Chr(34)+DirectoryName$+"\config\"+DirectoryName$+"_info.txt"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
			Message(Lng(50)+" erofs")
			Message(Lng(30),1)
			;extract.erofs.exe -i"system_a.img" -x -f -o"system_a"
			;Если вы хотите полностью заглушить команду (stdout и stderr), сделайте @command > nul 2>&1
			Err = RunConsole(bin$+"erofs\extract.erofs.exe", "-i "+Chr(34)+DirectoryName$+"."+Expansion$+Chr(34)+" -x -f -o "+Chr(34)+DirectoryName$+Chr(34)+" > nul", WorkingDirectory$, #PB_Program_Wait)
			Message(Lng(42)+" Extract erofs: " + Str(Err)+ExitStr(Err)) ;Exitcode
			If Err=0
				Recent(ExtractionPath$)
				Recent(Parameter$)
				RenameFile(ExtractionPath$+"\config\"+DirectoryName$+"_file_contexts", ExtractionPath$+"\config\"+DirectoryName$+"_file_contexts.txt")
				RenameFile(ExtractionPath$+"\config\"+DirectoryName$+"_fs_config", ExtractionPath$+"\config\"+DirectoryName$+"_fs_config.txt")
				RenameFile(ExtractionPath$+"\config\"+DirectoryName$+"_fs_options", ExtractionPath$+"\config\"+DirectoryName$+"_fs_options.txt")
				If OpenFile(33, ExtractionPath$+"\config\"+DirectoryName$+"_fs_options.txt")
					str$ = ReadString(33, #PB_UTF8 | #PB_File_IgnoreEOL)
					str$ = RemoveString(str$, "_repack", #PB_String_NoCase)
					str$ = ReplaceString(str$, ".img", "."+Expansion$) ;!!!
					str$ = ReplaceString(str$, "_file_contexts", "_file_contexts.txt")
					str$ = ReplaceString(str$, "_fs_config", "_fs_config.txt")
					str$ = ReplaceString(str$, "_fs_options", "_fs_options.txt")
					FileSeek(33, 0)
					TruncateFile(33)
					WriteStringN(33, "Type: "+PartType$, #PB_UTF8)
					WriteStringN(33, "Expansion: "+Expansion$, #PB_UTF8)
					WriteString(33, str$, #PB_UTF8)
					CloseFile(33)
					str$=""
				EndIf
			EndIf
		Else
			Message(Lng(50)+" EXT4")
			Message(Lng(30),1)
			Err = RunConsole(bin$+"imgextractor_.exe", Chr(34)+DirectoryName$+"."+Expansion$+Chr(34)+" >"+Chr(34)+DirectoryName$+"\config\"+DirectoryName$+"_info.txt"+Chr(34)+" -s", WorkingDirectory$, #PB_Program_Wait)
			If Err=0 And FileSize(ExtractionPath$+"\config\"+DirectoryName$+"_info.txt")>0 And OpenFile(11, ExtractionPath$+"\config\"+DirectoryName$+"_info.txt")
				str$ = ReadString(11, #PB_UTF8 | #PB_File_IgnoreEOL)
				str$ =  Mid(str$, FindString(str$, "EXT4 superblock info:")) 
				FileSeek(11, 0)
				If FindString(ReadStr(11, "FS compatible features"), "HAS_JOURNAL EXT_ATTR RESIZE_INODE")>0
					f_journal$ = "Yes"
				EndIf
				FileSeek(11, 0)
				TruncateFile(11)
				WriteString(11, str$, #PB_UTF8)
				CloseFile(11)
				str$="" 		
			EndIf
			
			Err = RunConsole(bin$+"imgextractor.exe", Chr(34)+DirectoryName$+"."+Expansion$+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
			Message(Lng(42)+" ImgExtractor: " + Str(Err)+ExitStr(Err)) ;Exitcode
			
			If Err=0
				Recent(ExtractionPath$)
				Recent(Parameter$)
				
				
				If FileSize(ExtractionPath$+"\config\"+DirectoryName$+"_fs_options.txt")>0 And OpenFile(0, ExtractionPath$+"\config\"+DirectoryName$+"_fs_options.txt")
					f_size$ = ReadStr(0, "Size")
					FolderName$ = ReadStr(0, "FolderName")
					WriteStringN(0,	"FileName: "	+DirectoryName$+"."+Expansion$,		#PB_UTF8)
					WriteStringN(0,	"Size: "		+f_size$,							#PB_UTF8)
					WriteStringN(0,	"Type: "		+PartType$,							#PB_UTF8)
					WriteStringN(0,	"Journal: "		+f_journal$,						#PB_UTF8)
					WriteStringN(0,	"FolderName: "	+FolderName$,						#PB_UTF8)
					CloseFile(0)
				EndIf
				
				If  f_size$ <> ""
					Message(">< !!! "+Lng(41)+" "+SizeIt(Val(f_size$)-GetFolderSize(ExtractionPath$))) ;Свободного места:
				EndIf 
				
			Else
				RunConsole("rmdir", "/q /s "+Chr(34)+ExtractionPath$+Chr(34), "", #PB_Program_Wait)
			EndIf
			
			If st\Not_Delete = #PB_Checkbox_Unchecked
				If FileSize(ExtractionPath$+".new.dat.br")>0
					DeleteFile(ExtractionPath$+".new.dat", #PB_FileSystem_Force)
					DeleteFile(ExtractionPath$+".img", #PB_FileSystem_Force)
				ElseIf FileSize(ExtractionPath$+".new.dat")>0
					DeleteFile(ExtractionPath$+".img", #PB_FileSystem_Force)
				EndIf
			EndIf
		EndIf
		
		If FileSize(ExtractionPath$+"_sparse."+Expansion$)>0
			If st\Not_Delete = #PB_Checkbox_Unchecked
				DeleteFile(ExtractionPath$+"."+Expansion$, #PB_FileSystem_Force)
				RenameFile(ExtractionPath$+"_sparse."+Expansion$, ExtractionPath$+"."+Expansion$)
			Else
				DeleteFile(ExtractionPath$+"_raw."+Expansion$, #PB_FileSystem_Force)
				RenameFile(ExtractionPath$+"."+Expansion$, ExtractionPath$+"_raw."+Expansion$)
				RenameFile(ExtractionPath$+"_sparse."+Expansion$, ExtractionPath$+"."+Expansion$)
			EndIf
		EndIf

		Message(Lng(38)+" "+FileNameExpansion$+" "+Lng(35), 1)                             ;Действие по распаковки образа раздела: ... завершено. 
	Else
		Message(Lng(4)+": "+FileNameExpansion$+" "+Lng(69), 1) ;Файл ... не может быть распакован!
	EndIf
; 	If Expansion$ <> "img"
; 		RenameFile(ExtractionPath$+".img", Parameter$)
; 	EndIf
EndProcedure

Procedure MainPack(Parameter$)
	Protected Err, Position, PartType$="Raw", ID, File_Contexts$, Fs_Config$, journal$, inodes$, super
	Protected f_size$, erofs$, type$, Exp$, label$, nSizeFolder.q, nFreeSpace.q, Date$
	Protected DirectoryName$ = GetFilePart(Parameter$) ;vendor
	Protected FolderName$, WorkingDirectory$ = GetPathPart(Parameter$) ;D:\X3\ATV_X3_0.3.8.1\
	
	If  ReadFile(1, Parameter$+"\config\"+DirectoryName$+"_fs_options.txt", #PB_File_SharedRead|#PB_File_SharedWrite)
		
		f_size$ = ReadStr(1, "Size")
		FolderName$ = ReadStr(1, "FolderName")
		If FolderName$ = "" : FolderName$ = DirectoryName$ : EndIf
		
		If LCase(ReadStr(1, "Type")) = "sparse"
			PartType$ = "Sparse"
		EndIf
		
		If LCase(ReadStr(1, "Journal")) = "yes"
			journal$=" -j 4096"
			inodes$=" -i"
		EndIf
		
		erofs$ = ReadStr(1, "mkfs.erofs options")
		
		CloseFile(1)
	EndIf
	
	If FileSize(Parameter$+".PARTITION")>=0
		Exp$ =".PARTITION"
	ElseIf FileSize(Parameter$+".img.ext4")>=0 Or FileSize(Parameter$+".img.ext4.lz4")>=0
		Exp$ =".img.ext4"  
	ElseIf FileSize(Parameter$+".fex")>=0
		Exp$ =".fex"
	ElseIf FileSize(Parameter$+".bin")>=0
		Exp$ =".bin"
	Else
		Exp$ =".img"
	EndIf

	;BackUp Start
	If FileSize(Parameter$+Exp$)>0 And FileSize(Parameter$+".org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
		Message(Lng(148)+": "+DirectoryName$+Exp$+" => "+DirectoryName$+".org") ;Создаётся резервная копия оригинала
		If CopyFile(Parameter$+Exp$, Parameter$+".org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
	EndIf
	
	If FileSize(Parameter$+Exp$)>0
		Message(Lng(70)+" "+DirectoryName$+Exp$+" "+Lng(87)+" "+DirectoryName$+".bak") ;Переименовываем ...в...
		DeleteFile(Parameter$+".bak", #PB_FileSystem_Force)
		If RenameFile(Parameter$+Exp$, Parameter$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
	EndIf
	;BackUp Finish
	
	If erofs$ = ""
		
		If f_size$=""
			f_size$ = Str(GetFolderSize(Parameter$));+50*1024*1024)
		EndIf
		
		If PartType$ = "Sparse" Or FileSize(Parameter$+".new.dat")>=0 Or FileSize(Parameter$+".new.dat.br")>=0
			type$ = " -s"
			PartType$ = "Sparse"
		EndIf
		
		;  	Debug f_size$
		;  	Debug PartType$
		;  	Debug journal$
		
		Message(Lng(39)+" "+DirectoryName$+Exp$+" |"+PartType$+ "| "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите..."
		
		label$ = DirectoryName$ 
		Position = FindString(DirectoryName$, ".") 
		If Position >0
			label$ = Left(DirectoryName$, Position-1) 
		EndIf
		
		If Right(label$, 2) = "_a" Or Right(label$, 2) = "_b"
			label$ = Left(label$,Len(label$)-2)
		EndIf
		
		nSizeFolder = GetFolderSize(Parameter$)
		nFreeSpace = Val(f_size$)-nSizeFolder
		Message(">< !!! "+Lng(41)+" "+SizeIt(nFreeSpace),1) ;Свободного места:
															;st\Free_Space
															;Debug LCase(GetFilePart(RTrim(WorkingDirectory$, "\")))
		If st\Expand_Size = #PB_Checkbox_Checked  And LCase(GetFilePart(RTrim(WorkingDirectory$, "\"))) = "super"
			super=#True
		ElseIf  st\Expand_Size = #PB_Checkbox_Unchecked And nFreeSpace < st\Free_Space*1024*1024 ;9437184
			f_size$ = Str(nSizeFolder+st\Free_Space*1024*1024)									 ;9*1024*1024
			Message(">< !!! "+"Expand size partition",1)
			nFreeSpace = Val(f_size$)-nSizeFolder
			Message(">< !!! "+Lng(41)+" "+SizeIt(nFreeSpace),1) ;Свободного места:
		EndIf
		
		If journal$ <> ""
			Message("HAS_JOURNAL EXT_ATTR RESIZE_INODE",1)
		EndIf
		
	
		
		If FileSize(Parameter$+"\config\"+DirectoryName$+"_file_contexts.txt")>=0
			File_Contexts$=" -S "+Chr(34)+"./config\"+DirectoryName$+"_file_contexts.txt"+Chr(34)
		EndIf
		
		If FileSize(Parameter$+"\config\"+DirectoryName$+"_fs_config.txt")>=0
			Fs_Config$=" -C "+Chr(34)+"./config\"+DirectoryName$+"_fs_config.txt"+Chr(34)
			RunConsole(bin$+"fspatch.exe", Chr(34)+DirectoryName$+"\"+DirectoryName$+Chr(34)+" "+Chr(34)+DirectoryName$+"\config\"+DirectoryName$+"_fs_config.txt"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		EndIf
		
		
		Date$ = Str(Date())
		
		;сборка раздела
		;make_ext4fs -s -J -L vendor -T -1 -S level2\vendor_file_contexts -C level2\vendor_fs_config -l %vendor_size% -a vendor level1\vendor.PARTITION level2\vendor\
		;./make_ext4fs -s -l 681574400 -a system /data/media/0/mod/system.img /data/local/UnpackerSystem/system"
		
		txt$ = journal$+inodes$ +type$+" -J -T "+Date$+" -L "+FolderName$+" -a "+FolderName$+File_Contexts$+Fs_Config$+" "+Chr(34)+"../"+DirectoryName$+Exp$+Chr(34)+" "+Chr(34)+"./"+FolderName$+Chr(34)
		;txt$ = "-l "+f_size$+journal$+inodes$ +type$+" -J -T "+Date$+" -L "+FolderName$+" -a "+FolderName$+" -S "+Chr(34)+"./config\"+DirectoryName$+"_file_contexts.txt"+Chr(34)+" -C "+Chr(34)+"./config\"+DirectoryName$+"_fs_config.txt"+Chr(34)+" "+Chr(34)+"../"+DirectoryName$+Exp$+Chr(34)+" "+Chr(34)+"./"+FolderName$+Chr(34)
		
		Message(Lng(39)+" "+DirectoryName$+Exp$+" |"+PartType$+ "| "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите..."
		
		If CreateFile(0, Parameter$+"\config\"+DirectoryName$+"_pack_ext4.sh") : WriteString(0, "make_ext4fs -l "+f_size$+txt$) : CloseFile(0) : EndIf
		Err = RunConsole(bin$+"make_ext4fs.exe", "-l "+f_size$+txt$, Parameter$, #PB_Program_Wait)
		
		If Blocks And super
			Message(">< !!! "+"Expand size partition",1)
			f_size$ = Str(nSizeFolder+100*1024*1024)
			
			If CreateFile(0, Parameter$+"\config\"+DirectoryName$+"_pack_ext4.sh") : WriteString(0, "make_ext4fs -l "+f_size$+txt$) : CloseFile(0) : EndIf
			Err = RunConsole(bin$+"make_ext4fs.exe", "-l "+f_size$+txt$, Parameter$, #PB_Program_Wait)
			
		EndIf
		
		Message(Lng(42)+" make_ext4fs: " + Str(Err)+ExitStr(Err),1) ;Exitcode
		If Err=0 : Recent(Parameter$) : EndIf
		
		
		
		
		If (st\Expand_Size = #PB_Checkbox_Unchecked  And st\Resize = #PB_Checkbox_Checked)  Or (Blocks>0 And super=#True)
			If FileSize(Parameter$+Exp$) >0 And Err = 0
				RunConsole(bin$+"resize2fs\resize2fs.exe", "-M "+Chr(34)+DirectoryName$+Exp$+Chr(34), WorkingDirectory$, #PB_Program_Hide | #PB_Program_Wait)
			EndIf
		EndIf
		Blocks = 0 
		
		;Recovery Start
		If FileSize(Parameter$+Exp$) = 0 Or Err <> 0
			If FileSize(Parameter$+".bak") >0
				Message(Lng(70)+" "+DirectoryName$+".bak "+Lng(87)+" "+DirectoryName$+Exp$) ;Переименовываем ...в...
				DeleteFile(Parameter$+Exp$)
				If RenameFile(Parameter$+".bak", Parameter$+Exp$)>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
			EndIf
		Else
			
			If FileSize(Parameter$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
				DeleteFile(Parameter$+".bak")
			EndIf
			;Recovery Finish
			
			If FileSize(Parameter$+".new.dat")>=0 Or FileSize(Parameter$+".new.dat.br")>=0
				DatPack(Parameter$+Exp$)
			ElseIf FileSize(Parameter$+Exp$+".lz4")>=0
				lz4Pack(Parameter$+Exp$)
			Else 
				Message(Lng(40)+" "+DirectoryName$+Exp$+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
			EndIf
		EndIf
	Else
		ErofsPack(Parameter$)
	EndIf
EndProcedure

Procedure ErofsPack(Parameter$)
	Protected Err, PartType$="Raw", ID
	Protected DirectoryName$ = GetFilePart(Parameter$) ;vendor
	Protected Expansion$ = "img", Exp$	;LCase(GetExtensionPart(Parameter$)) ;расширение файла
	Protected WorkingDirectory$ = GetPathPart(Parameter$) ;D:\X3\ATV_X3_0.3.8.1\
	
	ID = ReadFile(#PB_Any, Parameter$+"\config\"+DirectoryName$+"_fs_options.txt", #PB_File_SharedRead|#PB_File_SharedWrite) 
	If ID 
		RunConsole(bin$+"fspatch.exe", Chr(34)+DirectoryName$+"\"+DirectoryName$+Chr(34)+" "+Chr(34)+DirectoryName$+"\config\"+DirectoryName$+"_fs_config.txt"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(51)+" erofs...")
		options$ = ReadStr(ID, "mkfs.erofs options")
		
		If LCase(ReadStr(ID, "Type")) = "sparse"
			PartType$ = "Sparse"
		EndIf
		
		Exp$ = ReadStr(ID, "Expansion")
		If Exp$ <> "" : Expansion$ = Exp$ : EndIf
		
		CloseFile(ID)
		
		Message(Lng(39)+" "+DirectoryName$+"."+Expansion$+" |"+PartType$+ "| "+Lng(30)) ;Выполняется сборка образа раздела: ... Подождите..."
		
		If options$ <> ""
			Err = RunConsole(bin$+"erofs\mkfs.erofs.exe", options$+" > nul", WorkingDirectory$, #PB_Program_Wait)
			Message(Lng(42)+" mkfs.erofs: " + Str(Err)+ExitStr(Err),1) ;Exitcode
			
			If Err <> 0 And FileSize(WorkingDirectory$+DirectoryName$+".bak") >0
				Message(Lng(70)+" "+DirectoryName$+".bak"+" "+Lng(87)+" "+DirectoryName$+"."+Expansion$) ;Переименовываем ...в...
				RenameFile(WorkingDirectory$+DirectoryName$+".bak", WorkingDirectory$+DirectoryName$+"."+Expansion$)
			Else
				If FileSize(WorkingDirectory$+DirectoryName$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
					DeleteFile(WorkingDirectory$+DirectoryName$+".bak")
				EndIf
			EndIf
			
			If Err = 0 And PartType$ = "Sparse"
				Message(Lng(166)+" "+DirectoryName$+"."+Expansion$+" |Raw| "+Lng(87)+" |Sparse|") ;Конвертируем в
				DeleteFile(WorkingDirectory$+DirectoryName$+"_raw"+"."+Expansion$, #PB_FileSystem_Force)
				RenameFile(WorkingDirectory$+DirectoryName$+"."+Expansion$, WorkingDirectory$+DirectoryName$+"_raw"+"."+Expansion$)
				Err = RunConsole(bin$+"img2simg.exe", DirectoryName$+"_raw"+"."+Expansion$+" "+DirectoryName$+"."+Expansion$, WorkingDirectory$, #PB_Program_Wait)
				Message(Lng(42)+" img2simg: " + Str(Err)+ExitStr(Err),1) ;Exitcode
				If Err = 0
					DeleteFile(WorkingDirectory$+DirectoryName$+"_raw"+"."+Expansion$, #PB_FileSystem_Force)
				Else
					DeleteFile(WorkingDirectory$+DirectoryName$+"."+Expansion$, #PB_FileSystem_Force)
					RenameFile(WorkingDirectory$+DirectoryName$+"_raw"+"."+Expansion$, WorkingDirectory$+DirectoryName$+"."+Expansion$)
				EndIf
			EndIf
				
		EndIf
		
		;Message(Lng(40)+" "+DirectoryName$+"."+Expansion$+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
		If FileSize(Parameter$+".new.dat")>=0 Or FileSize(Parameter$+".new.dat.br")>=0
			DatPack(Parameter$+"."+Expansion$)
		ElseIf FileSize(Parameter$+Expansion$+".lz4")>=0
			lz4Pack(Parameter$+"."+Expansion$)
		Else 
			Message(Lng(40)+" "+DirectoryName$+Expansion$+" "+Lng(35), 1) ;Действие по сборке образа раздела: ... завершено."
		EndIf
		
	EndIf
EndProcedure


Procedure  SuperUnpack(Parameter$)
	;Debug "super: "+Parameter$
	Protected Err, Position, Name$, oldFileNameExt$, newFileNameExt$, Raw$ = "."
	Protected Expansion$ = LCase(GetExtensionPart(Parameter$))
	Protected FileNameExpansion$ = GetFilePart(Parameter$)
	Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
	Protected WorkingDirectory$ = GetPathPart(Parameter$)
	Protected ExtractionPath$ = WorkingDirectory$+DirectoryName$
	Protected SuperSize.q, PartSize.q, FullPartSize.q
	Protected FileNameExt$, NameFile$, Ext$, config$
	Protected PartType$ = CheckSignature(Parameter$)
	If PartType$ <> "Sparse" : PartType$ = "Raw": EndIf
	
	Message(Lng(37)+" "+FileNameExpansion$+" |"+PartType$+"| "+Lng(30),1) ;Выполняется распаковка образа раздела: ... Подождите...
	If PartType$ = "Sparse"
		Message(Lng(166)+" "+FileNameExpansion$+" |Sparse| "+Lng(87)+" "+DirectoryName$+"_raw."+Expansion$+" |Raw|", 1) ;Конвертируем в
		;simg2img.exe -i super.img -o super.raw.img
		Err = RunConsole(bin$+"simg2img.exe", Chr(34)+FileNameExpansion$+Chr(34)+" "+Chr(34)+DirectoryName$+"_raw."+Expansion$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(42)+" simg2img: " + Str(Err)+ExitStr(Err),1) ;Exitcode
		Raw$ = "_raw."
	EndIf
	Cleaning(Parameter$)
	
	Message(Lng(181)+" "+DirectoryName$+Raw$+Expansion$+" |Raw|") ;Извлечение разделов из
	If IsWin64()
		;Message("Super info:")
		CreateDirectory(WorkingDirectory$+DirectoryName$+"\config")
		RunConsole(bin$+"makesuper\lpdump.exe", "--slot=0 "+Chr(34)+DirectoryName$+Raw$+Expansion$+Chr(34)+"> "+Chr(34)+DirectoryName$+"\config\super_config.txt"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		;RunConsole(bin$+"makesuper\lpdump.exe", "--slot=1 "+Chr(34)+DirectoryName$+Raw$+Expansion$+Chr(34)+"> "+Chr(34)+DirectoryName$+"\config\super_config1.txt"+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Err = RunConsole(bin$+"makesuper\lpunpack.exe", Chr(34)+DirectoryName$+Raw$+Expansion$+Chr(34)+" "+Chr(34)+DirectoryName$+Chr(34), WorkingDirectory$, #PB_Program_Wait)
		Message(Lng(42)+" lpunpack: " + Str(Err)+ExitStr(Err),1) ;Exitcode
	Else
		Err = RunConsole(bin$+"sunpack.exe", Chr(34)+WorkingDirectory$+DirectoryName$+Raw$+Expansion$+Chr(34), ExtractionPath$, #PB_Program_Wait)
		Message(Lng(42)+" superunpack: " + Str(Err)+ExitStr(Err),1) ;Exitcode
		
		;Создание недостающих файлов разделов нулевой длины
		If ExamineDirectory(0, ExtractionPath$, "*.*")
			While NextDirectoryEntry(0)
				FileNameExt$ = DirectoryEntryName(0)
				NameFile$  = GetFilePart(ExtractionPath$+"\"+FileNameExt$, #PB_FileSystem_NoExtension)
				Ext$ = GetExtensionPart(ExtractionPath$+"\"+FileNameExt$)
				If Right(NameFile$,  2) = "_a"
					NameFile$ = Left(NameFile$, Len(NameFile$)-2)
					If FileSize(ExtractionPath$+"\"+NameFile$+"_b."+Ext$) = -1
						If CreateFile(0, ExtractionPath$+"\"+NameFile$+"_b."+Ext$)  : CloseFile(0) : EndIf
					EndIf
				EndIf
			Wend
			FinishDirectory(0)
		EndIf
		
	EndIf
	
	If Err = 0
		Recent(ExtractionPath$)
		Recent(Parameter$)
	EndIf
	
	SuperSize = FileSize(WorkingDirectory$+DirectoryName$+Raw$+Expansion$)	
	
	If FileSize(ExtractionPath$+"_raw."+Expansion$)>0
		If st\Not_Delete = #PB_Checkbox_Unchecked
			DeleteFile(ExtractionPath$+"_raw."+Expansion$, #PB_FileSystem_Force)
		EndIf
	Else
		DeleteFile(ExtractionPath$+"_raw."+Expansion$, #PB_FileSystem_Force)
	EndIf
	
	If ExamineDirectory(0, ExtractionPath$, "*.img")
		If Expansion$ <> "img" : Message(Lng(70)+": *.img "+Lng(87)+" *."+Expansion$,1) : EndIf  ;Переименовываем  в
		While NextDirectoryEntry(0)
			oldFileNameExt$ = DirectoryEntryName(0)	
			newFileNameExt$ = GetFilePart(oldFileNameExt$, #PB_FileSystem_NoExtension)+"."+Expansion$
			RenameFile(ExtractionPath$+"\"+oldFileNameExt$, ExtractionPath$+"\"+newFileNameExt$)
			PartSize = FileSize(ExtractionPath$+"\"+newFileNameExt$)
			Message("Partition: "+newFileNameExt$+" Size: "+SizeIt(PartSize))
			FullPartSize+PartSize
		Wend
		Message(">< !!! "+Lng(41)+" "+SizeIt(SuperSize-FullPartSize))
		
		FinishDirectory(0)
		Message(" ")
	EndIf
	
	config$ = WorkingDirectory$+DirectoryName$+"\config\super_config.txt"
	;Debug config$
	If FileSize(config$) >0 And OpenFile(0, config$)
		FileSeek(0, Lof(0)) ; прыгаем в конец файла (используется результат функции Lof())
		WriteStringN(0, "File information:")
		WriteStringN(0, "------------------------")
		WriteStringN(0, "  FileName: "+FileNameExpansion$)
		WriteStringN(0, "  FileType: "+PartType$)
		WriteStringN(0, "  PartExt: "+Expansion$)
		WriteStringN(0, "------------------------")
		CloseFile(0)
	EndIf
	
	PartUnpack(ExtractionPath$)
EndProcedure

Procedure  SuperPack(Parameter$)
	Protected Err, txt$, Metadata_Slots = 1, Metadata_Size , Name$, FullSize.q, command$
	Protected Expansion$, FileNameExpansion$, config$
	Protected DirectoryName$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
	Protected WorkingDirectory$ = GetPathPart(Parameter$)
	Protected FolderName$ = GetFilePart(Parameter$)  
	Protected ExtractionPath$ = WorkingDirectory$+DirectoryName$
	Protected SuperSize.q, PartSize.q, GroupSize.q, Key$, PartType$, PartExt$;, Blocking$
	Protected ID, IDo, meta_size$, meta_slot$, virtual$, max_size_super$, max_size_super2$, max_size_super3$, first_sector$, first_sector_size$, group_table2$, group_table3$, name_super$
	;Debug Parameter$
	
	
	If IsWin64()
		config$ = Parameter$+"\config\super_config.txt"
		If FileSize(config$)>0
			;Упаковываем распакованные разделы
			PartPack(Parameter$)
			Message(Lng(127)+" super, "+Lng(30),1) ;Подождите
			; Открывает файл настроек
			ID = ReadFile(#PB_Any, config$) 
			If ID 
				;Debug id
				meta_size$ = Str(Val(ReadStr(ID, "Metadata max size")))
				;Debug "meta_size: "+meta_size$
				meta_slot$ = ReadStr(ID, "Metadata slot count")
				;Debug "meta_slot: "+meta_slot$
				virtual$ = ReadStr(ID, "Header flags")
				;Debug "virtual: "+virtual$
				
				FileNameExpansion$ = ReadStr(ID, "FileName")
				If FileNameExpansion$ = "" : FileNameExpansion$ = "super.img" : EndIf
				
				Name$ = GetFilePart(Parameter$, #PB_FileSystem_NoExtension)
				
				Expansion$ = LCase(GetExtensionPart(FileNameExpansion$))
				If Expansion$ = "" : Expansion$ = "img" : EndIf
				
				PartExt$ = ReadStr(ID, "PartExt")
				If Not PartExt$ = "" : Expansion$ = PartExt$  : EndIf

				PartType$ = ReadStr(ID, "FileType")
				If PartType$ = "" : PartType$ = "Raw" : EndIf
				;If Blocking$ = "" : Blocking$ = "none" : EndIf
				
				;Debug "Name$ "+Name$
				;Debug "Expansion$ " +Expansion$

				SuperSize = Val(ReadStr(ID, "Size")) ;2147483648 ;FileSize(Parameter$+"_raw.img") ;
				max_size_super$ = Str(Val(ReadStr(ID, "Maximum size","",1)))
				;Debug "max_size_super: "+max_size_super$
				max_size_super2$ = Str(Val(ReadStr(ID, "Maximum size","",2)))
				;Debug "max_size_super2: "+max_size_super2$
				max_size_super3$ = Str(Val(ReadStr(ID, "Maximum size","",3)))
				;Debug "max_size_super3: "+max_size_super3$
				first_sector$ = Str(Val(ReadStr(ID, "First sector",""))* 512)
				;Debug "first_sector: "+first_sector$
				first_sector_size$ = Str(Val(ReadStr(ID, "First sector",""))*1024)
				;Debug "first_sector_size: "+first_sector_size$
				group_table2$ = ReadStr(ID, "Name","",2,"Group table")
				;Debug group_table2$
				
				group_table3$ = ReadStr(ID, "Name","",3, "Group table")
				;Debug group_table3$
				
				name_super$ = ReadStr(ID, "Partition name","")
				;Debug name_super$
				
				txt$ = "--metadata-size="+meta_size$+" --super-name="+name_super$+" --metadata-slots="+meta_slot$+" --device=super:"+Str(SuperSize)+":"+first_sector$
				If meta_slot$ = "1" Or meta_slot$ = "2"
					txt$+" --group="+group_table2$+":"+max_size_super2$
				ElseIf meta_slot$ = "3"
					txt$+" --group="+group_table2$+":"+max_size_super2$+" --group="+group_table3$+":"+max_size_super3$
				EndIf
				
				;Debug txt$
				;Debug "SuperSize: "+SuperSize$

				For k = 1 To 100
					name$ = ReadStr(ID,  "Name", "",k,"Partition table", "Super partition layout")
					If name$="Break" : Break : EndIf
					If CheckSignature(Parameter$+"\"+name$+"."+Expansion$) = "Sparse"
						DeleteFile(Parameter$+"\"+name$+"_sparse."+Expansion$)
						RenameFile(Parameter$+"\"+name$+"."+Expansion$, Parameter$+"\"+name$+"_sparse."+Expansion$)
						Message(Lng(166)+" "+name$+"."+Expansion$+" "+Lng(167)+" Raw")
						Message(Lng(30))
						Err = RunConsole(bin$+"simg2img.exe", Chr(34)+name$+"_sparse."+Expansion$+Chr(34)+" "+Chr(34)+name$+"."+Expansion$+Chr(34), Parameter$)
						Message(Lng(42)+" simg2img: " + Str(Err)+ExitStr(Err),1) ;Exitcode
						If Err <> 0
							RenameFile(Parameter$+"\"+name$+"_sparse."+Expansion$, Parameter$+"\"+name$+"."+Expansion$)
						EndIf
					EndIf
				Next 
				
				For k = 1 To 100
					name$  		= ReadStr(ID,  "Name",		"",k,"Partition table", "Super partition layout")
					group_part$ = ReadStr(ID, "Group",		"",k,"Partition table", "Super partition layout")
					attr$  =  ReadStr(ID, "Attributes",		"",k,"Partition table", "Super partition layout") ;Blocking$ ;"none"	; =
					If name$="Break" : Break : EndIf
					;Debug name$+"     "+group_part$
					PartSize = FileSize(Parameter$+"\"+name$+"."+PartExt$)
					If PartSize < 0 : PartSize = 0 : EndIf
					GroupSize+PartSize
					;Debug name$ +": "+PartSize
					
					;txt$+" -p="+name$+":"+attr$+":"+Str(PartSize)+":"+group_part$
					txt$+" --partition="+name$+":"+attr$+":"+Str(PartSize)+":"+group_part$
					
					If PartSize <> 0
						;txt$+" -i="+name$+"=./"+name$+"."+PartExt$
						txt$+" --image="+name$+"=./"+name$+"."+PartExt$
					EndIf
					
				Next 
				
				CloseFile(ID)
			EndIf

			Message(Lng(184)+" "+SizeIt(SuperSize)+" "+Lng(185)+" "+SizeIt(GroupSize)+" "+Lng(186)+" "+SizeIt(SuperSize-GroupSize)) ;Размер Super: Размер всех разделов: Свободное пространство в Super:
			Message("Metadata Size: "+meta_size$)
			Message("Super Type: "+PartType$,1)
			
			If PartType$ = "Sparse"
				PartType$ = " --sparse"
			Else
				PartType$ = ""
			EndIf
			
			If LCase(virtual$) = LCase("virtual_ab_device") : virtual$ = " --virtual-ab" : Else : virtual$ = "" : EndIf
			;txt$+virtual$+PartType$+" -o=../"+name_super$+"."+Expansion$
			txt$+virtual$+PartType$+" --output=../"+FileNameExpansion$
			;Debug txt$
			
			If CreateFile(0, Parameter$+"\config\pack_super.sh")
				WriteString(0, "lpmake "+txt$)
				CloseFile(0)
			EndIf
			
			;BackUp Start
			If FileSize(Parameter$+"."+Expansion$)>0 And FileSize(Parameter$+".org")=-1 And st\No_Org = #PB_Checkbox_Unchecked
				Message(Lng(148)+": "+name_super$+"."+Expansion$+" => "+name_super$+".org") ;Создаётся резервная копия оригинала
				If CopyFile(Parameter$+"."+Expansion$, Parameter$+".org")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
			EndIf
			
			If FileSize(Parameter$+"."+Expansion$)>0
				Message(Lng(70)+" "+name_super$+"."+Expansion$+" "+Lng(87)+" "+name_super$+".bak") ;Переименовываем ...в...
				DeleteFile(Parameter$+".bak", #PB_FileSystem_Force)
				If RenameFile(Parameter$+"."+Expansion$, Parameter$+".bak")>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
			EndIf
			;BackUp Finish
			
			Err = RunConsole(bin$+"makesuper\lpmake.exe", txt$, Parameter$, #PB_Program_Wait)
			Message(Lng(42)+" lpmake: " + Str(Err)+ExitStr(Err),1) ;Exitcode
			
			;Recovery Start
			If FileSize(Parameter$+"."+Expansion$) = 0 Or Err <> 0
				If FileSize(Parameter$+".bak") >0
					Message(Lng(70)+" "+name_super$+".bak "+Lng(87)+" "+name_super$+"."+Expansion$) ;Переименовываем ...в...
					DeleteFile(Parameter$+"."+Expansion$)
					If RenameFile(Parameter$+".bak", Parameter$+"."+Expansion$)>0 : Message(Lng(135)) : Else : Message(Lng(136)) : EndIf
				EndIf
			Else
				
				If FileSize(Parameter$+".bak") >=0 And st\No_Backup = #PB_Checkbox_Checked
					DeleteFile(Parameter$+".bak")
				EndIf
			EndIf
			;Recovery Finish
			
		Else
			Message(Lng(25)+" "+Chr(34)+FolderName$+Chr(34)+" "+Lng(26)+" (config.txt)", 1) ;В каталоге: ... не найдена инструкция для сборки образа!
		EndIf
	Else
		Message(">< !!!  "+Lng(180), 1)	;Упаковка super возможна только на x64 системах, извините...
	EndIf
	
EndProcedure

Procedure AttributesList(Parameter$)
  If FileSize(Parameter$+"\system")<>-2 And FileSize(Parameter$+"\vendor")<>-2
    Message(Lng(90)+": add "+Lng(91)+": system "+Lng(92)+" vendor, "+Lng(93)+"!", 1) ;В папке ... отсутствуют подпапки ... и(или) ... список атрибутов не может быть создан
  Else
    Protected BusyBox$ = bin$+"busybox.exe"
    If FileSize(Parameter$+"\system")=-2
      Message(Lng(88)+": system_add.txt "+Lng(30)) ;Создание списка атрибутов файлов ... Подождите...
      RunConsole(BusyBox$, "find system -type d  | "+BusyBox$+" sed "+Chr(34)+"s/$/ 0 0 755/"+Chr(34)+" > system_add.txt", Parameter$, #PB_Program_Wait) 
      RunConsole(BusyBox$, "find system -type f  | "+BusyBox$+" sed "+Chr(34)+"s/$/ 0 0 644/"+Chr(34)+" >> system_add.txt", Parameter$, #PB_Program_Wait)
      Message(Lng(89)+": system_add.txt "+Lng(35), 1) ;Действие по созданию списка атрибутов файлов ... завершено.
    EndIf
    If FileSize(Parameter$+"\vendor")=-2
      Message(Lng(88)+": vendor_add.txt "+Lng(30)) ;Создание списка атрибутов файлов ... Подождите...
      RunConsole(BusyBox$, "find vendor -type d  | "+BusyBox$+" sed "+Chr(34)+"s/$/ 0 2000 755/"+Chr(34)+" > vendor_add.txt", Parameter$, #PB_Program_Wait) 
      RunConsole(BusyBox$, "find vendor -type f  | "+BusyBox$+" sed "+Chr(34)+"s/$/ 0 0 644/"+Chr(34)+" >> vendor_add.txt", Parameter$, #PB_Program_Wait) 
      Message(Lng(89)+": vendor_add.txt "+Lng(35), 1) ;Действие по созданию списка атрибутов файлов ... завершено.
    EndIf
  EndIf
EndProcedure

Procedure GetUILanguage()
  Protected *Lang, UserIntLang
  If OpenLibrary(0, "kernel32.dll")
    *Lang = GetFunction(0, "GetUserDefaultUILanguage")
    If *Lang
      UserIntLang = CallFunctionFast(*Lang)
    EndIf
    CloseLibrary(0)
EndIf
ProcedureReturn UserIntLang
EndProcedure

Procedure SetLanguage(UserIntLang)
	Protected PathLang$, String$, Sum, k=0,  i=0, tmp$
	Protected count=ArraySize(Lng())
	If UserIntLang=0 : UserIntLang=GetUILanguage() : EndIf
	
	If UserIntLang = 1049
		String$ = PeekS(?lng, ?end_lng-?lng, #PB_UTF8|#PB_ByteLength)
		String$ = RemoveString(String$, Chr(13))
		Sum 	= CountString (String$ , Chr(10))+1
		For k = 1 To Sum
			tmp$ = StringField(String$, k, Chr(10))
			If tmp$ And Left(tmp$, 1) <> ";"
				i+1
				If i > count : Break : EndIf ;Прерываем цикл, если в файле больше строк, чем в таблице.
				Lng(i) = tmp$
			EndIf
		Next
	Else
		PathLang$ = bin$+"language\"+Str(UserIntLang)+".lng"
		If FileSize(PathLang$) > 1 And ReadFile(9, PathLang$)
			ReadStringFormat(9)
			While Eof(9) = 0
				tmp$ = ReadString(9) 
				If tmp$ And Left(tmp$, 1) <> ";"
					i+1
					If i > count : Break :EndIf ;Прерываем цикл, если в файле больше строк, чем в таблице.
					Lng(i) = tmp$
				EndIf
			Wend
			CloseFile(9)
		Else
			st\Locale_ID=1049
			SetLanguage(st\Locale_ID)
		EndIf
	EndIf
EndProcedure

Procedure Recent(NewFilename.s)
  If FileSize(Recentfilename)>0 
    If OpenFile(#FP,Recentfilename)<>0
      ClearList(Files())
      If NewFilename<>""
        AddElement(Files())
        Files()=NewFilename;Set as first element
      EndIf
      While Eof(#FP)=0
        sDummy.s=ReadString(#FP)
        If sDummy<>NewFilename ;is already here ?
          If ListSize(Files())<10 ; we allow only 10 Files in the Recentlist
            If sDummy<>""         ;No NULL-STRING
              AddElement(Files())
              Files()=sDummy
            EndIf
          EndIf
        EndIf
      Wend
      CloseFile(#FP)
      ResetList(Files())
      If OpenFile(#FP,Recentfilename)<>0
        While NextElement(Files())       ; Process all the elements...
          WriteStringN(#FP,Files())
        Wend
        CloseFile(#FP)
      EndIf
    EndIf
  Else
    ;New one
    If NewFilename<>""
      If CreateFile(#FP,Recentfilename)>0
        WriteStringN(#FP,NewFilename)
        CloseFile(#FP)
      EndIf
      AddElement(Files())
      Files()=NewFilename
    EndIf
  EndIf 
  MakeMenuBar()
EndProcedure

Procedure CreateRecentMenu()
	ResetList(Files())
	While NextElement(Files())
		Index = ListIndex(Files())
		Path$ = Files()
		If FileSize(Path$) = -2 ;GetExtensionPart(Path$) <> ""
			MenuItem(#MenuRecentFiles+Index, Path$, ImageID(4))
		Else
			MenuItem(#MenuRecentFiles+Index, Path$, ImageID(3))
		EndIf
	Wend
	If ListSize(Files()) >0
		MenuBar()
		MenuItem(#ClearList, Lng(109), ImageID(5))
	EndIf
EndProcedure

Procedure CreateEditMenu()
	MenuItem(#LogClear, Lng(11)+Chr(9)+"DEL", ImageID(5)) ;Очистить лог окно
	MenuBar()
	MenuItem(#Copy, Lng(95)+Chr(9)+"Ctrl+C", ImageID(17)) ;Копировать
	MenuItem(#Paste, Lng(169)+Chr(9)+"Ctrl+V", ImageID(21)) ;Вставить
	MenuItem(#SetSel, Lng(96)+Chr(9)+"Ctrl+A", ImageID(17))	;Выделить всё
	MenuItem(#Highlight, Lng(134)+Chr(9)+"Ctrl+H", ImageID(20)) ;Подсветить
	MenuBar()
	MenuItem(#SearchGoogle,  Lng(172)+" google"+Chr(9)+"Ctrl+G", ImageID(22)) ;Поиск в google
	MenuItem(#SearchPda, Lng(172)+" 4pda"+Chr(9)+"Ctrl+P", ImageID(12))	   ;Поиск в 4pda
	MenuBar()
	MenuItem(#GoogleTranslate, "Translate Google"+Chr(9)+"Ctrl+T", ImageID(23))	   ;Перевести
	MenuBar()
	MenuItem(#SaveAs, Lng(97)+Chr(9)+"Ctrl+S", ImageID(18)) ;Сохранить как...
	
	Protected selStart = 0, selEnd = 0 
	If IsGadget(#Editor) And IsMenu(#EditMenu)
		SendMessage_(GadgetID(#Editor), #EM_GETSEL, @selStart, @selEnd) 
		If selStart = selEnd 
			DisableMenuItem(#EditMenu, #Copy, #True) 
			DisableMenuItem(#EditMenu, #SearchGoogle, #True) 
			DisableMenuItem(#EditMenu, #SearchPda, #True) 
			DisableMenuItem(#EditMenu, #GoogleTranslate, #True)	
		Else 
			;DisableMenuItem(#EditMenu, #Copy, #False) 
		EndIf 
	EndIf
	
	If IsGadget(#Editor) And IsMenu(#EditMenu) And  GetClipboardText() = ""
		DisableMenuItem(#EditMenu, #Paste, #True) 
	EndIf
	
EndProcedure

Procedure ico2bmp(nIco)
  Protected  nBmp=CreateImage(#PB_Any,16,16,32)
  StartDrawing(ImageOutput(nBmp))
  Box(0,0,16,16,GetSysColor_(#COLOR_MENU)) ;RGB(240,240,240))
  DrawImage(ImageID(nIco),0,0,16,16)
  StopDrawing()
  ProcedureReturn nBmp
EndProcedure

Procedure SystemMenuAddItems()
  Protected hwnd = GetSystemMenu_(WindowID(#WIN_MAIN), #False) 
  Protected Item = GetMenuItemCount_(hwnd)
  InsertMenu_(hwnd, Item, #MF_BYPOSITION|#MF_SEPARATOR, 0, 0)
  Item+1
  InsertMenu_(hwnd, Item, #MF_BYPOSITION|#MF_STRING, #About, Lng(18))
  SetMenuItemBitmaps_(hwnd,Item, #MF_BYPOSITION, ImageID(ico2bmp(7)), #Null)
EndProcedure

Procedure MakeMenuBar() ;Создаём MenuBar
  Protected Index, Path$
  If CreateImageMenu(#ImageMenu, WindowID(#WIN_MAIN))  ; Здесь начинается создание меню....
    MenuTitle(Lng(4))                                  ;Файл
    MenuItem(#Unpack, Lng(5), ImageID(3))              ;Разобрать
    MenuItem(#Pack, Lng(6), ImageID(4))                ;Собрать
    ; --------- Недавние
    OpenSubMenu(Lng(7),ImageID(11))                    ;Недавние
    CreateRecentMenu()
    CloseSubMenu()
    ; ---------
    MenuBar(); Здесь будет вставлен разделитель
    MenuItem(#Settings, Lng(8), ImageID(9)) ;Настройки
    MenuItem(#CmdLine, Lng(187), ImageID(24))
    MenuBar()
    MenuItem(#Exit, Lng(9), ImageID(2)) ;Выход
    MenuTitle(Lng(10))                  ;Правка
    CreateEditMenu()
    MenuTitle(Lng(118)) ;Вид
    MenuItem(#OnTop, Lng(44))    ;Поверх всех окон
    SetMenuItemState(#ImageMenu, #OnTop, st\Main_Top) 
    MenuBar()
    MenuItem(#ToolbarShow, Lng(114))    ;Панель инструментов
    SetMenuItemState(#ImageMenu, #ToolbarShow, st\Toolbar_Set) 
    MenuItem(#VerticalPanel, Lng(119)) ;Вертикальная панель
    If st\Toolbar_Set=2
      SetMenuItemState(#ImageMenu, #VerticalPanel, #True)
    EndIf
    MenuBar()
    MenuItem(#OpenSettings, Lng(170)) ;Настройки при запуске
    SetMenuItemState(#ImageMenu, #OpenSettings, st\Open_Settings) 
    MenuBar()
    MenuItem(#CreateShortcut, Lng(120), ImageID(19));Создать ярлык на столе
    MenuTitle(Lng(12))								;Помощь
    MenuItem(#Help, Lng(13), ImageID(6))			;Справка
    MenuItem(#News, Lng(99), ImageID(8))			;Новости
    MenuItem(#Discussion, Lng(15), ImageID(8))		;Обсуждение
;     MenuItem(#Pda, Lng(14), ImageID(12))    		;Страничка
    MenuItem(#AuthorChannel, Lng(16), ImageID(10))	;Канал автора
    MenuItem(#About, Lng(18), ImageID(7))			;О программе
    
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_Z, #Undo)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Delete, #LogClear)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_C, #Copy)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_V, #Paste)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_A, #SetSel)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_H, #Highlight)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_G, #SearchGoogle)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_P, #SearchPda)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_T, #GoogleTranslate)
    AddKeyboardShortcut(#WIN_MAIN, #PB_Shortcut_Control | #PB_Shortcut_S, #SaveAs)
  EndIf
EndProcedure

Procedure MenuGadgetState()
  SetMenuItemState(#ImageMenu, #OnTop, st\Main_Top)
  If IsGadget(#CheckBox_Main_Top) : SetGadgetState(#CheckBox_Main_Top, st\Main_Top) : EndIf
  
  If st\Toolbar_Set=#False
    SetMenuItemState(#ImageMenu, #VerticalPanel, #False)
    If IsGadget(#Option_None) : SetGadgetState(#Option_None, #True) : EndIf
  ElseIf st\Toolbar_Set=#True
    SetMenuItemState(#ImageMenu, #VerticalPanel, #False)
    If IsGadget(#Option_Horizontally) : SetGadgetState(#Option_Horizontally, #True) : EndIf
  ElseIf st\Toolbar_Set=2
    SetMenuItemState(#ImageMenu, #VerticalPanel, #True)
    If IsGadget(#Option_Vertical) : SetGadgetState(#Option_Vertical, #True) : EndIf
  EndIf
  SetMenuItemState(#ImageMenu, #ToolbarShow, st\Toolbar_Set) 
  SetMenuItemState(#ImageMenu, #OpenSettings, st\Open_Settings) 
EndProcedure

Procedure MakeToolBar() ;Создаём меню инструментов;
  If IsToolBar(#ToolBar)>0 : FreeToolBar(#ToolBar) : EndIf
  If IsGadget(#Container)>0 : ResizeGadget(#Container, #PB_Ignore, #PB_Ignore, 0, #PB_Ignore) : EndIf
  
  If st\Toolbar_Set = 1
    CreateToolBar(#ToolBar, WindowID(#WIN_MAIN)) ;, #PB_ToolBar_Large
  ElseIf st\Toolbar_Set = 2 And IsGadget(#Container)>0
    ResizeGadget(#Container, #PB_Ignore, #PB_Ignore, 20, #PB_Ignore)
    If CreateToolBar(#ToolBar, GadgetID(#Container))>0 ;, #PB_ToolBar_Large
      SetWindowLongPtr_(ToolBarID(#ToolBar),#GWL_STYLE,GetWindowLongPtr_(ToolBarID(#ToolBar),#GWL_STYLE)|#TBSTYLE_WRAPABLE)
    EndIf
  EndIf
  If IsToolBar(#ToolBar)>0
    ToolBarImageButton(#LogClear, ImageID(5))
    ToolBarToolTip(#ToolBar, #LogClear, Lng(11))
    ToolBarImageButton(#SaveAs, ImageID(18))
    ToolBarToolTip(#ToolBar, #SaveAs, Lng(97))
    ToolBarImageButton(#Unpack, ImageID(3))
    ToolBarToolTip(#ToolBar, #Unpack, Lng(5))
    ToolBarImageButton(#Pack, ImageID(4))
    ToolBarToolTip(#ToolBar, #Pack, Lng(6))
    ToolBarImageButton(#ToolBarRecentFiles, ImageID(11))
    ToolBarToolTip(#ToolBar, #ToolBarRecentFiles, Lng(7))
    ToolBarSeparator()
    ToolBarImageButton(#Settings, ImageID(9))
    ToolBarToolTip(#ToolBar, #Settings, Lng(8))
    
    ToolBarImageButton(#CmdLine, ImageID(24))
    ToolBarToolTip(#ToolBar, #CmdLine, Lng(187))
    
    ToolBarSeparator()
    ToolBarImageButton(#News, ImageID(8))
    ToolBarToolTip(#ToolBar, #News, Lng(99))
;     ToolBarImageButton(#Pda, ImageID(12))
;     ToolBarToolTip(#ToolBar, #Pda, Lng(14))
    ToolBarImageButton(#AuthorChannel, ImageID(10))
    ToolBarToolTip(#ToolBar, #AuthorChannel, Lng(16))
    ToolBarImageButton(#About, ImageID(7))
    ToolBarToolTip(#ToolBar, #About, Lng(18))
  EndIf
EndProcedure

;-->>> Создаём ГЛАВНОЕ ОКНО
Procedure WindowMain()
  Protected WinMainFlags, Editor_x, Editor_y, Editor_w, Editor_h
  If GetSystemMetrics_(#SM_CXSCREEN)=st\Desktop_Width And GetSystemMetrics_(#SM_CYSCREEN)=st\Desktop_Height And st\Main_X>0 And st\Main_Y>0 And st\Main_Width>=473 And st\Main_Height>=251
    WinMainFlags = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget
  Else
    st\Main_Width = 473 : st\Main_Height = 308
    WinMainFlags = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered
  EndIf 
  
  If st\Main_Maximize ; Окно при создании, не отображаем
    WinMainFlags = WinMainFlags + #PB_Window_Invisible
  EndIf

  OpenWindow(#WIN_MAIN,  st\Main_X, st\Main_Y, st\Main_Width, st\Main_Height, ProgramName$, WinMainFlags) ;ἄλφα βeta
  
  If st\Main_Maximize ; Максимизируем окно при запуске
    SetWindowState(#WIN_MAIN, #PB_Window_Maximize)
    HideWindow(#WIN_MAIN, #False) 
  EndIf
  
  SmartWindowRefresh(#WIN_MAIN, #True)
  WindowBounds(#WIN_MAIN, 473, 308, #PB_Ignore, #PB_Ignore) ; Задаёт минимальные и максимальные размеры указанного Окна
  SetWinOpacity(WindowID(#WIN_MAIN), st\Window_Transparency); Включаем прозрачность окна программы
  StickyWindow(#WIN_MAIN, #True) ; Поверх всех окон
  If Not st\Main_Top
    StickyWindow(#WIN_MAIN, st\Main_Top)   ; Поверх всех окон                   
  EndIf

  SetLanguage(st\Locale_ID) ;Установка языка интерфейса
  SystemMenuAddItems() ;Системное меню на значке программы
  Recent("");Init the RecentFiles-list
  
  ContainerGadget(#Container, 0, 0, 20, 260, #PB_Container_BorderLess) ;260
  ;SetGadgetColor(#Container , #PB_Gadget_BackColor, $000000)
  CloseGadgetList()
  
  MakeToolBar()
  EditorCreateResize()
  
  SendMessage_(GadgetID(#Editor),#EM_SETTARGETDEVICE, #Null, 0)
  SetGadgetColor(#Editor , #PB_Gadget_BackColor, st\Editor_BackColor) ;цвет фона
  SetGadgetColor(#Editor, #PB_Gadget_FrontColor, st\Editor_FontColor) ;цвет шрифта
  SendMessage_(GadgetID(#Editor), #EM_SETMARGINS, #EC_LEFTMARGIN, 6|0 << 16) ;отступ от левого угла
  ;гиперлинки
  SendMessage_(GadgetID(#Editor), #EM_SETEVENTMASK, 0, #ENM_LINK|SendMessage_(GadgetID(#Editor), #EM_GETEVENTMASK, 0, 0))
  SendMessage_(GadgetID(#Editor), #EM_AUTOURLDETECT, #True, 0)
  
  If Len(st\Editor_FontName) = 0
    If OSVersion() >= #PB_OS_Windows_7
      st\Editor_FontName = "Consolas"
    Else
      st\Editor_FontName = "Courier New"
    EndIf
  EndIf
  SetGadgetFont(#Editor, LoadFont(0, st\Editor_FontName, st\Editor_FontSize, st\Editor_FontStyle))
  
  DragAcceptFiles(#Editor)
  
  CreateStatusBar(#StatusBar, WindowID(#WIN_MAIN))
  AddStatusBarField(23)
  StatusBarImage(#StatusBar, 0, ImageID(1), #PB_StatusBar_BorderLess)
  AddStatusBarField(#PB_Ignore)
  StatusBarText(#StatusBar, 1, Lng(71), #PB_StatusBar_BorderLess) ;Нет активных действий.
EndProcedure

 ;-->>> Создаём окно настроек
Procedure WindowSettings()
  If Not IsWindow(#WIN_SETTING)  
    If GetSystemMetrics_(#SM_CXSCREEN)=st\Desktop_Width And GetSystemMetrics_(#SM_CYSCREEN)=st\Desktop_Height And st\Setting_X <> #PB_Ignore And st\Setting_Y <> #PB_Ignore And st\Setting_X>0 And st\Setting_Y>0
      Flags = #PB_Window_SystemMenu | #PB_Window_SizeGadget
    Else 
      Flags = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_WindowCentered
    EndIf
    If OpenWindow(#WIN_SETTING, st\Setting_X, st\Setting_Y, st\Setting_Width, st\Setting_Height, Lng(8), Flags, WindowID(#WIN_MAIN)) ;Настройки
      SendMessage_ (WindowID(#WIN_SETTING), #WM_SETICON, 0, ImageID(9))
      ;SetWinOpacity(WindowID(#WIN_SETTING), st\Window_Transparency) ;Прозрачность окна
      WindowBounds(#WIN_SETTING, 395, 383, #PB_Ignore, #PB_Ignore)
      Protected Font = LoadFont( #PB_Any, "Segoe UI", 10, #PB_Font_Italic)
      PanelGadget(#Panel, 0, 0, WindowWidth(#WIN_SETTING), WindowHeight(#WIN_SETTING))
      ; --------
      AddGadgetItem (#Panel, -1, Lng(50)) ;Распаковка
      FrameGadget(#PB_Any, 10,  10, 364, 172, Lng(52)+" ") ;После распаковки образа прошивки:
      CheckBoxGadget(#CheckBox_Unpack_Super, 20, 30, 285, 20, Lng(53)+ " SUPER (Win x86/x64)") ;Распаковывать раздел:
      SetGadgetState(#CheckBox_Unpack_Super, st\Unpack_Super)
     If IsFont(Font) : SetGadgetFont(#CheckBox_Unpack_Super, FontID(Font))  : EndIf
      CheckBoxGadget(#CheckBox_Unpack_System, 20, 55, 265, 20, Lng(53)+ " SYSTEM") ;Распаковывать раздел:
      SetGadgetState(#CheckBox_Unpack_System, st\Unpack_System)
      CheckBoxGadget(#CheckBox_Unpack_Vendor, 20,  80, 265, 20, Lng(53)+" VENDOR") ;Распаковывать раздел:
      SetGadgetState(#CheckBox_Unpack_Vendor, st\Unpack_Vendor)
      CheckBoxGadget(#CheckBox_Unpack_Product, 20,  105, 265, 20, Lng(53)+" PRODUCT") ;Распаковывать раздел:
      SetGadgetState(#CheckBox_Unpack_Product, st\Unpack_Product)
      CheckBoxGadget(#CheckBox_Unpack_Odm, 20,  130, 265, 20, Lng(53)+" ODM") ;Распаковывать раздел:
      SetGadgetState(#CheckBox_Unpack_Odm, st\Unpack_Odm)
      CheckBoxGadget(#CheckBox_Open_Folder, 20,  155, 265, 20, Lng(54)) ;Открывать папку в проводнике
      SetGadgetState(#CheckBox_Open_Folder, st\Open_Folder)
      FrameGadget(#PB_Any, 10,  185, 364, 45, "RockChip"+" ")
      TextGadget(#PB_Any, 20, 205, 97, 20, "imgRePackerRK") 
      OptionGadget(#Option_Version_Six, 120, 203, 60, 20, "v 1.06")
      OptionGadget(#Option_Version_Seven, 180, 203, 100, 20, "v 1.07 h_test")
      If st\Ver = "107"
        SetGadgetState(#Option_Version_Seven, #True)  ; сделать активной опцию
      Else 
        SetGadgetState(#Option_Version_Six, #True)  ; сделать активной опцию
      EndIf
      
      CheckBoxGadget(#CheckBox_Subfolder, 20,  245, 345, 20, Lng(137)) ;Распаковывать архив в подпапку
      SetGadgetState(#CheckBox_Subfolder, st\Subfolder)
      CheckBoxGadget(#CheckBox_Seven_UnPack, 20,  270, 345, 20, Lng(138)) ;Распаковка прошивки, после извлечения из архива
      SetGadgetState(#CheckBox_Seven_UnPack, st\Seven_UnPack)
      CheckBoxGadget(#CheckBox_Delete_Archive, 20,  295, 345, 20, Lng(139)) ;Удалять архив после извлечения содержимого
      SetGadgetState(#CheckBox_Delete_Archive, st\Delete_Archive)
      
      If st\Subfolder = #PB_Checkbox_Unchecked
        DisableGadget(#CheckBox_Seven_UnPack, #True)
    EndIf
    
    CheckBoxGadget(#CheckBox_Not_Delete, 20,  320, 345, 20, Lng(81)) ;Не удалять промежуточные разделы
      
      ; --------
      AddGadgetItem (#Panel, -1, Lng(51)) ;Упаковка
      FrameGadget(#PB_Any, 10,  10, 364, 150, Lng(55)+" ") ;До упаковки прошивки:
      CheckBoxGadget(#CheckBox_Pack_System, 20,  30, 345, 20, Lng(56)+" SYSTEM") ;Собрать  раздел:
      SetGadgetState(#CheckBox_Pack_System, st\Pack_System)
      CheckBoxGadget(#CheckBox_Pack_Vendor, 20,  55, 345, 20, Lng(56)+" VENDOR") ;Собрать  раздел:
      SetGadgetState(#CheckBox_Pack_Vendor, st\Pack_Vendor)
      CheckBoxGadget(#CheckBox_Pack_Product, 20,  80, 345, 20, Lng(56)+" PRODUCT") ;Собрать  раздел:
      SetGadgetState(#CheckBox_Pack_Product, st\Pack_Product)
      CheckBoxGadget(#CheckBox_Pack_Odm, 20, 105, 345, 20, Lng(56)+" ODM") ;Собрать  раздел:
      SetGadgetState(#CheckBox_Pack_Odm, st\Pack_Odm)
      CheckBoxGadget(#CheckBox_Pack_Super, 20,  130, 345, 20, Lng(56)+" SUPER (Win x64 Only!)") ;Собрать  раздел:
      SetGadgetState(#CheckBox_Pack_Super, st\Pack_Super)
      If IsFont(Font) : SetGadgetFont(#CheckBox_Pack_Super, FontID(Font))  : EndIf
      FrameGadget(#PB_Any, 10,  168, 364, 70, "Amlogic ")
      CheckBoxGadget(#CheckBox_Index, 20,  185, 345, 20, Lng(57)) ;Добавлять индекс в название файла прошивки
      SetGadgetState(#CheckBox_Index, st\Index_Add)
      CheckBoxGadget(#CheckBox_Open_UsbTool, 20,  210, 300, 20, Lng(58)+" Amlogic USB Burning Tool"); : DisableGadget(#CheckBox_Open_UsbTool, 1) ;Открыть образ в
      If FileSize(st\Path_UsbTool)<>-1
        SetGadgetState(#CheckBox_Open_UsbTool, st\Open_UsbTool)
      EndIf
      ButtonGadget(#Button_Open_UsbTool, 344, 211, 20, 20, "...")
      GadgetToolTip(#Button_Open_UsbTool, Lng(59)+" USB_Burning_Tool.exe") ;Указать путь к файлу:
      
      CheckBoxGadget(#CheckBox_Get_Hash, 20,  245, 345, 20, Lng(140)+": *.md5") ;Создавать файл хеша образа прошивки
      SetGadgetState(#CheckBox_Get_Hash, st\Get_Hash)
      CheckBoxGadget(#CheckBox_Seven_Pack, 20,  270, 345, 20, Lng(141)+": *.7z") ;После сборки прошивки, упаковать её в архив
      SetGadgetState(#CheckBox_Seven_Pack, st\Seven_Pack)

      TextGadget(#PB_Any, 20, 297, 110, 20, Lng(105)) ;Уровень сжатия:;#Text_Compress_Level
      ComboBoxGadget(#ComboBox_Seven_Level, 130, 294, 40, 20)
      AddGadgetItem(#ComboBox_Seven_Level, -1,"0")
      AddGadgetItem(#ComboBox_Seven_Level, -1,"1")
      AddGadgetItem(#ComboBox_Seven_Level, -1,"3")
      AddGadgetItem(#ComboBox_Seven_Level, -1,"5")
      AddGadgetItem(#ComboBox_Seven_Level, -1,"7")
      AddGadgetItem(#ComboBox_Seven_Level, -1,"9")
      If st\Seven_Level= "0"
        SetGadgetState(#ComboBox_Seven_Level, 0)
      ElseIf st\Seven_Level = "1"
        SetGadgetState(#ComboBox_Seven_Level, 1)
      ElseIf st\Seven_Level = "3"
        SetGadgetState(#ComboBox_Seven_Level, 2)
      ElseIf st\Seven_Level = "5"
        SetGadgetState(#ComboBox_Seven_Level, 3)
      ElseIf st\Seven_Level = "7"
        SetGadgetState(#ComboBox_Seven_Level, 4)
      ElseIf st\Seven_Level = "9"
        SetGadgetState(#ComboBox_Seven_Level, 5)
      EndIf
      
      TextGadget(#PB_Any, 205, 297, 90, 20, Lng(143)+": ") ;Размер тома:
      ;SetGadgetColor(#PB_Any, #PB_Gadget_BackColor, RGB(0 , 255 , 0))
      StringGadget(#String_Size_Part, 295, 294, 40, 20, st\Size_Part, #PB_String_Numeric)
      TextGadget(#PB_Any, 340, 297, 50, 20, "Mb")

      CheckBoxGadget(#CheckBox_Delete_Image, 20,  320, 345, 20, Lng(142)) ;Удалять образ прошивки, после сжатия в архив
      SetGadgetState(#CheckBox_Delete_Image, st\Delete_Image)
      
      If st\Seven_Pack = #PB_Checkbox_Unchecked
        DisableGadget(#ComboBox_Seven_Level, #True)
        DisableGadget(#String_Size_Part, #True)
        DisableGadget(#CheckBox_Delete_Image, #True)
      EndIf
      ; --------
      AddGadgetItem (#Panel, -1, Lng(82)) ;Прочее
      ;CheckBoxGadget(#CheckBox_Not_Delete, 10,  10, 240, 20, Lng(81)) ;Не удалять промежуточные разделы
      SetGadgetState(#CheckBox_Not_Delete, st\Not_Delete)
      CheckBoxGadget(#CheckBox_Transfer, 10,  10, 240, 20, Lng(106)+" 4") ;Список передачи версии:
      SetGadgetState(#CheckBox_Transfer, st\Transfer)
      FrameGadget(#PB_Any, 10,  37, 364, 70, "Brotli keys: ")
      TextGadget(#PB_Any, 20, 56, 250, 20, Lng(108)) ;Декомпрессия
      StringGadget(#String_Decompress, 120,  52, 243, 20, st\Decompress)
      TextGadget(#PB_Any, 20, 80, 250, 20, Lng(107)) ;Компрессия
      StringGadget(#String_Compress, 120,  78, 243, 20, st\Compress)
      FrameGadget(#PB_Any, 10,  111, 364, 70, "Update.zip: ")
      TextGadget(#Text_Compress_Level, 20, 133, 120, 20, Lng(105)) ;Уровень сжатия:
      ComboBoxGadget(#ComboBox_Compress_Level, 140, 129, 40, 20) 
      AddGadgetItem(#ComboBox_Compress_Level, -1,"0")
      AddGadgetItem(#ComboBox_Compress_Level, -1,"1")
      AddGadgetItem(#ComboBox_Compress_Level, -1,"3")
      AddGadgetItem(#ComboBox_Compress_Level, -1,"5")
      AddGadgetItem(#ComboBox_Compress_Level, -1,"7")
      AddGadgetItem(#ComboBox_Compress_Level, -1,"9")
      If st\Compress_Level= "0"
        SetGadgetState(#ComboBox_Compress_Level, 0)
      ElseIf st\Compress_Level = "1"
        SetGadgetState(#ComboBox_Compress_Level, 1)
      ElseIf st\Compress_Level = "3"
        SetGadgetState(#ComboBox_Compress_Level, 2)
      ElseIf st\Compress_Level = "5"
        SetGadgetState(#ComboBox_Compress_Level, 3)
      ElseIf st\Compress_Level = "7"
        SetGadgetState(#ComboBox_Compress_Level, 4)
      ElseIf st\Compress_Level = "9"
        SetGadgetState(#ComboBox_Compress_Level, 5)
      EndIf
      CheckBoxGadget(#CheckBox_Signature, 20,  152, 220, 20, Lng(104)) ;Подпись тестовым ключём
      SetGadgetState(#CheckBox_Signature, st\Signature)
      
      FrameGadget(#PB_Any, 10,  186, 364, 100, "Make ext4: ")
      CheckBoxGadget(#CheckBox_Expand_Size, 20,  209, 300, 20, Lng(144)) ;Собирать разделы не превышая исходный размер
      SetGadgetState(#CheckBox_Expand_Size, st\Expand_Size)
      
      TextGadget(#Text_Expand_Size, 20, 235, 214, 20, Lng(145)+":") ;Добавлять свободное пространство
      ;SetGadgetColor(#Text_Expand_Size, #PB_Gadget_BackColor, $0000FF)
      StringGadget(#String_Expand_Size, 235,  232, 50, 20, Str(st\Free_Space), #PB_String_Numeric) : DisableGadget(#String_Expand_Size, st\Expand_Size)
      TextGadget(#PB_Any, 290, 235, 50, 20, "Mb")
      
      CheckBoxGadget(#CheckBox_Resize, 20,  257, 290, 20, Lng(171)) : DisableGadget(#CheckBox_Resize, st\Expand_Size) ;Обрезать свободное пространство
      SetGadgetState(#CheckBox_Resize, st\Resize)

      CheckBoxGadget(#CheckBox_No_Backup, 10,  295, 290, 20, Lng(146)+" (*.bak)") ;Не сохранять резервные копии
      SetGadgetState(#CheckBox_No_Backup, st\No_Backup)
      
      CheckBoxGadget(#CheckBox_No_Org, 10,  320, 290, 20, Lng(147)+" (*.org)") ;Не резервировать оригинал
      SetGadgetState(#CheckBox_No_Org, st\No_Org)
      
      
      ; -------- 
      AddGadgetItem (#Panel, -1, Lng(127)) ;Сборка
      CheckBoxGadget(#CheckBox_Framework, 10,  10, 270, 20, Lng(128)+" framework-res.apk") ;Использовать внешний
      If FileSize(bin$+"framework\framework-res.apk")=-1
        st\Framework = #PB_Checkbox_Unchecked
      EndIf
      SetGadgetState(#CheckBox_Framework, st\Framework)
      ButtonGadget(#Button_Framework, 330, 10, 20, 20, "...")
      GadgetToolTip(#Button_Framework, Lng(129)+" framework-res.apk") ;Выбрать файл
      CheckBoxGadget(#CheckBox_SignatureApk, 10,  35, 270, 20, Lng(104)) ;Подпись тестовым ключём
      SetGadgetState(#CheckBox_SignatureApk, st\SignatureApk)
      CheckBoxGadget(#CheckBox_Alignment, 10,  60, 270, 20, Lng(130)) ;Выравнивание всех несжатых данных
      SetGadgetState(#CheckBox_Alignment, st\Alignment)
      ; --------
      AddGadgetItem (#Panel, -1, Lng(43)) ;Окно
      CheckBoxGadget(#CheckBox_Main_Top, 10,  10, 140, 20, Lng(44)) ;Поверх всех окон
      ButtonGadget(#Button_Color_Window, 219, 12, 100, 20, Lng(45)) ;Фон окна
      SetGadgetState(#CheckBox_Main_Top, st\Main_Top)
      TextGadget(#Text_Transparency, 10, 35, 250, 20, Lng(46)) ;Прозрачность окна
      TrackBarGadget(#TrackBar_Transparency, 10, 55, 315, 20, 100, 255) : SetGadgetState(#TrackBar_Transparency, st\Window_Transparency)
      TextGadget(#Text_Transparency_Level, 340, 55, 30, 20, Str(st\Window_Transparency)) 
      ButtonGadget(#Button_Font_Window, 14, 85, 100, 20, Lng(47)) ;Шрифт окна
      ButtonGadget(#Button_Color_Font, 219, 85, 100, 20, Lng(48)) ;Цвет шрифта
      TextGadget(#Text_Font_Size, 10, 115, 250, 20, Lng(49)) ;Размер шрифта
      TrackBarGadget(#TrackBar_Font_Size, 10, 135, 315, 20, 8, 72) : SetGadgetState(#TrackBar_Font_Size, st\Editor_FontSize)
      TextGadget(#Text_Font_Level, 340, 135, 30, 20, Str(st\Editor_FontSize)) 
      FrameGadget(#PB_Any, 10,  165, 364, 45, Lng(114)+" ") ;Панель инструментов
      OptionGadget(#Option_Horizontally, 20, 182, 110, 20, Lng(115)) ;Горизонтально
      OptionGadget(#Option_Vertical, 173, 182, 100, 20, Lng(116)) ;"Вертикально"
      OptionGadget(#Option_None, 303, 182, 60, 20, Lng(117)) ;Нет
      If st\Toolbar_Set = #True
        SetGadgetState(#Option_Horizontally, #True)  ; сделать активной опцию
      ElseIf st\Toolbar_Set = 2
        SetGadgetState(#Option_Vertical, #True)  ; сделать активной опцию
      ElseIf st\Toolbar_Set = #False
        SetGadgetState(#Option_None, #True)  ; сделать активной опцию
      EndIf
      
      CheckBoxGadget(#CheckBox_Auto_Exit, 10,  222, 150, 20, Lng(168)+":") ;Авто закрытие через:
      SetGadgetState(#CheckBox_Auto_Exit, st\Auto_Exit)
      ComboBoxGadget(#ComboBox_AutoExit_Time, 160, 221, 50, 23) 
      For k=0 To 10
        AddGadgetItem(#ComboBox_AutoExit_Time, -1,Str(k))
      Next
      SetGadgetState(#ComboBox_AutoExit_Time, st\AutoExit_Time)
      If st\Auto_Exit = #PB_Checkbox_Unchecked
        DisableGadget(#ComboBox_AutoExit_Time, #True)
      EndIf

      ; --------
      AddGadgetItem (#Panel, -1, Lng(60)) ;Звук "Сигнал");
      CheckBoxGadget(#CheckBox_Finish_Sound, 10,  10, 260, 20, Lng(62)) ;Сигнал после выполнения всех действий
      SetGadgetState(#CheckBox_Finish_Sound, st\Finish_Sound)
      TextGadget(#Text_Volume, 10, 35, 250, 20, Lng(61)) ;Громкость
      TrackBarGadget(#TrackBar_Volume_level, 10, 55, 328, 20, 0, 100)
      SetGadgetState(#TrackBar_Volume_level, st\Volume_level)
      TextGadget(#Text_Volume_level, 353, 55, 30, 20, Str(st\Volume_Level)) 
      CheckBoxGadget(#CheckBox_Play_Sound, 10,  85, 250, 20, Lng(63)) ;Воспроизвести аудио сигнал
      ; --------
      AddGadgetItem (#Panel, -1, Lng(85)) ;Язык
      FrameGadget(#PB_Any, 10,  10, 364, 220, Lng(86)+" ") ;Язык интерфейса
      ComboBoxGadget(#ComboBox_Language, 20, 30, 343, 23) 
      AddGadgetItem(#ComboBox_Language, -1,"Auto")
      AddGadgetItem(#ComboBox_Language, -1,"English - United States ") ;  (LCID: 1033)
      AddGadgetItem(#ComboBox_Language, -1,"Russian")             ;   (LCID: 1049)
      AddGadgetItem(#ComboBox_Language, -1,"Chinese Traditional") ;   (LCID:  1028)
      AddGadgetItem(#ComboBox_Language, -1,"Chinese Simplified")  ;   (LCID:  2052)
      AddGadgetItem(#ComboBox_Language, -1,"Belarusian")          ;   (LCID:  1059)
      AddGadgetItem(#ComboBox_Language, -1,"Ukrainian ")          ;   (LCID:  1058)
      AddGadgetItem(#ComboBox_Language, -1,"Portuguese - Brazil") ;   (LCID:  1046)
      AddGadgetItem(#ComboBox_Language, -1,"Vietnamese")          ;   (LCID:  1066)
      AddGadgetItem(#ComboBox_Language, -1,"Turkish")			  ;   (LCID:  1055)
      AddGadgetItem(#ComboBox_Language, -1,"German - Germany")    ;   (LCID:  1031)
      If st\Locale_ID = 1033
        SetGadgetState(#ComboBox_Language, 1)
      ElseIf st\Locale_ID = 1049
        SetGadgetState(#ComboBox_Language, 2)
      ElseIf st\Locale_ID = 1028 
      	SetGadgetState(#ComboBox_Language, 3)
      	ElseIf st\Locale_ID = 2052
        SetGadgetState(#ComboBox_Language, 4)
      ElseIf st\Locale_ID = 1059
        SetGadgetState(#ComboBox_Language, 5)
      ElseIf st\Locale_ID = 1058
        SetGadgetState(#ComboBox_Language, 6)
      ElseIf st\Locale_ID = 1046
          SetGadgetState(#ComboBox_Language, 7)
      ElseIf st\Locale_ID = 1066
          SetGadgetState(#ComboBox_Language, 8)
      ElseIf st\Locale_ID = 1055
      	SetGadgetState(#ComboBox_Language, 9)
      ElseIf st\Locale_ID = 1031
      	SetGadgetState(#ComboBox_Language, 10)
      Else
        SetGadgetState(#ComboBox_Language, 0)
      EndIf
      TextGadget(#Text_LCID, 233, 250, 135, 25, "LCID CODE: "+Str(GetUILanguage()), #PB_Text_Right)
      SetGadgetColor(#Text_LCID, #PB_Gadget_FrontColor, 8421504) 
      ; --------
      DragAcceptFiles(#Panel)
      SetGadgetState(#Panel, st\Setting_Stage) ;Установка требуемой вкладки
    EndIf
  EndIf
EndProcedure

Procedure WindowAbout()
	Static Window=0, TextID, BuildID, ThisYear, CloseMenu, Font
	
	If Window ; Опрос событий
		Select Event()	
			Case #PB_Event_Menu
				Select EventMenu()
					Case CloseMenu
						PostEvent(#PB_Event_CloseWindow, Window,0)
				EndSelect
			Case #PB_Event_CloseWindow
				UnbindEvent(#PB_Event_Menu, @WindowAbout(), Window)
				UnbindEvent(#PB_Event_CloseWindow, @WindowAbout(), Window)
				RemoveKeyboardShortcut(Window, #PB_Shortcut_Escape)
				CloseWindow(Window)
				FreeFont(Font)
				Window=0		
		EndSelect
	Else
		; Создание окна и перенаправление событий
		Window = OpenWindow(#PB_Any, 0, 0, 370, 159, Lng(18), #PB_Window_SystemMenu | #PB_Window_WindowCentered, WindowID(#WIN_MAIN))
		SendMessage_ (WindowID(Window), #WM_SETICON, 0, ImageID(7))
		ImageGadget(#PB_Any, 10, 23, 48, 48, ImageID(16))
		BuildID = TextGadget(#PB_Any, 5, 85, 57, 48, "Build: "+#PB_Editor_BuildCount, #PB_Text_Center)
		SetGadgetColor(BuildID, #PB_Gadget_FrontColor, 8421504)
		TextID = TextGadget(#PB_Any, 75, 20, 250, 25, ProgramName$, #PB_Text_Center)
		Font = LoadFont(#PB_Any,"Cooper Black", 13, #PB_Font_Italic) : SetGadgetFont(TextID, FontID(Font))
		TextGadget(#PB_Any, 80, 48, 240, 35, Lng(73), #PB_Text_Center);+" "+st\CPU_Name
		FrameGadget(#PB_Any, 70, 4, 290, 145, "")
		ThisYear = Year(Date())
		If ThisYear<2021 : ThisYear=2025 : EndIf
		TextGadget(#PB_Any, 80, 85, 290, 24, "Copyright 2020-"+Str(ThisYear)+" © CryptoNickSoft™", #PB_Text_Center)
		TextGadget(#PB_Any, 80, 109, 290, 24, "Copyright 2020-"+Str(ThisYear)+" © ColdWindScholar™", #PB_Text_Center)
		
		BindEvent(#PB_Event_Menu, @WindowAbout(), Window)
		BindEvent(#PB_Event_CloseWindow, @WindowAbout(), Window)
		AddKeyboardShortcut(Window, #PB_Shortcut_Escape, CloseMenu)
	EndIf
EndProcedure

Procedure SetWinOpacity(hwnd.l, Opacity.l) ; Opacity: в данном интервале: 0-255 
  SetWindowLong_(hwnd, #GWL_EXSTYLE, $00080000) 
  If OpenLibrary(1, "user32.dll") 
    CallFunction(1, "SetLayeredWindowAttributes", hwnd, 0, Opacity, 2) 
    CloseLibrary(1) 
  EndIf 
EndProcedure 

Procedure HookProc(nCode, wParam, lParam) 
  Protected cn$, win 
  Select nCode 
    Case #HCBT_CREATEWND 
      *pcbt.CBT_CREATEWND = lParam 
      *pcs.CREATESTRUCT = *pcbt\lpcs 
      cn$ = Space(#MAX_PATH)
      GetClassName_(wParam, @cn$, #MAX_PATH-1)
      If cn$ = "#32770"
        win = GetActiveWindow()
        If Not IsWindow(win):win=0:EndIf
        If IsWindow(win)
          *pcs\x = WindowX(win)+WindowWidth(win)/2-*pcs\cx/2
          *pcs\y = WindowY(win)+WindowHeight(win)/2-*pcs\cy/2
        EndIf
      EndIf
  EndSelect
  ProcedureReturn CallNextHookEx_(Hook, nCode, wParam, lParam) 
EndProcedure

Procedure MessageRequesterEx(title$, body$, flags=0)
  Protected result
  Hook = SetWindowsHookEx_(#WH_CBT, @HookProc(), #Null, GetCurrentThreadId_()) 
  result = MessageRequester(title$, body$, flags)
  UnhookWindowsHookEx_(Hook)
  ProcedureReturn result
EndProcedure

Procedure.s Replace(Str.s, English.s, National.s)
  ProcedureReturn ReplaceString(Str, English, National)
EndProcedure

Procedure.s stdOutString(Program.s, String.s)
  If Program = "imgextractor"
;     String = ReplaceString(String, "Convert ", "Конвертируем ")
;     String = ReplaceString(String, " to ", " в ")
;     String = ReplaceString(String, "Extraction from ", "Извлечение из ")
  ElseIf Program = "amlimagepack"
;     String = ReplaceString(String, "Image package version ", "Версия упаковки образа ")
;     String = ReplaceString(String, "Unpack item ", "Распакован элемент ")
;     String = ReplaceString(String, "Backup item ", "Резервный элемент  ")
;     String = ReplaceString(String, " to ", " в ")
;     String = ReplaceString(String, " from ", " из ")
;     String = ReplaceString(String, "Pack Item", "Упакован элемент")
;     String = ReplaceString(String, "Pack image", "Упакован образ")
;     String = ReplaceString(String, "Write config file ", "Создан файл конфигурации ")
;     String = ReplaceString(String, "Image unpack ", "Образ распакован ")
;     String = ReplaceString(String, " size:", " размер:")
;     String = ReplaceString(String, "version:", "версия:")
;     String = ReplaceString(String, " bytes", " байт")
  ElseIf Program = "make_ext4fs"
;     String = ReplaceString(String, "loaded ", "загружено ")
;     String = ReplaceString(String, " entries", " записей")
;     String = ReplaceString(String, "Creating filesystem with parameters:", "Создание файловой системы с параметрами:")
;     String = ReplaceString(String, "Created filesystem with ", "Создана файловая система с ")
;    ;String = ReplaceString(String, " blocks", " блоки")
     
  EndIf
  ProcedureReturn String
EndProcedure

Procedure.s stdErrString(Program.s, String.s)
    Protected FindPosText, LenFirstText, LenLastText, Value.l
    If Program = "make_ext4fs"
        FindPosText= FindString(String, "failed to allocate", 0, #PB_String_NoCase)
        If FindPosText
            LenFirstText+FindPosText+19
            LenLastText= Len(Mid(String, FindString(String, "block", LenFirstText, #PB_String_NoCase)))
            Value = Val(Mid(String, LenFirstText, Len(String)-(LenFirstText)-LenLastText))
            If Value
                Blocks= Value
            EndIf
        EndIf
        
    EndIf
    ProcedureReturn String
EndProcedure

Procedure.s ReadProgramStringOem(iPid)
  Protected Ret$=""
  Protected SizeBuff=AvailableProgramOutput(iPid)
  If SizeBuff>0
    Protected *Buff=AllocateMemory(SizeBuff)
    ReadProgramData(iPid,*Buff,SizeBuff)
    OemToCharBuffA(*Buff,*Buff,SizeBuff)
    Ret$=PeekS(*Buff,SizeBuff,#PB_Ascii)
    FreeMemory(*Buff)
  EndIf
  ProcedureReturn Ret$
EndProcedure

Procedure.s Cn(Str$)
  Protected i,j=1,Ret$="",Sym$,Str1$="",Flag=0
  Str$=ReplaceString(Str$,Chr(13)+Chr(10),Chr(12))
  For i=1 To Len(Str$)
    Sym$=Mid(Str$,i,1)
    Select Sym$
      Case Chr(12)
        Ret$+Str1$+Chr(13)+Chr(10)
        Str1$=""
      Case Chr(13)
        Flag=1
      Default
        If Flag:Str1$="":Flag=0:EndIf
        Str1$+Sym$
    EndSelect
  Next
  Ret$+Str1$
  ProcedureReturn Ret$
EndProcedure

Procedure EditorEndLine(Gadget)
  Protected sel.CHARRANGE, GadgetID, LineEnd
  If IsGadget(Gadget)
    GadgetID=GadgetID(Gadget)
    LineEnd = SendMessage_(GadgetID, #EM_GETLINECOUNT, 0, 0)-1
    sel\cpMin=SendMessage_(GadgetID, #EM_LINEINDEX, LineEnd, 0)
    sel\cpMax=sel\cpMin
    SendMessage_(GadgetID, #EM_EXSETSEL, 0, @sel)
  EndIf
EndProcedure

Procedure Message(string$, empty=0)
  Protected str$
  If string$
    If empty : str$ = Chr(10) : EndIf
    Text$+string$+Chr(13)+Chr(10)+str$
    SetGadgetText(#Editor,Text$)
    EditorEndLine(#Editor)
  EndIf
EndProcedure

Procedure.s GetExePath()
  Protected Path.s = GetPathPart(ProgramFilename())
  If Path = GetTemporaryDirectory()
    Path = GetCurrentDirectory()
  EndIf
  ProcedureReturn Path
EndProcedure


Procedure.s CharToOem(String.s)
  CharToOem_(@String, @String)
  ProcedureReturn String
EndProcedure
 
Procedure.s OemToChar(String.s)
  OemToChar_(@String, @String)
  ProcedureReturn String
EndProcedure

Procedure.s OemToCharEx(str$)
  Protected iByteLength, sOem_in_Ascii$, sunicode$
  iByteLength = Len(str$) + 2     
  sOem_in_Ascii$ = Space(iByteLength)
  PokeS(@sOem_in_Ascii$, str$, -1, #PB_Ascii)
  sunicode$ = Space(iByteLength)
  OemToChar_(@sOem_in_Ascii$, @sunicode$)
  ProcedureReturn sunicode$
EndProcedure

Procedure RunConsole(File$, Parameter$, WorkingDirectory$, Flags=0)
    Protected FileName$ = LCase(GetFilePart(File$, #PB_FileSystem_NoExtension));+" 2>1.txt"
	Protected iPid = RunProgram("cmd.exe", "/c "+File$+" "+Parameter$, WorkingDirectory$, #PB_Program_Open | #PB_Program_Read | #PB_Program_Error | #PB_Program_Hide) ;    
	;Protected iPid = RunProgram(File$, Parameter$, WorkingDirectory$, #PB_Program_Open | #PB_Program_Read | #PB_Program_Error | #PB_Program_Hide) 
	Protected stderr$, stdout$, Ret = -300                                                                                                                 
	If iPid
		
		While ProgramRunning(iPid)
			Repeat
				stderr$ = ReadProgramError(iPid,  #PB_Ascii)
				If stderr$
					If Not (FileName$= "make_ext4fs" Or FileName$= "imgextractor");oem
						stderr$ = OemToCharEx(stderr$)
					EndIf
					Message(stdErrString(FileName$, Cn(stderr$)))
				EndIf
			Until stderr$=""       
			
			stdout$=ReadProgramStringOem(iPid)
			If stdout$
				Message(stdOutString(FileName$, Cn(stdout$)))
			EndIf
		Wend
		
		Repeat
			stderr$ = ReadProgramError(iPid,  #PB_Ascii)
			If stderr$
				If Not (FileName$= "make_ext4fs" Or FileName$= "imgextractor");oem
					stderr$ = OemToCharEx(stderr$)
				EndIf
				Message(stdErrString(FileName$, Cn(stderr$)))
			EndIf
		Until stderr$=""
		
		Ret = ProgramExitCode(iPid)
		CloseProgram(iPid) ;Close the connection to the program 
		
	EndIf
	ProcedureReturn Ret
EndProcedure

Procedure.s SizeIt(Value.q)  
  Protected unit.b=0, byte.q, nSize.s, sMin.s
  If Value < 0 : Value * -1 : sMin="-" : EndIf
  byte = Value
  While byte >= 1024
    byte / 1024 : unit + 1
  Wend
  If unit : nSize = StrD(Value/Pow(1024, unit), 15) : pos.l = FindString(nSize, ".") : Else : nSize = Str(Value) : EndIf
  If unit : If pos <  4 : nSize=Mid(nSize,1,pos+2) : Else : nSize = Mid(nSize, 1, pos-1) : EndIf : EndIf
  ProcedureReturn sMin+nSize+" "+StringField("bytes,KB,MB,GB,TB,PB", unit+1, ",")  
EndProcedure

Procedure.q GetFolderSize(Path.s, State.b = 1)
  Protected Path$ = Path
  Static.q nSize
  If State : nSize = 0 : EndIf
  hF = ExamineDirectory(#PB_Any, Path, "*.*")
  If hF <> #False   
    While NextDirectoryEntry(hF)
      If DirectoryEntryType(hF) = #PB_DirectoryEntry_Directory
        If DirectoryEntryName(hF) <> "." And DirectoryEntryName(hF) <> ".."
          If DirectoryEntryAttributes(hF) & #FILE_ATTRIBUTE_REPARSE_POINT
            Continue
          EndIf
          Path$ = Path + "\" + DirectoryEntryName(hF)  
          GetFolderSize(Path$, 0) ; Traverse Directory
        EndIf
      Else
        nSize + FileSize(Path + "\"  + DirectoryEntryName(hF))
      EndIf
    Wend
    FinishDirectory(hF)
  EndIf
  ProcedureReturn nSize
EndProcedure

Procedure IsEmptyFolder(Path$) ;Debug PathIsDirectoryEmpty_(dir$)
  Protected res$, i = 1
  If ExamineDirectory(0, Path$, "*")
    While NextDirectoryEntry(0)
      res$ = DirectoryEntryName(0)
      If res$ = ".." Or res$ = "."
        res$ = ""
        Continue
      EndIf
      If res$
        i = 0
        Break
      EndIf
    Wend
    FinishDirectory(0)
  Else
    i = -1
  EndIf
  ProcedureReturn i
EndProcedure

Procedure.s ExitStr(number=-500)
  Protected Ret.s
  If number = 0
    Ret = "  ("+Lng(76)+"!)" ;Выполнено успешно
  Else
    Ret = "  ("+Lng(77)+"!)" ;Ошибка выполнения
    ErrorsCount+1
  EndIf
  ProcedureReturn Ret
EndProcedure

Procedure RecycleFile(file$); - Deletes a file or a directory and moves it in the RECYCLE-Bin 
  Protected *MemoryID = AllocateMemory( (Len(file$)+2 ) * SizeOf(Character))
  Protected SHFileOp.SHFILEOPSTRUCT                
  If *MemoryID
    PokeS(*MemoryID,file$)
    SHFileOp\pFrom  = *MemoryID
    SHFileOp\wFunc  = #FO_DELETE
    SHFileOp\fFlags = #FOF_ALLOWUNDO|#FOF_NOCONFIRMATION|#FOF_NOERRORUI|#FOF_SILENT
    Protected ok = SHFileOperation_(SHFileOp)
    FreeMemory(*MemoryID)
  EndIf
  If ok=0 : ok=1 : Else : ok=0 : EndIf
  ProcedureReturn ok
EndProcedure

Procedure CreateShortcut_all(Path.s, LINK.s, Argument.s, DESCRIPTION.s, WorkingDirectory.s, ShowCommand.l, IconFile.s, IconIndexInFile.l) 
  CoInitialize_(0) 
  If CoCreateInstance_(?CLSID_ShellLink,0,1,?IID_IShellLinkW,@psl.IShellLinkW) = 0  
    psl\SetPath(Path) 
    psl\SetArguments(Argument) 
    psl\SetWorkingDirectory(WorkingDirectory) 
    psl\SetDescription(DESCRIPTION) 
    psl\SetShowCmd(ShowCommand) 
    psl\SetHotkey(HotKey) 
    psl\SetIconLocation(IconFile, IconIndexInFile) 
    If psl\QueryInterface(?IID_IPersistFile,@ppf.IPersistFile) = 0 
      hres = ppf\Save(LINK,#True) 
      Result = 1 
      ppf\Release() 
    EndIf 
    psl\Release() 
  EndIf 
  CoUninitialize_() 
  ProcedureReturn Result 
  DataSection 
    CLSID_ShellLink: 
    Data.l $00021401 : Data.w $0000,$0000 : Data.b $C0,$00,$00,$00,$00,$00,$00,$46 
    IID_IShellLink: 
    Data.l $000214EE : Data.w $0000,$0000 : Data.b $C0,$00,$00,$00,$00,$00,$00,$46 
    IID_IPersistFile: 
    Data.l $0000010B : Data.w $0000,$0000 : Data.b $C0,$00,$00,$00,$00,$00,$00,$46 
    IID_IShellLinkW: 
    Data.l $000214F9 : Data.w $0000, $0000 : Data.b $C0, $00, $00, $00, $00, $00, $00, $46 
  EndDataSection 
EndProcedure 

Procedure GadgetFromGadgetID(GadgetID)
  If IsWindow_(GadgetID)
    ProcedureReturn GetDlgCtrlID_(GadgetID)
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure EditorCreateResize()
  Protected Editor_x, Editor_y, Editor_w, Editor_h, Progress_y
  ;Debug GadgetWidth(#Container)
  If IsGadget(#Container)>0 And GadgetWidth(#Container)=20 ;Вертикальное отображение
    Editor_x = 25
    Editor_y = 0
    Editor_w = WindowWidth(#WIN_MAIN)-Editor_x
    Editor_h = WindowHeight(#WIN_MAIN)-49 ;44
    Progress_y = Editor_h
  ElseIf IsToolBar(#ToolBar)>0  And GadgetWidth(#Container)=0 ;Горизонтальное отображение
    Editor_x = 0
    Editor_y =25
    Editor_w = WindowWidth(#WIN_MAIN)
    Editor_h = WindowHeight(#WIN_MAIN)-49-Editor_y ;44
    Progress_y = Editor_h+25
  Else ;Панель инструментов отсутствует
    Editor_x = 0
    Editor_y = 0
    Editor_w = WindowWidth(#WIN_MAIN)
    Editor_h = WindowHeight(#WIN_MAIN)-49 ;44
    Progress_y = Editor_h
  EndIf
  If IsGadget(#Editor)>0
    ResizeGadget(#Editor, Editor_x, Editor_y, Editor_w, Editor_h)
    ResizeGadget(#Progress, Editor_x, Progress_y, Editor_w, 4)
  Else
  	EditorGadget(#Editor, Editor_x, Editor_y, Editor_w, Editor_h, #PB_Editor_ReadOnly);
  	SendMessage_(GadgetID(#Editor), #EM_SETTEXTMODE, #TM_RICHTEXT, 0)
    ProgressBarGadget(#Progress,Editor_x,Progress_y,Editor_w,4,0,100)
  EndIf
EndProcedure

Procedure Highlight() 
	;Debug "Highlight"
	Protected editFormat.myCHARFORMAT2
	editFormat\cbSize = SizeOf(myCHARFORMAT2) 
	editFormat\dwMask = #CFM_COLOR 
	editFormat\crTextColor = GetGadgetColor(#Editor, #PB_Gadget_FrontColor) ;RGB(0, 0, 0) 
	Protected editFind.FINDTEXT 
	editFind\chrg\cpMin = 0  ; this will change in procedure as text is found 
	editFind\chrg\cpMax = -1
	Protected textToFind$, spaces, i, thisFind$, found, error, normal
	
	SendMessage_(GadgetID(#Editor), #EM_SETSEL, 0, 0) 
	SendMessage_(GadgetID(#Editor), #EM_SETCHARFORMAT, 4, editFormat) 
	textToFind$ = Lng(77)+"!,"+Lng(76)+"!,"+Lng(133) ;Ошибка выполнения & Выполнено успешно & Имеются ошибки выполнения
	spaces = CountString(textToFind$, ",")			 ;1
	
	For i = 1 To spaces+1 
		editFind\chrg\cpMin = 0 
		thisFind$ = StringField(textToFind$, i, ",")
		editFind\lpstrText = @thisFind$ 
		If i=1
			editFormat\crTextColor = RGB(255, 0, 0)
		ElseIf i=2
			editFormat\crTextColor = RGB(0, 255, 0)
		ElseIf i=3
			editFormat\crTextColor = RGB(255, 255, 255)
		EndIf
		Repeat 
			found = SendMessage_(GadgetID(#Editor), #EM_FINDTEXT, #FR_DOWN, editFind) 
			If found > -1 
				editFind\chrg\cpMin = found+1 
				SendMessage_(GadgetID(#Editor), #EM_SETSEL, found, found + Len(thisFind$))  
				SendMessage_(GadgetID(#Editor), #EM_SETCHARFORMAT, #SCF_SELECTION | #SCF_WORD, editFormat) 
				If i=1 : error=1 : EndIf
				If i=2 : normal=1 : EndIf
			EndIf 
		Until found = -1 
	Next i 
	EditorEndLine(#Editor)
	If error = 1
		SetGadgetState(#Progress , 100)
		SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_ERROR, 0)
	ElseIf normal = 1
		SetGadgetState(#Progress , 100)
		SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_NORMAL, 0)
	EndIf
EndProcedure

;   max=SendMessage_(GadgetID(#Editor),#WM_GETTEXTLENGTH,0,0)
;   SendMessage_(GadgetID(#Editor), #EM_SETSEL, max, max)
;   
;   SendMessage_(GadgetID(1), #EM_SETSEL, $fffffff, $fffffff)
;   
;   SendMessage_(GadgetID(#Editor), #EM_SETSEL, -1, 0)
;   SendMessage_(GadgetID(#Editor),#EM_SCROLL,#SB_BOTTOM,0)

Procedure WinCallback(hWnd,uMsg,wParam,lParam)
	Select uMsg
		Case #WM_NOTIFY
			*el.ENLINK = lParam
			If *el\nmhdr\code=#EN_LINK
				If *el\msg=#WM_LBUTTONDOWN
					StringBuffer = AllocateMemory(512)
					txt.TEXTRANGE
					txt\chrg\cpMin = *el\chrg\cpMin
					txt\chrg\cpMax = *el\chrg\cpMax
					txt\lpstrText = StringBuffer
					SendMessage_(GadgetID(#Editor), #EM_GETTEXTRANGE, 0, txt)
					RunProgram(PeekS(StringBuffer))
					FreeMemory(StringBuffer)
				EndIf
			EndIf	
		Case #WM_SYSCOMMAND ;Событие в контекстном системном меню 
			Select wParam
				Case #About
					WindowAbout()
			EndSelect
		Case #WM_SIZE							  ; Изменение размера окна.
			Select GetActiveWindow()
				Case #WIN_MAIN
					EditorCreateResize()
				Case #WIN_SETTING
					If IsGadget(#Panel)>0
						ResizeGadget(#Panel, #PB_Ignore, #PB_Ignore, WindowWidth(#WIN_SETTING), WindowHeight(#WIN_SETTING))
					EndIf
			EndSelect
		Case #WM_EXITSIZEMOVE
			st\Main_X = WindowX(#WIN_MAIN)
			st\Main_Y = WindowY(#WIN_MAIN)
			st\Main_Width = WindowWidth(#WIN_MAIN) 
			st\Main_Height = WindowHeight(#WIN_MAIN)
	EndSelect
	ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure

Procedure WndProc(hwnd, uMsg, wParam, lParam)
  Protected NumberOfCharactersDropped.i,CharacterIndex.i
  Protected CharacterBuffer.s = Space(#MAX_PATH),GadgetN.l
  Protected number, files$
  Select uMsg
  	Case #WM_RBUTTONUP
  		If GadgetFromGadgetID(hwnd) = #Editor And CreatePopupImageMenu(#EditMenu)>0
  			If IsThread(ThreadAutoExit)
  				KillThread(ThreadAutoExit)
  				SetGadgetText(#Editor,Text$)
  				EditorEndLine(#Editor)
  				SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_NORMAL, 0)
  				SetGadgetState(#Progress , 0)
  			EndIf
  			ResizeGadget(#Editor, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  			CreateEditMenu()
  			DisplayPopupMenu(#EditMenu,WindowID(#WIN_MAIN))
  		EndIf  
  	Case #WM_LBUTTONUP
  		If GadgetFromGadgetID(hwnd) = #Editor
  			If IsThread(ThreadAutoExit)
  				KillThread(ThreadAutoExit)
  				SetGadgetText(#Editor,Text$)
  				EditorEndLine(#Editor)
  				SendMessage_(GadgetID(#Progress), #PBM_SETSTATE, #PBST_NORMAL, 0)
  				SetGadgetState(#Progress , 0)
  			EndIf
  			ResizeGadget(#Editor, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  		EndIf
  	Case #WM_DROPFILES
  		If GadgetFromGadgetID(hwnd) = #Editor 
  			NumberOfCharactersDropped = DragQueryFile_(wParam , $FFFFFFFF, ReturnedFileName.s, 0)
  			For number = 0 To NumberOfCharactersDropped - 1
  				DragQueryFile_(wParam, number, CharacterBuffer, #MAX_PATH)
  				ListFill(CharacterBuffer)
        Next
        RunActions() 
      ElseIf GadgetFromGadgetID(hwnd) = #Panel And GetGadgetState(#Panel) = 3
        NumberOfCharactersDropped = DragQueryFile_(wParam , $FFFFFFFF, ReturnedFileName.s, 0)
        For number = 0 To NumberOfCharactersDropped - 1
          DragQueryFile_(wParam, number, CharacterBuffer, #MAX_PATH)
          If LCase(GetExtensionPart(CharacterBuffer)) = "apk" 
            If CopyFile(CharacterBuffer, bin$+"framework\framework-res.apk")>0
              SetGadgetState(#CheckBox_Framework, #PB_Checkbox_Checked)
            EndIf
          EndIf
        Next
      EndIf
      DragFinish_(*DroppedFilesArea)
  EndSelect
  ProcedureReturn CallWindowProc_(lpOldWndProc, hWnd, uMsg, wParam, lParam)
EndProcedure

Procedure.s OSVersionEx()
	Protected Ret$
	Select OSVersion()
		Case   #PB_OS_Windows_XP
			Ret$ = "Windows XP"
		Case #PB_OS_Windows_Server_2003
			Ret$ = "Windows Server 2003"
		Case #PB_OS_Windows_Vista
			Ret$="Windows Vista"
		Case #PB_OS_Windows_Server_2008
			Ret$="Windows Server 2008"
		Case #PB_OS_Windows_7
			Ret$="Windows 7"
		Case #PB_OS_Windows_Server_2008_R2
			Ret$="Windows Server 2008 R2"
		Case #PB_OS_Windows_8
			Ret$="Windows 8"
		Case #PB_OS_Windows_Server_2012
			Ret$="Windows Server 2012"
		Case #PB_OS_Windows_8_1
			Ret$="Windows 8.1"
		Case #PB_OS_Windows_Server_2012_R2
			Ret$="Windows Server 2012 R2"
		Case #PB_OS_Windows_10
			Ret$="Windows 10"
			Case #PB_OS_Windows_11
			Ret$="Windows 11"
		Case #PB_OS_Windows_Future
			Ret$ = "Windows Future"
		Default
			Ret$="Unknown"
	EndSelect
	ProcedureReturn Ret$
EndProcedure

Procedure GetUsbTool()
  Protected Path.s
  Path = OpenFileRequester(Lng(78)+" USB_Burning_Tool.exe", "", Lng(4)+" (*.exe)|*.exe", 0) ;Пожалуйста укажите путь к файлу ... Файл
  If Path
    st\Path_UsbTool = Path
  EndIf
EndProcedure

Procedure ChoiceFramework()
  Protected Path.s
  Path = OpenFileRequester(Lng(78)+" framework-res.apk", "", Lng(4)+" (framework-res.apk)|*.apk", 0) ;Пожалуйста укажите путь к файлу ... Файл
  If Path
    CopyFile(Path, bin$+"framework\framework-res.apk")
  EndIf
EndProcedure

Procedure Exit()
	Protected Result=6
	If IsThread(ThreadActions)
		Result = MessageRequesterEx(Lng(74), Lng(75)+Chr(10)+Lng(79), #MB_ICONQUESTION | #MB_YESNOCANCEL) ;Внимание ... Выполняются запланированные действия! ... Вы уверены что хотите закрыть окно программы?... Вы уверены что хотите закрыть окно программы?
	EndIf
	
	If Result = 6
		If CreateFile(0, bin$+"config\lastAction.log")    ; файл создаёт, если он пока не существует
			WriteString(0, Text$)
			CloseFile(0)
		EndIf
		
		If  CreatePreferences(bin$+"config\settings.ini")
			PreferenceGroup("Settings")
			If st\Main_X>0 And st\Main_Y>0 And st\Main_Width>0 And st\Main_Height>0
				WritePreferenceLong("Desktop_Width", GetSystemMetrics_(#SM_CXSCREEN))
				WritePreferenceLong("Desktop_Height", GetSystemMetrics_(#SM_CYSCREEN))
				WritePreferenceLong("Main_X", st\Main_X)
				WritePreferenceLong("Main_Y", st\Main_Y)
				WritePreferenceLong("Main_Width", st\Main_Width)
				WritePreferenceLong("Main_Height", st\Main_Height)
			EndIf
			If GetWindowState(#WIN_MAIN) = #PB_Window_Maximize
				WritePreferenceLong("Main_Maximize",1)
			Else
				WritePreferenceLong("Main_Maximize",0)
			EndIf
			WritePreferenceLong("Main_Top", st\Main_Top)
			
			If IsWindow(#WIN_SETTING)  
				st\Setting_Stage=GetGadgetState(#Panel)
				st\Setting_X=WindowX(#WIN_SETTING)
				st\Setting_Y=WindowY(#WIN_SETTING)
				st\Setting_Width = WindowWidth(#WIN_SETTING) 
				st\Setting_Height=WindowHeight(#WIN_SETTING)
			EndIf
			
			If st\Setting_Width>0 And st\Setting_Height>0
				WritePreferenceLong("Setting_Stage", st\Setting_Stage)
				WritePreferenceLong("Setting_Width", st\Setting_Width)
				WritePreferenceLong("Setting_Height", st\Setting_Height)
				WritePreferenceLong("Setting_X", st\Setting_X)
				WritePreferenceLong("Setting_Y", st\Setting_Y)
			EndIf
			WritePreferenceLong("Window_Transparency",st\Window_Transparency)
			
			WritePreferenceLong("Open_Settings",st\Open_Settings)
			
			WritePreferenceLong("Editor_BackColor",st\Editor_BackColor)
			WritePreferenceString("Editor_FontName",st\Editor_FontName)
			WritePreferenceLong("Editor_FontSize",st\Editor_FontSize)
			WritePreferenceLong("Editor_FontColor",st\Editor_FontColor)
			WritePreferenceLong("Editor_FontStyle",st\Editor_FontStyle)
			WritePreferenceLong("Unpack_Super",st\Unpack_Super)
			WritePreferenceLong("Unpack_System",st\Unpack_System)
			WritePreferenceLong("Unpack_Vendor",st\Unpack_Vendor)
			WritePreferenceLong("Unpack_Product",st\Unpack_Product)
			WritePreferenceLong("Unpack_Odm",st\Unpack_Odm)
			WritePreferenceLong("Open_Folder",st\Open_Folder)
			WritePreferenceString("Ver",st\Ver)
			WritePreferenceLong("Pack_System",st\Pack_System)
			WritePreferenceLong("Pack_Vendor",st\Pack_Vendor)
			WritePreferenceLong("Pack_Product",st\Pack_Product)
			WritePreferenceLong("Pack_Odm",st\Pack_Odm)
			WritePreferenceLong("Pack_Super",st\Pack_Super)
			WritePreferenceLong("Index_Add",st\Index_Add)
			WritePreferenceLong("Open_UsbTool",st\Open_UsbTool)
			WritePreferenceLong("Framework",st\Framework)
			WritePreferenceLong("SignatureApk",st\SignatureApk)
			WritePreferenceLong("Alignment",st\Alignment)
			WritePreferenceLong("Locale_ID",st\Locale_ID)
			WritePreferenceLong("Not_Delete",st\Not_Delete)
			WritePreferenceLong("Transfer",st\Transfer)
			WritePreferenceString("Decompress",st\Decompress)
			WritePreferenceString("Compress",st\Compress)
			WritePreferenceString("Compress_Level",st\Compress_Level)
			WritePreferenceLong("Signature",st\Signature)
			WritePreferenceLong("Toolbar_Set",st\Toolbar_Set)
			WritePreferenceLong("Free_Space",st\Free_Space)
			WritePreferenceLong("Expand_Size",st\Expand_Size)
			WritePreferenceLong("Resize",st\Resize)
			WritePreferenceLong("No_Backup",st\No_Backup)
			WritePreferenceLong("No_Org",st\No_Org)
			WritePreferenceLong("Get_Hash",st\Get_Hash)
			WritePreferenceLong("Seven_Pack",st\Seven_Pack)
			WritePreferenceLong("Seven_UnPack",st\Seven_UnPack)
			WritePreferenceLong("Subfolder",st\Subfolder)
			WritePreferenceLong("Delete_Archive",st\Delete_Archive)
			WritePreferenceString("Seven_Level",st\Seven_Level)
			WritePreferenceString("Size_Part",st\Size_Part)
			WritePreferenceLong("Delete_Image",st\Delete_Image)
			WritePreferenceLong("Auto_Exit",st\Auto_Exit)
			WritePreferenceLong("AutoExit_Time",st\AutoExit_Time)
			WritePreferenceString("Path_UsbTool",st\Path_UsbTool)
			WritePreferenceLong("Finish_Sound",st\Finish_Sound)
			WritePreferenceLong("Volume_Level",st\Volume_Level)
			WritePreferenceString("Pack_Folder",st\Pack_Folder)
			WritePreferenceString("Unpack_Folder",st\Unpack_Folder)
			ClosePreferences()
		EndIf
		
		DragAcceptFree(#Editor)
		If InSound And IsSound(#Sound) : FreeSound(#Sound) : EndIf
		If IsFont(Font) : FreeFont(Font) : EndIf
	EndIf
	
	ProcedureReturn Result
EndProcedure

Procedure FatalError() 
   Protected Result$
   Result$+"String - "+ErrorLine()+~"\nFile: "+ErrorFile() 
   Result$+~"\n\nType error: "+ErrorMessage()
   MessageRequester("MIK program error!", Result$, #MB_OK|#MB_ICONERROR) 
EndProcedure 

DataSection
	img0:
	IncludeBinary "image\wait.ico"
	img1:
	IncludeBinary "image\ready.ico"
	img2:
	IncludeBinary "image\exit.ico"
	img3:
	IncludeBinary "image\cd_edit.ico"
	img4:
	IncludeBinary "image\cd.ico"
	img5:
	IncludeBinary "image\page.ico"
	img6:
	IncludeBinary "image\help.ico"
	img7:
	IncludeBinary "image\information.ico"
	img8:
	IncludeBinary "image\telegram.ico"
	img9:
	IncludeBinary "image\setting.ico"
	img10:
	IncludeBinary "image\youtube.ico"
	img11:
	IncludeBinary "image\Recent.ico"
	img12:
	IncludeBinary "image\pda.ico"
	img14:
	IncludeBinary "image\donate.ico"
	img15:
	IncludeBinary "image\idea.ico"
	img16:
	IncludeBinary "image\about.ico"
	img17:
	IncludeBinary "image\page_copy.ico"
	img18:
	IncludeBinary "image\page_save.ico"
	img19:
	IncludeBinary "image\shortcut.ico"
	img20:
	IncludeBinary "image\page_paintbrush.ico"
	img21:
	IncludeBinary "image\page_paste.ico"
	img22:
	IncludeBinary "image\google.ico"
	img23:
	IncludeBinary "image\translate.ico"
	img24:
	IncludeBinary "image\cmd.ico"
	lng:
	IncludeBinary "1049\1049.lng"
	end_lng:
EndDataSection
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 4467
; FirstLine = 4445
; Folding = -------------------
; Markers = 737,1937,4061,4062
; Optimizer
; EnableThread
; EnableXP
; UseIcon = image\icon.ico
; Executable = MIT.exe
; CompileSourceDirectory
; EnableBuildCount = 2988
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 4.2.0.%BUILDCOUNT
; VersionField1 = 4.2.0.%BUILDCOUNT
; VersionField2 = CryptoNick Soft
; VersionField3 = Multi Image Kitchen
; VersionField4 = 4.2.0.%BUILDCOUNT
; VersionField6 = Распаковщик\упаковщик прошивок и образов разделов
; VersionField8 = %EXECUTABLE
; VersionField9 = CryptoNickSoft@gmail.com