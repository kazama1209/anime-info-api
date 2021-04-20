require "bundler/setup"
require "json"
require "syobocal"

def get_anime_details(tid)
  title = Syobocal::DB::TitleLookup.get({"TID" => tid})
  comment = title.first[:comment]
  parser = Syobocal::Comment::Parser.new(comment)

  staffs = []

  parser.staffs.each do |staff|
    staffs << {
      "role": staff.instance_variable_get("@role"),
      "name": staff.instance_variable_get("@people")[0].instance_variable_get("@name")
    }
  end

  casts = []

  parser.casts.each do |cast|
    casts << {
      "character": cast.instance_variable_get("@character"),
      "name": cast.instance_variable_get("@people")[0].instance_variable_get("@name")
    }
  end

  data = {
    "staffs": staffs,
    "casts": casts
  }

  data.to_json
end
