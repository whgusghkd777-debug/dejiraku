
# Deziraku (デジラク) - ホテル予約システム

ホテルや宿泊施設を検索し、リアルタイムで部屋の空き状況を確認・予約・決済できるウェブサービスです。

ユーザーがチェックイン・チェックアウトの日付と人数を入力すると、すぐに予約可能な部屋を表示します。


## プロジェクト概要

- ユーザー中心の直感的な予約フローとデータの一貫性を重視して開発しました。
- **私の役割**: メインバックエンド開発者（DB設計、予約・決済ロジック、同時アクセス制御を主担当）

## 技術スタック

| カテゴリ       | 技術                          |
|----------------|-------------------------------|
| バックエンド   | Java 1.8 + Spring Framework + MyBatis |
| サーバー       | Apache Tomcat 9              |
| データベース   | Oracle DB                    |
| フロントエンド | JSP + HTML5/CSS3/JavaScript + Bootstrap 5 |
| ビルドツール   | Maven                        |
| アーキテクチャ | MVC パターン                 |

（このスタックはレガシーシステム保守でよく使われます。新規開発ではSpring Boot + JPAが主流です）

## 主要機能

- リアルタイム部屋在庫確認（日付・人数ベース）
- 重複予約防止（データ一貫性検証）
- 決済トランザクション管理（予約と決済を原子的に処理）
- 検索最適化（インデックス活用 + SQLチューニング）

## 核心コード例

### 1. 楽観的ロックによる同時アクセス制御

```java
// Room.java (Entityクラス)
@Entity
public class Room {
    @Id
    private Long id;
    private int availableCount; // 残り部屋数

    @Version // 楽観的ロックの核心（バージョン衝突でエラー発生）
    private int version;

    // getter/setter 省略
}

// ReservationService.java
@Service
public class ReservationService {

    @Transactional // トランザクション管理（失敗時はロールバック）
    public void reserve(Long roomId, int guests) {
        Room room = roomRepository.findById(roomId).orElseThrow();

        if (room.getAvailableCount() < guests) {
            throw new RuntimeException("部屋が不足しています");
        }

        room.setAvailableCount(room.getAvailableCount() - guests);
        roomRepository.save(room); // 保存時にバージョン自動チェック
    }
}
```

### 2. MyBatis SQLチューニング例

```xml
<!-- RoomMapper.xml -->
<select id="searchRooms" resultType="Room">
    SELECT * FROM rooms
    WHERE check_in_date <= #{checkOut}
      AND check_out_date >= #{checkIn}
      AND capacity >= #{guests}
    <!-- インデックスがかかったカラムのみ使用で高速化 -->
</select>
```

## インストールと実行方法

1. リポジトリをクローン  
   `git clone https://github.com/whgusghkd777-debug/dejiraku.git`

2. Mavenビルド  
   `mvn clean install`

3. Oracle DB設定  
   `application.properties` に接続情報を記載

4. Tomcatで実行  
   WARファイルをデプロイ、またはIDEでサーバー起動

## 今後の改善計画

- Spring Boot + JPAへのリファクタリング
- AWSデプロイ + 実際の決済API連携
- フロントエンドをReactに分離

## 開発を通じて学んだこと

同時アクセス制御とトランザクションの重要性を深く理解しました。実務ではデータ破損防止が最優先だと実感。

貢献歓迎！IssueやPull Requestお待ちしています。

**連絡先**  
メール: whgusghkd777@gmail.com  
PPT: https://www.notion.so/PPT-2d278b58bbbf80859a7ada329ae52326  
技術ブログ: https://url.kr/xt4qjr
```
