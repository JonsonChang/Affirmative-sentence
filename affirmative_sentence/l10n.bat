@echo off
REM 設定 Flutter 專案的根目錄
set PROJECT_ROOT=%cd%

REM 設定 .arb 檔案所在的目錄
set ARB_DIR=%PROJECT_ROOT%\lib\l10n

REM 設定 app_localizations.dart 想要複製到的目標目錄
set OUTPUT_DIR=%PROJECT_ROOT%\lib\l10n

REM 設定原始目錄
set SOURCE_DIR=%PROJECT_ROOT%\.dart_tool\flutter_gen\gen_l10n

REM 複製檔案
echo 正在將檔案從 "%SOURCE_DIR%" 複製到 "%OUTPUT_DIR%"...
xcopy "%SOURCE_DIR%\*" "%OUTPUT_DIR%\" /s /y
if %errorlevel% neq 0 (
    echo 複製檔案失敗。
    echo 請確認目錄 "%SOURCE_DIR%" 是否存在，
    echo 並且您是否有權限將檔案複製到 "%OUTPUT_DIR%"。
    exit /b %errorlevel%
)

echo 檔案已成功複製到 "%OUTPUT_DIR%"。

echo.
echo 操作完成。
pause
exit /b 0
