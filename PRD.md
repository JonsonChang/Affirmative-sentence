## 肯定語句 Affirmative sentence - 產品需求文件 (PRD)

**1. 簡介**

本產品為一款跨平台行動應用程式，旨在透過每日定時推送肯定語句通知，幫助使用者建立積極正向的思維模式。使用者可自訂通知時間與內容，並選擇偏好的肯定語句。

**2. 目標使用者**

- 希望培養積極心態的個人
- 需要自我激勵的使用者
- 想要改善情緒和心理健康的人群
- 對肯定語句有興趣的使用者

**3. 產品目標**

- 幫助使用者養成每日接收肯定語句的習慣。
- 提供使用者高度的個人化設定，以符合不同需求。
- 打造簡單易用、介面友善的應用程式。
- 支援Android和iOS平台，擴大使用者範圍。

**4. 功能需求**

**4.1 核心功能**

- **肯定語句管理：**
  - 使用者可新增、編輯、刪除肯定語句。
  - 提供預設的肯定語句庫，並進行分類。
  - 使用者可將肯定語句加入收藏，方便管理。
- **通知設定：**
  - 使用者可設定多個通知時間。
  - 使用者可選擇通知的重複頻率 (每天、特定星期)。
  - 使用者可開啟/關閉通知功能。
- **隨機推送：**
  - 於指定時間，從使用者勾選的肯定語句中隨機選擇一句推送通知。
- **跨平台支援：**
  - 同時支援Android和iOS平台。

**4.2 UI/UX 需求**

- **介面設計：**
  - 簡潔、直觀、易於操作。
  - 提供多種主題或顏色選擇，增加個人化。
  - 字體大小、顏色、樣式可調整，方便閱讀。
- 

**4.3 其他需求**

- **背景執行：**
  - 應用程式在背景執行時，仍可準時發送通知。
- **資料儲存：**
  - 使用者資料 (肯定語句、設定等) 儲存於本地端，保護隱私。
- **效能：**
  - 應用程式啟動速度快，執行流暢。
  - 佔用系統資源少，不影響手機效能。

**5. 技術需求**

- **開發平台：** Flutter
- **資料庫：** SQLite (本地端資料庫)
- **通知服務：** 本地通知 (Local Notification)

**6. 限制與假設**

- **作業系統版本：**
  - Android：8.0 以上
  - iOS：13.0 以上
- **網路連線：**
  - 不需要網路連線
- **使用者行為：**
  - 假設使用者會定期開啟應用程式，並更新肯定語句。

**7. 發布與迭代**

- **發布平台：** Google Play Store, Apple App Store
- **迭代計畫：**
  - 第一版：實現核心功能，滿足基本使用需求。
  - 後續版本：
    - 增加更多個人化設定 (例如：通知音效、震動模式)。
    - 擴充肯定語句庫，提供更多元的內容。
    - 社群分享功能，讓使用者可以分享喜歡的肯定語句。
    - 數據分析功能，幫助使用者了解使用狀況。

**8. 成功指標**

- **下載量：** App發布後的下載次數。
- **活躍使用者數：** 每日/每月使用App的使用者數量。
- **使用者留存率：** 使用者持續使用App的比率。
- **使用者評價：** 使用者在應用程式商店的評分和評論。
- **通知點擊率:** 使用者點擊通知的比率