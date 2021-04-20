require "rexml/document"
require "open-uri"

# しょぼいカレンダーから番組表を取得する
def get_schedule(span)
  url = "http://cal.syoboi.jp/cal_chk.php?days=#{span}" # span: どれくらい先まで取得するかの期間を日にちで指定
  xml = REXML::Document.new(open(url).read)

  schedule = []

  xml.elements.each("syobocal/ProgItems/ProgItem") { |item|
    schedule << {
      title: item.attribute("Title").to_s,                # タイトル
      sub_title: item.attribute("SubTitle").to_s,         # サブタイトル
      st_time: Time.parse(item.attribute("StTime").to_s), # 開始時刻
      ed_time: Time.parse(item.attribute("EdTime").to_s), # 終了時刻
      ch_name: item.attribute("ChName").to_s,             # チャンネル名
      ch_id: item.attribute("ChID").to_s.to_i             # チャンネルID
    }
  }

  schedule.select{ |program|
    # データの取得期間を現在時刻から翌日の朝5時までに絞る
    st = Time.now
    day = Time.now.hour < 5 ? Date.today : Date.today + 1
    ed = Time.new(day.year, day.month, day.day, 5)

    # 自分が住んでいる地域で放送されているチャンネルのIDを選択
    # チャンネルIDの調べ方: http://cal.syoboi.jp/mng?Action=ShowChList
    ch_ids = [
      1,  # NHK総合
      2,  # NHK Eテレ
      3,  # フジテレビ
      4,  # 日本テレビ
      5,  # TBS
      6,  # テレビ朝日
      7,  # テレビ東京
      19, # TOKYO MX
    ]

    st < program[:st_time] and program[:st_time] < ed and ch_ids.include?(program[:ch_id])
  }.sort_by{ |program| program[:st_time] }.to_json
end
