@echo off
REM �]�w Flutter �M�ת��ڥؿ�
set PROJECT_ROOT=%cd%

REM �]�w .arb �ɮשҦb���ؿ�
set ARB_DIR=%PROJECT_ROOT%\lib\l10n

REM �]�w app_localizations.dart �Q�n�ƻs�쪺�ؼХؿ�
set OUTPUT_DIR=%PROJECT_ROOT%\lib\l10n

REM �]�w��l�ؿ�
set SOURCE_DIR=%PROJECT_ROOT%\.dart_tool\flutter_gen\gen_l10n

REM �ƻs�ɮ�
echo ���b�N�ɮױq "%SOURCE_DIR%" �ƻs�� "%OUTPUT_DIR%"...
xcopy "%SOURCE_DIR%\*" "%OUTPUT_DIR%\" /s /y
if %errorlevel% neq 0 (
    echo �ƻs�ɮץ��ѡC
    echo �нT�{�ؿ� "%SOURCE_DIR%" �O�_�s�b�A
    echo �åB�z�O�_���v���N�ɮ׽ƻs�� "%OUTPUT_DIR%"�C
    exit /b %errorlevel%
)

echo �ɮפw���\�ƻs�� "%OUTPUT_DIR%"�C

echo.
echo �ާ@�����C
pause
exit /b 0
