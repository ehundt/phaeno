class Import::Plant

  def self.import(orig_data)
    data = {}
    data["dwd_object_id"] = orig_data["pflanzengruppe,-objekt"]
    data["name"] = orig_data["bezeichnung"]

    if data["name"]
      plant = ::Plant.where(dwd_object_id: data["dwd_object_id"]).first_or_create(data)
      print plant.name + ", "
    end

  end
end
