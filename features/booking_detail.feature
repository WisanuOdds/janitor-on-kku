Feature: Booking detail
    Odds อยากจะเห็นรายละเอียดการจองห้องประชุมเพื่อจะได้รู้ว่าถูกจองโดยใครจะได้สอบถามได้

    Scenario: กดดูรายละเอียดการจองห้องประชุมได้สำเร็จ
        Given ฉันเข้าสู่ระบบแล้ว
        And ฉันทำการจองแล้ว
        When ฉันกดดูรายการจองของฉัน
        Then ฉันจะเห็นรายละเอียดการจองห้องประชุมนี้