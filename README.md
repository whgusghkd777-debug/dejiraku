# Deziraku (デジラク) - ホテル予約システム

ホテルや宿泊施設を検索し、リアルタイムで部屋の空き状況を確認・予約・決제できるウェブサービスです。  
ユーザーがチェックイン・チェックアウトの日付と人数を入力すると、すぐに予約可能な部屋を表示します。  
（簡単な説明: ヤノルジャやAirbnbみたいなホテル予約サイト。リアルタイムで部屋があるか確認して予約できる。）



## プロジェクト概要
- ユーザー中心の直感的な予約フローとデータ安定性を重視して開発。
- **私の役割**: メインバックエンド開発者（DB設計、予約・決済ロジック、同時アクセス制御担当）。

## 技術スタック
- **バックエンド**: Java 1.8 + Spring Framework + MyBatis
- **サーバー**: Apache Tomcat 9
- **データベース**: Oracle DB
- **フロントエンド**: JSP + HTML5/CSS3/JavaScript + Bootstrap 5
- **ビルドツール**: Maven (pom.xml)
- **パターン**: MVC

（実務Tips: 今のスタックはレガシーシステムの保守でよく使われる。新規プロジェクトはSpring Boot + JPAがトレンド。）

## 主要機能
- リアルタイム部屋在庫確認（日付・人数ベース）
- 重複予約防止（データ一貫性検証）
- 決済トランザクション管理（予約 + 決済を一気に処理）
- 検索最適化（インデックス + SQLチューニング）

### 核心コード例1: 楽観的ロックで同時アクセス制御（簡単な注釈付き）
```java
// Room.java (Entityクラス - DBテーブルと連結)
@Entity
public class Room {
    @Id
    private Long id;
    private int availableCount;  // 残り部屋数
    
    @Version  // このアノテーションが楽観的ロックの核心（簡単な説明: DBにversionカラムを自動作成して変更時にチェック）
    private int version;  // バージョン番号（他の人が修正したら増える）
    
    // getter, setter省略
}

// ReservationService.java (予約サービス - トランザクション処理)
@Service
public class ReservationService {
    
    @Transactional  // メソッド全体を1つのトランザクションに（失敗したらロールバック - 簡単な説明: 予約+決済のどちらか失敗したら両方キャンセル）
    public void reserve(Long roomId, int guests) {
        Room room = roomRepository.findById(roomId).orElseThrow();
        
        if (room.getAvailableCount() < guests) {  // 在庫不足チェック
            throw new RuntimeException("部屋不足");
        }
        
        room.setAvailableCount(room.getAvailableCount() - guests);  // 在庫減らす
        roomRepository.save(room);  // 保存時にversion自動増加（他の人が先に修正してたらエラー発生）
    }
}
```
（実務で: 複数人が同時に同じ部屋を予約しようとした時の衝突防止。楽観的ロックは性能が良くてよく使われる。）

### 核心コード例2: MyBatis SQLチューニング例
```xml
<!-- RoomMapper.xml (MyBatisマッパー - SQLを書く) -->
<select id="searchRooms" resultType="Room">
    SELECT * FROM rooms 
    WHERE check_in_date <= #{checkOut} 
      AND check_out_date >= #{checkIn}
      AND capacity >= #{guests}
      <!-- インデックスがかかったカラムだけ条件に入れて高速検索（簡単な説明: よく使うカラムにインデックスかけると速度が速くなる） -->
</select>
```

## インストールと実行方法（初心者必須！）
1. リポジトリクローン: `git clone https://github.com/whgusghkd777-debug/dejiraku.git`
2. Mavenビルド: `mvn clean install` （簡単な説明: 依存関係ダウンロードしてコンパイル）
3. Oracle DB設定: application.propertiesにDB接続情報を入れる
4. Tomcatで実行: WARファイルをデプロイするか、IDEでRun as Server

## 今後の計画
- Spring Boot + JPAにリファクタリング（現代の実務技術にアップグレード）
- AWSデプロイ + 実際の決済API連携
- フロントエンドをReactに分離

## 開発者として学んだこと
同時アクセス制御とトランザクションの重要性をしっかり実感しました。実務ではデータが壊れる事故を防ぐのが一番大事だと分かりました。

貢献大歓迎！イシューやプルリクエストお待ちしています。

### 実務Tips
- READMEはポートフォリオで最初に見るところ。ここまで構造を整えてスクリーンショット・コード例を入れると、はるかにプロに見える。
- 実際の会社プロジェクトのREADMEもほぼこの構成（インストール方法、使用方法、スタック、ロードマップ）で書かれる。チームメンバーがすぐ実行できるようにしなきゃいけない。
- 初心者なら今すぐこの内容をコピーしてGitHubに貼り付け、スクリーンショットを数枚撮って追加してみて。ポートフォリオの点数が一気に上がるよ。
