;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!include "LogicLib.nsh"
!include WordFunc.nsh
!include "FileFunc.nsh"
!insertmacro VersionCompare

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compiler flags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetOverwrite on				; overwrite files
SetCompress auto			; compress iff saves space
SetCompressor /solid lzma	; compress whole installer as one block
SetDatablockOptimize off	; only saves us 0.1%, not worth it
XPStyle on                  ; add an XP manifest to the installer
RequestExecutionLevel admin	; on Vista we must be admin because we write to Program Files

LangString LanguageCode ${LANG_ENGLISH}  "en"

!define INSTPROG "Radegast"
!define APPNAME "RadegastVoicepack"
!define VERSION "1.0"
!define UNINST_REG "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
; The name of the installer
Name "${APPNAME}"

; The file to write
OutFile "..\${APPNAME}-${VERSION}.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\${INSTPROG}"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${APPNAME}" "Install_Dir"

;--------------------------------

LicenseText "Please review the Vivox license terms before installing Radegast Voicepack"
LicenseData "Vivox-License.rtf"

; Pages
Page license
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

; The stuff to install
Section "${APPNAME} core (required)"
	
  
  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File /x *.nsi /x *.bak /x *~ /x .* *.*
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${APPNAME}" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM ${UNINST_REG} "DisplayName" "${APPNAME}"
  WriteRegStr HKLM ${UNINST_REG} "UninstallString" '"$INSTDIR\uninstall_voice.exe"'
  WriteRegStr HKLM ${UNINST_REG} "QuietUninstallString" '"$INSTDIR\uninstall_voice.exe" /S'
  WriteRegStr HKLM ${UNINST_REG} "Publisher" "Radegast Development Team"
  WriteRegStr HKLM ${UNINST_REG} "DisplayVersion" "${VERSION}"
  WriteRegDWORD HKLM ${UNINST_REG} "NoModify" 1
  WriteRegDWORD HKLM ${UNINST_REG} "NoRepair" 1
  WriteUninstaller "uninstall_voice.exe"
  
SectionEnd

;--------------------------------
; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM ${UNINST_REG}
  DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

  ; Remove files and uninstaller
  Delete $INSTDIR\SLVoice.exe
  Delete $INSTDIR\Vivox-License.rtf
  Delete $INSTDIR\alut.dll
  Delete $INSTDIR\ortp.dll
  Delete $INSTDIR\vivoxsdk.dll
  Delete $INSTDIR\wrap_oal.dll
  Delete $INSTDIR\uninstall_voice.exe

SectionEnd
