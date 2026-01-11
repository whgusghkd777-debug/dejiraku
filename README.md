
# Deziraku (デジラク) - ホテル予約システム

ホテルや宿泊施設を検索し、日付・人数で部屋を選択、予約・モック決済まで行えるWebアプリケーションです。
Spring MVCベースで、ユーザー中心のシンプルな予約フローを実現しました。

## プロジェクト概要

- 開発期間: 2025年　10月　27日　~　2025年　11月　14日　（チーム5名（バックエンド2、DB1、フロント1、企画/リーダー1））
- **私の役割**: バックエンドメイン担当（会員認証、予約ロジック、在庫管理、決済フロー、マイページを主に実装。DB設計支援、コードレビューも参加）

## 技術スタック

| カテゴリ     | 技術                          |
|--------------|-------------------------------|
| バックエンド | Java 1.8 + Spring MVC + JdbcTemplate |
| データベース | Oracle DB                     |
| フロントエンド | JSP + JSTL + Bootstrap        |
| サーバー     | Apache Tomcat                 |
| ビルドツール | Maven                         |
| アーキテクチャ | MVC パターン                  |

（このスタックは国内レガシーシステムや教育プロジェクトでよく使われます。実務ではSpring Boot + JPAに移行するケースが多いです）

## 主要機能

- 会員登録・ログイン（簡易実装、将来的にBCrypt予定）
- ホテル検索・一覧（地域・日付・人数で動的検索、ページネーション予定）
- 部屋詳細表示
- 予約処理（在庫チェック・減算、@Transactionalで原子性確保）
- モック決済フロー
- マイページ（予約確認・キャンセル：STATUS更新で履歴保持）

## 私がメイン実装したコントローラー

- AuthController / JoinController: ログイン・会員登録
- ReservationController: 予約作成
- PaymentController: 決済フロー
- MypageController: 予約一覧・キャンセル

## 核心コード例（実際のプロジェクトから抜粋）

### 1. 予約サービス（トランザクション + 在庫管理）

```java
// ReservationServiceImpl.java
package com.globalin.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.globalin.dao.ReservationDao;
import com.globalin.dao.RoomDao;
import com.globalin.domain.Reservation;

@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationDao reservationDao;

    @Autowired
    private RoomDao roomDao;

    @Transactional  // 予約と在庫減算を原子的に処理
    @Override
    public long createReservation(Reservation reservation) {

        // 在庫確認（簡易的にremain_countカラム使用）
        int available = roomDao.getAvailableCount(
                reservation.getRoomId(), reservation.getCheckin(), reservation.getCheckout());

        if (available < reservation.getGuests()) {
            throw new RuntimeException("在庫不足です");
        }

        // 在庫減算
        roomDao.decreaseStock(
                reservation.getRoomId(), reservation.getCheckin(), reservation.getCheckout(), reservation.getGuests());

        // 予約登録（OracleシーケンスでID自動生成）
        reservationDao.insert(reservation);

        // 最新の予約ID取得
        return reservationDao.getCurrentId();  // SELECT SEQ_RESERVATION_ID.CURRVAL FROM DUAL
    }
}
```

### 2. 予約DAO（キャンセルはDELETEではなくSTATUS更新）

```java
// ReservationDaoImpl.java（抜粋）
@Repository
public class ReservationDaoImpl {

    @Autowired
    private JdbcTemplate jdbc;

    public void insert(Reservation r) {
        String sql = "INSERT INTO RESERVATION (RESERVATION_ID, MEMBER_ID, HOTEL_ID, ROOM_ID, ..."
                   + "CHECKIN, CHECKOUT, GUESTS, BOOKING_STATUS) "
                   + "VALUES (SEQ_RESERVATION_ID.NEXTVAL, ?, ?, ?, ..., ?, ?, ?, 'PAID')";
        jdbc.update(sql, r.getMemberId(), r.getHotelId(), r.getRoomId(), ...
                    r.getCheckin(), r.getCheckout(), r.getGuests());
    }

    // キャンセル：データ履歴を残すためSTATUS更新
    public int cancel(long memberId, long reservationId) {
        String sql = "UPDATE RESERVATION SET BOOKING_STATUS = 'CANCELED' "
                   + "WHERE RESERVATION_ID = ? AND MEMBER_ID = ? AND BOOKING_STATUS = 'PAID'";
        return jdbc.update(sql, reservationId, memberId);
    }
}
```

## 同時予約競合対策について

プロジェクトでは規模が小さいため、@Transactional + 在庫チェックで基本的な一貫性を確保しました。
実務（大規模予約システム）では以下のように強化します：
- 日付別在庫テーブル作成
- 悲観的ロック（SELECT FOR UPDATE）
- Redis分散ロック（Redissonなど）

## インストールと実行方法

1. リポジトリクローン  
   `git clone https://github.com/whgusghkd777-debug/dejiraku.git`
2. Mavenビルド  
   `mvn clean install`
3. Oracle DB接続設定（application.propertiesまたはXMLに記載）
4. TomcatでWARデプロイまたはIDEで実行

## 今後の改善計画

- Git + GitHub徹底活用、CI/CD導入
- Spring Boot + JPAに移行（ボイラープレート削減）
- Redisで同時性強化
- 実際の決済ゲートウェイ（トス、Stripeなど）連携
- フロントをThymeleafまたはReactに変更

## 学んだこと

- MVCの責任分離とトランザクションの重要性
- DB制約エラー解決を通じたSQLデバッグ力向上
- チーム開発でのコミュニケーションとコード規約の必要性
- 時間制約下での優先順位判断力

貢献歓迎です！Issue・PRお待ちしています。

**連絡先**  
メール: whgusghkd777@gmail.com  
PPT資料: https://www.notion.so/PPT-2d278b58bbbf80859a7ada329ae52326
```
